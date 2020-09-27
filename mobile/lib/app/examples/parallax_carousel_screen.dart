import 'package:flutter/material.dart';
import 'package:movie_web/widgets/parallax-carousel.dart';

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
