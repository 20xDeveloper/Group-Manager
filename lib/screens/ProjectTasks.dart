import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './../widgets/ScreenArguments.dart';
import './Assignments.dart';


import './../utils/GlobalVariables.dart';
import './CreateTask.dart';

class ProjectTasks extends StatefulWidget {
  static const routeName = "/assignments/project/tasks";

  @override
  _ProjectTasksState createState() => _ProjectTasksState();
}

class _ProjectTasksState extends State<ProjectTasks> {
  final newSectionNameController = TextEditingController();
  final newTaskNameController = TextEditingController();
  final newTaskDescriptionController = TextEditingController();
  // final newTaskDueDate = TextEditingController();

  DateTime newTaskDueDate = DateTime.now();

  // List<dynamic> tasksState;
  List<dynamic> routeArgs; // This contains the list of project sections
  bool initialSetupDone = false;

  void initState() {
    super
        .initState(); // I forget the point why it needs to call the parent class constructor. Ask on discord.
  }

  // fetchProjectsTasks() async {
  //   try {
  //     const url =
  //         "http://192.168.1.10:3000/assignments/project/tasks"; // this route handles getting projects and tasks
  //          final response = await http.post(url,
  //           body: json.encode({
  //             'email': emailControllerr.text,
  //             'password': passwordControllerr.text
  //           }),
  //           headers: {
  //             "accept": "application/json",
  //             "content-type": "application/json"
  //           });

  //     var projectsAndTasks = json.decode(response.body);

  //     setState(() {
  //       projects = projectsAndTasks['projects'];
  //       tasks = projectsAndTasks['tasks'];
  //     });

  //     print("here is the value for the projects " + projects.toString());
  //   } catch (error) {
  //     print(error);
  //     throw error;
  //   }
  // }

  // createNewTask() async {
  //   try {

  //       // -- Call the API to create a new task --
  //         const url =
  //             "http://192.168.1.10:3000/task/create"; // this route handles getting projects and tasks
  //             final response = await http.post(url,
  //               body: json.encode({

  //                 'new task name': newTaskNameController.text,
  //                 "project_ID": routeArgs[0]['tasks'][0]['project_ID'],
  //                 'description': newTaskDescriptionController.text,
  //                 'due': newTaskDueDate.text

  //               }),
  //               headers: {
  //                 "accept": "application/json",
  //                 "content-type": "application/json"
  //               });

  //         // var projectsAndTasks = json.decode(response.body);

  //   } catch (error) {
  //     print(error);
  //     throw error;
  //   }
  // }

  createNewProjectSection(context) async {
    try {
      print("Here is the value for the state " + routeArgs.toString());

      // -- Call the API to add a new project section to this project --
      const url = GlobalVariables.apiURL +
          "/project_section/create"; // this route handles getting projects and tasks
      final response = await http.post(url,
          body: json.encode({
            'new section name': newSectionNameController.text,
            "project_ID": routeArgs[0]['tasks'][0]['project_ID']
          }),
          headers: {
            "accept": "application/json",
            "content-type": "application/json"
          });

      var projectsAndTasks = json.decode(response.body);

      // -- Call the other route to get the updated list of project sections --
      const url2 = GlobalVariables.apiURL +
          "/assignments/project/tasks"; // this route handles getting projects and tasks
      final response2 = await http.post(url2,
          body: json
              .encode({'projectID': routeArgs[0]['tasks'][0]['project_ID']}),
          headers: {
            "accept": "application/json",
            "content-type": "application/json"
          });

      var projectTasks = json.decode(response2.body);

      setState(() {
        routeArgs = projectTasks['list_of_sections_with_tasks'];
      });
    } catch (error) {
      print(error);
      throw error;
    }
  }

  // update_list_of_project_tasks() async {
  //   try {
  //     const url = GlobalVariables.apiURL +
  //         "/assignments/project/tasks"; // this route handles getting projects and tasks
  //     final response = await http.post(url,
  //         body: json.encode({'projectID': routeArgs[0]['tasks'][0]['project_ID']}),
  //         headers: {
  //           "accept": "application/json",
  //           "content-type": "application/json"
  //         });

  //     var projectTasks = json.decode(response.body);

  //     setState(() {
  //       routeArgs = projectTasks['list_of_sections_with_tasks'];
  //     });

  //   } catch (error) {
  //     print(error);
  //     throw error;
  //   }
  // }

