import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import '../json_decode_gifs.dart';
import '/json_decode_autocomplete.dart';
import '/theme/app_colors.dart';
//import 'autocomplete_listview_widget.dart';
import 'card_widget.dart';
import 'package:provider/provider.dart';

class ProviderWidget extends StatefulWidget {
  const ProviderWidget({super.key});

  @override
  State<ProviderWidget> createState() => _ProviderWidgetState();
}

class _ProviderWidgetState extends State<ProviderWidget> {
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => Model(),
        child: const SearchWidget(),
      );
}

class Model extends ChangeNotifier {
  List<String>? textAutocomplete = [];
  static Future<Database>? gifDB;
  DecodeSearchRequest? gifInfo;
  String input = '';
  String searchText = '';
  //String _oldPage = '';
  int currentPage = 0;
  String hintText = '';
  late FocusNode searchTextFocusNode;
  static const _apiKey = 'LIVDSRZULELA';
  var client = http.Client(); // обернуть в метод!!!?????????

  void createSearchText(int index) {
    searchText = textAutocomplete![index];
    searchGifs();
  }

  void searchAutocomplete() async {
    var client = http.Client();
    //print('input ${input}');
    try {
      var response = await client.get(
        Uri.https('g.tenor.com', 'v1/autocomplete',
            {'q': input, 'key': _apiKey, 'limit': '5'}),
      ); //https://g.tenor.com/v1/autocomplete?q=<term>&key=<API KEY>
      if (response.statusCode == 200) {
        var jsonResponse = DecodeAutocomplete.fromJson(
            convert.jsonDecode(response.body) as Map<String, dynamic>);
        textAutocomplete = jsonResponse.results;
        // notifyListeners();
      }
    } finally {
      client.close();
    }
    notifyListeners();
  }

  void searchGifs() async {
    var client = http.Client();

    try {
      var response = await client.get(
        Uri.https('g.tenor.com', 'v1/search',
            {'q': searchText, 'key': _apiKey, 'limit': '30', 'pos': currentPage.toString()}), //pos !!!!!!!!!!!
      ); //https://g.tenor.com/v1/search?q=excited&key=LIVDSRZULELA&limit=8
      if (response.statusCode == 200) {
        gifInfo = DecodeSearchRequest.fromJson(
            convert.jsonDecode(response.body) as Map<String, dynamic>);

      }
      //использовать числа из ответа 'next' в TextField для подгрузки контента!!!!!
    } finally {
      client.close();
    }
    notifyListeners();
  }

}

class SearchWidget extends StatefulWidget {
  const SearchWidget({Key? key}) : super(key: key);

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  var inputTextController = TextEditingController();


  _changeInputText() {
    setState(() => context.read<Model>().input = inputTextController.text);
    context.read<Model>().searchAutocomplete();
    //setState(() { });
  }

  @override
  void initState() {
    super.initState();
    inputTextController.addListener(_changeInputText);
  }

  @override
  void dispose() {
    inputTextController.dispose();
    context.watch<Model>().searchTextFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<Model>().searchTextFocusNode = FocusNode();
    final modelRead = context.read<Model>();
    final modelWatch = context.watch<Model>();

    Widget listViewAutocomplete = SizedBox(
      height: 170,
      child: ListView.builder(
        itemCount: modelWatch.textAutocomplete?.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(6),
            child: GestureDetector(
                onTap: () {
                  modelRead.createSearchText(index);
                  modelRead.searchTextFocusNode.unfocus();
                  inputTextController.clear();
                  modelRead.hintText =  modelWatch.textAutocomplete![index];
                  modelRead.input = '';
                  modelRead.textAutocomplete?.length = 0;

                },
                child: SizedBox(
                    height: 15,
                    child: Text(modelWatch.textAutocomplete![index]))),
          );
        },
      ),
    );

    return SafeArea(
      child: Stack(children: [
        Padding(
          padding: const EdgeInsets.only(left: 6, top: 65, right: 6),
          child: modelWatch.searchText != ''
              ? CardWidget()
              : const SizedBox(),
        ),
        Column(
          children: [
            TextField(
              focusNode: modelWatch.searchTextFocusNode,
              decoration: InputDecoration(
                hintText: modelWatch.hintText,
                border: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: AppColors.mainColor,
                    width: 1.0,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              controller: inputTextController,
              onSubmitted: (text) {
                modelRead.searchText = text;
                modelRead.hintText = text;
                inputTextController.clear();
                modelRead.input = '';
                modelRead.textAutocomplete?.length = 0;
                modelRead.searchGifs();
                modelRead.searchTextFocusNode.unfocus();
                //print('text = $text');
              },
            ),
            context.watch<Model>().input != ''
                ? listViewAutocomplete
                : const SizedBox(),
          ],
        ),
      ]),
    );
  }
}

//for ListView
//keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
