import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class HistoryOfEverythingScreen extends StatefulWidget {
  static final String routeName = 'hof';

  @override
  _HistoryOfEverythingState createState() => _HistoryOfEverythingState();
}

class _HistoryOfEverythingState extends State<HistoryOfEverythingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          Text('ABC'),
          Container(
            padding: const EdgeInsets.all(20.0),
            child: CollapsibleContainer(
              child: Text('My Child What so ever'),
              backgroundColor: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}

class CollapsibleContainer extends StatefulWidget {
  final Duration duration;
  final Widget child;
  final Color backgroundColor;
  final Color iconColor;

  const CollapsibleContainer(
      {Key key,
      @required this.child,
      this.duration = const Duration(milliseconds: 300),
      this.backgroundColor = Colors.grey,
      this.iconColor = Colors.black})
      : super(key: key);

  @override
  _CollapsibleContainerState createState() => _CollapsibleContainerState();
}

class _CollapsibleContainerState extends State<CollapsibleContainer>
    with SingleTickerProviderStateMixin {
  bool _isCollapse = true;
  AnimationController animationController;
  Animation<double> sizedAnimation;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: widget.duration, vsync: this);
    sizedAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  onToggle() {
    setState(() {
      _isCollapse = !_isCollapse;
    });

    switch (sizedAnimation.status) {
      case AnimationStatus.completed:
        animationController.reverse();
        break;
      case AnimationStatus.dismissed:
        animationController.forward();
        break;
      // When in the middle of animating then do nothing
      case AnimationStatus.reverse:
      case AnimationStatus.forward:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: [
            Container(
              height: 150,
              child: Row(
                children: [
                  Container(
                    child: FlareActor(
                      'assets/ExpandCollapse.flr',
                      animation: _isCollapse ? 'Collapse' : 'Expand',
                      color: widget.iconColor,
                    ),
                    width: 20,
                    height: 20,
                  )
                ],
              ),
            ),
            SizeTransition(
              sizeFactor: sizedAnimation,
              axis: Axis.vertical,
              child: widget.child,
            )
          ],
        ),
      ),
    );
  }
}
