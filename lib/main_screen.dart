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
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => Model(),
        child: MainScreenWidget(),
      );
}

class Model extends ChangeNotifier {
  List<String>? textAutocomplete = [];

  //static Future<Database>? gifDB;
  DecodeSearchRequest? gifInfo;
  String input = '';
  String searchText = '';

  //String _oldPage = '';
  int currentPage = 0;
  String hintText = '';
  late FocusNode searchTextFocusNode;
  static const _apiKey = 'LIVDSRZULELA';
  var client = http.Client();
  // DataBaseManage currentDB = DataBaseManage();
  // List<FavoriteList>? favoritesGifs = [];
  //
  // void getListDB() async {
  //   favoritesGifs = await currentDB.gifs();
  //   notifyListeners();
  // }
  void createSearchText(int index) {
    searchText = textAutocomplete![index];
    searchGifs();
  }

  void searchAutocomplete() async {
    var client = http.Client();
    //print('input ${input}');
    try {
      var response = await client.get(
        Uri.https('g.tenor.com', 'v1/autocomplete',
            {'q': input, 'key': _apiKey, 'limit': '5'}),
      ); //https://g.tenor.com/v1/autocomplete?q=<term>&key=<API KEY>
      if (response.statusCode == 200) {
        var jsonResponse = DecodeAutocomplete.fromJson(
            convert.jsonDecode(response.body) as Map<String, dynamic>);
        textAutocomplete = jsonResponse.results;
        // notifyListeners();
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
      //использовать числа из ответа 'next' в TextField для подгрузки контента!!!!!
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

  late DataBaseManage gifDB;
  void getDataFromDB() async {
    final data = await gifDB.gifs();
    setState(() {
      favoritesGifs = data;
    });
  }
  void onSelectTab(int index) {
    if (_selectedTab == index) return;
    setState(() {
      _selectedTab = index;
    });
  }

  @override
  void initState() {
    //context.read<Model>().getListDB();
    super.initState();
    this.gifDB = DataBaseManage();
    this.gifDB.createDB().whenComplete(() => {
      getDataFromDB(),
      setState(() { }),
    });
  }
  // Center(
  // child: _widgetOptions[_selectedTab],

  @override
  Widget build(BuildContext context) {
    final modelRead = context.read<Model>();
    final modelWatch = context.watch<Model>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search in tenor'),
      ),
      body: IndexedStack(
        index: _selectedTab,
        children: [
          SearchWidget(currentDB: gifDB), //SearchWidget()
          FavoriteItemsWidget(currentDB: gifDB, favoritesGifs: favoritesGifs,),
          Text('settings'),
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
