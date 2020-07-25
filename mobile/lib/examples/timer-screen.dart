import 'package:flutter/material.dart';
import 'package:movie_web/common/radial-gesture.dart';

class TimeScreen extends StatelessWidget {
  static String routeName = '/timer-screen';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Center(child: CurvedPosition()),
      ),
    );
  }
}

class CurvedPosition extends StatefulWidget {
  @override
  _CurvedPositionState createState() => _CurvedPositionState();
}

class _CurvedPositionState extends State<CurvedPosition>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..forward();
    animation = CurvedAnimation(parent: controller, curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      animation: animation,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class AnimatedBox extends AnimatedWidget {
  AnimatedBox({Key key, this.animation})
      : super(key: key, listenable: animation);
  final Animation<double> animation;
  final double _width = 400;
  final double _height = 300;
  static final _leftTween = Tween(begin: 0, end: 1.0);
  static final _bottomTween = CurveTween(curve: Curves.ease);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _width,
      height: _height,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(border: Border.all()),
      child: Stack(
        children: <Widget>[
          Positioned(
            left: _leftTween.evaluate(animation) * _width,
            bottom: _bottomTween.evaluate(animation) * _height,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: Colors.red),
            ),
          )
        ],
      ),
    );
  }
}

class _Clock extends StatelessWidget {
  const _Clock({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Using to get argument pass to this route
//    print((ModalRoute.of(context).settings.arguments as dynamic)["ac"];
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration:
              BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    color: Colors.white,
                    offset: Offset(0, 1),
                    blurRadius: 0.1,
                    spreadRadius: 0.1),
              ], shape: BoxShape.circle),
              child: _Timer(),
            ),
          ),
        ),
      ),
    );
  }
}

class _Timer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RadialGesture(
          onRadialGestureStart: () {},
          onRadialGestureUpdate: () {},
          onRadialGestureEnd: () {},
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: CustomPaint(
              painter: _TimerPainter(),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

class _TimerPainter extends CustomPainter {
  Paint tickPaint = Paint()
    ..style = PaintingStyle.fill
    ..color = Colors.black;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();

    Path path = new Path();
    path.moveTo(0, -10);
    path.lineTo(-10, 0);
    path.lineTo(10, 0);
    path.close();

    canvas.translate(size.width / 2, 0);

//    canvas.rotate(radians)

    canvas.drawPath(path, tickPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class AnimatedContainer extends StatelessWidget {
  AnimatedContainer({Key key, this.animation})
      : width = Tween(begin: 0.0, end: 300.0).animate(CurvedAnimation(
            parent: animation,
            curve: Interval(0.0, 0.5, curve: Curves.easeInOut))),
        height = Tween(begin: 0.0, end: 200.0).animate(CurvedAnimation(
            parent: animation,
            curve: Interval(0.2, 0.7, curve: Curves.bounceInOut))),
        backgroundColor = ColorTween(begin: Colors.red, end: Colors.green)
            .animate(CurvedAnimation(
                parent: animation,
                curve: Interval(0.3, 1.0, curve: Curves.elasticInOut))),
        super(key: key);

  final Animation<double> animation;
  final Animation<double> width;
  final Animation<double> height;
  final Animation<Color> backgroundColor;

  Widget _build(BuildContext context, Widget child) {
    return Container(
      width: width.value,
      height: height.value,
      decoration: BoxDecoration(color: backgroundColor.value),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: _build,
    );
  }
}
