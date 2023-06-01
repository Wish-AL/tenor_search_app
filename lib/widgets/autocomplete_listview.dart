import 'package:flutter/material.dart';

class ListViewAutocomplete extends StatefulWidget {
  final List<String>? results;
  const ListViewAutocomplete({Key? key, required this.results}) : super(key: key);

  @override
  State<ListViewAutocomplete> createState() => _ListViewAutocompleteState();
}

class _ListViewAutocompleteState extends State<ListViewAutocomplete> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: ListView.builder(
        itemCount: widget.results?.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(6),
            child: Text(widget.results![index]),
          );
        },


      ),
    );
  }
}
