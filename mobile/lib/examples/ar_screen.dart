import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';

class ArScreen extends StatelessWidget {
  static String routeName = '/ar-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ARKitSceneView(
        onARKitViewCreated: (controller) {

        },
      ),
    );
  }
}