  Widget getTextWidgets(
      List<dynamic> tasks, double contentHeight, BuildContext screen_context) {
    return new Column(
        children: tasks
            .map((task) => GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                        screen_context, "/assignments/project/tasks/details",
                        arguments:
                            task); // When you use dot notation it means it's a static property. If you add round brackets obviously it means it's a static method now.
                  },
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Icon(Icons.check_circle),
                        margin: EdgeInsets.fromLTRB(
                            MediaQuery.of(context).size.width * 0.05,
                            contentHeight * 0.03,
                            MediaQuery.of(context).size.width * 0.06,
                            contentHeight * 0.03),
                      ),
                      Container(
                        child: Text(
                          task['name'],
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 12, 0),
                          child: Text(
                            task['due'],
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
            .toList());
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: newTaskDueDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != newTaskDueDate)
      setState(() {
        newTaskDueDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as List<dynamic>;

    // -- Setting up the initial state --
    if (!initialSetupDone) {
      setState(() {
        routeArgs = args;
        initialSetupDone = true;
      });
    }

    // -- App bar --
    final appBar = AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () =>  Navigator.pushNamed(context, Assignments.routeName,
          ),
      ),
      title: Text("Assignments"),
      actions: <Widget>[
        Container(
            color: Colors.blue,
            child: FlatButton(
              onPressed: () async {
                return showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: TextFormField(
                          controller: newSectionNameController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              labelText: 'Enter new section name'),
                        ),
                        //  Column(

                        //   children: <Widget>[
                        //     Text("Create new project section"),

                        //   ],
                        // ),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () {
                              createNewProjectSection(context);
                              Navigator.pop(context);
                            },
                            child: Text(
                                "Create"), // FOR SOME REASON WHEN YOU USE * doubleNumber ON A MediaQuery.of(context).size it means the percent of that screen size you want to take up. Just make sure at the end it adds up to 1.0 or you will get size overflow. btw 1.0 is 100 percent.
                          ),
                          FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                                "Cancel"), // FOR SOME REASON WHEN YOU USE * doubleNumber ON A MediaQuery.of(context).size it means the percent of that screen size you want to take up. Just make sure at the end it adds up to 1.0 or you will get size overflow. btw 1.0 is 100 percent.
                          )
                        ],
                      );
                    });
              },
              child: Row(
                children: <Widget>[
                  Icon(Icons.add, color: Colors.white),
                  Text("Section", style: TextStyle(color: Colors.white)),
                ],
              ),
              // icon: Icon(Icons.add, color: Colors.white,), label: Text("Section", style: TextStyle(color: Colors.white))))

              // Container(child: Text("Section"), alignment: Alignment(0, 0.03), padding: EdgeInsets.fromLTRB(0, 0, 10, 0),)
            ))
      ], // add the project name to the app bar. THIS IS WHERE I LEFT OFF.
    );

    // -- The height of the content --
    final contentHeight = (MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top);

    // -- The screen --
    return DefaultTabController(
        length: 4,
        child: initialSetupDone
            ? Scaffold(
                appBar: appBar,
                floatingActionButton: FloatingActionButton(
                  onPressed: () async {
                    await setState(() {
                      initialSetupDone = false;
                    });

                    Navigator.of(context)
                        .pushNamed(CreateTask.routeName, arguments: routeArgs);
                  },
                  child: Icon(Icons.add),
                  backgroundColor: Colors.green,
                ),
                body: ListView.builder(
                    itemCount: routeArgs.length,
                    itemBuilder: (BuildContext context, int index) {
                      Map<String, dynamic> task_details = routeArgs[index];

                      return //return  ListTile(
                          ExpansionTile(
                        title: Text(task_details['section name']),
                        children: <Widget>[
                          getTextWidgets(
                              task_details['tasks'], contentHeight, context)
                        ],
                      );

                   
                    })
                // : GestureDetector(child: Icon(Icons.arrow_back), onTap: (){
                //   Navigator.of(context).pushReplacementNamed('/assignments');
                // },),
                //  bottomSheet: Container(
                //     color: Theme.of(context).primaryColor,
                //     height: contentHeight * 0.12,
                //     child: TabBar(
                //       tabs: <Widget>[
                //         Tab(icon: Icon(Icons.work), text: "Projects"),
                //         Tab(text: "Today", icon: Icon(Icons.calendar_today)),
                //         Tab(text: "All Tasks", icon: Icon(Icons.calendar_view_day)),
                //         Tab(text: "Completed", icon: Icon(Icons.check))
                //       ],
                //     ),
                //   ),
                )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}
