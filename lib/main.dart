import 'package:flutter/material.dart';
import 'package:movie_web/screens/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        appBarTheme: AppBarTheme(
          color: Color.fromRGBO(0, 0, 0, 0.87),
        ),
        scaffoldBackgroundColor: Color.fromRGBO(0, 0, 0, 0.87)

      ),
      home: HomeScreen(),
    );
  }
}
