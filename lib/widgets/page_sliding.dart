import 'package:flutter/material.dart';

class OnePageSliding extends StatefulWidget {
  @override
  _OnePageSlidingState createState() => _OnePageSlidingState();
}

class _OnePageSlidingState extends State<OnePageSliding> {
  final movies = [Colors.blue, Colors.green, Colors.amber];

  final PageController _pageController = PageController(
    initialPage: 0,
  );

  Widget _buttonLeft() {
    return Align(
      alignment: Alignment.centerLeft,
      child: FlatButton(
        shape: CircleBorder(),
        child: Icon(
          Icons.chevron_left,
          color: Colors.white,
          size: 50,
        ),
        onPressed: () {
          final pageIndex = (_pageController.page - 1).toInt();
          // print(_pageController.page);
          // print(pageIndex);
          // print(pageIndex);
          // if (pageIndex >= 0) {
            _pageController.animateToPage(
              pageIndex >= 0 ? pageIndex : movies.length,
              curve: Curves.linear,
              duration: Duration(milliseconds: 500),
            );
          // }
        },
      ),
    );
  }

  Widget _buttonRight() {
    return Align(
      alignment: Alignment.centerRight,
      child: FlatButton(
        shape: CircleBorder(),
        child: Icon(
          Icons.chevron_right,
          color: Colors.white,
          size: 50,
        ),
        onPressed: () {
          final pageIndex = (_pageController.page + 1).toInt();
          print(pageIndex);
          // if (pageIndex <= movies.length) {
            _pageController.animateToPage(
               pageIndex <= (movies.length - 1)  ? pageIndex : 0,
              curve: Curves.linear,
              duration: Duration(milliseconds: 500),
            );
          // }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        PageView.builder(
          controller: _pageController,
          itemCount: movies.length,
          itemBuilder: (context, index) {
            return Container(
              color: movies[index],
            );
          },
        ),
        _buttonLeft(),
        _buttonRight()
      ],
    );
  }
}
