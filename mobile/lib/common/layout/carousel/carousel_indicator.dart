import 'package:flutter/material.dart';

class CarouselIndicator extends StatelessWidget {
  final Listenable controller;
  final int size;

  CarouselIndicator({@required this.controller, this.size});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(animation: controller, builder: (context, widget) {

    },
    child: Row(
      children: [

      ],
    ),
    );
  }
}
