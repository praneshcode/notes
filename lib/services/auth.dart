import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes/services/database.dart';

class AuthSevice {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get user {
    return _auth.authStateChanges();
  }

  Future<bool> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      await DatabaseService(uid: user.user!.uid).createDocument();
    } catch (e) {
      print(e);
      return false;
    }

    return true;
  }

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print(e);
      return false;
    }

    return true;
  }

  Future<bool> signInWithGoogleAccount() async {
    return true;
  }

  Future<bool> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }
}
