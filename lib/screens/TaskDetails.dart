import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';

import './../utils/GlobalVariables.dart';
import './../widgets/UserMessageContainer.dart';
import './ProjectTasks.dart';

class TaskDetails extends StatefulWidget {
  @override
  _TaskDetailsState createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  Map<String, dynamic> task_information;
  Map<String, dynamic> selected_project;
  // String project_name;
  bool initial_setup_done = false;
  String project_logo;
  final user_Input_controller = TextEditingController();
  final update_description_controller = TextEditingController();
  List<dynamic> questions_and_updates;
  double contentHeight;

  bool bottomSheet_arrow_direction = false;
  bool is_menu_open = false;

  bool _loading = false;
  List<dynamic> projectTasksState;

  // void initState() {
  //   super
  //       .initState(); // I forget the point why it needs to call the parent class constructor. Ask on discord.

  //       // get_list_of_updates_and_questions();
  // }

  // -- THIS IS WHERE I LEFT OFF. need to add this function and where the flatbutton needs to use it --
  submit_update() async {
    try {
      print("here is thee value for task_ID " +
          task_information['id'].toString());
      const create_update_API_endpoint = GlobalVariables.apiURL +
          '/task_update/create'; // this route gets a specific project using the project ID you send it

      final response = await http.post(create_update_API_endpoint,
          body: json.encode({
            'description': update_description_controller.text,
            'user_ID': GlobalVariables.users['id'],
            'task_ID': task_information['id']
          }),
          headers: {
            "accept": "application/json",
            "content-type": "application/json"
          });

      var api_response = json.decode(response.body);
      // if(){

      // }

      get_list_of_updates_and_questions(true);
      // setState(() {
      //   // project_name = project['project']['name'];
      //   selected_project = project;
      // });

    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> get_list_of_updates_and_questions(
      bool function_called_by_submit) async {
    try {
      const create_update_API_endpoint = GlobalVariables.apiURL +
          '/task_update'; // this route gets a specific project using the project ID you send it

      final response = await http.post(create_update_API_endpoint,
          body: json.encode({
            'task_ID': task_information['id'],
          }),
          headers: {
            "accept": "application/json",
            "content-type": "application/json"
          });

      var api_response = json.decode(response.body);

      print("here is the list of questions and updates " +
          api_response['list_of_task_updates'].toString());
      // print("Here is the value from the api " + api_response.toString());

      // await api_response['all_task_updates'].forEach((task_update) =>
      //   questions_and_updates.add(task_update['name']));

      if (mounted) {
        setState(() {
          questions_and_updates = api_response['list_of_task_updates'];
        });
      }

      // -- If this fuction was called by submit then update the list of questions and updates to display to the user --
      if (function_called_by_submit) {
        showMenu();
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> get_project_name() async {
    try {
      const get_project_name_API_endpoint = GlobalVariables.apiURL +
          "/assignments/project"; // this route gets a specific project using the project ID you send it

      final response = await http.post(get_project_name_API_endpoint,
          body: json.encode({
            'project ID': task_information['project_ID'],
            // 'user_ID': GlobalVariables.users['id']
          }),
          headers: {
            "accept": "application/json",
            "content-type": "application/json"
          });

      var project = json.decode(response.body);

      // print("here is the value fromt he api for project name " +
      //     project['project']['name'].toString());

      if (mounted) {
        setState(() {
          // project_name = project['project']['name'];
          selected_project = project;
        });
      }

      await downloadFireBaseImage(project['project']['firebaseImageUrl']);
    } catch (error) {
      print(error);
      throw error;
    }
  }

  downloadFireBaseImage(firebaseImageUrl) async {
    final String firebaseImageURL =
        await FirebaseStorage().ref().child(firebaseImageUrl).getDownloadURL();
    setState(() {
      project_logo = firebaseImageURL;
      initial_setup_done = true;
    });

    // this._handleLoad(); // I created this function because it takes time to download the image from firebase and it displays and error message if it doesn't get loaded before the widget this built.
  }

  // -- THIS IS WHERE I LEFT OFF. I NEED TO CREATE A NEW ROUTE FOR MARKING A TASK AS COMPLETE.
  Future<void> mark_task_as_complete(screen_context) async {
    try {
      // -- Call the API to add a new project section to this project --
      const url = GlobalVariables.apiURL +
          "/tasks/complete"; // this route handles getting projects and tasks
      final response = await http.post(url,
          body: json.encode({
            'task ID': task_information['id'],
          }),
          headers: {
            "accept": "application/json",
            "content-type": "application/json"
          });

      var task_completion_api_response = json.decode(response.body);

      // -- Get the updated list of project tasks and pass this as a route argument to the project task widget/screen. Remember the one you completed should not display on the list of tasks now. --
      getProjectTasks(screen_context);
    } catch (error) {
      print(error);
      throw error;
    }
  }

  delete_task(screen_context) async {
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


      getProjectTasks(screen_context);

      
    } catch (error) {
      print(error);
      throw error;
    }
  }

  getProjectTasks(screen_context) async {
    try {
      print("here is the value for the global variable " +
          GlobalVariables.users['id'].toString());
      const url = GlobalVariables.apiURL +
          "/assignments/project/tasks"; // this route handles getting projects and tasks
      final response = await http.post(url,
          body: json.encode({
            'projectID': task_information['project_ID'],
            // 'user_ID': GlobalVariables.users['id']
          }),
          headers: {
            "accept": "application/json",
            "content-type": "application/json"
          });

      var projectTasks = json.decode(response.body);

      setState(() {
        projectTasksState = projectTasks['list_of_sections_with_tasks'];
      });
      Navigator.pushNamed(screen_context, ProjectTasks.routeName,
          arguments: projectTasksState);
      // print("here is the value for the projects SDFGSDG " + projectTasksState.toString());

    } catch (error) {
      print(error);
      throw error;
    }
  }

  // -- THIS IS WHERE I LEFT OFF --
  // now create the list of updates and questions under the Row widget and do navigator.pop(context) when they click on the arrow up icon when the drawer is open. -- THIS IS WHERE I LEFT OFF --
  showMenu() {
    setState(() {
      is_menu_open = true;
    });
    print(
        "here is the value for the question and updated in the showMenu function " +
            questions_and_updates.toString());
    // setState(() {
    //   bottomSheet_arrow_direction = !bottomSheet_arrow_direction;
    // });
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          // final contentHeight = (MediaQuery.of(context).size.height -
          //     appBar.preferredSize.height -
          //     MediaQuery.of(context).padding.top);
          BuildContext bottom_modal_sheet_context = context;
          return
              //  Container(child: Text("hello world"));

              SingleChildScrollView(
            child: Container(
              height: contentHeight * 0.75,
              padding: EdgeInsets.only(top: contentHeight * 0.03),
              width: MediaQuery.of(context).size.width * 1.0,
              color: Color(0xff344955),
              child: Column(
                children: <Widget>[
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: <
                      Widget>[
                    IconButton(
                      onPressed: () {
                        setState(() {
                          is_menu_open = false;
                        });
                        Navigator.pop(context);
                      },
                      // showMenu,

                      //          setState(() {
                      //            bottomSheet_arrow_direction = !bottomSheet_arrow_direction;

                      // });

                      icon: Icon(Icons.arrow_drop_up, color: Colors.white),
                      // color: Colors.white,
                    ),
                    Spacer(), // Spacer is a very helpful widget HOLY. It spaces the items in a row equally.
                    Padding(
                      padding: EdgeInsets.only(top: contentHeight * 0.03),
                      child: Text("Questions and Updates",
                          style: TextStyle(color: Colors.white)),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: TextFormField(
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
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 1.0),
                                    ),
                                    labelText: 'Enter your question/update...',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 1.0),
                                    ),
                                  ),
                                ),
                                //  Column(

                                //   children: <Widget>[
                                //     Text("Create new project section"),

                                //   ],
                                // ),
                                actions: <Widget>[
                                  FlatButton(
                                    onPressed: () {
                                      // createNewProjectSection(context);
                                      Navigator.pop(context);

                                      submit_update();
                                      Navigator.pop(bottom_modal_sheet_context);
                                    },
                                    child: Text(
                                        "submit"), // FOR SOME REASON WHEN YOU USE * doubleNumber ON A MediaQuery.of(context).size it means the percent of that screen size you want to take up. Just make sure at the end it adds up to 1.0 or you will get size overflow. btw 1.0 is 100 percent.
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
                      icon: Icon(Icons.add),
                      color: Colors.white,
                    ),
                  ]),
                  SizedBox(
                    height: contentHeight * 0.50,
                    child: ListView.builder(
                      itemBuilder: (ctx, index) {
                        print(
                            "here is the value for the question and updates " +
                                questions_and_updates.length.toString());
                        return UserMessageContainer(
                            contentHeight,
                            questions_and_updates[index]['user_data']
                                ['profile_pic'],
                            questions_and_updates[index]['user_data']['name'],
                            questions_and_updates[index]['date'],
                            questions_and_updates[index]['description']);
                      },
                      itemCount: questions_and_updates == null
                          ? 0
                          : questions_and_updates.length,
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      // title: Text("Task Details"),
      backgroundColor: Theme.of(context).primaryColor,
      centerTitle: true,
      actions: <Widget>[
        GestureDetector(
            onTap: () {
              return showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Text(
                          "You have successfully marked this task as complete."),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () {
                            //                     Navigator.pushNamed(
                            //     context,
                            //     ProjectTasks
                            //         .routeName, arguments:
                            // projectTasksState);
                            mark_task_as_complete(context);
                          },
                          child: Text(
                              "Okay"), // FOR SOME REASON WHEN YOU USE * doubleNumber ON A MediaQuery.of(context).size it means the percent of that screen size you want to take up. Just make sure at the end it adds up to 1.0 or you will get size overflow. btw 1.0 is 100 percent.
                        ),
                      ],
                    );
                  });
            },
            child: Container(
                margin: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.05),
                child: Icon(Icons.check, color: Colors.white))),
        GestureDetector(
            onTap: () {
              return showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Text("You have successfully deleted this task."),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () {
                            //                     Navigator.pushNamed(
                            //     context,
                            //     ProjectTasks
                            //         .routeName, arguments:
                            // projectTasksState);
                            delete_task(context);
                          },
                          child: Text(
                              "Okay"), // FOR SOME REASON WHEN YOU USE * doubleNumber ON A MediaQuery.of(context).size it means the percent of that screen size you want to take up. Just make sure at the end it adds up to 1.0 or you will get size overflow. btw 1.0 is 100 percent.
                        ),
                      ],
                    );
                  });
            },
            child: Container(
                margin: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.05),
                child: Icon(Icons.delete, color: Colors.white)))
      ],
    );

    final creating_content_height = (MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top);

    if (!initial_setup_done) {
      final route_args =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

      setState(() {
        task_information = route_args;
        contentHeight = creating_content_height;
      });

      get_project_name();
      get_list_of_updates_and_questions(false);
    }

    // print("here is the task information " + task_information.toString());

    return Scaffold(
        // floatingActionButton: FloatingActionButton(
        //     child: Icon(Icons.add),
        //     onPressed: () async {
        //       return showDialog(
        //           context: context,
        //           builder: (BuildContext context) {
        //             return AlertDialog(
        //               content: TextFormField(
        //                 controller: update_description_controller,
        //                 maxLines: 7,
        //                 validator: (value) {
        //                   if (value.isEmpty) {
        //                     return 'Please enter some text';
        //                   }
        //                   return null;
        //                 },
        //                 decoration: InputDecoration(
        //                   focusedBorder: OutlineInputBorder(
        //                     borderSide:
        //                         BorderSide(color: Colors.black, width: 1.0),
        //                   ),
        //                   labelText: 'Enter your question/update...',
        //                   enabledBorder: OutlineInputBorder(
        //                     borderSide:
        //                         BorderSide(color: Colors.black, width: 1.0),
        //                   ),
        //                 ),
        //               ),
        //               //  Column(

        //               //   children: <Widget>[
        //               //     Text("Create new project section"),

        //               //   ],
        //               // ),
        //               actions: <Widget>[
        //                 FlatButton(
        //                   onPressed: () {
        //                     // createNewProjectSection(context);
        //                     submit_update();
        //                     Navigator.pop(context);
        //                   },
        //                   child: Text(
        //                       "submit"), // FOR SOME REASON WHEN YOU USE * doubleNumber ON A MediaQuery.of(context).size it means the percent of that screen size you want to take up. Just make sure at the end it adds up to 1.0 or you will get size overflow. btw 1.0 is 100 percent.
        //                 ),
        //                 FlatButton(
        //                   onPressed: () {
        //                     Navigator.pop(context);
        //                   },
        //                   child: Text(
        //                       "Cancel"), // FOR SOME REASON WHEN YOU USE * doubleNumber ON A MediaQuery.of(context).size it means the percent of that screen size you want to take up. Just make sure at the end it adds up to 1.0 or you will get size overflow. btw 1.0 is 100 percent.
        //                 )
        //               ],
        //             );
        //           });
        //       //  Navigator.of(context)
        //       //     .pushNamed(CreateTask.routeName, arguments: routeArgs);
        //       //   Navigator.of(context)
        //       // .pushNamed("/assignments/project/tasks/details/update");
        //     }),
        bottomNavigationBar: BottomAppBar(
          elevation: 0,
          color: Color(0xff344955),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            height: 56.0,
            child: Row(children: <Widget>[
              IconButton(
                onPressed: showMenu,

                //          setState(() {
                //            bottomSheet_arrow_direction = !bottomSheet_arrow_direction;

                // });

                icon: Icon(Icons.arrow_drop_down),
                // !bottomSheet_arrow_direction
                //     ? Icon(Icons.arrow_drop_down)
                //     : Icon(Icons.arrow_drop_up),
                color: Colors.white,
              ),
              Spacer(), // Spacer is a very helpful widget HOLY. It spaces the items in a ROW widget equally. You could probably do this with a COLUMN widget as well. I think. I'm not sure about the last part. Remember you got to be precise when you are programming or it wont work and you will get into errors. That is just how programming works.
              Text("Question and Updates",
                  style: TextStyle(color: Colors.white)),
              Spacer(),
              IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext dialog_context) {
                        return AlertDialog(
                          content: TextFormField(
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
                                borderSide:
                                    BorderSide(color: Colors.black, width: 1.0),
                              ),
                              labelText: 'Enter your question/update...',
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 1.0),
                              ),
                            ),
                          ),
                          //  Column(

                          //   children: <Widget>[
                          //     Text("Create new project section"),

                          //   ],
                          // ),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () {
                                // createNewProjectSection(context);
                                submit_update();
                                Navigator.pop(dialog_context);
                                // Navigator.pop(context);
                              },
                              child: Text(
                                  "submit"), // FOR SOME REASON WHEN YOU USE * doubleNumber ON A MediaQuery.of(context).size it means the percent of that screen size you want to take up. Just make sure at the end it adds up to 1.0 or you will get size overflow. btw 1.0 is 100 percent.
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
                icon: Icon(Icons.add),
                color: Colors.white,
              )
            ]),
          ),
        ),
        // SingleChildScrollView(
        //     child: Container(
        //         height: contentHeight * 0.25,
        //         padding: EdgeInsets.only(top: contentHeight * 0.03),
        //         width: MediaQuery.of(context).size.width * 1.0,
        //         color: Colors.grey[300],
        //         child: Padding(
        //             padding: EdgeInsets.only(
        //                 left: MediaQuery.of(context).size.width * 0.04),
        //             child: Text("Questions and Updates:"))),
        //   ),

        // -- THE TWO LINES BELOW MIGHT BE IMPORTANT ON HOW TO FIX THE PROBLEM WHEN POPING OUT THE KEYBOARD AND COVERING THE CONTENT. THIS PREVENTS IT MAYBE. I DON'T KNOW WHY I STILL HAVE IT. THE LAST TIME I REMEMBER WAS IT DOES NOT WORK. --
        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: true,
        appBar: appBar,
        body: initial_setup_done
            ? SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // -- Title Container --
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(
                                  right:
                                      MediaQuery.of(context).size.width * 0.01),
                              child: Icon(
                                Icons.work,
                              )),
                          Text(
                            task_information['name'],
                            style: TextStyle(
                              fontSize: contentHeight * 0.04,
                            ),
                          )
                        ],
                      ),
                      padding: EdgeInsets.only(top: contentHeight * 0.05),
                    ),
                    // -- Due date and project name Container --
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // - Avatar for project -
                        Container(
                          child: !initial_setup_done
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  radius: contentHeight * 0.03,
                                  backgroundImage: NetworkImage(project_logo)),
                          margin: EdgeInsets.fromLTRB(
                              MediaQuery.of(context).size.width * 0.03,
                              contentHeight * 0.03,
                              MediaQuery.of(context).size.width * 0.03,
                              contentHeight * 0.03),
                        ),
                        // - Text for the project picture -
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Project",
                                style: TextStyle(color: Colors.grey)),
                            Text(selected_project['project']['name'])
                          ],
                        ),

                        // -- Due Date Container --
                        Container(
                          child: Icon(Icons.calendar_today),
                          margin: EdgeInsets.fromLTRB(
                              MediaQuery.of(context).size.width * 0.15,
                              contentHeight * 0.03,
                              MediaQuery.of(context).size.width * 0.03,
                              contentHeight * 0.03),
                        ),
                        // - Text for the project picture -
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Due Date",
                                style: TextStyle(color: Colors.grey)),
                            Text(task_information['due'])
                          ],
                        )
                      ],
                    ),

                    // -- Task Description --
                    Padding(
                        padding: EdgeInsets.only(
                            bottom: contentHeight * 0.40,
                            left: MediaQuery.of(context).size.width * 0.04,
                            top: MediaQuery.of(context).size.width * 0.05),
                        child: Text(
                          task_information['description'],
                          textAlign: TextAlign.left,
                        )),

                    //  -- INSERT UPDATE AND QUESTIONS SECTION --
                    //       Container(
                    // padding: EdgeInsets.only(top: contentHeight * 0.03),
                    // width: MediaQuery.of(context).size.width * 1.0,
                    // color: Colors.grey[300],
                    // child: Padding(
                    //     padding: EdgeInsets.only(
                    //         left: MediaQuery.of(context).size.width * 0.04),
                    //     child: Text("Questions and Updates:"))),
                    // SingleChildScrollView(
                    //   child: Column(
                    //     children: <Widget>[],
                    //   ),
                    // ),
                    //         TextFormField(

                    //           controller: user_Input_controller,
                    //           validator: (value) {
                    //             if (value.isEmpty) {
                    // return 'Please enter some text';
                    //             }
                    //             return null;
                    //           },
                    //           decoration: InputDecoration(
                    // labelText: 'Ask a question or post an update...',
                    // hasFloatingPlaceholder: false),
                    //         ),
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}
