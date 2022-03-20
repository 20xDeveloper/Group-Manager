import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


import '../widgets/Main_Drawer.dart';
import '../widgets/UserCard.dart';
import './../utils/GlobalVariables.dart';






class UserMessages extends StatefulWidget {
  

  @override
  _UserMessagesState createState() => _UserMessagesState();
}

class _UserMessagesState extends State<UserMessages> {
  final appBar = AppBar(
    title: Text("Contacts"),
  );

  List<dynamic> users = [];


  void initState()  {
    super
        .initState(); // I forget the point why it needs to call the parent class constructor. Ask on discord.

 this.fetchAllUsers();
  }

  Future<void> fetchAllUsers() async {
      try{
        final url = GlobalVariables.apiURL + "/users";


        final response = await http.get(url, headers: {
                "accept": "application/json",
                "content-type": "application/json"
              });


        var users_decoded = await json.decode(response.body);

        

        await setState(() {
          users = users_decoded['all_users_on_this_app'];
        });
        
        // print("Here is the value from the api " + users[0].toString());

      }catch(error){
        print(error);
        throw error;
      }
  }

  @override
  Widget build(BuildContext context) {
        // print("Here is the value from the api 234 " + users[0].toString());


    return 
    // Container(child: Text("hey"),);
    
    
    Scaffold(
        appBar: appBar,
        drawer: MainDrawer(),
        body:
        //  UserCard(
        //         // appBar.preferredSize.height,
        //         // users[0]['name']
        //         ));
        
        
        ListView.builder(
          itemBuilder: (ctx, index) {
            return UserCard(
                appBar.preferredSize.height,
                users[index]['name'],
                users[index]['profile_pic']
                );
          },
          itemCount: users.length,
        ));
  }
}