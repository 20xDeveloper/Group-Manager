import 'package:flutter/material.dart';

import '../widgets/Main_Drawer.dart';


class HomeNavigator extends StatefulWidget {
  @override
  _HomeNavigator createState() => _HomeNavigator();
}

class _HomeNavigator extends State<HomeNavigator> {
  // _pages is a list that contains a map/object and inside that map/object it has a string and an object and that object can be a widget
  // Also, you don't have to write List<Map<String, Object>> and the program will still work. It's just good practice because then the programmer
  // knows what _pages is. Also _pages is a private property because it has "_" in the name.

  // final List<Map<String, Object>> _pages = [
  //   {
  //     'page': CategoriesScreen(),
  //     'title': 'Categories',
  //   },
  //   {
  //     'page': FavoritesScreen(),
  //     'title': 'Your Favorite',
  //   },
  // ];
  // int _selectedPageIndex = 0;

  // void _selectPage(int index) {
  //   setState(() {
  //     _selectedPageIndex = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(_pages[_selectedPageIndex]['title']),
        title: Text("Hey"),

      ),
      drawer: MainDrawer(),
      // body: _pages[_selectedPageIndex]['page'],
      // bottomNavigationBar: BottomNavigationBar(
      //   onTap: _selectPage,
      //   backgroundColor: Theme.of(context).primaryColor,
      //   unselectedItemColor: Colors.white,
      //   selectedItemColor: Theme.of(context).accentColor,
      //   currentIndex: _selectedPageIndex,
      //   // type: BottomNavigationBarType.fixed,
      //   items: [
      //     BottomNavigationBarItem(
      //       backgroundColor: Theme.of(context).primaryColor,
      //       icon: Icon(Icons.category),
      //       title: Text('Categories'),
      //     ),
      //     BottomNavigationBarItem(
      //       backgroundColor: Theme.of(context).primaryColor,
      //       icon: Icon(Icons.star),
      //       title: Text('Favorites'),
      //     ),
      //   ],
      // ),
    );
  }
}
