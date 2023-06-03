
import 'package:flutter/material.dart';
import 'package:tenor_search_app/widgets/search_widget.dart';

class MainScreenWidget extends StatefulWidget {
  const MainScreenWidget({Key? key}) : super(key: key);

  @override
  State<MainScreenWidget> createState() => _MainScreenWidgetState();
}

class _MainScreenWidgetState extends State<MainScreenWidget> {
  int _selectedTab = 0;
  // static const List<Widget> _widgetOptions = <Widget>[
  //   SearchWidget(),
  //   SearchWidget(),
  //   SearchWidget(),
  // ];



  void onSelectTab(int index) {
    if (_selectedTab == index) return;
    setState(() {
      _selectedTab = index;
    });
}
  // Center(
  // child: _widgetOptions[_selectedTab],

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search in tenor'),
      ),
      body: IndexedStack(
        index: _selectedTab,
        children: const [
          SearchWidget(),
          Text('favorite'),
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
