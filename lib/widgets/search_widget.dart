import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../json_decode_gifs.dart';
import '/json_decode_autocomplete.dart';
import '/theme/app_colors.dart';
import 'autocomplete_listview_widget.dart';
import 'card_widget.dart';
import 'package:provider/provider.dart';

class ProviderWidget extends StatefulWidget {
  const ProviderWidget({super.key});

  @override
  State<ProviderWidget> createState() => _ProviderWidgetState();
}

class _ProviderWidgetState extends State<ProviderWidget> {

  @override
  Widget build(BuildContext context) =>
      ChangeNotifierProvider(create: (context) => Model(),//использовать provider где вместо context.read<Model>()._____ или (watch) используется context.select(Model value) => value.____
        child: const SearchWidget(),
      );

}
class Model extends ChangeNotifier {
  List<String>? textAutocomplete = [];
  DecodeSearchRequest? gifInfo;
  String input = '';
  String searchText = '';
  String _page = '';
  static const _apiKey = 'LIVDSRZULELA';
  var client = http.Client();// обернуть в метод!!!?????????

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
      );//https://g.tenor.com/v1/autocomplete?q=<term>&key=<API KEY>
      if (response.statusCode == 200) {
        var jsonResponse = DecodeAutocomplete.fromJson(convert.jsonDecode(response.body) as Map<String, dynamic>);
        textAutocomplete = jsonResponse.results;
        notifyListeners();
      } //else print('SOMETHING WRONG!${response.statusCode}');
    } finally {
      client.close();
    }
  }

  void searchGifs() async {
    var client = http.Client();
    try {
      var response = await client.get(
        Uri.https('g.tenor.com', 'v1/search',
            {'q': searchText, 'key': _apiKey, 'pos': _page}),//pos !!!!!!!!!!!
      );//https://g.tenor.com/v1/search?q=excited&key=LIVDSRZULELA&limit=8
      if (response.statusCode == 200) {
        gifInfo = DecodeSearchRequest.fromJson(convert.jsonDecode(response.body) as Map<String, dynamic>);
        _page = gifInfo?.next ?? '';
        notifyListeners();
        //print('===============================${gifInfo?.results?.length}');
      }
      //использовать числа из ответа 'next' в TextField для подгрузки контента!!!!!
    } finally {
      client.close();
    }
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
    inputTextController.dispose();//когда контроллер понадобится еще в процессе работы кода????
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      return SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 6, top: 65, right: 6),
              child: context.watch<Model>().searchText != '' ? CardWidget() : const SizedBox(),
            ),
            Column(
              children: [
                TextField(
                decoration: InputDecoration(
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
                   context.read<Model>().searchText = text;
                   context.read<Model>().searchGifs();
                   //_selectInputText;
                   context.read<Model>().input = '';
                  //print('text = $text');
                 },
                ),
                context.watch<Model>().input != '' ? ListViewAutocomplete() : SizedBox(),
              ],
            ),
          ]
        ),
      );
  }
}


//for ListView
//keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
