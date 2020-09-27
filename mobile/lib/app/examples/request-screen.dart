import 'package:flutter/material.dart';
import 'package:movie_web/api/dio.dart';

class RequestScreen extends StatefulWidget {
  static const String routeName = "/request-screen";

  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Container(
        child: RaisedButton(
          child: Text("Get API"),
          onPressed: () {

            DioProvider dioProvider = DioProvider();
            dioProvider.dio.get("todos/1").then((value) => print(value));
            // dioProvider
            // .base
            //     .download("https://www.google.com/", "./xx.html")
            //     .then((value) => {print(value)});
          },
        ),
      ),
    ));
  }
}
