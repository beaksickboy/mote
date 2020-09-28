import 'package:flutter/material.dart';
import 'package:movie_web/common/layout/carousel.dart';

class ParallaxCarouselScreen extends StatelessWidget {
  static String routeName = '/parallax-carousel-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: ParallaxCarousel(
              showScrollIndicator: true,
              items: [
                ParallaxCardModel(
                  backgroundImage: AssetImage('assets/pic1.jpg'),

                ),
                ParallaxCardModel(
                  backgroundImage: AssetImage('assets/pic2.jpg'),

                ),
                ParallaxCardModel(
                  backgroundImage: AssetImage('assets/pic3.jpg'),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
