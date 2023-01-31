import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Widget loadingWidget(Color color, double size) {
  return Scaffold(
    body: Center(
      child: SpinKitCircle(
        color: color,
        size: size,
      ),
    ),
  );
}
