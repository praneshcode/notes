import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes/screens/home/notebox.dart';
import 'package:notes/services/database.dart';
import 'package:provider/provider.dart';

class NoteBoxList extends StatelessWidget {
  int crossAxisCount;

  NoteBoxList({required this.crossAxisCount});

  @override
  Widget build(BuildContext context) {
    final snapshot = Provider.of<DocumentSnapshot?>(context);
    if (snapshot == null) {
      return Container();
    }

    final List<NoteBox> _noteBoxList =
        DatabaseService.notesListFromSnapshot(snapshot)
            .map((element) => NoteBox(noteData: element))
            .toList();

    if (_noteBoxList.isEmpty) {
      return Center(
        child: Text('add some notes'),
      );
    }

    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Padding(
        padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
        child: StaggeredGrid.count(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          children: _noteBoxList,
        ),
      ),
    );
  }
}
