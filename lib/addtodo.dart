import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class AddTodo extends StatefulWidget {
  @override
  _AddTodoState createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {

  TextEditingController controllerTodo = new TextEditingController();

  void addDataTodo() {
    var url= "https://todowebspring.herokuapp.com/api/todo";

    var body = json.encode({"name": controllerTodo.text});

    http.post(url, body: body, headers: { 'Content-type' : 'application/json',
    'Accept': 'application/json'});

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Add Todo"),
      ),
      body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: <Widget>[
              new Column(
                children: <Widget>[
                  new TextField(
                    controller: controllerTodo,
                    decoration: new InputDecoration(hintText: "Add Todo"),
                  ),
                  new Padding(padding: const EdgeInsets.all(10.0)),
                  new RaisedButton(
                      child: new Text("Add"),
                      color: Colors.blueAccent,
                      onPressed: () {
                        addDataTodo();
                        Navigator.pop(context);
                      })
                ],
              ),
            ],
          )),
    );
  }
}
