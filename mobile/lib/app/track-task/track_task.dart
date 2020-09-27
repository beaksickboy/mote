import 'package:flutter/material.dart';
import 'package:movie_web/app/track-task/task_appbar.dart';

class TrackTask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [TaskAppBar()],
        ),
      ),
    );
  }
}
