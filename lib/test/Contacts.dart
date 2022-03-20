import 'package:flutter/material.dart';
import 'package:group_manager/widgets/category_selector.dart';
import 'package:group_manager/widgets/favorite_contacts.dart';

class Contacts extends StatefulWidget {
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
            elevation: 0.0,
            leading: IconButton(
              icon: Icon(Icons.menu),
              iconSize: 30.0,
              color: Colors.white,
              onPressed: () {},
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                iconSize: 30.0,
                color: Colors.white,
                onPressed: () {},
              )
            ],
            title: Text('Contacts',
                style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold))),
        body: Column(
          children: <Widget>[
            CategorySelector(),
            // This expanded widget is the whole screen expanded. Expanded takes the left over space. The container is the round border container.
            Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0))),
                  child: Column(
                    children: <Widget>[
                      // FavoriteContacts()
                      Expanded(
                          // Expanded takes up the remainder of the space for this container. You must remove the height for the container it will be confusing for other developers to read especially junior developers.
                          child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30.0),
                                topRight: Radius.circular(30.0))),
                      ))
                    ],
                  )),
            )
          ],
        ));
  }
}
