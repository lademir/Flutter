import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
    TextEditingController


  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculadora TTR"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        actions: <Widget>[
        IconButton(
            icon: Icon(Icons.refresh_rounded),
            onPressed: onPressed)
        ],
      ),
    );
  }
}
