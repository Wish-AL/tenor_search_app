import 'package:flutter/material.dart';
import 'package:tenor_search_app/theme/app_colors.dart';
import 'item_view_screen.dart';
import 'main_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  //Model.gifDB = gifDatabase;
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
          )),
      home: ProviderWidget(),
    );
  }
}
