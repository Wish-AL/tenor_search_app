import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
import '../data_base.dart';

class FavoriteItemsWidget extends StatefulWidget {
  const FavoriteItemsWidget({super.key});

  @override
  State<FavoriteItemsWidget> createState() => _FavoriteItemsWidgetState();
}

class _FavoriteItemsWidgetState extends State<FavoriteItemsWidget> {
  late List<FavoriteList> list;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.star),
      onPressed: () async {

        list = await DataBaseManage.gifs();
        for(int i = 0; i < list.length; i++) {
          print(list[i].gifUrl);
        }
      // DataBaseManage.getListFromDB();
        }
    );
  }
}
