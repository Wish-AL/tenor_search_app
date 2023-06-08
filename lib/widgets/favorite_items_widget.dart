import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../data_base.dart';
import '../item_view_screen.dart';
import '../main_screen.dart';

class FavoriteItemsWidget extends StatefulWidget {
  final DataBaseManage currentDB;
  final List<FavoriteList> favoritesGifs;
  const FavoriteItemsWidget({super.key, required this.currentDB, required this.favoritesGifs});

  @override
  State<FavoriteItemsWidget> createState() => _FavoriteItemsWidgetState();
}

class _FavoriteItemsWidgetState extends State<FavoriteItemsWidget> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(

        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: widget.favoritesGifs?.length ?? 0,
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
                          imageUrl: widget.favoritesGifs?[index].gifUrl ?? '',
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(1.5),
                    child: Image(
                      image: NetworkImage(
                        widget.favoritesGifs?[index].previewUrl ?? '',
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
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          widget.currentDB.deleteFromDB(widget.favoritesGifs![index].id);
                          setState(() {});
                        },
                      ),
                      const SizedBox(
                        width: 95.7,
                      ),
                      IconButton(
                        icon: const Icon(Icons.share),
                        onPressed: () {
                          if (widget.favoritesGifs![index].previewUrl != null) {
                            Share.share(
                                widget.favoritesGifs![index]
                                    .previewUrl,
                                subject: 'look');
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

    // IconButton(
    //     icon: const Icon(Icons.star),
    //     onPressed: () async {
    //       list = await DataBaseManage.gifs();
    //       for (int i = 0; i < list.length; i++) {
    //         print(list[i].gifUrl);
    //       }
    //       // DataBaseManage.getListFromDB();
    //     });
  }
}
