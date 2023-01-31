import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes/services/database.dart';
import 'package:provider/provider.dart';

class NoteEditor extends StatefulWidget {
  @override
  State<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  Map mapFromNoteBox = {};

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    var data = ModalRoute.of(context)?.settings.arguments;
    if (data != null) {
      mapFromNoteBox = data as Map;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.0,
        actions: [
          PopupMenuButton(
            onSelected: (value) async {
              await DatabaseService(uid: user!.uid)
                  .deleteNote(mapFromNoteBox['noteId']);

              print('deleted ${mapFromNoteBox['noteId']}');
              Navigator.pop(context);
            },
            constraints: BoxConstraints(maxWidth: 64.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            itemBuilder: (context) {
              return {'Delete'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Container(
                    child: Icon(
                      Icons.delete_outline,
                      color: Colors.red[900],
                    ),
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20.0, 24.0, 24.0, 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: mapFromNoteBox['title'],
                onChanged: (value) async {
                  await DatabaseService(uid: user!.uid)
                      .updateTitle(mapFromNoteBox['noteId'], value);
                },
                style: TextStyle(fontSize: 22.0),
                decoration: InputDecoration.collapsed(
                  hintText: 'Title',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                ),
                maxLines: null,
              ),
              SizedBox(height: 20.0),
              TextFormField(
                onChanged: (value) async {
                  await DatabaseService(uid: user!.uid)
                      .updateBody(mapFromNoteBox['noteId'], value);
                },
                initialValue: mapFromNoteBox['body'],
                style: TextStyle(fontSize: 16.0),
                decoration: InputDecoration.collapsed(
                  hintText: 'Note',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                ),
                maxLines: null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
