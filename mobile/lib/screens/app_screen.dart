import 'package:flutter/material.dart';
import 'package:movie_web/screens/home_screen.dart';
import 'package:movie_web/screens/utitlity_screen.dart';

class AppScreen extends StatefulWidget {
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

class _AppScreenState extends State<AppScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  int tabBarIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      vsync: this,
      length: tabItems.length,
      initialIndex: tabBarIndex,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }



  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        // Control size of shadow below the appBar
//        elevation: 0.0,
//        actions: <Widget>[
//          IconButton(
//            icon: Icon(Icons.search),
//            onPressed: () {
//              showSearch(
//                context: context,
//                delegate: SearchScreen(),
//              );
//            },
//          )
//        ],
//      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          HomeScreen(),
          Text("homed"),
          UtitlityScreen(),
        ],
      ),
      bottomNavigationBar: TabBar(
        controller: _tabController,
        tabs: tabItems.map((item) {
          return Tab(
            icon: Icon(item.icon),
            text: item.title,
          );
        }).toList(),
      ),
    );
  }
}
// Size of screen
//    final Size size = MediaQuery.of(context).size;

// Widget _movieBanner(width) {
//   return Container(
//     width: width,
//     height: width / ratio,
//     child: OnePageSliding(),
//   );
// }

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


// On smaller screen reduce padding ratio
// final paddingRatio = size.width < 600 ? 0.03 : 0.07;
// final padding = size.width * paddingRatio;
