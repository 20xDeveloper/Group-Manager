import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../widgets/Main_Drawer.dart';
import '../widgets/UserIconContainer.dart';
import './../utils/GlobalVariables.dart';

class Messages extends StatefulWidget {

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  List<dynamic> all_users = [];

  void initState() {
    super
        .initState(); // I forget the point why it needs to call the parent class constructor. Ask on discord.

    this.get_list_of_users();
  }

  Future<void> get_list_of_users() async {
    try {
      const url = GlobalVariables.apiURL +
          "/users"; // this route handles getting projects and tasks
      final response = await http.get(url, headers: {
        "accept": "application/json",
        "content-type": "application/json"
      });

      var api_response = json.decode(response.body);

      await setState(() {
        all_users = api_response['all_users_on_this_app'];
      });

      print("here is the value for all users " + all_users.toString());
    } catch (error) {
      print(error);
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
        title: Text("Messages"),
        bottom: TabBar(
          tabs: <Widget>[Tab(text: "Contacts"), Tab(text: "Online")],
        ));

    final contentHeight = (MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top);

    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: appBar,
        drawer: MainDrawer(),
        body: TabBarView(children: [
          Column(
            children: <Widget>[
              Container(
                height: contentHeight * 0.30,
                decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    // borderRadius: BorderRadius.only(
                    //     topLeft: Radius.circular(25),
                    //     topRight: Radius.circular(25))
                        ),
                child: Container(
                  margin: EdgeInsets.only(top: contentHeight * 0.05),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: all_users.length,
                    itemBuilder: (BuildContext context, int index) {
                      return UserIconContainer(
                          contentHeight,
                          all_users[index]['id'],
                          all_users[index]['name'],
                          all_users[index]['profile_pic']);
                    },
                  ),
                ),
              )
            ],
          ),
          Text("hello")
        ]),
      ),
    );
  }
}
