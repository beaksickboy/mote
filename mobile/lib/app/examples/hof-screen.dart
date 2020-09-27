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
                    fit: BoxFit.cover,
                    animation: 'Idle',
                  ),
                  baseBuilder: (collapse) {
                    return Container(
                      child: FlareActor(
                        'assets/ExpandCollapse.flr',
                        animation: collapse ? 'Expand' : 'Collapse',
                        color: Colors.black,
                      ),
                      width: 20,
                      height: 20,
                    );
                  },
                  child: _Detail(),
                  backgroundColor: Colors.lightBlueAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Detail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Robot Era',
            style: TextStyle(
                fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Container(
            height: 100,
            child: NimaActor(
              'assets/Robot.nima',
              fit: BoxFit.contain,
              animation: 'Flight',
            ),
          )
        ],
      ),
    );
  }
}
