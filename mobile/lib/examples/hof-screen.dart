import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:movie_web/common/layout/collapsible-container.dart';
import 'package:nima/nima_actor.dart';

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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20.0),
                child: CollapsibleContainer(
                  background: NimaActor(
                    'assets/fish/Fish_and_Stuff.nima',
                    fit: BoxFit.contain,
                    animation: 'Idle',
                  ),
                  child: Container(
                    child: Text('My Child Will so when expand'),
                    height: 150,
                    width: double.infinity,
                    color: Colors.blue,
                  ),
                  backgroundColor: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20.0),
                child: CollapsibleContainer(
                  background: NimaActor(
                    'assets/Robot.nima',
                    fit: BoxFit.contain,
                    animation: 'Flight',
                  ),
                  child: Container(
                    child: Text('My Child Will so when expand'),
                    height: 150,
                    width: double.infinity,
//                    color: Colors.blue,
                  ),
                  backgroundColor: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
