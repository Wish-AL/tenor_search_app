import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tenor_search_app/theme/app_colors.dart';
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
  final ScrollController _scrollController = ScrollController();

  bool idCompare(int index) {
    for (int i = 0; i < context.read<ModelDB>().favoritesGifs.length; i++) {
      if (context.watch<Model>().gifInfo!.results![index]!.id! ==
          context.read<ModelDB>().favoritesGifs[i].id) return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState(); //trying to make a pagination
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
                            imageUrl: modelWatch.gifInfo!.results?[index]
                                    ?.media?[0]?.gif?.url ??
                                '',
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Image(
                        image: NetworkImage(
                          modelWatch.gifInfo!.results?[index]?.media?[0]
                                  ?.tinygif?.url ??
                              '',
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
                        icon: idCompare(index) //-------send to Favorite
                            ? const Icon(
                                Icons.star,
                                color: AppColors.mainGreen,
                              )
                            : const Icon(
                                Icons.star_border,
                                color: AppColors.mainGreen,
                              ),
                        onPressed: () {
                          if (modelWatch.gifInfo!.results?[index]?.media?[0]
                                  ?.nanogif?.url !=
                              null) {
                            context.read<ModelDB>().updateListValueInAdd(
                                modelWatch.gifInfo!.results![index]!.id!,
                                modelWatch.gifInfo!.results![index]!
                                    .media![0]!.gif!.url!,
                                modelWatch.gifInfo!.results![index]!
                                    .media![0]!.nanogif!.url!);
                          }
                        },
                      ),
                      const SizedBox(
                        width: 90,
                      ),
                      IconButton(
                        icon: const Icon(Icons.share, color: Colors.blue,),
                        onPressed: () {
                          if (modelWatch.gifInfo!.results?[index]?.media?[0]
                                  ?.nanogif?.url !=
                              null) {
                            Share.share(
                              modelWatch.gifInfo!.results![index]!.media![0]!
                                  .nanogif!.url!,
                              subject: modelWatch.gifInfo!.results![index]!
                                  .contentdescription, //modelWatch.searchText,
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
