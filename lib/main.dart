import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes/screens/wrapper.dart';
import 'package:notes/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:notes/screens/home/note_editor.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
  ));

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyC8855Y2hzN0-bwGU9KfrzXZjF0qFz3-dk",
            projectId: "notes-1e47c",
            messagingSenderId: "132164172246",
            appId: "1:132164172246:web:33506bcb332349a4ef0c77"));
  } else {
    await Firebase.initializeApp();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      value: AuthSevice().user,
      initialData: null,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => Wrapper(),
          '/editor': (context) => NoteEditor(),
        },
      ),
    );
  }
}
