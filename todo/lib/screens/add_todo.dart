import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart' as http;
import 'package:todo/screens/todo_list.dart';

class AddTODO extends StatefulWidget {
  const AddTODO({super.key});

  @override
  State<AddTODO> createState() => _AddTODOState();
}

class _AddTODOState extends State<AddTODO> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add TODO"),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.all(15),
        children: [
          //Title
          TextField(
            decoration: InputDecoration(hintText: "Title"),
            controller: titleController,
          ),

          //Description
          TextField(
            decoration: InputDecoration(hintText: "Description"),
            minLines: 5,
            maxLines: 6,
            controller: descController,
          ),

          //
          ElevatedButton(
            onPressed: () {
              addTodo();
            },
            child: Text("Add TODO"),
          )
        ],
      ),
    );
  }

  void addTodo() async {
    //get the data from form
    final title = titleController.text;
    final description = descController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };

    //submit data to the server
    final url = "http://api.nstack.in/v1/todos";
    final uri = Uri.parse(url);
    final response = await http.post(
      uri, 
      headers: {
        "Content-Type": "application/json"
      },
      body: jsonEncode(body)
    );

    //show success or fail message based on status
    print(response.body);
    if(response.statusCode ==201){
      statusMessage("Todo added succesfully!", Colors.green.shade200);
      titleController.text = "";
      descController.text = "";
      Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) => TodoList(),));
    }else{
      statusMessage("Something went wrong",Colors.red.shade200); 
    }
  }


  void statusMessage(String message, Color color){
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,     
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
