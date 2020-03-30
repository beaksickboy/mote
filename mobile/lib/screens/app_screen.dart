import 'package:flutter/material.dart';
import 'package:movie_web/mock-data/data.dart';
import 'package:movie_web/screens/search_scren.dart';
import 'package:movie_web/screens/utitlity_screen.dart';
import 'package:movie_web/utils/color_util.dart';
import 'package:movie_web/widgets/catergory_movie.dart';

import 'package:movie_web/widgets/movie.dart';
import 'package:movie_web/widgets/page_sliding.dart';

class AppScreen extends StatefulWidget {
  // Width / Height
  @override
  _AppScreenState createState() => _AppScreenState();
}

class TabItem {
  const TabItem({this.title, this.icon});
  final String title;
  final IconData icon;
}

const tabItems = [
  TabItem(title: "Home", icon: Icons.home),
  TabItem(title: "Movie", icon: Icons.local_movies),
  TabItem(title: "More", icon: Icons.more_horiz)
];

class _AppScreenState extends State<AppScreen> {
  // final ratio = 118 / 70;
  int tabBarIndex = 0;

  Widget build(BuildContext context) {
    // Size of screen
    final Size size = MediaQuery.of(context).size;

    // On smaller screen reduce padding ratio
    // final paddingRatio = size.width < 600 ? 0.03 : 0.07;
    // final padding = size.width * paddingRatio;

    return DefaultTabController(
      length: tabItems.length,
      initialIndex: tabBarIndex,
      child: Scaffold(
        appBar: AppBar(
          // Control size of shadow below the appBar
          elevation: 0.0,
          // leading: IconButton(
          //   icon: Icon(Icons.menu),
          //   onPressed: () {

          //   },
          // ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: SearchScreen());
              },
            )
          ],
        ),
        body: TabBarView(children: [
          Text("home"),
          Text("homed"),
          UtitlityScreen(),
        ]),
        // body: Padding(
        //   padding: EdgeInsets.symmetric(horizontal: 15.0),
        //   child: ListView(
        //     children: <Widget>[
        //       Padding(
        //         child: _movieBanner(size.width - (padding * 2)),
        //         padding: EdgeInsets.symmetric(vertical: 25.0),
        //       ),
        //       CategoryMovie(
        //         category: 'Top Rated',
        //         movies: movieList,
        //       ),
        //     ],
        //   ),
        // ),
        bottomNavigationBar: TabBar(
            tabs: tabItems.map((item) {
          return Tab(icon: Icon(item.icon), text: item.title);
        }).toList()),
      ),
    );
  }

  // Widget _movieBanner(width) {
  //   return Container(
  //     width: width,
  //     height: width / ratio,
  //     child: OnePageSliding(),
  //   );
  // }
}
