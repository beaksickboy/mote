//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//
//class MultiSelectDropdownMenu extends StatelessWidget {
//  final List<dynamic> items;
//
//  MultiSelectDropdownMenu({
//    Key key,
//    @required this.items
//  });
//
//  @override
//  Widget build(BuildContext context) {
//    return DropdownButtonFormField(
//      onChanged: (value) {
//        print(value);
//      },
//      value: false,
//
//      items: [
//        DropdownMenuItem(
//          value: true,
//          child: Text('asdad'),
//        ),
//        DropdownMenuItem(
//          value: false,
//          child: Row(
//            children: [
//              Checkbox(
//                value: false,
//                onChanged: (value) {
//
//                },
//              ),
//              Text('adsadadads')
//            ],
//          ),
//        )
//      ],
//    );
//  }
//}

import 'package:flutter/material.dart';

/*
  Create a popup route to push on top of stack
  Get available constraint with LayoutBuilder
 */
class _MultiSelectDropdownRoute extends PopupRoute {
  Widget child;
  Rect inputRect;

  _MultiSelectDropdownRoute({@required this.child, this.inputRect});

  @override
  Color get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return _MultiSelectDropdownPage(
          child: child,
          constraints: constraints,
          inputRect: inputRect
        );
      },
    );
  }

  @override
  Duration get transitionDuration => Duration(milliseconds: 500);

  @override
  String get barrierLabel => 'BarrierLabel';
}

class _MultiSelectDropdownPage extends StatelessWidget {
  final BoxConstraints constraints;
  final Widget child;
  final Rect inputRect;

  _MultiSelectDropdownPage({this.constraints, this.child, this.inputRect});

  @override
  Widget build(BuildContext context) {
    print(constraints.toString());
//    DropdownButtonFormField
    return child;
  }
}

class MultiSelectDropdownMenu extends StatefulWidget {
  final List<DropdownMenuItem> items;
  final bool filter;

  MultiSelectDropdownMenu({@required this.items, this.filter});

  @override
  _MultiSelectDropdownMenuState createState() =>
      _MultiSelectDropdownMenuState();
}

class _MultiSelectDropdownMenuState extends State<MultiSelectDropdownMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: InputDecorator(
          child: Text('adads'),
          decoration: InputDecoration(
            suffixIcon: Icon(Icons.arrow_drop_down),
          ),
        ),
        onTap: () {
          // Get curren input render box
          final RenderBox inputBox = context.findRenderObject();
          // Cast to rect
          final Rect inputRect =
              inputBox.localToGlobal(Offset.zero) & inputBox.size;
          Navigator.of(context).push(
            _MultiSelectDropdownRoute(
              child: Text('adas'),
              inputRect: inputRect,
            ),
          );
        },
      ),
    );
  }
}
