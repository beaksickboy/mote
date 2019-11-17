import 'package:flutter/material.dart';
import 'package:movie_web/mock-data/data.dart';
import 'package:movie_web/screens/search_scren.dart';
import 'package:movie_web/widgets/catergory_movie.dart';

import 'package:movie_web/widgets/movie.dart';
import 'package:movie_web/widgets/page_sliding.dart';

class HomeScreen extends StatelessWidget {
  // Width / Height
  final ratio = 118 / 70;

  Widget build(BuildContext context) {
    // Size of screen
    final Size size = MediaQuery.of(context).size;

    // On smaller screen reduce padding ratio
    final paddingRatio = size.width < 600 ? 0.03 : 0.07;
    final padding = size.width * paddingRatio;

    return Scaffold(
      appBar: AppBar(
        // Control size of shadow below the appBar
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: SearchScreen());
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: ListView(
          children: <Widget>[
            Padding(
              child: _movieBanner(size.width - (padding * 2)),
              padding: EdgeInsets.symmetric(vertical: 25.0),
            ),
            CategoryMovie(
              category: 'Top Rated',
              movies: movieList,
            ),
          ],
        ),
      ),
    );
  }

  Widget _movieBanner(width) {
    return Container(
      width: width,
      height: width / ratio,
      child: OnePageSliding(),
    );
  }
}
