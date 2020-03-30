import 'package:flutter/material.dart';
import 'package:movie_web/utils/color_util.dart';

class SearchScreen extends SearchDelegate {

  // Override default hint
  @override
  String get searchFieldLabel => 'Find your favorite anime';



  // Override default appBarTheme
  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme.copyWith(
      primaryColor:  ColorUtil.backgroundColor, // Background color
      primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.grey),
      primaryColorBrightness: Brightness.light,
      primaryTextTheme: theme.textTheme.copyWith(),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    // if no text then dnot show clear button
    return query.length > 0 ? [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ] : [];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Maybe add some filter view
    // Show as ListTile, select a movie will navigate user to that moview detail
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Show search suggestion with Icon Icons.call_made
    // Click on one row or hit search will show search result like Tiki
    return Container();
  }
}
