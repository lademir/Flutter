import 'package:flutter/material.dart';
import 'package:buscador_gifs/ui/homepage.dart';
import 'package:buscador_gifs/ui/gif_page.dart';

void main() {
  runApp(MaterialApp(
    home: Homepage(),
    theme: ThemeData(
        hintColor: Colors.white,
        primaryColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          hintStyle: TextStyle(color: Colors.white),
        )),
  ));

}



