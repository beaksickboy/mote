import 'package:flutter/material.dart';
import 'package:movie_web/models/movie_model.dart';

class Movie extends StatelessWidget {
  final MovieModel moviesInfo;
  final double width;
  final double height;
  final double movieTitleHeight;
  Movie({this.moviesInfo, this.width, this.height, this.movieTitleHeight});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        children: [
          SizedBox(
            child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(15.0),
                ),
                child: FadeInImage.assetNetwork(
                  image: moviesInfo.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: 'assets/loading.gif',
                )),
            height: height,
          ),
          FittedBox(
            child: Text(
              '${moviesInfo.name}',
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
