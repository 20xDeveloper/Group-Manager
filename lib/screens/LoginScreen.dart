import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './../utils/GlobalVariables.dart';

class LoginScreen extends StatefulWidget {
  // MyHomePage({Key key, this.title}) : super(key: key);

  // final String title;

  @override
  _LoginScreen createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  final emailControllerr = TextEditingController();
  final passwordControllerr = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    //  GlobalKey<FormFieldState<String>>();
    final appBar = AppBar(
        title: Text("Group Manager"),
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        centerTitle: true);

    Future<void> login() async {
      // http://192.168.1.10:3000
      const url = GlobalVariables.apiURL + "/users/login"; // Your IP address changes. TO check it type ipconfig on the terminal. You might want to create a global variable for this that way you just have to change that one value and it will be used where ever it's needed.
      // const url = 'https://flutter-update.firebaseio.com/products.json';
      // print("HEY " + usernameController.text);
      // print("here is the value for the email " + emailControllerr.text + "hi");
      try {
        print("hey 1");
        final response = await http.post(url,
            body: json.encode({
              'email': emailControllerr.text,
              'password': passwordControllerr.text
            }),
            headers: {
              "accept": "application/json",
              "content-type": "application/json"
            });

        var response_decoded = json.decode(response.body);
        // print("here is the response for response $response_decoded");
        GlobalVariables.users = response_decoded['user'];
        // print("here is the value from the api response " + GlobalVariables.users.toString());

        // print("here is the response " + json.decode(response.body));

        // var response_decoded = json.decode(response.body);

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
                        Navigator.of(context).pushNamed("/news");
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
                content: Text(response_decoded['invalid']),
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

        // // final newProduct = Product(
        //   title: product.title,
        //   description: product.description,
        //   price: product.price,
        //   imageUrl: product.imageUrl,
        //   id: json.decode(response.body)['name'],
        // );
        // _items.add(newProduct);
        // // _items.insert(0, newProduct); // at the start of the list
        // notifyListeners();
      } catch (error) {
        print(error);
        throw (error);
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
              return SingleChildScrollView(
                              child: Form(
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
                            "Welcome back!",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              0, constraints.maxHeight * 0.01, 0, 0),
                          child: Text("Login with your email to start chatting",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 10)),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              0, constraints.maxHeight * 0.03, 0, 0),
                          width: constraints.maxWidth * 0.7,
                          child: TextFormField(
                            controller: emailControllerr,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            decoration:
                                InputDecoration(labelText: 'Enter your username'),
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.fromLTRB(
                                0, constraints.maxHeight * 0.03, 0, 0),
                            width: constraints.maxWidth * 0.7,
                            child: TextFormField(
                              obscureText: true,
                              controller: passwordControllerr,
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
                        Container(
                            margin: EdgeInsets.fromLTRB(
                                0, constraints.maxHeight * 0.05, 0, 0),
                            child: FlatButton(
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    login();
                                  }
                                },
                                child: Text("Login"),
                                color: Theme.of(context).primaryColor))
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        )));
  }
}
