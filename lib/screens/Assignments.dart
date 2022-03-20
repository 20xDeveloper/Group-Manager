import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../widgets/Main_Drawer.dart';
import '../widgets/ProjectCard.dart';
import './../utils/GlobalVariables.dart';

class Assignments extends StatefulWidget {
  static const routeName = "/assignments";
  @override
  _AssignmentsState createState() => _AssignmentsState();
}

class _AssignmentsState extends State<Assignments> {
  final appBar = AppBar(
    title: Text("Assignments"),
  );

  List<dynamic> projects = [];
  List<dynamic> tasks = [];
  List<dynamic> completed_tasks = [];
  List<dynamic> todays_tasks = [];

  void initState() {
    super
        .initState(); // I forget the point why it needs to call the parent class constructor. Ask on discord.

    // this._handleSignIn();
    this.fetchProjectsAndTasks();
    this.get_all_completed_tasks();
    this.todays_task();
  }

  Future<void> fetchProjectsAndTasks() async {
    try {
      const url = GlobalVariables.apiURL +
          "/assignments"; // this route handles getting projects and tasks
      final response = await http.get(url, headers: {
        "accept": "application/json",
        "content-type": "application/json"
      });

      var projectsAndTasks = json.decode(response.body);

      await setState(() {
        projects = projectsAndTasks['projects'];
        tasks = projectsAndTasks['tasks'];
      });


    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> get_all_completed_tasks() async {
    try {
      const url = GlobalVariables.apiURL +
          "/assignments/completed/tasks"; // this route handles getting projects and tasks
      final response = await http.get(url, headers: {
        "accept": "application/json",
        "content-type": "application/json"
      });

      var api_response = json.decode(response.body);

      // print(
      //     "here is the api response when trying to get the list of completed tasks " +
      //         api_response.toString());

      if (mounted) {
        setState(() {
          completed_tasks = api_response['completed_tasks'];
        });
      }

      // print("here is the value for the projects " + tasks.toString());
    } catch (error) {
      print(error);
      throw error;
    }
  }

  delete_task(task_information) async {
    try {
      // -- Call the API to add a new project section to this project --
      const url = GlobalVariables.apiURL +
          "/tasks/delete"; // this route handles getting projects and tasks
      final response = await http.post(url,
          body: json.encode({
            'task ID': task_information['id'],
          }),
          headers: {
            "accept": "application/json",
            "content-type": "application/json"
          });

      var task_completion_api_response = json.decode(response.body);

      get_all_completed_tasks();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> todays_task() async {
    try {
      // -- Call the API to add a new project section to this project --
      const url = GlobalVariables.apiURL +
          "/assignments/today/tasks"; // this route handles getting projects and tasks
      final response = await http.get(url, headers: {
        "accept": "application/json",
        "content-type": "application/json"
      });

      var api_response = json.decode(response.body);

      setState(() {
        todays_tasks = api_response['todays_list_of_tasks'];
      });
      print("here is the value for the todays_task state hey hey HEY HEY HEY HEY HEY "+ todays_tasks.toString());

    } catch (error) {
      print(error);
      throw error;
    }
  }

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

  @override
  Widget build(BuildContext context) {
    // This variable excludes the status bar and and the app bar. So, you just get the content height which is what you want. Using this variable will make your content responsive to different screen sizes.
    final contentHeight = (MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
          appBar: appBar,
          drawer: MainDrawer(),
          bottomSheet: Container(
            color: Theme.of(context).primaryColor,
            height: contentHeight * 0.12,
            child: TabBar(
              tabs: <Widget>[
                Tab(icon: Icon(Icons.work), text: "Projects"),
                Tab(text: "Today", icon: Icon(Icons.calendar_today)),
                Tab(text: "All Tasks", icon: Icon(Icons.calendar_view_day)),
                Tab(text: "Completed", icon: Icon(Icons.check))
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              ListView.builder(
                  itemCount: projects.length,
                  itemBuilder: (ctx, index) {
                    return ProjectCard(
                        appBar.preferredSize.height,
                        projects[index]['name'],
                        projects[index]['firebaseImageUrl'],
                        projects[index]['id']);
                  }),
               Column(
                children: <Widget>[
                  getTextWidgets(todays_tasks, contentHeight, context)
                ],
              ),
              Column(
                children: <Widget>[
                  getTextWidgets(tasks, contentHeight, context)
                ],
              ),
              ListView.builder(
                  itemCount: completed_tasks.length,
                  itemBuilder: (BuildContext list_view_context, int index) {
                    Map<String, dynamic> task = completed_tasks[index];

                    return //return  ListTile(
                        Row(
                      children: <Widget>[
                        Container(
                          child: Icon(Icons.check),
                          margin: EdgeInsets.fromLTRB(
                              MediaQuery.of(list_view_context).size.width *
                                  0.05,
                              contentHeight * 0.03,
                              MediaQuery.of(list_view_context).size.width *
                                  0.06,
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
                        Spacer(),
                        Container(
                          child: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                delete_task(task);
                              }),
                          margin: EdgeInsets.fromLTRB(
                              MediaQuery.of(list_view_context).size.width *
                                  0.05,
                              contentHeight * 0.03,
                              MediaQuery.of(list_view_context).size.width *
                                  0.06,
                              contentHeight * 0.03),
                        ),
                      ],
                    );
                  }),
            ],
          )),
    );
  }
}
