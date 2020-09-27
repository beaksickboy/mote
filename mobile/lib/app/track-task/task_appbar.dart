import 'package:flutter/material.dart';
import 'package:movie_web/common/presentation/custom_icon_icons.dart';

class TaskAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        // appBarTheme: AppBarTheme(
        //   color: Colors.purple
        // )
      ),
      child: Container(
        height: 50,
        width: double.infinity,
        color: Colors.purple,
        child: Row(
          children: [Icon(Icons.tag_faces_sharp),
          Expanded(child: Container()),
          Icon(CustomIcon.user),
          Icon(Icons.notifications)],
        ),
      ),
    );
  }
}
