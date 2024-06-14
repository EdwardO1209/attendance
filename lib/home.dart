// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class HomeTab extends StatefulWidget {
  final rfid;
  HomeTab({required this.rfid});
  @override
  State<HomeTab> createState() => _homeState(rfid: rfid);
}

DateTime datenow = DateTime.now();
const urlImg = "http://20.10.0.19/empImg/luffy.jpg";

class _homeState extends State<HomeTab> {
  String rfid;
  _homeState({required this.rfid});
  SharedPreferences? sharedPreferences;
  String firstname = "";
  String employeeID = "";
  String lastname = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDet();
  }

  void getDet() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      firstname = pref.getString('firstname')!;
      lastname = pref.getString('lastname')!;
      employeeID = pref.getString('employeeID')!;
      rfid = pref.getString('rfid')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Home",
          style: TextStyle(
            fontSize: 25,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                Color.fromARGB(255, 143, 204, 145),
                Color.fromARGB(255, 70, 182, 128)
              ])),
        ),
      ),
      backgroundColor: Colors.grey[300],
      body: Center(
        child: Column(children: [
          const SizedBox(
            height: 20,
          ),

          //Picture
          Image.network(
            urlImg,
            height: 150.0,
            width: 160.0,
            fit: BoxFit.cover,
          ),

          const SizedBox(
            height: 15,
          ),

          //Name
          Text(
            "Name : $firstname $employeeID",
            style: const TextStyle(fontSize: 25),
          ),

          const SizedBox(
            height: 0,
          ),

          //Employee ID
          Text(
            "employee ID : $lastname",
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 10,
          ),
        ]),
      ),
    );
  }
}
