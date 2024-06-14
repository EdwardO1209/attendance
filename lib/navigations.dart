// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter_application_1/home.dart';
import 'package:flutter_application_1/menu.dart';
import 'package:flutter_application_1/persons.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'package:flutter/material.dart';

class navigation extends StatefulWidget {
  @override
  State<navigation> createState() => _navigationState();
}

DateTime datenow = DateTime.now();
const urlImg = "http://10.0.17.126/empImg/luffy.jpg";

class _navigationState extends State<navigation> {
  int selectedIndex = 0;
  final List<Widget> tabs = [
    HomeTab(rfid: ""),
    menu(
      rfid: null,
    ),
    const PersonsTab(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[selectedIndex],
      bottomNavigationBar: Container(
        //color: Colors.greenAccent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 8),
          child: GNav(
              onTabChange: (newIndex) => setState(() {
                    selectedIndex = newIndex;
                  }),
              //backgroundColor: Color.fromARGB(255, 187, 199, 193),
              padding: const EdgeInsets.all(12),
              gap: 8,
              color: Colors.black,
              activeColor: Colors.white,
              tabBackgroundColor: Color.fromARGB(255, 140, 228, 203),
              tabs: const [
                GButton(
                  icon: Icons.home_outlined,
                  // active: Icons.person,
                  text: "Home",
                ),
                GButton(
                  icon: Icons.calendar_month,
                  text: "Logdate",
                ),
                GButton(
                  icon: Icons.person_outlined,
                  text: "Persons",
                ),
              ]),
        ),
      ),
    );
  }
}
