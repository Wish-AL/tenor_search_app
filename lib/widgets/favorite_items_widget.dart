import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../data_base.dart';
import '../item_view_screen.dart';
import '../main_screen.dart';

class FavoriteItemsWidget extends StatefulWidget {
  final DataBaseManage currentDB;
  final List<FavoriteList> favoritesGifs;

  const FavoriteItemsWidget(
      {super.key, required this.currentDB, required this.favoritesGifs});

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
        itemCount: context.watch<ModelDB>().favoritesGifs.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            shadowColor: Colors.black,
            elevation: 5,
            color: Colors.blueGrey[100],
            child: Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ItemViewScreenWidget(
                            imageUrl: widget.favoritesGifs[index]
                                .gifUrl,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Image(
                        image: NetworkImage(
                          context
                                  .watch<ModelDB>()
                                  .favoritesGifs[index]
                                  .previewUrl,
                        ), fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.brown,),
                        onPressed: () {
                          widget.currentDB.deleteFromDB(
                              context.read<ModelDB>().favoritesGifs[index].id);
                          context.read<ModelDB>().updateListValueInDelete();
                        },
                      ),
                      const SizedBox(
                        width: 90,
                        //child: text(),
                      ),
                      IconButton(
                        icon: const Icon(Icons.share, color: Colors.blue,),
                        onPressed: () {
                          Share.share(
                              context
                                  .watch<ModelDB>()
                                  .favoritesGifs[index]
                                  .previewUrl,
                              subject: 'look');
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
