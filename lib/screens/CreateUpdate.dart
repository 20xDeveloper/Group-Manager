import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './../utils/GlobalVariables.dart';

class CreateUpdate extends StatefulWidget {
  @override
  _CreateUpdateState createState() => _CreateUpdateState();
}

class _CreateUpdateState extends State<CreateUpdate> {
  final update_description_controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  submit_update() async {
    try {
      const create_update_API_endpoint = GlobalVariables.apiURL +
          '/task_update/create'; // this route gets a specific project using the project ID you send it

      final response = await http.post(create_update_API_endpoint,
          body: json.encode({
            'description': update_description_controller.text,
          }),
          headers: {
            "accept": "application/json",
            "content-type": "application/json"
          });

      var api_response = json.decode(response.body);

      // setState(() {
      //   // project_name = project['project']['name'];
      //   selected_project = project;
      // });

    } catch (error) {
      print(error);
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
        // title: Text("Task Details"),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true);

    final contentHeight = (MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top);
    return Scaffold(
        appBar: appBar,
        body: Form(
          key: _formKey,
          child: Column(children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: contentHeight * 0.05),
              child: TextFormField(
                controller: update_description_controller,
                maxLines: 7,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                  ),
                  labelText: 'Enter your question or update here',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                  ),
                ),
              ),
            ),
            Container(
                child: FlatButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        submit_update();
                      }
                    },
                    child: Text("Submit"),
                    color: Theme.of(context).primaryColor))
          ]),
        ));
  }
}
