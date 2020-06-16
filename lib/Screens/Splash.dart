import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pluginCG/Components/AButton.dart';
import 'package:pluginCG/Mainsection/MainScreen.dart';
import 'package:pluginCG/Screens/SignIn.dart';
import 'package:pluginCG/Screens/SignUp.dart';
import 'package:pluginCG/Screens/UserInformation.dart';
import 'package:pluginCG/resources/Assets.dart' as assets;
import 'package:pluginCG/resources/Color.dart' as colors;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pluginCG/Globals/Globals.dart' as globals;
import 'package:firebase_messaging/firebase_messaging.dart';

class Splash extends StatefulWidget {
  Splash({Key key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  check() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("partialRegister")) {
      bool key = prefs.getBool("partialRegister");
      if (key == true) {
        var newRoute = MaterialPageRoute(
            builder: (context) => UserInformation(data: [0, 1, 2, 3]));
        Navigator.pushAndRemoveUntil(context, newRoute, (route) => false);
      }
    }
    if (prefs.containsKey("fullRegister")) {
      bool key = prefs.getBool("fullRegister");
      if (key == true) {
        await getUserInfo();
        var newRoute = MaterialPageRoute(builder: (context) => MainScreen());
        Navigator.pushAndRemoveUntil(context, newRoute, (route) => false);
      }
    }
  }

  getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString("uid");
    globals.uid = uid;
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
      print(token);
      docRef.updateData({"token": "$token"});
    });
  }

  @override
  void initState() {
    check();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: height,
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  width: width,
                  height: height / 2,
                  child: Stack(
                    children: <Widget>[
                      Container(
                          width: width,
                          child: Image.asset(
                            "assets/panel.png",
                            fit: BoxFit.fill,
                          )),
                      Center(
                        child: Container(
                          height: 100,
                          width: 100,
                          child: assets.logo,
                        ),
                      )
                    ],
                  )),
              Container(
                alignment: Alignment.bottomCenter,
                height: height / 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    AButton(
                      color: colors.pBlue,
                      name: "SIGN UP",
                      hei: height / 8,
                      screen: SignUp(),
                    ),
                    AButton(
                      color: colors.pCyan,
                      name: "SIGN IN",
                      hei: height / 8,
                      screen: SignIn(),
                    ),
                  ],
                ),
              )
            ],
          )),
        ),
      ),
    );
  }
}
