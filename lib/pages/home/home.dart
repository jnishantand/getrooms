import 'package:flutter/material.dart';
import 'package:getroom/pages/home/menu/profile.dart';
import 'package:getroom/pages/home/menu/search.dart';
import 'package:getroom/pages/home/menu/settings.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  // BottomNavigationBar items
  final menu_list = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: "Home",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.search),
      label: "Search",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: "Settings",
    )
  ];

  // List of widgets for each menu item
  final ListOfPages = [
    Profile(),
  Search(),
    Settings(),

  ];

  void onTapMenu(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: menu_list,
        onTap: onTapMenu,
     //   currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
      ),
      body: ListOfPages[currentIndex],
    );
  }
}
