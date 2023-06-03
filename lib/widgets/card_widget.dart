import 'package:flutter/material.dart';
import '../json_decode_gifs.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:tenor_search_app/theme/app_colors.dart';

class CardWidget extends StatefulWidget {
  final String searchText;
  const CardWidget({Key? key, required this.searchText}) : super(key: key);

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  static const _apiKey = 'LIVDSRZULELA';

  DecodeSearchRequest? gifInfo;
  void searchGifs() async {
    var client = http.Client();
    try {
      var response = await client.get(
        Uri.https('g.tenor.com', 'v1/search',
            {'q': widget.searchText, 'key': _apiKey, 'pos': ''}),//pos !!!!!!!!!!!
      );//https://g.tenor.com/v1/search?q=excited&key=LIVDSRZULELA&limit=8
      if (response.statusCode == 200) {
        gifInfo = DecodeSearchRequest.fromJson(convert.jsonDecode(response.body) as Map<String, dynamic>);
        print('===============================${gifInfo?.results?.length}');
      }
      //использовать числа из ответа 'next' в TextField для подгрузки контента!!!!!
    } finally {
      client.close();
      setState(() {});
    }
  }
  @override
  void initState(){
    super.initState();
    searchGifs();
  }
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: gifInfo?.results?.length ?? 0,

        itemBuilder: (BuildContext context, int index) {
          return Card(
            color: Colors.blueGrey[100],
            child: Column(children: [
              GestureDetector(
                //onTap: ,
                child: Image(
                  image: NetworkImage(gifInfo!.results?[index]?.media?[0]?.nanogif?.url ?? ''),
                ),
              ),
              const SizedBox(height: 5,),
              const Row(
                children: [
                  Icon(Icons.star),
                ],
              ),
            ],),
          );
        }
    );
  }
}
