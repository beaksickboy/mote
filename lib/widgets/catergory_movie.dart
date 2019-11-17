import 'package:flutter/material.dart';
import 'package:movie_web/models/movie_model.dart';
import 'package:movie_web/widgets/movie.dart';

class CategoryMovie extends StatelessWidget {
  final String category;
  final List<MovieModel> movies;

  CategoryMovie({this.category, this.movies});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('$category'),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return SizedBox(width: 10.0,);
              },
              itemBuilder: (context, index) {
                final movieInfo = movies[index];
                return Movie(moviesInfo: movieInfo);
              },
              itemCount: movies.length,
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              
            ),
          )
        ],
      ),
    );
  }
}
