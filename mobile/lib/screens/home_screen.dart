import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:movie_web/widgets/parallax-carousel.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ParallaxCarousel(
              items: [
                ParallaxCardModel(
                  backgroundImage: Image.asset('assets/pic1.jpg', fit: BoxFit.cover,),

                ),
                ParallaxCardModel(
                  backgroundImage: Image.asset('assets/pic2.jpg', fit: BoxFit.cover),

                ),
                ParallaxCardModel(
                  backgroundImage: Image.asset('assets/pic3.jpg', fit: BoxFit.cover),

                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
