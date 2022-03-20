import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(title: Text("Group Manager"), centerTitle: true);

    return Scaffold(
        backgroundColor: Colors.lightBlue,
        appBar: appBar,
        body: Center(
            child: Material(
          elevation: 16.0,
          child: LayoutBuilder(
            builder: (ctx, constraints) {
              return Container(
                height: (MediaQuery.of(context).size.height -
                        appBar.preferredSize.height -
                        MediaQuery.of(context).padding.top) *
                    0.95,
                color: Colors.green,
                width: MediaQuery.of(context).size.width * 0.95,
                child: Column(
                  children: <Widget>[
                    Flexible(
                        child: Container(
                            child: Column(children: <Widget>[
                      Container(
                        // margin:EdgeInsets.fromLTRB(0, constraints.maxHeight * 0.3, 0, 0),
                        child: Text(
                          "Welcome back!",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        // margin: EdgeInsets.fromLTRB(0, constraints.maxHeight * 0.01, 0, 0),
                        child: Text("Login with your email to start chatting",
                            style: TextStyle(color: Colors.white, fontSize: 7)),
                      )
                    ]))),
                  ],
                ),
              );
            },
          ),
        )));
  }
}
