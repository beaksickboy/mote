import 'package:flutter/material.dart';
import 'package:movie_web/bloc/bloc-provider.dart';
import 'package:movie_web/examples/examples.dart';
import 'package:movie_web/examples/form-screen.dart';
import 'package:movie_web/examples/hof-screen.dart';
import 'package:movie_web/examples/platform-screen.dart';
import 'package:movie_web/examples/request-screen.dart';
import 'package:movie_web/examples/teddy-screen.dart';
import 'package:movie_web/screens/app_screen.dart';
import 'package:movie_web/examples/ar_screen.dart';
import 'package:movie_web/screens/home_screen.dart';
import 'package:movie_web/examples/parallax_carousel_screen.dart';
import 'package:movie_web/examples/radial_menu_screen.dart';
import 'package:movie_web/examples/timer-screen.dart';
import 'package:movie_web/utils/color_util.dart';

void main() {
  runApp(
    BlocProvider(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.purple,
//            scaffoldBackgroundColor: ColorUtil.backgroundColor,
          appBarTheme: AppBarTheme(
//              color: ColorUtil.backgroundColor,
              ),
//            bottomAppBarTheme:
//            BottomAppBarTheme(color: ColorUtil.backgroundColor),
//            bottomSheetTheme:
//            BottomSheetThemeData(backgroundColor: ColorUtil.backgroundColor),
          // The displayColor is applied to display4, display3, display2, display1, and caption.
          //  The bodyColor is applied to the remaining text styles.
//            textTheme: Theme
//                .of(context)
//                .textTheme
//                .apply(bodyColor: Colors.white, displayColor: Colors.white),
//            snackBarTheme: SnackBarThemeData(
//                backgroundColor: Colors.purple,
//                actionTextColor: ColorUtil.backgroundColor),
//            hintColor: Colors.grey),
//    home: SafeArea(child: HomeScreen()),
        ),
        initialRoute: Examples.routeName,
        routes: {
          Examples.routeName: (context) => Examples(),
          ParallaxCarouselScreen.routeName: (context) =>
              ParallaxCarouselScreen(),
          RadialMenuScreen.routeName: (context) => RadialMenuScreen(),
          TimeScreen.routeName: (context) => TimeScreen(),
          ArScreen.routeName: (context) => ArScreen(),
          PlatformScreen.routeName: (context) => PlatformScreen(),
          FormScreen.routeName: (context) => FormScreen(),
          HistoryOfEverythingScreen.routeName: (context) => HistoryOfEverythingScreen(),
          TeddyScreen.routeName: (context) => TeddyScreen(),
          RequestScreen.routeName: (context) => RequestScreen(),
        });
  }
}
