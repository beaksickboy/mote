import 'dart:math';

import 'package:flutter/material.dart';

class RadialGesture extends StatefulWidget {
  final RadialGestureStart onRadialGestureStart;
  final RadialGestureUpdate onRadialGestureUpdate;
  final RadialGestureEnd onRadialGestureEnd;
  final Widget child;

  RadialGesture(
      {this.onRadialGestureStart,
      this.onRadialGestureUpdate,
      this.onRadialGestureEnd,
      this.child});

  @override
  _RadialGestureState createState() => _RadialGestureState();
}

class _RadialGestureState extends State<RadialGesture> {
  PolarCoordinate _polarCoordinate(globalOffset) {
    final localTouchOffset =
        (context.findRenderObject() as RenderBox).globalToLocal(globalOffset);

    // Convert the local offset to a Point so that we can do math with it.
    final localTouchPoint = new Point(localTouchOffset.dx, localTouchOffset.dy);

    // Create a Point at the center of this Widget to act as the origin.
    final originPoint =
        new Point(context.size.width / 2, context.size.height / 2);
    return PolarCoordinate.fromPoints(originPoint, localTouchPoint);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (DragStartDetails details) {
        final polarCoordinate = _polarCoordinate(details.globalPosition);
        widget.onRadialGestureStart();
      },
      onPanUpdate: (DragUpdateDetails details) {
        final polarCoordinate = _polarCoordinate(details.globalPosition);
        print(polarCoordinate);
        widget.onRadialGestureUpdate();
      },
      onPanEnd: (DragEndDetails details) {
        widget.onRadialGestureEnd();
      },
      child: widget.child,
      behavior: HitTestBehavior.opaque,
    );
  }
}

class PolarCoordinate {
  final double angle;
  final double radius;

  factory PolarCoordinate.fromPoints(Point origin, Point point) {
    // Subtract the origin from the point to get the vector from the origin
    // to the point.
    final vectorPoint = point - origin;
    final vector = new Offset(vectorPoint.x, vectorPoint.y);

    // The polar coordinate is the angle the vector forms with the x-axis, and
    // the distance of the vector.
    return PolarCoordinate(
      vector.direction,
      vector.distance,
    );
  }

  PolarCoordinate(this.angle, this.radius);

  @override
  toString() {
    return 'Polar Coord: ${radius.toStringAsFixed(2)}' +
        ' at ${(angle * (360 / (2 * pi))).toStringAsFixed(2)}°';
  }
}

typedef RadialGestureStart = void Function();
typedef RadialGestureUpdate = void Function();
typedef RadialGestureEnd = void Function();
