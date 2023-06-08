import 'package:flutter/material.dart';

class ItemViewScreenWidget extends StatelessWidget {
  final String imageUrl;
  const ItemViewScreenWidget({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {

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
