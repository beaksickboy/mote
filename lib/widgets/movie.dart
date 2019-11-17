import 'package:flutter/material.dart';
import 'package:movie_web/models/movie_model.dart';

class Movie extends StatelessWidget {
  final MovieModel moviesInfo;
  Movie({this.moviesInfo});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180.0,
      child: Column(
        children: [
          SizedBox(
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(15.0),
              ),
              child: Image.network(
                moviesInfo.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            height: 250,
          ),
          FittedBox(
            child: Text(
              '${moviesInfo.name}',
              maxLines: 1,
            ),
          )
        ],
      ),
    );
  }
}
