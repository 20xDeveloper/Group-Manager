import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

import './ChatRoom.dart';


class UserCard extends StatefulWidget {
  final double appBarHeight;
  final String username;
  final String firebaseImageUrl;

  UserCard(this.appBarHeight, this.username, this.firebaseImageUrl);

  @override
  _UserCardState createState() =>
      _UserCardState(appBarHeight, username, firebaseImageUrl);
}

class _UserCardState extends State<UserCard> {
  final double appBarHeight;
  final String username;
  final String firebaseImageUrl;
  String downloadedFirebaseImageUrl;
  bool _loading = true;

  _UserCardState(this.appBarHeight, this.username, this.firebaseImageUrl);

  void initState() {
    super
        .initState(); // I forget the point why it needs to call the parent class constructor. Ask on discord.

    this.downloadFireBaseImage();
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
    return GestureDetector(
           onTap: () {
          Navigator.pushNamed(
              context,
              ChatRoom.routeName); // When you use dot notation it means it's a static property. If you add round brackets obviously it means it's a static method now.
              // arguments:
              //     ScreenArguments(newsTitle, description, createdAt, newsUrl));
        },
          child: Card(

          // margin: EdgeInsets.all(20),
          elevation: 5,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.98,
            height: (MediaQuery.of(context).size.height - // page height
                    appBarHeight - // subtracting the app bar height then....
                    MediaQuery.of(context)
                        .padding
                        .top) * // subtracting the tool bar on your phone which then you get the actual height for your content then you multiple how much percent of the screen size you want this container to be.
                0.12,
            child: LayoutBuilder(builder: (ctx, constraints) {
              if (_loading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Row(
                  children: <Widget>[
                    Container(
                      child: CircleAvatar(
                          radius: constraints.maxHeight * 0.40,
                          backgroundImage:
                              NetworkImage(downloadedFirebaseImageUrl)),
                      margin: EdgeInsets.fromLTRB(constraints.maxHeight * 0.17, 0,
                          constraints.maxHeight * 0.12, 0),
                    ),
                    Container(
                      child: Text(
                        username,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                );
              }
            }), // 0.3 is 30 percent of the page height.
          ) // This is where I left off. Adding the card widget.
          ),
    );
  }
}
