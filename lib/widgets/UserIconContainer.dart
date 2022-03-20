import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';

import '../widgets/Main_Drawer.dart';
import './ChatRoom.dart';


class UserIconContainer extends StatefulWidget {
  final double contentHeight;
  final int user_ID;

  final String username;
  final String firebaseImageUrl;

  UserIconContainer(this.contentHeight, this.user_ID, this.username, this.firebaseImageUrl);

  @override
  _UserIconContainerState createState() =>
      _UserIconContainerState(contentHeight, this.user_ID, username, firebaseImageUrl);
}

class _UserIconContainerState extends State<UserIconContainer> {
  final double contentHeight;
  final int user_ID;
  final String username;
  final String firebaseImageUrl;
  String downloadedFirebaseImageUrl;
  bool _loading = true;


  _UserIconContainerState(
      this.contentHeight,this.user_ID, this.username, this.firebaseImageUrl);

  void initState() {
    super
        .initState(); // I forget the point why it needs to call the parent class constructor. Ask on discord.

    this.downloadFireBaseImage();
  }

  Future<void> downloadFireBaseImage() async {
    final String user_profile_pic =
        await FirebaseStorage().ref().child(firebaseImageUrl).getDownloadURL();
    setState(() {
      downloadedFirebaseImageUrl = user_profile_pic;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
            Navigator.pushNamed(
              context,
              ChatRoom
                  .routeName, arguments: user_ID);
      },
          child: Container(
        child: Column(
          children: <Widget>[
            _loading ? CircularProgressIndicator() :
            CircleAvatar(
              backgroundColor: Colors.grey,
              radius: contentHeight * 0.07,
              backgroundImage: NetworkImage(downloadedFirebaseImageUrl)
            ),
            Container(child: Text(username))
          ],
        ),
        margin: EdgeInsets.fromLTRB(
            MediaQuery.of(context).size.width * 0.05,
            contentHeight * 0.03,
            MediaQuery.of(context).size.width * 0.06,
            contentHeight * 0.03),
      ),
    );
  }
}
