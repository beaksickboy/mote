import 'package:flutter/material.dart';
import 'package:movie_web/examples/parallax_carousel_screen.dart';
import 'package:movie_web/examples/radial_menu_screen.dart';
import 'package:movie_web/examples/timer-screen.dart';

class _DemoInfo {
  String title;
  String subTitle;
  Icon icon;
  String routeName;

  _DemoInfo({this.title, this.subTitle, this.icon, this.routeName});
}

class HomeScreen extends StatelessWidget {
  static String routeName = '/';

  final List<_DemoInfo> demos = [
    _DemoInfo(
        title: 'Parallax Carousel',
        icon: Icon(Icons.widgets),
        routeName: ParallaxCarouselScreen.routeName,
        subTitle: 'Carousel with parallax effect'),
    _DemoInfo(
        title: 'Radial Menu',
        icon: Icon(Icons.widgets),
        routeName: RadialMenuScreen.routeName,
        subTitle: 'Radial Menu'),
    _DemoInfo(
        title: 'Timer Screen',
        icon: Icon(Icons.widgets),
        routeName: TimeScreen.routeName,
        subTitle: 'Timer Screen'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: demos
            .map(
              (e) => ListTile(
                title: Text(e.title),
                subtitle: Text(e.subTitle),
                leading: e.icon,
                onTap: () {
                  Navigator.pushNamed(context, e.routeName);
                },
              ),
            )
            .toList(),
      ),
    );
  }
}
