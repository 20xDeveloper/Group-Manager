import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


import './ChatRoom.dart';
import './ScreenArguments.dart';
import './../utils/GlobalVariables.dart';


import './../screens/ProjectTasks.dart';

class ProjectCard extends StatefulWidget {
  static const routeName = "/assignments/project/tasks";


  final double appBarHeight;
  final String projectName;
  final String firebaseImageUrl;
  final int projectID;

  ProjectCard(this.appBarHeight, this.projectName, this.firebaseImageUrl,
      this.projectID);

  @override
  _ProjectCardState createState() =>
      _ProjectCardState(appBarHeight, projectName, firebaseImageUrl, projectID);
}

class _ProjectCardState extends State<ProjectCard> {
  final double appBarHeight;
  final String projectName;
  final String firebaseImageUrl;
  final int projectID;
  List<dynamic> projectTasksState;

  String downloadedFirebaseImageUrl;
  bool _loading = true;

  _ProjectCardState(this.appBarHeight, this.projectName, this.firebaseImageUrl,
      this.projectID);

  void initState() {
    super
        .initState(); // I forget the point why it needs to call the parent class constructor. Ask on discord.
    this.getProjectTasks();

    this.downloadFireBaseImage();
  }

  getProjectTasks() async {
    try {

      print("here is the value for the global variable " + GlobalVariables.users['id'].toString());
      const url =
          GlobalVariables.apiURL + "/assignments/project/tasks"; // this route handles getting projects and tasks
           final response = await http.post(url,
            body: json.encode({
              'projectID': projectID,
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
      print("here is the value for the projects SDFGSDG " + projectTasksState.toString());

    } catch (error) {
      print(error);
      throw error;
    }
  }

  downloadFireBaseImage() async {
    final String firebaseImageURL =
        await FirebaseStorage().ref().child(firebaseImageUrl).getDownloadURL();
    setState(() {
      downloadedFirebaseImageUrl = firebaseImageURL;
    });

    this._handleLoad(); // I created this function because it takes time to download the image from firebase and it displays and error message if it doesn't get loaded before the widget this built.
  }

  void _handleLoad() {
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final contentHeight = (MediaQuery.of(context).size.height -
        appBarHeight -
        MediaQuery.of(context).padding.top);

    // print("here is the value for projects in the build method " + projectTasksState.toString());

    if (_loading) {
      return Center(
        child: Container(
            child: CircularProgressIndicator(),
            margin: EdgeInsets.fromLTRB(
                0, contentHeight * 0.07, 0, contentHeight * 0.07)),
      );
    } else {
      return GestureDetector(
        onTap: () {
          Navigator.pushNamed(
              context,
              ProjectTasks
                  .routeName, arguments:
          projectTasksState); // When you use dot notation it means it's a static property. If you add round brackets obviously it means it's a static method now.
          
        },
        child: Card(
          child: Row(
            children: <Widget>[
              Container(
                child: CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: contentHeight * 0.07,
                    backgroundImage: NetworkImage(downloadedFirebaseImageUrl)),
                margin: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width * 0.05,
                    contentHeight * 0.03,
                    MediaQuery.of(context).size.width * 0.06,
                    contentHeight * 0.03),
              ),
              Container(
                child: Text(
                  projectName,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
