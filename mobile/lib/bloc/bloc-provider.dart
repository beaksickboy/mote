import 'package:flutter/material.dart';
import 'package:movie_web/bloc/user-service.dart';

class BlocProvider extends InheritedWidget {
  final userBloc = UserService();

  BlocProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static BlocProvider of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<BlocProvider>();
}
