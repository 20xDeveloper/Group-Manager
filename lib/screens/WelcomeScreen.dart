import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  // MyHomePage({Key key, this.title}) : super(key: key);

  // final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void navigate_screen(BuildContext ctx, String route_name) {
    Navigator.of(ctx).pushNamed("/" + route_name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        children: <Widget>[
          Flexible(
            flex: 2,
            child: Container(
                // height: (MediaQuery.of(context).size.height) *
                // 0.7,
                width: double.infinity,
                color: Theme.of(context).secondaryHeaderColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Group Manager",
                        style: TextStyle(fontSize: 25, color: Colors.white))
                  ],
                )),
          ),
          Flexible(
              flex: 1,
              child: LayoutBuilder(builder: (ctx, constraints) {
                return Container(
                    // height:  (MediaQuery.of(context).size.height) *
                    // 0.3,
                    color: Colors.green,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                          // fit: FlexFit.tight,
                          child: Container(
                              // height: constraints.maxHeight * 0.25,
                              margin: EdgeInsets.fromLTRB(
                                  0, (constraints.maxHeight * 0.07), 0, 0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("Welcome to Group Manager",
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.white)),
                                  Expanded(
                                    child: Container(
                                        margin:
                                            EdgeInsets.fromLTRB(0, 10, 0, 0),
                                        child: Text(
                                            "Login or Register to get started",
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.lightGreen,
                                            ))),
                                  )
                                ],
                              )),
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          child: Container(
                              // height: constraints.maxHeight * 0.25,

                              width: double.infinity,
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      width: 0.5, color: Colors.lightGreen),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: FlatButton(
                                      onPressed: () =>
                                          {navigate_screen(context, "login")},
                                      child: Text("Login",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white)),
                                    ),
                                  )
                                ],
                              )),
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          child: Container(
                              // height: constraints.maxHeight * 0.25,

                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                                              child: FlatButton(
                                  onPressed: () => {navigate_screen(context, "register")},
                                    child: Text("Register",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.white))),
                              )
                            ],
                          )),
                        ),
                      ],
                    ));
              }))
        ],
      ),
    ));
  }
}
