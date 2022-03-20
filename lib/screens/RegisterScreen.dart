// import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './../utils/GlobalVariables.dart';


class RegisterScreen extends StatefulWidget {
  // MyHomePage({Key key, this.title}) : super(key: key);

  // final String title;

  @override
  _RegisterScreen createState() => _RegisterScreen();
}

class _RegisterScreen extends State<RegisterScreen> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  Widget alert;

  final _formKey = GlobalKey<FormState>();

  // void initState() {
  //   print("hey");

  //   super.initState();
  // }

  // void dispose(){

  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    // var alert = AlertDialog(title: Text("Success"), content: Text("You have successfully created an account."), actions: [FlatButton(
    //                         onPressed: () {
    //                         Navigator.of(context).pushNamed("/login");
    //                         },
    //                         child: Text("Okay"),
    //                         color: Theme.of(context).primaryColor)]);
    final appBar = AppBar(
        title: Text("Group Manager"),
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        centerTitle: true);

    Future<void> register() async {
      // http://192.168.1.10:3000
      const url = GlobalVariables.apiURL + "/users";
      // const url = 'https://flutter-update.firebaseio.com/products.json';
      // print("HEY " + usernameController.text);
      // print(usernameController.text);
      try {
        final response = await http.post(url,
            body: json.encode({
              'name': usernameController.text,
              'email': emailController.text,
              'password': passwordController.text
            }),
            headers: {
              "accept": "application/json",
              "content-type": "application/json"
            });

        var response_decoded = json.decode(response.body);

// print(response);

        if (response_decoded.containsKey('user')) {
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                title: Text("Success"),
                content: Text("You have successfully created an account."),
                actions: [
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.of(context).pushNamed("/login");
                      },
                      child: Text("Okay"),
                      color: Theme.of(context).primaryColor)
                ]),
          );
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                title: Text("Error"),
                content: Text(response_decoded['error']),
                actions: [
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Navigator.of(context).pushNamed("/login");
                      },
                      child: Text("Okay"),
                      color: Theme.of(context).primaryColor)
                ]),
          );
        }
      } catch (error) {
        showDialog(
          context: context,
          builder: (BuildContext context) =>
              AlertDialog(title: Text("Error"), content: Text(error), actions: [
            FlatButton(
                onPressed: () {
                  Navigator.pop(context);

                  // Navigator.of(context).pushNamed("/login");
                },
                child: Text("Okay"),
                color: Theme.of(context).primaryColor)
          ]),
        );
        // print(error);
        // throw error;
      }
    }

    return Scaffold(
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        appBar: appBar,
        body: Center(
            child: Material(
          elevation: 16.0,
          child: LayoutBuilder(
            builder: (ctx, constraints) {
              return Form(
                key: _formKey,
                child: Container(
                  height: (MediaQuery.of(context).size.height -
                          appBar.preferredSize.height -
                          MediaQuery.of(context).padding.top) *
                      0.95,
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(
                            0, constraints.maxHeight * 0.05, 0, 0),
                        child: Text(
                          "Create an account",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      // Container(
                      //   margin: EdgeInsets.fromLTRB(
                      //       0, constraints.maxHeight * 0.01, 0, 0),
                      //   child: Text("Login with your email to start chatting",
                      //       style: TextStyle(color: Colors.black, fontSize: 10)),
                      // ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(
                              0, constraints.maxHeight * 0.03, 0, 0),
                          width: constraints.maxWidth * 0.7,
                          child: TextFormField(
                            controller: usernameController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                labelText: 'Enter your Username'),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(
                              0, constraints.maxHeight * 0.03, 0, 0),
                          width: constraints.maxWidth * 0.7,
                          child: TextFormField(
                            controller: emailController,
                            decoration:
                                InputDecoration(labelText: 'Enter your Email'),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                            margin: EdgeInsets.fromLTRB(
                                0, constraints.maxHeight * 0.03, 0, 0),
                            width: constraints.maxWidth * 0.7,
                            child: TextFormField(
                              obscureText: true,
                              controller: passwordController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Enter your Password',

                                // border: UnderlineInputBorder(borderRadius: BorderRadius.horizontal(left: )),
                              ),
                            )),
                      ),
                      //           Expanded(
                      //                                   child: Container(
                      //                 margin: EdgeInsets.fromLTRB(
                      //                     0, constraints.maxHeight * 0.03, 0, 0),
                      //                 width: constraints.maxWidth * 0.7,
                      //                 child: TextFormField(
                      //                         validator: (value) {
                      //       if (value.isEmpty) {
                      //         return 'Please enter some text';
                      //       }
                      //       return null;
                      // },
                      //                   controller: confirmPasswordController,
                      //                   decoration: InputDecoration(
                      //                     labelText: 'Confirm your Password',
                      //                     // border: UnderlineInputBorder(borderRadius: BorderRadius.horizontal(left: )),
                      //                   ),
                      //                 )),
                      //           ),
                      Container(
                          margin: EdgeInsets.fromLTRB(
                              0, constraints.maxHeight * 0.05, 0, 0),
                          child: FlatButton(
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  register();
                                }
                              },
                              child: Text("Register"),
                              color: Theme.of(context).primaryColor)),
                      Container(child: alert)
                    ],
                  ),
                ),
              );
            },
          ),
        )));
  }
}
