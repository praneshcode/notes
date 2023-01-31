import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final _storageRef = FirebaseStorage.instance.ref();

  Future<String?> uploadFile(File file, String filename) async {
    try {
      final imageRef = _storageRef.child('profile_images/$filename.jpg');
      await imageRef.putFile(file);

      return imageRef.getDownloadURL();
    } catch (e) {
      return null;
    }
  }

  Future<bool> deleteFile(String filename) async {
    try {
      final imageRef = _storageRef.child('profile_images/$filename.jpg');
      await imageRef.delete();

      return true;
    } catch (e) {
      return false;
    }
  }

}
