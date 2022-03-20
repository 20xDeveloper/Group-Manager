import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

import './InfoCardDetails.dart';
import './ScreenArguments.dart';

class InfoCard extends StatefulWidget {
  final double appBarHeight;
  final String newsTitle;
  // final String newsDescription;
  final String createdAt;
  final String description;
  final String firebaseImageUrl;
  final String newsUrl;

  InfoCard(this.appBarHeight, this.newsTitle, this.createdAt, this.description,
      this.firebaseImageUrl, this.newsUrl);

      
  @override
  _InfoCardState createState() => _InfoCardState(appBarHeight, newsTitle,
      createdAt, description, firebaseImageUrl, newsUrl);
}

class _InfoCardState extends State<InfoCard> {
  final double appBarHeight;
  final String newsTitle;
  // final String newsDescription;
  final String createdAt;
  final String description;
  final String firebaseImageUrl;
  final String newsUrl;
  String downloadedFirebaseImageUrl;

  bool _loading = true;

  void _handleLoad() {
    setState(() {
      _loading = false;
    });
  }

  _InfoCardState(this.appBarHeight, this.newsTitle, this.createdAt,
      this.description, this.firebaseImageUrl, this.newsUrl);

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

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 2.4,
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
              context,
              InfoCardDetails
                  .routeName, // When you use dot notation it means it's a static property. If you add round brackets obviously it means it's a static method now.
              arguments:
                  ScreenArguments(newsTitle, description, createdAt, newsUrl, []));
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
                  0.50,
              child: LayoutBuilder(builder: (ctx, constraints) {
                return Column(
                  children: <Widget>[
                    Container(
                      child: Text(
                        newsTitle,
                        textAlign: TextAlign.left,
                      ),
                      margin: EdgeInsets.all(8),
                      width: constraints.maxWidth,
                    ),
                    Container(
                        child: Text(createdAt,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 8,
                              color: Colors.grey,
                            )),
                        margin: EdgeInsets.fromLTRB(8, 0, 0, 0),
                        width: constraints.maxWidth),

                    // FittedBox(child: Image.asset('assets/Images/Sion.jpg'), fit: BoxFit.fill,)
                    Container(
                      child: _loading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Image.network(downloadedFirebaseImageUrl),
                      width: constraints.maxWidth,
                      height: constraints.maxHeight - 42,
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    ),
                  ],
                );
              }), // 0.3 is 30 percent of the page height.
            ) // This is where I left off. Adding the card widget.
            ),
      ),
    );
  }
}
