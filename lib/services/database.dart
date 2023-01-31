import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';
import 'package:notes/models/note_data.dart';

class DatabaseService {
  final String? uid;

  DatabaseService({this.uid});

  final CollectionReference _noteCollection =
      FirebaseFirestore.instance.collection('notes');

  Stream<DocumentSnapshot> get notesSnapshot {
    return _noteCollection.doc(uid).snapshots();
  }

  static List<NoteData> notesListFromSnapshot(DocumentSnapshot snapshot) {
    var firestoreMap = snapshot.data() as Map;
    firestoreMap
        .removeWhere((key, value) => key == 'ignore' || key == 'profile');

    List<NoteData> list = firestoreMap.entries.map((MapEntry mapEntry) {
      String noteId = mapEntry.key;
      Map nestedMap = mapEntry.value;
      return NoteData(
          noteId: noteId, title: nestedMap['title'], body: nestedMap['body']);
    }).toList();

    return list;
  }

  Future createDocument() async {
    await _noteCollection.doc(uid).set({'ignore': '', 'profile': ''});
  }

  Future updateProfilePic(String url) async {
    await _noteCollection
        .doc(uid)
        .set({'profile': url}, SetOptions(merge: true));
  }

  static String getProfilePic(DocumentSnapshot snapshot) {
    var firestoreMap = snapshot.data() as Map;
    return firestoreMap['profile'];
  }

  Future<Map?> createNote() async {
    var randomNoteId = randomAlphaNumeric(10);

    bool error = false;
    await _noteCollection.doc(uid).update({
      randomNoteId: {'title': '', 'body': ''}
    }).onError((error, stackTrace) {
      error = true;
    });

    if (!error) {
      return {'noteId': randomNoteId, 'title': '', 'body': ''};
    }
  }

  Future deleteNote(String noteId) async {
    await _noteCollection.doc(uid).update({noteId: FieldValue.delete()});
  }

  Future updateTitle(String noteId, String title) async {
    await _noteCollection.doc(uid).set({
      noteId: {'title': title}
    }, SetOptions(merge: true));
  }

  Future updateBody(String noteId, String body) async {
    await _noteCollection.doc(uid).set({
      noteId: {'body': body}
    }, SetOptions(merge: true));
  }
}
