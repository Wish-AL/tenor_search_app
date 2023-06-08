import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data_base.dart';
import '../main_screen.dart';
import '/theme/app_colors.dart';
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

    Widget listViewAutocomplete = DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: SizedBox(
        height: 175,
        child: ListView.builder(
          itemCount: modelWatch.textAutocomplete?.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: GestureDetector(
                  onTap: () {
                    modelRead.createSearchText(index);
                    modelRead.searchTextFocusNode.unfocus();
                    inputTextController.clear();
                    modelRead.hintText = modelWatch.textAutocomplete![index];
                    modelRead.input = '';
                    modelRead.textAutocomplete?.length = 0;
                  },
                  child: SizedBox(
                      height: 36,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(modelWatch.textAutocomplete![index])),
                      ))),
            );
          },
        ),
      ),
    );

    return SafeArea(
      child: Stack(children: [
        Padding(
          padding: const EdgeInsets.only(left: 6, top: 72, right: 6),
          child: modelWatch.searchText != ''
              ? CardWidget(currentDB: widget.currentDB)
              : Center(
                  child: Image.asset('lib/images/clapping.gif'),
                ),
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                focusNode: modelWatch.searchTextFocusNode,
                decoration: InputDecoration(
                  hintText: modelWatch.hintText,
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AppColors.mainColor,
                      width: 2.0,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(10),
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
                },
              ),
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
