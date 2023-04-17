import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:todo/screens/add_todo.dart';
import 'package:http/http.dart' as http;

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchTodo();
  }
  List items = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TODO List"),
        centerTitle: true,
        elevation: 0,
      ),

      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              child: Text("${index+1}"),
            ),
            title: Text(items[index]['title']),
            subtitle: Text(items[index]['description']),
          );
        },
      ),

      //fab
      floatingActionButton: FloatingActionButton.extended(
        label: Text("Add TODO"),
        onPressed: () {
          navigateToAddPage();
        },
      ),
    );
  }

  void navigateToAddPage() {
    final route = MaterialPageRoute(
      builder: (context) => AddTODO(),
    );
    Navigator.push(context, route);
  }

  void fetchTodo() async {
    final url = "http://api.nstack.in/v1/todos?page=1&limit=10";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'];
      setState(() {
        items = result;
      });
    } else {
      print(response.statusCode);
    }
  }
}
