import 'package:flutter/material.dart';
import 'package:movie_web/common/layout/carousel/carousel.dart';

class ParallaxCarouselScreen extends StatelessWidget {
  static String routeName = '/parallax-carousel-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: Carousel(
              showScrollIndicator: true,
              viewPortFraction: 0.8,
              boxPadding: EdgeInsets.all(10),
              infiniteScroll: false,
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
