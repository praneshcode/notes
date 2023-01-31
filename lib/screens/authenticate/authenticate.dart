import 'package:flutter/material.dart';
import 'package:notes/screens/authenticate/sign_in.dart';
import 'package:notes/screens/authenticate/register.dart';

class Authenticate extends StatefulWidget {
  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;

  void toggleview() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return showSignIn
        ? SignIn(
            toggleView: toggleview,
          )
        : Register(
            toggleView: toggleview,
          );
  }
}
