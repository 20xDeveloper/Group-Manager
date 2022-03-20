import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';

class ChatRoom extends StatefulWidget {
  static const routeName = "/messages/chat";

  
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  @override
  Widget build(BuildContext context) {
    final String name_of_who_you_are_chatting_with = ModalRoute.of(context).settings.arguments;


    var appBar = AppBar(
        title: Text(name_of_who_you_are_chatting_with));
        // bottom: TabBar(
        //   tabs: <Widget>[Tab(text: "Contacts"), Tab(text: "Online")],
        // ));

    final contentHeight = (MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top);



    return Scaffold(
      // bottomSheet: ,  // -- THIS IS WHERE I LEFT OFF --
      appBar: appBar,
      // drawer: MainDrawer(),
      body:
        Column(
          children: <Widget>[
           // List View Builder goes here for the past messages history in this chat room.
          ],
        ),

    );
  }
}