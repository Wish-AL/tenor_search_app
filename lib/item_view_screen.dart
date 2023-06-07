import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'dart:io';
// import 'package:sqlite3/sqlite3.dart';


class ItemViewScreenWidget extends StatelessWidget {
  const ItemViewScreenWidget({super.key});


  @override
  Widget build(BuildContext context) {
    String imageUrl = '';
    return Scaffold(
        appBar: AppBar(
          title: const Text('Search in tenor'),
        ),
        body: Image(
          image: NetworkImage(
            imageUrl,
          ),
        ),
    );
  }
}
