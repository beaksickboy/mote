import 'package:flutter/material.dart';

import 'package:movie_web/widgets/page_sliding.dart';

class HomeScreen extends StatelessWidget {
  final ratio = 118 / 55; // Width / Height 
  Widget _movieBanner(width) {
    return Container(
      width: width,
      height: width / ratio,
      child: OnePageSliding(),
    );
  }

  Widget build(BuildContext context) {
    // Size of screen
    final Size size = MediaQuery.of(context).size;
    
    // On smaller screen reduce padding ratio
    final paddingRatio = size.width < 600 ? 0.03 : 0.07;
    final padding = size.width * paddingRatio;

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: Column(
          children: <Widget>[
            _movieBanner(size.width - (padding * 2))
          ],
        ),
      ),
    );
  }
}