import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '/json_decode_autocomplete.dart';
import '/theme/app_colors.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({Key? key}) : super(key: key);

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  late TextEditingController inputTextController;
  String? _input;
  static const _apiKey = 'LIVDSRZULELA';

  //var client = http.Client();// обернуть в метод!!!

  _changeInputText() {
    setState(() => _input = inputTextController.text);
  }

  @override
  void initState() {
    super.initState();
    inputTextController.addListener(_changeInputText);
  }

  @override
  void dispose() { //уточнить когда использовать!!!
    inputTextController.dispose();
    super.dispose();
  }

  void searchAutocomplete(String input) async {
    var client = http.Client();
    try {
      var response = await client.get(
        //https://g.tenor.com/v1/autocomplete?q=<term>&key=<API KEY>
        Uri.https('g.tenor.com', 'v1/autocomplete',
            {'q': input, 'key': _apiKey, 'limit': '5'}),
      );

      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      var jsonResponse = DecodeAutocomplete.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      //var uri = Uri.parse(decodedResponse['uri'] as String);
      //print(await client.get(uri));
    } finally {
      client.close();
    }
  }

  void searchGifs(String input) async {
    var client = http.Client();
    try {
      var response = await client.get(
        //https://g.tenor.com/v1/search?q=excited&key=LIVDSRZULELA&limit=8
        Uri.https('g.tenor.com', 'v1/search',
            {'q': input, 'key': _apiKey, 'pos': ''}),
      );
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      var uri = Uri.parse(decodedResponse['uri'] as String);
      //использовать числа из ответа 'next' в TextField для подгрузки контента!!!!!
      //print(await client.get(uri));
    } finally {
      client.close();
    }
  }

  void gifsById(String id) async {
    var client = http.Client();
    try {
      var response = await client.get(
        //https://g.tenor.com/v1/gifs?ids=8776030&key=LIVDSRZULELA
        Uri.https('g.tenor.com', 'v1/search', {'ids': id, 'key': _apiKey}),
      );
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      var uri = Uri.parse(decodedResponse['uri'] as String);

      //print(await client.get(uri));
    } finally {
      client.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: TextField(
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
        //onChanged: (text) {},
        onSubmitted: (text) {
          searchGifs(text);
        },
      ),
    );
  }
}
//for ListView
//keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
