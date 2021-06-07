import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main(){
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {


  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final _toDoController = TextEditingController();

  List _toDoList = [];
  Map<String, dynamic> _lastRemoved;
  int _lastRemovedPos;


  @override
  void initState() {
    super.initState();

     _readData().then(((data) {
       setState(() {
         _toDoList = json.decode(data);
       });
    }));
  }

  void _addToDo() {
    setState(() {
      Map<String, dynamic> newToDo = Map();
      newToDo["title"] = _toDoController.text;
      _toDoController.text = "";
      newToDo["ok"] = false;
      _toDoList.add(newToDo);
      _saveData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task List"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: TextField(
                      controller: _toDoController,
                      decoration: InputDecoration(
                          labelText: "New Task",
                          labelStyle: TextStyle(color: Colors.blueAccent)
                      ),
                    ),
                ),
                // ignore: deprecated_member_use
                RaisedButton(
                    color: Colors.blueAccent,
                    child: Text("ADD"),
                    textColor: Colors.white,
                    onPressed: _addToDo,
                )
              ],
            ),
          ),
          Expanded(
              child: ListView.builder(//permite construir a lista conforme vai sendo adicionado coisa nela
                  padding: EdgeInsets.only(top: 10.0),
                  itemCount: _toDoList.length,
                  itemBuilder: buildItem),
          )
        ],
      ),
    );
  }
  Widget buildItem (BuildContext context, int index) {
    return Dismissible(
      key: Key(DateTime.now().microsecondsSinceEpoch.toString()), /*o tempo atual em ms*/
        background: Container(
          color: Colors.red,
          child: Align(
            alignment: Alignment(-0.9, 0),
            child: Icon(Icons.delete,color: Colors.white),
          ),
        ) ,
      direction: DismissDirection.startToEnd,
      child: CheckboxListTile(
        title: Text(_toDoList[index]["title"]),
        value: _toDoList[index]["ok"],
        secondary: CircleAvatar(
          child: Icon(_toDoList[index]["ok"] ?
          Icons.check : Icons.error),),
        onChanged: (c) {
          setState(() {
            _toDoList[index]["ok"] = c;
            _saveData();
          });
        },
      ),
      onDismissed: (direction) {
          setState(() {
            _lastRemoved = Map.from(_toDoList[index]);
            _lastRemovedPos = index;
            _toDoList.removeAt(index);

            _saveData();

            final snack = SnackBar(
                content: Text("Tarefa \"${_lastRemoved["title"]}\" removida"),
                action: SnackBarAction(
                  label: "Desfazer",
                  onPressed: () {
                    setState(() {
                      _toDoList.insert(_lastRemovedPos, _lastRemoved);
                      _saveData();
                    });
                  },
                ),
              duration: Duration(seconds: 2),
            );
            // ignore: deprecated_member_use
            Scaffold.of(context).showSnackBar(snack);
          });
      },
    );
  }


  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory(); //tem que usar um future porque a funcao nao eh executada instantaneamente
    return File("${directory.path}/data.json");
  }
  Future<File> _saveData() async { //converter file para json
    String data = jsonEncode(_toDoList);

    final file = await _getFile();
    return file.writeAsString(data);
  }
  Future<String> _readData() async {
    try{
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }
}






