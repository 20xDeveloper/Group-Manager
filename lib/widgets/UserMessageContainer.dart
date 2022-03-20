import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserMessageContainer extends StatefulWidget {
  final double contentHeight;
  final String project_logo;
  final String username;
  final String post_date;
  final String description;
  // Pase the profile pic, username, date created for the update/question variable here. -- THIS IS WHERE I LEFT OFF --

  UserMessageContainer(this.contentHeight, this.project_logo, this.username,
      this.post_date, this.description);

  @override
  _UserMessageContainerState createState() => _UserMessageContainerState(
      contentHeight, project_logo, username, post_date, description);
}

class _UserMessageContainerState extends State<UserMessageContainer> {
  final double contentHeight;
  final String project_logo;
  String downloadedFirebaseImageUrl;
  final String username;
  final String post_date;
  final String description;
  bool _loading = false;

  _UserMessageContainerState(this.contentHeight, this.project_logo,
      this.username, this.post_date, this.description);

  void initState() {
    super
        .initState(); // I forget the point why it needs to call the parent class constructor. Ask on discord.

    // this.downloadFireBaseImage();
  }

  downloadFireBaseImage() async {
    final String firebaseImageURL =
        await FirebaseStorage().ref().child(project_logo).getDownloadURL();
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
    return Container(
      // margin: EdgeInsets.only(bottom: contentHeight * 0.0),
      child: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Row(
              children: <Widget>[
                Container(
                  child: CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: contentHeight * 0.05,
                      // backgroundImage:
                      //     NetworkImage(downloadedFirebaseImageUrl)
                          ),
                  margin: EdgeInsets.fromLTRB(
                      MediaQuery.of(context).size.width * 0.03,
                      contentHeight * 0.03,
                      MediaQuery.of(context).size.width * 0.03,
                      contentHeight * 0.03),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(username,
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold)),
                    Text(post_date,
                        style: TextStyle(fontSize: contentHeight * 0.02)),
                    Text(description, style: TextStyle(color: Colors.black))
                  ],
                ),
              ],
            ),
    );
  }
}
