import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:movie_web/const/device_width.dart';
import 'package:movie_web/models/movie_model.dart';
import 'package:movie_web/widgets/movie.dart';

class CategoryMovie extends StatelessWidget {
  final String category;
  final List<MovieModel> movies;

  CategoryMovie({this.category, this.movies});

  double getMovieWidth(Size screenSize) {
    if (screenSize.width < MOBILE_WIDTH) {
      return 200.0;
    }
    // return 0;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final movieInfoWidth = getMovieWidth(screenSize);
    final movieInfoHeight = movieInfoWidth * 1.5;
    final movieHeight = movieInfoWidth * 1.3;
    final movieTextHeight = movieInfoWidth * 0.2;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('$category'),
        Container(
          height: movieInfoHeight,
          child: ListView.separated(
            separatorBuilder: (context, index) {
              return SizedBox(
                width: 10.0,
              );
            },
            itemBuilder: (context, index) {
              final movieInfo = movies[index];
              return Movie(
                moviesInfo: movieInfo,
                width: movieInfoWidth,
                height: movieHeight,
                movieTitleHeight: movieTextHeight,
              );
            },
            itemCount: movies.length,
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
          ),
        )
      ],
      // ),
    );
  }
}
