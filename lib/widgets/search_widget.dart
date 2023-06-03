import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../json_decode_gifs.dart';
import '/json_decode_autocomplete.dart';
import '/theme/app_colors.dart';
import 'card_widget.dart';


class SearchWidget extends StatefulWidget {
  const SearchWidget({Key? key}) : super(key: key);

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  var inputTextController = TextEditingController();
  List<String>? textAutocomplete = [];
  DecodeSearchRequest? gifInfo;
  String _input = '';
  String _searchText = '';
  String _page = '';
  static const _apiKey = 'LIVDSRZULELA';
  var client = http.Client();// обернуть в метод!!!?????????

  _changeInputText() {
    setState(() => _input = inputTextController.text);
    searchAutocomplete(_input);
    setState(() {

    });
  }
  _selectInputText() {
    setState(() => CardWidget);

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

  void searchAutocomplete(String input) async {
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
      } //else print('SOMETHING WRONG!${response.statusCode}');
    } finally {
      //client.close();
    }
  }

  @override
  Widget build(BuildContext context) {

    Widget listViewAutocomplete = SizedBox(
      height: 170,
      child: ListView.builder(
        itemCount: textAutocomplete?.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(6),
            child: GestureDetector(
                onTap: (){
                  _searchText = textAutocomplete![index];
                  //_selectInputText;
                  client.close();
                  _input = '';
                  print('search text ${_searchText}');
                  },
                child: SizedBox(
                    height: 15,
                    child: Text(textAutocomplete![index]))),
          );
        },
      ),
    );

    return SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 6, top: 65, right: 6),
              child: _searchText != '' ? CardWidget(searchText: _searchText) : const SizedBox(),
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
                   _searchText = text;
                   //_selectInputText;
                   _input = '';
                  print('text = $text');
                 },
                ),
                _input != '' ? listViewAutocomplete : SizedBox(),
              ],
            ),
          ]
        ),
      );
  }
}


//for ListView
//keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
