import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import '../data_base.dart';
import '../json_decode_gifs.dart';
import '../main_screen.dart';
import '/json_decode_autocomplete.dart';
import '/theme/app_colors.dart';
//import 'autocomplete_listview_widget.dart';
import 'card_widget.dart';

class SearchWidget extends StatefulWidget {
  final DataBaseManage currentDB;
  const SearchWidget({Key? key, required this.currentDB}) : super(key: key);

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
              ? CardWidget(currentDB: widget.currentDB)
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
