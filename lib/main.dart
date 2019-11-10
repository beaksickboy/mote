import 'package:flutter/material.dart';
import 'package:movie_web/screens/home_screen.dart';
import 'package:movie_web/utils/color_util.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: ColorUtil.backgroundColor,
        appBarTheme: AppBarTheme(
          color: ColorUtil.backgroundColor,
        ),
        // The displayColor is applied to display4, display3, display2, display1, and caption.
        //  The bodyColor is applied to the remaining text styles.
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white
        ),
        hintColor: Colors.grey
      ),
      home: HomeScreen(),
    );
  }
}
