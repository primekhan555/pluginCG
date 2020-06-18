import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:pluginCG/Mainsection/MainScreen.dart';
import 'package:pluginCG/Screens/UserInformation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:pluginCG/Globals/Globals.dart' as globals;
import 'package:http/http.dart' as http;

final FirebaseAuth _auth = FirebaseAuth.instance;
var provider=FacebookAuthProvider();

Future handleFBSignIn(context) async {
  FacebookLogin facebookLogin = FacebookLogin();
  FacebookLoginResult facebookLoginResult =
      await facebookLogin.logIn(['email']);
  switch (facebookLoginResult.status) {
    case FacebookLoginStatus.cancelledByUser:
      break;
    case FacebookLoginStatus.error:
      Toast.show("an error occured While login through facebook", context,
          gravity: Toast.BOTTOM, duration: Toast.LENGTH_SHORT);
      break;
    case FacebookLoginStatus.loggedIn:
      final accessToken = facebookLoginResult.accessToken.token;
      final facebookAuthCred =
          FacebookAuthProvider.getCredential(accessToken: accessToken);
      final user = await _auth.signInWithCredential(facebookAuthCred);
      var graph = await http.get(
          "https://graph.facebook.com/v6.0/me?fields=name,first_name,last_name,email,picture.height(320).width(320)&access_token=$accessToken");
      var profile = json.decode(graph.body);
      globals.lName = profile['name'];
      globals.lEmail = profile['email'];
      globals.uid = user.user.uid;
      globals.lUrl = profile['picture']['data']['url'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("uid", "${user.user.uid}");
      prefs.setBool("partialRegister", true);
      prefs.setBool("fullRegister", false);
      Firestore.instance
          .collection("users")
          .document("${user.user.uid}")
          .get()
          .then((value) {
        if (value.exists) {
          navigate(context, MainScreen());
        } else
          navigate(context, UserInformation(data: [1, 2, 3]));
      });

      break;
  }
  // return facebookLoginResult;
}

navigate(BuildContext context, Widget screen) {
  var newRoute = MaterialPageRoute(builder: (context) => screen);
  Navigator.pushAndRemoveUntil(context, newRoute, (route) => false);
}
