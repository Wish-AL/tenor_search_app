import 'package:flutter/material.dart';
import 'package:tenor_search_app/theme/app_colors.dart';

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
      // routes: {
      //   '/auth': (context) => const AuthWidget(),
      //   '/main_screen': (context) => const MainScreenWidget(),
      //   //'/select': (context) => SelectPageWidget(),
      // },
      // initialRoute: '/auth',
      // onGenerateRoute: (RouteSettings settings){
      //   return MaterialPageRoute<void>(builder: (context) {
      //     return Scaffold(
      //       body: Center(
      //         child: Text('Sorry it is Error!'),
      //       ),
      //     );
      //   });
      // },
    );
  }
}
