import 'package:flutter/material.dart';
import 'package:tenor_search_app/widgets/favorite_items_widget.dart';
import 'package:tenor_search_app/widgets/search_widget.dart';
import 'data_base.dart';
import 'package:provider/provider.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'json_decode_autocomplete.dart';
import 'json_decode_gifs.dart';

class ProviderWidget extends StatefulWidget {
  const ProviderWidget({super.key});

  @override
  State<ProviderWidget> createState() => _ProviderWidgetState();
}

class _ProviderWidgetState extends State<ProviderWidget> {
  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => Model()),
          ChangeNotifierProvider(create: (context) => ModelDB()),
        ],
        child: const MainScreenWidget(),
      );
}
class ModelDB extends ChangeNotifier{
  List<FavoriteList> favoritesGifs = [];
  late DataBaseManage gifDB;
  void updateListValueInDelete() async{
    favoritesGifs =
  await gifDB.gifs();
    notifyListeners();
  }
  void updateListValueInAdd(String id,String gifUrl, String previewUrl) async {
    gifDB.insertToDB(id, gifUrl, previewUrl);
    favoritesGifs = await gifDB.gifs();
    notifyListeners();
  }

}
class Model extends ChangeNotifier {
  List<String>? textAutocomplete = [];
  DecodeSearchRequest? gifInfo;
  String input = '';
  String searchText = '';
  int currentPage = 0;
  String hintText = '';
  late FocusNode searchTextFocusNode;
  static const _apiKey = 'LIVDSRZULELA';
  var client = http.Client();

  void createSearchText(int index) {
    searchText = textAutocomplete![index];
    searchGifs();
  }

  void searchAutocomplete() async {
    var client = http.Client();
    try {
      var response = await client.get(
        Uri.https('g.tenor.com', 'v1/autocomplete',
            {'q': input, 'key': _apiKey, 'limit': '5'}),
      ); //https://g.tenor.com/v1/autocomplete?q=<term>&key=<API KEY>
      if (response.statusCode == 200) {
        var jsonResponse = DecodeAutocomplete.fromJson(
            convert.jsonDecode(response.body) as Map<String, dynamic>);
        textAutocomplete = jsonResponse.results;
      }
    } finally {
      client.close();
    }
    notifyListeners();
  }

  void searchGifs() async {
    var client = http.Client();

    try {
      var response = await client.get(
        Uri.https('g.tenor.com', 'v1/search', {
          'q': searchText,
          'key': _apiKey,
          'limit': '30',
          'pos': currentPage.toString()
        }), //pos !!!!!!!!!!!
      ); //https://g.tenor.com/v1/search?q=excited&key=LIVDSRZULELA&limit=8
      if (response.statusCode == 200) {
        gifInfo = DecodeSearchRequest.fromJson(
            convert.jsonDecode(response.body) as Map<String, dynamic>);
      }
    } finally {
      client.close();
    }
    notifyListeners();
  }
}

class MainScreenWidget extends StatefulWidget {
  const MainScreenWidget({Key? key}) : super(key: key);

  @override
  State<MainScreenWidget> createState() => _MainScreenWidgetState();
}

class _MainScreenWidgetState extends State<MainScreenWidget> {
  int _selectedTab = 0;
  List<FavoriteList> favoritesGifs = [];


  void onSelectTab(int index) {
    if (_selectedTab == index) return;
    setState(() {
      _selectedTab = index;
    });
  }

  void getDataFromDB() async {
    final data = await context.read<ModelDB>().gifDB.gifs();
    setState(() {
      context.read<ModelDB>().favoritesGifs = data;
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<ModelDB>().gifDB = DataBaseManage();
    context.read<ModelDB>().gifDB.createDB().whenComplete(() => {
          getDataFromDB(),
          setState(() {}),
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search in tenor'),
      ),
      body: IndexedStack(
        index: _selectedTab,
        children: [
          SearchWidget(currentDB: context.watch<ModelDB>().gifDB), //SearchWidget()
          FavoriteItemsWidget(
            currentDB: context.watch<ModelDB>().gifDB,
            favoritesGifs: context.read<ModelDB>().favoritesGifs,
          ),
          Center(
            child: Image.asset('lib/images/phone_animation.gif'),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        //нижняя панель меню
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Пошук',
          ),
          BottomNavigationBarItem(
            // onTap,
            icon: Icon(Icons.favorite_border),
            label: 'Улюблене',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Налаштування',
          ),
        ],
        currentIndex: _selectedTab,
        onTap: onSelectTab,
      ),
    );
  }
}
