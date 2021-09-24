import 'package:animated_login/screens/home/home_screen.dart';
import 'package:flutter/material.dart';


Future push(
    BuildContext context,
    Widget page,
    ) {
  return Navigator.push(
    context,
    MaterialPageRoute(builder: (BuildContext context) => page),
  );
}

Future replace(BuildContext context, Widget page) {
  return Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (BuildContext context) => page),
  );
}

void popUntilHome(BuildContext context) {
  if (Navigator.canPop(context)) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
          (route) => false,
    );
  }
}