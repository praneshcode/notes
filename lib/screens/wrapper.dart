import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes/screens/authenticate/authenticate.dart';
import 'package:notes/screens/home/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    if (user?.uid == null) {
      return Authenticate();
    } else {
      print('${user?.uid} signed in');
      return Home();
    }
  }
}
