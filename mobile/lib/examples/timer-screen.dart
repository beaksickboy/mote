import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:movie_web/common/layout/random-color-block.dart';
import 'package:movie_web/common/radial-gesture.dart';

final Color GRADIENT_TOP = const Color(0xFFF5F5F5);
final Color GRADIENT_BOTTOM = const Color(0xFFE8E8E8);

class TimeScreen extends StatelessWidget {
  static String routeName = '/timer-screen';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
            child: Column(
          children: [
            RandomColorBlock(
              height: 150,
            ),
            _Clock(),
            Expanded(child: Container()),
            RandomColorBlock(
              height: 50,
            ),
            RandomColorBlock(
              height: 50,
            )
          ],
        )),
      ),
    );
  }
}

class _Clock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(50.0),
        child: AspectRatio(
          aspectRatio: 1.0,
          child: Container(
            padding: EdgeInsets.all(55),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [GRADIENT_TOP, GRADIENT_BOTTOM],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x44000000),
                    blurRadius: 2,
                    spreadRadius: 1,
                    offset: Offset(0, 1),
                  )
                ]
                // boxShadow:
                ),
            child: Stack(children: [
              Container(
                height: double.infinity,
                width: double.infinity,
                child: CustomPaint(
                  painter: TickPainter(),
                ),
              ),
              RadialGestureDetector()
              // KnobTimer(
              //   rotatePercent: 0.25,
              // )
            ]),
          ),
        ),
      ),
    );
  }
}

class TickPainter extends CustomPainter {
  final numberOfTick = 35;
  final tickSize = 6;
  final longTickPerSection = 5;
  final offsetTick = 25;

  final tickPaint = Paint()
    ..color = Colors.black
    ..strokeWidth = 1.0;
  final textPaint = TextPainter()
    ..textAlign = TextAlign.center
    ..textDirection = TextDirection.ltr;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.height / 2;
    double rotation = 0;
    canvas.translate(size.width / 2, size.height / 2);

    canvas.save();

