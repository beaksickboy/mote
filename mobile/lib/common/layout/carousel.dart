import 'dart:ui';
import 'package:flutter/material.dart';

class ParallaxCarousel extends StatefulWidget {
  final List<ParallaxCardModel> items;
  final int borderRadius;
  final bool showScrollIndicator;

  ParallaxCarousel({
    @required this.items,
    this.borderRadius,
    this.showScrollIndicator = false,
  });

  @override
  _ParallaxCarouselState createState() => _ParallaxCarouselState();
}

class _ParallaxCarouselState extends State<ParallaxCarousel> {
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: PageController(
        viewportFraction: 0.8,

      ),
      itemBuilder: (context, index) {
        index = index % widget.items.length;
        return Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: widget.items[index].backgroundImage,
            fit: BoxFit.cover,
          )),
          child: widget.items[index].widget,
        );
      },
      // itemCount: widget.items.length,
    );
  }
}
//
// class _BottomBar extends StatelessWidget {
//   final double scrollPercent;
//   final int numCards;
//   final Color thumbColor;
//   final Color trackColor;
//   final bool showScrollIndicator;
//
//   _BottomBar(
//       {@required this.scrollPercent,
//       @required this.numCards,
//       this.thumbColor,
//       this.trackColor,
//       this.showScrollIndicator});
//
//   @override
//   Widget build(BuildContext context) {
//     return showScrollIndicator
//         ? Container(
//             height: 40.0,
//             width: double.infinity,
//             padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
//             child: _ScrollIndicator(
//               scrollPercent: scrollPercent,
//               numCards: numCards,
//               thumbColor: thumbColor,
//               trackColor: trackColor,
//             ),
//           )
//         : SizedBox(
//             height: 0,
//             width: 0,
//           );
//   }
// }
//
// class _CarouselCard extends StatelessWidget {
//   final double parallax;
//   final ParallaxCardModel el;
//   final BorderRadius borderRadius;
//
//   _CarouselCard({
//     @required this.parallax,
//     @required this.el,
//     this.borderRadius,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       fit: StackFit.expand,
//       children: [
//         ClipRRect(
//           borderRadius: this.borderRadius ?? BorderRadius.circular(10),
//           child: FractionalTranslation(
//             translation: Offset(parallax * 2.0, 0),
//             child: OverflowBox(
//               maxWidth: double.infinity,
//               child: el.backgroundImage,
//             ),
//           ),
//         ),
//
//         /// SizedBox.shrink() Return an container width and height is 0
//         el.widget ?? SizedBox.shrink(),
//       ],
//     );
//   }
// }

class ParallaxCardModel {
  final ImageProvider backgroundImage;
  final Widget widget;

  ParallaxCardModel({@required this.backgroundImage, @required this.widget});
}
