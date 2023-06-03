import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import '../json_decode_gifs.dart';
import 'json_decode_autocomplete.dart';

class ApiRes {
  static List<String>? textAutocomplete = [];
  static DecodeSearchRequest? gifInfo;
  static String _input = '';
  static String _searchText = '';
  static const _apiKey = 'LIVDSRZULELA';


  static void searchAutocomplete(String input, List<String>? textAutocomplete) async {
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

  static void searchGifs(String input) async {
    //Stirng
    var client = http.Client();
    try {
      var response = await client.get(
        Uri.https('g.tenor.com', 'v1/search',
            {'q': _searchText, 'key': _apiKey, 'pos': ''}),//pos !!!!!!!!!!!
      );//https://g.tenor.com/v1/search?q=excited&key=LIVDSRZULELA&limit=8
      if (response.statusCode == 200) {
        gifInfo = DecodeSearchRequest.fromJson(convert.jsonDecode(response.body) as Map<String, dynamic>);

      }

      //использовать числа из ответа 'next' в TextField для подгрузки контента!!!!!
      //print(await client.get(uri));
    } finally {
      //client.close();
    }
  }


  void gifsById(String id) async {
    var client = http.Client();
    try {
      var response = await client.get(
        Uri.https('g.tenor.com', 'v1/search', {'ids': id, 'key': _apiKey}),
      );//https://g.tenor.com/v1/gifs?ids=8776030&key=LIVDSRZULELA
      // var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      // var uri = Uri.parse(decodedResponse['uri'] as String);

      //print(await client.get(uri));
    } finally {
      //client.close();
    }
  }
}

