import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:firebase_auth/firebase_auth.dart'; // Dpes
// import 'package:google_sign_in/google_sign_in.dart';

import '../widgets/Main_Drawer.dart';
import '../widgets/InfoCard.dart';
import './WelcomeScreen.dart';
import './LoginScreen.dart';
import './RegisterScreen.dart';
import './NewsScreen.dart';
import './UserMessages.dart';
import '../widgets/InfoCardDetails.dart';
import './Assignments.dart';
import './ProjectTasks.dart';
import './CreateTask.dart';
import './TaskDetails.dart';
import './CreateUpdate.dart';
import './Messages.dart';
import '../widgets/ChatRoom.dart';


import './../utils/GlobalVariables.dart';

// import './test/Contacts.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  bool displayEvents = false; // if its false it means view news.

  //  List<Widget> newsisInfoCardState = [];
  List<dynamic> newsisInfoCardState = [];
  List<dynamic> eventsInfoCardState = [];
  String firebaseImageURLState;

  // final GoogleSignIn _googleSignIn = GoogleSignIn();
  // final FirebaseAuth _auth = FirebaseAuth.instance;

  void initState() {
    super
        .initState(); // I forget the point why it needs to call the parent class constructor. Ask on discord.
    print("here is the value for the global variable " +
        GlobalVariables.users.toString());
    // this._handleSignIn();
    this.fetchNews();
  }

  // Future<FirebaseUser> _handleSignIn() async {
  //   final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
  //   final GoogleSignInAuthentication googleAuth =
  //       await googleUser.authentication;

  //   final AuthCredential credential = GoogleAuthProvider.getCredential(
  //     accessToken: googleAuth.accessToken,
  //     idToken: googleAuth.idToken,
  //   );

  //   final FirebaseUser user =
  //       (await _auth.signInWithCredential(credential)).user;
  //   print("signed in " + user.displayName);
  //   return user;
  // }

  Future<void> fetchNews() async {
    try {
      const url = GlobalVariables.apiURL + "/newsis";

      print("hey 1");
      final response = await http.get(url, headers: {
        "accept": "application/json",
        "content-type": "application/json"
      });

      var newsis = json.decode(response.body);

// final String firebaseImageURL = await FirebaseStorage().ref().child("promo21.png").getDownloadURL();

// await downloadFirebaseImage(newsis);

      // Now get the list of Events
      const url2 = GlobalVariables.apiURL + "/events";

      final response2 = await http.get(url2, headers: {
        "accept": "application/json",
        "content-type": "application/json"
      });

      var events = json.decode(response2.body);
      print("here is the value of the state " + events.toString());

      setState(() {
        // newsisInfoCardState = newsisInfoCard;
        // firebaseImageURLState = firebaseImageURL;
        newsisInfoCardState = newsis['newsis'];
        eventsInfoCardState = events['events'];
      });
      // }
      // this.newsisInfoCardState = newsisInfoCard;

      // check if it's saving the state and if it then create another function that returns a list of widget just like
      // the answer on stackoverflow. that might solve your problem.

    } catch (error) {
      print(error);
      throw (error);
    }
  }

//  Future<dynamic> downloadFirebaseImage(newsis) async{
//     for(var i  = 0; i < newsis['newsis'].length; i++){
//       newsis['newsis'].map((news, index) async {
//         final String firebaseImageURL = await FirebaseStorage().ref().child(news['firebaseImageUrl']).getDownloadURL();
//         news['firebaseImageUrl'] = firebaseImageURL;
//       });

//     }

//   }

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
        title: Text("News"),
        bottom: TabBar(
          tabs: <Widget>[Tab(text: "News"), Tab(text: "Events")],
        ));

    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors
              .green, // To use this somewhere you just type Theme.of(context).what_ever_proerty
          secondaryHeaderColor: Colors.blue),
      routes: {
        '/welcome': (ctx) => MyHomePage(),

        '/login': (ctx) => LoginScreen(),
        '/register': (ctx) => RegisterScreen(),
        '/contacts': (ctx) => UserMessages(),
        '/news': (ctx) => NewsScreen(),
        '/news/details': (ctx) => InfoCardDetails(),
        '/assignments': (ctx) => Assignments(),
        '/messages': (ctx) => Messages(),
        '/contacts/messages': (ctx) => ChatRoom(),


        '/assignments/project/tasks': (ctx) => ProjectTasks(),
        '/assignments/project/tasks/create': (ctx) => CreateTask(),
        '/assignments/project/tasks/details': (ctx) => TaskDetails(),
        '/assignments/project/tasks/details/update': (ctx) => CreateUpdate(),

        // '/contacts/messages': (ctx) => ChatRoom(),

        // CategoryMealsScreen.routeName: (ctx) => CategoryMealsScreen(),
      },
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: appBar,
            drawer: MainDrawer(),
            body: TabBarView(children: <Widget>[
              ListView.builder(
                itemBuilder: (ctx, index) {
                  return InfoCard(
                      appBar.preferredSize.height,
                      newsisInfoCardState[index]['title'],
                      newsisInfoCardState[index]['createdAt'],
                      newsisInfoCardState[index]['description'],
                      // firebaseImageURLState,
                      newsisInfoCardState[index]['firebaseImageUrl'],
                      newsisInfoCardState[index]['newsURL']);
                },
                itemCount: newsisInfoCardState.length,
              ),
              ListView.builder(
                itemBuilder: (ctx, index) {
                  return InfoCard(
                      appBar.preferredSize.height,
                      eventsInfoCardState[index]['title'],
                      eventsInfoCardState[index]['createdAt'],
                      eventsInfoCardState[index]['description'],
                      // firebaseImageURLState,
                      eventsInfoCardState[index]['firebaseImageUrl'],
                      eventsInfoCardState[index]['eventsURL']);
                },
                itemCount: eventsInfoCardState.length,
              ),
            ])),
      ),
    );
  }
}
