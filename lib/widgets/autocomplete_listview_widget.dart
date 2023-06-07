import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:tenor_search_app/widgets/search_widget.dart';

class ListViewAutocomplete extends StatefulWidget {
  const ListViewAutocomplete({super.key});

  @override
  State<ListViewAutocomplete> createState() => _ListViewAutocompleteState();
}

class _ListViewAutocompleteState extends State<ListViewAutocomplete> {
  @override
  Widget build(BuildContext context) {
    final modelRead = context.read<Model>();
    final modelWatch = context.watch<Model>();
    return SizedBox(
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
                  //inputTextController.text(modelWatch.textAutocomplete![index]);
                  //modelRead.input = '';
                  modelRead.textAutocomplete?.length = 0;
                },
                child: SizedBox(
                    height: 15,
                    child: Text(modelWatch.textAutocomplete![index]))),
          );
        },
      ),
    );
  }
}