    for (var i = 0; i < numberOfTick; i++) {
      bool isLongTick = (i % longTickPerSection) == 0;
      canvas.drawLine(
          Offset(0, -radius), Offset(0, -radius - tickSize), tickPaint);

      if (isLongTick) {
        canvas.save();
        canvas.translate(0, -radius - offsetTick);
        textPaint.text = TextSpan(
          text: "$i",
          style: TextStyle(
            color: Colors.black,
          ),
        );
        textPaint.layout();
        // Rotate text backward
        canvas.rotate(-rotation);

        textPaint.paint(
            canvas, Offset((-textPaint.width / 2), -textPaint.height / 2));
        canvas.restore();
      }
      rotation += 2 * pi / numberOfTick;
      canvas.rotate(2 * pi / numberOfTick);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class RadialGestureDetector extends StatefulWidget {
  final Widget child;

  RadialGestureDetector({this.child});

  @override
  _RadialGestureDetectorState createState() => _RadialGestureDetectorState();
}

class _RadialGestureDetectorState extends State<RadialGestureDetector> {
  double currentRadian = 0;
  PolarCoordinate startCoordinate;
  PolarCoordinate trackingCurrentCoordinate;

  format(double radian) {
    if (radian >= -3 && radian <= -1.5) {
      return 1.5 + radian;
    } else if (radian > -1.5 && radian <= 0) {
      return radian + 1.5;
    } else if (radian > 0 && radian <= 1.5) {
      return radian + 1.5;
    } else {
      return -4.5 + radian;
    }
  }

  onRadialGestureStart(PolarCoordinate polarCoordinate) {
    // if (startCoordinate == null) {

    print("start " +
        (format(polarCoordinate.radian)).toString() +
        "  origin: " +
        polarCoordinate.radian.toString());
    startCoordinate = polarCoordinate;
    currentRadian = polarCoordinate.radian;
    // }
  }

  onRadialGestureUpdate(PolarCoordinate polarCoordinate) {
    if (startCoordinate == null) {
      return;
    }
    trackingCurrentCoordinate = polarCoordinate;
    // print((polarCoordinate.angle - startCoordinate.angle) / pi * 2);
    // double percent = (polarCoordinate.angle - startCoordinate.angle) / pi * 2;
    // print(percent);
    print(polarCoordinate.radian);
    setState(() {
      // radian = polarCoordinate.radian - startCoordinate.radian;
      currentRadian = format(polarCoordinate.radian);
    });
  }

  onRadialGestureEnd() {
    startCoordinate = trackingCurrentCoordinate;
  }

  @override
  Widget build(BuildContext context) {
    return RadialGesture(
      child: KnobTimer(
        rotatePercent: currentRadian,
      ),
      onRadialGestureStart: onRadialGestureStart,
      onRadialGestureUpdate: onRadialGestureUpdate,
      onRadialGestureEnd: onRadialGestureEnd,
    );
  }
}

class KnobTimer extends StatelessWidget {
  final double rotatePercent;

  KnobTimer({this.rotatePercent});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          child: CustomPaint(
            painter: ArrowPainter(rotatePercent: rotatePercent),
          ),
        ),
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [GRADIENT_TOP, GRADIENT_BOTTOM],
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x44000000),
                  blurRadius: 2,
                  spreadRadius: 1,
                  offset: Offset(0, 1),
                )
              ]
              // boxShadow:
              ),
          child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [GRADIENT_TOP, GRADIENT_BOTTOM],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x44000000),
                    blurRadius: 2,
                    spreadRadius: 1,
                    offset: Offset(0, 1),
                  )
                ]
                // boxShadow:
                ),
            child: Center(
              child: Transform.rotate(
                angle: pi * 2 * rotatePercent,
                child: Icon(Icons.timer),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ArrowPainter extends CustomPainter {
  final double rotatePercent;

  ArrowPainter({this.rotatePercent});

  Paint painter = Paint()
    ..style = PaintingStyle.fill
    ..color = Colors.black;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    canvas.save();

    canvas.translate(radius, radius);
    canvas.rotate(rotatePercent);
    // canvas.rotate(rotatePercent);
    Path path = new Path()
      ..moveTo(0, -radius - 10)
      ..lineTo(-10, -radius)
      ..lineTo(10, -radius)
      ..close();
    canvas.drawPath(path, painter);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

//
// class CurvedPosition extends StatefulWidget {
//   @override
//   _CurvedPositionState createState() => _CurvedPositionState();
// }
//
// class _CurvedPositionState extends State<CurvedPosition>
//     with SingleTickerProviderStateMixin {
//   AnimationController controller;
//   Animation<double> animation;
//
//   @override
//   void initState() {
//     super.initState();
//     controller = AnimationController(
//       duration: const Duration(seconds: 5),
//       vsync: this,
//     )..forward();
//     animation = CurvedAnimation(parent: controller, curve: Curves.easeInOut);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       animation: animation,
//     );
//   }
//
//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }
// }
//
// class AnimatedBox extends AnimatedWidget {
//   AnimatedBox({Key key, this.animation})
//       : super(key: key, listenable: animation);
//   final Animation<double> animation;
//   final double _width = 400;
//   final double _height = 300;
//   static final _leftTween = Tween(begin: 0, end: 1.0);
//   static final _bottomTween = CurveTween(curve: Curves.ease);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: _width,
//       height: _height,
//       margin: EdgeInsets.all(10),
//       decoration: BoxDecoration(border: Border.all()),
//       child: Stack(
//         children: <Widget>[
//           Positioned(
//             left: _leftTween.evaluate(animation) * _width,
//             bottom: _bottomTween.evaluate(animation) * _height,
//             child: Container(
//               width: 10,
//               height: 10,
//               decoration: BoxDecoration(color: Colors.red),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
//
// class _Clock extends StatelessWidget {
//   const _Clock({
//     Key key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     // Using to get argument pass to this route
// //    print((ModalRoute.of(context).settings.arguments as dynamic)["ac"];
//     return Padding(
//       padding: const EdgeInsets.all(30.0),
//       child: AspectRatio(
//         aspectRatio: 1,
//         child: Container(
//           decoration:
//               BoxDecoration(color: Colors.white, shape: BoxShape.circle),
//           child: Padding(
//             padding: const EdgeInsets.all(30.0),
//             child: Container(
//               decoration: BoxDecoration(boxShadow: [
//                 BoxShadow(
//                     color: Colors.white,
//                     offset: Offset(0, 1),
//                     blurRadius: 0.1,
//                     spreadRadius: 0.1),
//               ], shape: BoxShape.circle),
//               child: _Timer(),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _Timer extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         RadialGesture(
//           onRadialGestureStart: () {},
//           onRadialGestureUpdate: () {},
//           onRadialGestureEnd: () {},
//           child: Container(
//             width: double.infinity,
//             height: double.infinity,
//             child: CustomPaint(
//               painter: _TimerPainter(),
//             ),
//           ),
//         ),
//         Container(
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: Colors.grey,
//           ),
//         ),
//       ],
//     );
//   }
// }
//

//
// class AnimatedContainer extends StatelessWidget {
//   AnimatedContainer({Key key, this.animation})
//       : width = Tween(begin: 0.0, end: 300.0).animate(CurvedAnimation(
//             parent: animation,
//             curve: Interval(0.0, 0.5, curve: Curves.easeInOut))),
//         height = Tween(begin: 0.0, end: 200.0).animate(CurvedAnimation(
//             parent: animation,
//             curve: Interval(0.2, 0.7, curve: Curves.bounceInOut))),
//         backgroundColor = ColorTween(begin: Colors.red, end: Colors.green)
//             .animate(CurvedAnimation(
//                 parent: animation,
//                 curve: Interval(0.3, 1.0, curve: Curves.elasticInOut))),
//         super(key: key);
//
//   final Animation<double> animation;
//   final Animation<double> width;
//   final Animation<double> height;
//   final Animation<Color> backgroundColor;
//
//   Widget _build(BuildContext context, Widget child) {
//     return Container(
//       width: width.value,
//       height: height.value,
//       decoration: BoxDecoration(color: backgroundColor.value),
//       child: child,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: animation,
//       builder: _build,
//     );
//   }
// }
