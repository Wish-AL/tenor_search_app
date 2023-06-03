import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tenor_search_app/widgets/search_widget.dart';

class CardWidget extends StatefulWidget {
  const CardWidget({Key? key}) : super(key: key);

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {

  @override
  Widget build(BuildContext context) {

    final modelWatch = context.watch<Model>();
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: modelWatch.gifInfo?.results?.length ?? 0,

        itemBuilder: (BuildContext context, int index) {
          return Card(
            color: Colors.blueGrey[100],
            child: Column(children: [
              GestureDetector(
                //onTap: ,
                child: Image(
                  image: NetworkImage(modelWatch.gifInfo!.results?[index]?.media?[0]?.nanogif?.url ?? ''),
                ),
              ),
              const SizedBox(height: 5,),
              const Row(
                children: [
                  Icon(Icons.star),
                ],
              ),
            ],),
          );
        }
    );
  }
}
