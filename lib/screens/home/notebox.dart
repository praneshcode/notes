import 'package:flutter/material.dart';
import 'package:notes/models/note_data.dart';

class NoteBox extends StatelessWidget {
  final NoteData noteData;

  NoteBox({required this.noteData});

  List<Widget> _widgetList(NoteData noteData) {
    Text titleWidget = Text(
      noteData.title,
      style: TextStyle(
          fontSize: 16.0, color: Colors.black, fontWeight: FontWeight.w500),
    );
    SizedBox space = SizedBox(height: 8.0);
    Text bodyWidget = Text(
      noteData.body,
      style: TextStyle(
        fontSize: 14.0,
        color: Colors.grey[600],
      ),
      maxLines: 10,
      overflow: TextOverflow.ellipsis,
    );

    if (noteData.title.isEmpty && noteData.body.isNotEmpty) {
      return [bodyWidget];
    } else if (noteData.body.isEmpty && noteData.title.isNotEmpty) {
      return [titleWidget];
    } else if (noteData.body.isEmpty && noteData.title.isEmpty) {
      return [titleWidget];
    }

    return [titleWidget, space, bodyWidget];
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/editor', arguments: {
          'noteId': noteData.noteId,
          'title': noteData.title,
          'body': noteData.body,
        });
      },
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          border: Border.all(
            color: Colors.grey[350]!,
            width: 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _widgetList(noteData),
        ),
      ),
    );
  }
}
