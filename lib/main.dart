import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import './addtodo.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Todo App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List> getData() async {
    final response = await http.get("https://todowebspring.herokuapp.com/api/todos");
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      floatingActionButton: new FloatingActionButton(
          child: new Icon(Icons.add),
          onPressed: () => Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) => new AddTodo(),
              ))),
      body: new FutureBuilder<List>(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? new ItemList(
                  list: snapshot.data,
                )
              : new Center(
                  child: new CircularProgressIndicator(),
                );
        },
      ),
    );
  }
}

class ItemList extends StatelessWidget {
  final List list;

  ItemList({this.list});

  void changeCompleteTodo(int id) {
    var url = "https://todowebspring.herokuapp.com/api/todo/complete/" + id.toString();

    http.post(url, headers: { 'Content-type' : 'application/json',
      'Accept': 'application/json'});
  }

  void changeNotCompleteTodo(int id) {
    var url = "https://todowebspring.herokuapp.com/api/todo/notComplete/" + id.toString();
    http.post(url, headers: { 'Content-type' : 'application/json',
      'Accept': 'application/json'});
  }

  void removeTodo(int id) {
    var url = "https://todowebspring.herokuapp.com/api/todo/delete/"+ id.toString();
    http.post(url, headers: { 'Content-type' : 'application/json',
      'Accept': 'application/json'});
  }


  void confirmRemove(BuildContext context, int id, var name){
    AlertDialog alertDialog = new AlertDialog(
      content: new Text("Remover todo: '${name}' ?"),
      actions: <Widget>[
        new RaisedButton(
            child: new Text("OK"),
            color: Colors.red,
            onPressed: () {
              removeTodo(id);
            }
            ),
        new RaisedButton(
            child: new Text("Cancelar"),
            color: Colors.green,
            onPressed: ()=>  Navigator.pop(context),
        )
      ],
    );

    showDialog(context: context, child: alertDialog);
  }


  void confirmDialogNotCompleteStatusTodo(BuildContext context, int id, var name){
    AlertDialog alertDialog = new AlertDialog(
      content: new Text("Descompletar todo: '${name}' ?"),
      actions: <Widget>[
        new RaisedButton(
            child: new Text("OK"),
            color: Colors.red,
            onPressed: () {
              changeNotCompleteTodo(id);
            }
        ),
        new RaisedButton(
            child: new Text("Cancelar"),
            color: Colors.green,
            onPressed: ()=>
              Navigator.pop(context),
        )
      ],
    );

    showDialog(context: context, child: alertDialog);
  }

  void confirmDialogCompleteStatusTodo(BuildContext context, int id, var name){
    AlertDialog alertDialog = new AlertDialog(
      content: new Text("Completar todo: '${name}' ?"),
      actions: <Widget>[
        new RaisedButton(
            child: new Text("OK"),
            color: Colors.red,
            onPressed: () {
              changeCompleteTodo(id);
            }
        ),
        new RaisedButton(
          child: new Text("Cancelar"),
          color: Colors.green,
          onPressed: ()=>
              Navigator.pop(context),
        )
      ],
    );

    showDialog(context: context, child: alertDialog);
  }

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, i) {
        if (list[i]['complete'] == false) {
          return new Container(
            padding: const EdgeInsets.all(10.0),
            child: new GestureDetector(
              onTap: () {
                confirmDialogCompleteStatusTodo(context, list[i]['id'],
                    list[i]['name']);
              },
              child: new ListTile(
                title: new Text(list[i]['name']),
                leading: new Icon(Icons.check_box_outline_blank),
              ),
              onLongPress: () {
                confirmRemove(context, list[i]['id'], list[i]['name']);
                //removeTodo(list[i]['id']);
                },
            ),
          );
        } else {
          return new Container(
            padding: const EdgeInsets.all(10.0),
            child: new GestureDetector(
              onTap: () {
                confirmDialogNotCompleteStatusTodo(context, list[i]['id'],
                    list[i]['name']);
              },
              onLongPress: () {
                confirmRemove(context, list[i]['id'], list[i]['name']);
                //removeTodo(list[i]['id']);
              },
              child: new ListTile(
                title: new Text(list[i]['name']),
                leading: new Icon(Icons.check),
              ),
            ),
          );
        }
      },
    );
  }
}
