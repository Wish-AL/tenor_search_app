import 'package:flutter/material.dart';
import 'package:tenor_search_app/theme/app_colors.dart';
import 'package:tenor_search_app/widgets/search_widget.dart';

import 'main_screen.dart';

void main() {
  runApp(const TenorSearchApp());
}

class TenorSearchApp extends StatelessWidget {
  const TenorSearchApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //title: 'Flutter Demo',
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.mainColor,
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: AppColors.mainColor,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.blueGrey,
          )
      ),
      routes: {
        //'/auth': (context) => const AuthWidget(),
        '/main_screen': (context) => MainScreenWidget(),
        '/search': (context) => SearchWidget(),
        //'/select': (context) => SelectPageWidget(),
      },
      initialRoute: '/main_screen',
      onGenerateRoute: (RouteSettings settings){
        return MaterialPageRoute<void>(builder: (context) {
          return const Scaffold(
            body: Center(
              child: Text('Sorry it is Error!'),
            ),
          );
        });
      },
    );
  }
}
