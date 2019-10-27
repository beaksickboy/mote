import 'package:flutter/material.dart';

class OnePageSliding extends StatefulWidget {
  @override
  _OnePageSlidingState createState() => _OnePageSlidingState();
}

class _OnePageSlidingState extends State<OnePageSliding> {
  final movies = [Colors.blue, Colors.green, Colors.amber];

  int currentPage = 0;

  final PageController _pageController = PageController(
    initialPage: 0,
  );

  Widget _buttonLeft() {
    return Align(
      alignment: Alignment.centerLeft,
      child: IconButton(
        icon: Icon(
          Icons.chevron_left,
          color: Colors.white,
          size: 50,
        ),
        onPressed: () {},
      ),
    );
  }

  Widget _buttonRight() {
    return Align(
      alignment: Alignment.centerRight,
      child: IconButton(
        
        icon: Icon(
          Icons.chevron_right,
          color: Colors.white,
          size: 50.0,
        ),
        onPressed: () {},
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
