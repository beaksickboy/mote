import 'package:flutter/material.dart';

class LLCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 500,
        child: PageView.builder(
          itemBuilder: (context, index) {
            print(index);
            return index % 2 == 0
                ? Container(
                    child: Text('a'),
                    color: Colors.purple,
                  )
                : Container(
                    child: Text('b'),
                  );
          },
          itemCount: 2,
//          controller: ,
        ),
      ),
    );
  }
}
