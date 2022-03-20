import 'package:flutter/material.dart';

import './screens/WelcomeScreen.dart';
import './screens/LoginScreen.dart';
import './screens/RegisterScreen.dart';
import './screens/NewsScreen.dart';
import './screens/UserMessages.dart';
import './screens/Assignments.dart';
import './screens/ProjectTasks.dart';

import './test/Contacts.dart';
import './screens/HomeNavigator.dart';
import './widgets/InfoCardDetails.dart';
import './screens/CreateTask.dart';
import './screens/TaskDetails.dart';
import './screens/CreateUpdate.dart';
import './screens/Messages.dart';
import './widgets/ChatRoom.dart';












void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.green, // To use this somewhere you just type Theme.of(context).what_ever_proerty
          secondaryHeaderColor: Colors.blue 
          ),
      // home: MyHomePage(),
        initialRoute: '/', // default is '/'
      routes: {
        '/': (ctx) => MyHomePage(),
        '/login': (ctx) => LoginScreen(),
        '/register': (ctx) => RegisterScreen(),
        '/contacts': (ctx) => UserMessages(),
        '/news': (ctx) => NewsScreen(),
        '/news/details': (ctx) => InfoCardDetails(),
        '/messages': (ctx) => Messages(),
        '/contacts/messages': (ctx) => ChatRoom(),
        '/assignments': (ctx) => Assignments(),
        '/assignments/project/tasks': (ctx) => ProjectTasks(),
        '/assignments/project/tasks/create': (ctx) => CreateTask(),
  '/assignments/project/tasks/details': (ctx) => TaskDetails(),
        '/assignments/project/tasks/details/update': (ctx) => CreateUpdate(),






        // CategoryMealsScreen.routeName: (ctx) => CategoryMealsScreen(),
      },
    );
  }
}

