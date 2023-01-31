import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes/screens/home/notebox.dart';
import 'package:notes/services/database.dart';

class CustomSearchDelegate extends SearchDelegate {
  DocumentSnapshot<Object?>? snapshot;

  CustomSearchDelegate(this.snapshot);

  Widget searchResult() {
    if (snapshot == null || query.isEmpty) {
      return Container(
        decoration: BoxDecoration(color: Colors.white),
      );
    }

    final List<NoteBox> noteBoxList =
        DatabaseService.notesListFromSnapshot(snapshot!)
            .map((element) => NoteBox(noteData: element))
            .toList();

    List<NoteBox> matchQueryList = [];
    noteBoxList.forEach((element) {
      if (element.noteData.title.toLowerCase().contains(query.toLowerCase()) ||
          element.noteData.body.toLowerCase().contains(query.toLowerCase())) {
        matchQueryList.add(element);
      }
    });

    return Container(
      height: double.infinity,
      decoration: BoxDecoration(color: Colors.white),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
          child: StaggeredGrid.count(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            children: matchQueryList,
          ),
        ),
      ),
    );
  }

  @override
  String get searchFieldLabel => 'Search your notes';

  @override
  ThemeData appBarTheme(BuildContext context) {
    return super.appBarTheme(context).copyWith(
          appBarTheme: super.appBarTheme(context).appBarTheme.copyWith(
                elevation: 0.0,
                toolbarHeight: 65.0,
                color: Color.fromRGBO(248, 247, 251, 1),
              ),
          hintColor: Colors.grey[400],
          textTheme: TextTheme(
            headline6: TextStyle(
              color: Colors.black,
              fontSize: 17.0,
            ),
          ),
        );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: query.isEmpty
            ? Icon(null)
            : Icon(
                Icons.clear,
                color: Colors.grey[800],
              ),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(
        Icons.arrow_back,
        color: Colors.grey[800],
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) => searchResult();

  @override
  Widget buildSuggestions(BuildContext context) => searchResult();
}
