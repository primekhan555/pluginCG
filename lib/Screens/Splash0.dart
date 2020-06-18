import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pluginCG/Mainsection/MainScreen.dart';
import 'package:pluginCG/Screens/Splash.dart';
import 'package:pluginCG/Screens/UserInformation.dart';
import 'package:pluginCG/resources/Logo.dart' as logo;
import 'package:pluginCG/Globals/Globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

class Splash0 extends StatefulWidget {
  const Splash0({Key key}) : super(key: key);

  @override
  _Splash0State createState() => _Splash0State();
}

class _Splash0State extends State<Splash0> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    getUserInfo();
    super.initState();
    Timer(const Duration(seconds: 3), () {
      check();
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height - (height / 5),
        padding: EdgeInsets.only(bottom: height / 9),
        alignment: Alignment.bottomCenter,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/panel.png"),
                alignment: Alignment.topCenter,
                fit: BoxFit.fill)),
        child: Container(
          height: 190,
          width: 190,
          child: logo.logo(),
        ),
      ),
    );
  }

  check() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("fullRegister")) {
      bool key = prefs.getBool("fullRegister");
      if (key == true) {
        await getUserInfo();
        var newRoute = MaterialPageRoute(builder: (context) => MainScreen());
        Navigator.pushAndRemoveUntil(context, newRoute, (route) => false);
      }
    } else if (prefs.containsKey("partialRegister")) {
      bool key = prefs.getBool("partialRegister");
      if (key == true) {
        var newRoute = MaterialPageRoute(
            builder: (context) => UserInformation(data: [0, 1, 2, 3]));
        Navigator.pushAndRemoveUntil(context, newRoute, (route) => false);
      }
    } else {
      var newRoute = MaterialPageRoute(builder: (context) => Splash());
      Navigator.pushAndRemoveUntil(context, newRoute, (route) => false);
    }
  }

  getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString("uid");
    globals.uid = uid;
    if (uid != "") {
      DocumentReference docRef =
          Firestore.instance.collection("users").document("$uid");
      docRef.get().then((DocumentSnapshot ds) {
        if (ds.exists) {
          setState(() {
            globals.lName = ds.data["name"];
            globals.lEmail = ds.data["email"];
            globals.lUrl = ds.data["picUrl"];
            globals.lGender = ds.data["gender"];
            globals.lCountry = ds.data["country"];
            globals.lAge = ds.data["age"];
          });
        }
      });
      _firebaseMessaging.getToken().then((token) {
        docRef.updateData({"token": "$token"});
      });
    }
  }
}
