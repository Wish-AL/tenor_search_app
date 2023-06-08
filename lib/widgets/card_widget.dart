import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tenor_search_app/widgets/search_widget.dart';
import 'package:share_plus/share_plus.dart';
import '../data_base.dart';
import '../item_view_screen.dart';
import '../main_screen.dart';

class CardWidget extends StatefulWidget {
  final DataBaseManage currentDB;
  const CardWidget({Key? key, required this.currentDB}) : super(key: key);

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  final ScrollController _scrollController = new ScrollController();


  @override
  void initState() {
    super.initState(); //trying to make pagination
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        context.read<Model>().currentPage += 30;
        context.read<Model>().searchGifs();
      } else if (_scrollController.position.pixels ==
              _scrollController.position.minScrollExtent &&
          context.read<Model>().currentPage > 0) {
        context.read<Model>().currentPage -= 30;
        context.read<Model>().searchGifs();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final modelRead = context.read<Model>();
    final modelWatch = context.watch<Model>();

    return GridView.builder(
        controller: _scrollController,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: modelWatch.gifInfo?.results?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            color: Colors.blueGrey[100],
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ItemViewScreenWidget(
                          imageUrl: modelWatch.gifInfo!.results?[index]
                                  ?.media?[0]?.gif?.url ??
                              '',
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(1.5),
                    child: Image(
                      image: NetworkImage(
                        modelWatch.gifInfo!.results?[index]?.media?[0]?.nanogif
                                ?.url ??
                            '',
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.star),
                        onPressed: () {
                          if (modelWatch.gifInfo!.results?[index]?.media?[0]
                                  ?.nanogif?.url !=
                              null) {
                            widget.currentDB.insertToDB(
                                modelWatch.gifInfo!.results![index]!.media![0]!
                                    .gif!.url!,
                                modelWatch.gifInfo!.results![index]!.media![0]!
                                    .nanogif!.url!);
                          }
                        },
                      ),
                      const SizedBox(
                        width: 95.7,
                      ),
                      IconButton(
                        icon: const Icon(Icons.share),
                        onPressed: () {
                          if (modelWatch.gifInfo!.results?[index]?.media?[0]
                                  ?.nanogif?.url !=
                              null) {
                            Share.share(
                              modelWatch!.gifInfo!.results![index]!.media![0]!
                                  .nanogif!.url!,
                              subject: modelWatch.searchText,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
