import 'package:flutter/material.dart';
import 'package:movie_web/common/layout/platform-button.dart';

class PlatformScreen extends StatelessWidget {
  static final String routeName = '/platform-example';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          // IOS Android button
          PlatformButton(
            child: Text('Android Button'),
            onPressed: () {},
          ),
          PlatformButton(
            child: Text('IOS Button'),
            onPressed: () {},
            ios: true,
          ),
        ],
      ),
    );
  }
}
