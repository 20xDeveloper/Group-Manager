import 'package:flutter/material.dart';

class FavoriteContacts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment
                .spaceBetween, // This makes each row/column have space between them. so the text and icon will be in the same row but space in between them. test it out and see for your self.
            children: <Widget>[
              Text("Favorite Contacts",
                  style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0)),
              IconButton(
                icon: Icon(Icons.more_horiz),
                onPressed: () {},
                iconSize: 30.0,
                color: Colors.blueGrey,
              )
            ],
          ),
        ),
        Container(
          height: 120.0,
          color: Colors.blue,
          // child: ListView.builder(
          //   itemCount: favorites.length,
          //   itemBuilder: (BuildContext context, int index) {
          //     return ;
          //   }
          // )
        )
      ],
    );
  }
}
