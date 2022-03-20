import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './../utils/GlobalVariables.dart';

class CreateTask extends StatefulWidget {
  static const routeName = "/assignments/project/tasks/create";

  @override
  _CreateTaskState createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  final taskNameController = TextEditingController();
  final taskDescriptionController = TextEditingController();
  // final taskDueDateController = TextEditingController();

  String taskMonthValue = 'January';
  String taskDayValue = '1';
  List<dynamic> routeArgs; // This contains the list of project sections
  bool initial_setup_done_for_create_task_screen = false;

  BuildContext screen_context;

  final _formKey = GlobalKey<FormState>();

  String
      whichProjectSection; // This variable is used to store the value for which project section this task will go into.
  List<String> project_sections_state;

  List<dynamic> updated_list_of_project_tasks;
  // void initState() {
  //   super
  //       .initState(); // I forget the point why it needs to call the parent class constructor. Ask on discord.

  //   // this._handleSignIn();
  //   // this.fetchProjectSections();
  // }

  Future<void> fetchProjectSections() async {
    try {
      const url = GlobalVariables.apiURL + "/project_section";

      final response = await http.post(url,
          body: json.encode({
            'project_ID': routeArgs[0]['project ID']
            // 'email': emailControllerr.text,
            // 'password': passwordControllerr.text
          }),
          headers: {
            "accept": "application/json",
            "content-type": "application/json"
          });

      var project_sections = json.decode(response.body);
      print("Here is the value from the api " + project_sections.toString());
      List<String> project_section_names = [];

      // this is how you iterate through a list and store it in a variable/state
      await project_sections['project_sections'].forEach((project_section) =>
          project_section_names.add(project_section['name']));
      // print("here is the value for the project sections " +
      //     project_sections['project_sections'].toString()); // this is what we have to loop through and store it in the state to insert it to the dropdownbutton widget. -- THIS IS WHERE I LEFT OFF --

      // print("here is the value for the project sections " +
      //     project_section_names.toString());

      await setState(() {
        project_sections_state = project_section_names;
        whichProjectSection = project_section_names[0];
      });
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  update_list_of_project_tasks() async {
    try {
      const url = GlobalVariables.apiURL +
          "/assignments/project/tasks"; // this route handles getting projects and tasks
      final response = await http.post(url,
          body: json.encode({
            'projectID': routeArgs[0]['project ID'],
            // 'user_ID': GlobalVariables.users['id']
          }),
          headers: {
            "accept": "application/json",
            "content-type": "application/json"
          });

      var projectTasks = json.decode(response.body);

      setState(() {
        updated_list_of_project_tasks =
            projectTasks['list_of_sections_with_tasks'];
      });
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> createTask() async {
    try {
      print("here is the value for the global variables " +
          GlobalVariables.users['id'].toString());
      const create_task_api_endpoint = GlobalVariables.apiURL + "/tasks/create";

      final response = await http.post(create_task_api_endpoint,
          body: json.encode({
            'project_ID': routeArgs[0]['project ID'],
            'task_name': taskNameController.text,
            'task_description': taskDescriptionController.text,
            'task_due': taskMonthValue + " " + taskDayValue,
            'project_section_name': whichProjectSection,
            // 'user_ID': GlobalVariables.users['id']
          }),
          headers: {
            "accept": "application/json",
            "content-type": "application/json"
          });

      var create_task_api_response = json.decode(response.body);

      // print("here is the api response when creating a task " + create_task_api_response);
      await update_list_of_project_tasks();
      //  await Navigator.pop(screen_context, true);
      await Navigator.of(screen_context).pushNamed("/assignments/project/tasks",
          arguments: updated_list_of_project_tasks);
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  @override
  Widget build(BuildContext context) {
    print('COME ON COME ON COME ON' +
        initial_setup_done_for_create_task_screen.toString());
    if (!initial_setup_done_for_create_task_screen) {
      print("HOLY MOLY");
      final args = ModalRoute.of(context).settings.arguments as List<dynamic>;
      setState(() {
        routeArgs = args;
        initial_setup_done_for_create_task_screen = true;
        screen_context = context;
      });
      fetchProjectSections();
    }

// print('here is the value for the args value ' + args.toString());
//     String whichProjectSection = 'Select Project Section';

    final appBar = AppBar(
        title: Text("Create Task"),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true);

    final contentHeight = (MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top);

    return Scaffold(
        appBar: appBar,
        body: project_sections_state == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Form(
                key:
                    _formKey, // -- THIS IS WHERE I LEFT OFF. I HAVE TO ADD THE FORM KEY TO THIS FORM SO THE VALIDATION CAN WORK WHEN YOU CLICK ON THE FLAT BUTTON. STUFF LIKE THAT. LOOK INTO IT AND YOU WILL UNDERSTAND WHAT I MEAN. There is an if statement checking the formKey.validation(). To see how to set it up look at the login screen. --
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      // The below lines of code is where I left off. Trying to add a drop down for the month and date for the due date field. I'm doing this because tasks should have due dates. I'm not sure if i will make this a mandatory field. Gotta check the database table if it allows null as a value. THIS IS WHERE I LEFT OFF
                      // The widget you are looking for is called a DropDownButton.
                      Row(
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.width * 0.20),
                              child: Text("Due Date:")),
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: DropdownButton<String>(
                              value: taskMonthValue,
                              icon: Icon(Icons.arrow_downward),
                              iconSize: 14,
                              elevation: 16,
                              style: TextStyle(color: Colors.black),
                              // underline: Container(
                              //   height: 2,
                              //   color: Colors.deepPurpleAccent,
                              // ),
                              onChanged: (String newValue) {
                                setState(() {
                                  taskMonthValue = newValue;
                                });
                              },
                              items: <String>[
                                'January',
                                'February',
                                'March',
                                'April',
                                'May',
                                'June',
                                'July',
                                'August',
                                'September',
                                'October',
                                'November',
                                'December'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: DropdownButton<String>(
                              value: taskDayValue,
                              icon: Icon(Icons.arrow_downward),
                              iconSize: 14,
                              elevation: 16,
                              style: TextStyle(
                                  color: Colors
                                      .black), // -- THIS IS WHERE I LEFT OFF. I HAVE TO FIX THE LAYOUT OF THESE DROP DOWNS --
                              // underline: Container(
                              //   height: 2,
                              //   color: Colors.deepPurpleAccent,
                              // ),
                              onChanged: (String newValue) {
                                setState(() {
                                  taskDayValue = newValue;
                                });
                              },
                              items: <String>[
                                '1',
                                '2',
                                '3',
                                '4',
                                '5',
                                '6',
                                '7',
                                '8',
                                '9',
                                '10',
                                '11',
                                '12',
                                '13',
                                '14',
                                '15',
                                '16',
                                '17',
                                '18',
                                '19',
                                '20',
                                '21',
                                '22',
                                '23',
                                '24',
                                '25',
                                '26',
                                '27',
                                '28',
                                '29',
                                '30',
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.width * 0.20),
                              child: Text("Project Section:")),
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: DropdownButton<String>(
                              value: whichProjectSection,
                              icon: Icon(Icons.arrow_downward),
                              iconSize: 14,
                              elevation: 16,
                              style: TextStyle(color: Colors.black),
                              // underline: Container(
                              //   height: 2,
                              //   color: Colors.deepPurpleAccent,
                              // ),
                              onChanged: (String newValue) {
                                setState(() {
                                  whichProjectSection = newValue;
                                });
                              },
                              items: <String>[
                                ...project_sections_state
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                        controller: taskNameController,
                        // Validator will be called when the if statement is true. If you look at the FlatButton widget you can see we have an if statement checking if the _formkey.currentState.vaalidate() is true. That is what calls there validator named arguments from the TextFormField contructor function. We created the _formKey as a state in this stateful widget.
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        decoration:
                            InputDecoration(labelText: 'Enter the task name'),
                      ),
                      TextFormField(
                        controller: taskDescriptionController,
                        maxLines: 7,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: 'Enter the task description'),
                      ),
                      FlatButton(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              createTask();
                            }
                          },
                          child: Text("Create"),
                          color: Theme.of(context).primaryColor)
                    ],
                  ),
                )));
  }
}
