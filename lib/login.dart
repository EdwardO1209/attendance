import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:flutter_application_1/navigations.dart';

import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var username = TextEditingController();
  var password = TextEditingController();

  void login() async {
    if (username.text == "" || password.text == "") {
      Fluttertoast.showToast(
        msg: 'Username or Password are empty',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        fontSize: 16,
      );
    } else {
      var uri = 'https://10.0.17.126/conn/login.php';
      var response = await http.post(Uri.parse(uri),
          body: ({
            'username': username.text,
            'password': password.text,
          }));
      var body = json.decode(response.body);
      if (response.statusCode == 200) {
        // print("Login Success" + response.toString());
        pageRoute(body['firstname'], body['lastname'], body['employeeID'],
            body['rfid']);
        //Navigator.push(
        //    context, MaterialPageRoute(builder: (context) => misc()));
      } else {
        Fluttertoast.showToast(
          msg: 'Username and Password are incorrect',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          fontSize: 16,
        );
      }
    }
  }

  void pageRoute(
    String firstname,
    String employeeID,
    String lastname,
    String rfid,
  ) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      pref.setString('employeeID', employeeID);
      pref.setString("firstname", firstname);
      pref.setString('lastname', lastname);
      pref.setString('rfid', rfid);
    });
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => navigation()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(
              height: 20,
            ),
            //Title
            const Text(
              'WELCOME',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),

            const SizedBox(
              height: 30,
            ),
            //User
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: TextField(
                    controller: username,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Username',
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            //Password
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: TextField(
                    controller: password,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Password',
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            //LoginButton
            ElevatedButton(
              child: const Text('Log In'),
              onPressed: () {
                login();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  padding: const EdgeInsets.all(20),
                  fixedSize: const Size(240, 60),
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
          ]),
        ),
      ),
    );
  }
}
