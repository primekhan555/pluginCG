import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pluginCG/Components/AButton.dart';
import 'package:pluginCG/Components/ContinueText.dart';
import 'package:pluginCG/Components/LoginButton.dart';
import 'package:pluginCG/Components/LoginIcon.dart';
import 'package:pluginCG/Components/LogoText.dart';
import 'package:pluginCG/Components/TermsText.dart';
import 'package:pluginCG/Screens/SignIn.dart';
import 'package:pluginCG/Screens/SignUp.dart';
import 'package:pluginCG/Screens/Splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pluginCG/Globals/Globals.dart' as globals;
import 'package:pluginCG/resources/Color.dart' as colors;
import 'fbLogin.dart' as fbLogin;
import 'package:shared_preferences/shared_preferences.dart';

class SignUpEmail extends StatefulWidget {
  SignUpEmail({Key key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUpEmail> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String password, email;
  bool showpass = true;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: colors.pBlue,
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      LogoText(
                        margin: height / 15,
                        padding: height / 5,
                      ),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              textField("Email", "email"),
                              textField("Password", "pass"),
                            ],
                          )),
                      Padding(padding: EdgeInsets.only(top: 10)),
                      InkWell(
                        onTap: () async {
                          final form = _formKey.currentState;
                          if (form.validate()) {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            form.save();
                            await _auth
                                .createUserWithEmailAndPassword(
                                    email: globals.lEmail,
                                    password: globals.lPassword)
                                .then((currentUser) {
                              prefs.setString("uid", currentUser.user.uid);
                              currentUser.user.sendEmailVerification();
                              prefs.setString("info", "pending");
                              var route = MaterialPageRoute(
                                  builder: (context) => SignUp());
                              Navigator.push(context, route);
                            });
                          } else {
                            _scaffoldKey.currentState.showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.red[700],
                                content: Text('Fields Empty'),
                              ),
                            );
                          }
                        },
                        child: LoginButton(
                          btnText: "SIGN UP",
                        ),
                      ),
                      ContinueText(),
                      Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              InkWell(
                                onTap: () => fbLogin.handleFBSignIn(context),
                                child: LoginIcon(
                                  icon: FontAwesomeIcons.facebookSquare,
                                ),
                              ),
                              Container(width: 15),
                              InkWell(
                                onTap: () {
                                  var newRoute = MaterialPageRoute(
                                      builder: (context) => SignIn());
                                  Navigator.pushAndRemoveUntil(
                                      context, newRoute, (route) => false);
                                },
                                child: LoginIcon(
                                  icon: FontAwesomeIcons.phoneSquare,
                                ),
                              ),
                            ],
                          )),
                      TermsText(),
                    ],
                  ),
                ),
                Container(
                  height: height / 10,
                  margin: EdgeInsets.only(top: height / 6.8),
                  child: AButton(
                    color: colors.pCyan,
                    name: "SIGN IN",
                    hei: height / 10,
                    screen: SignUp(),
                  ),
                ),
              ],
            ),
          ),
        ),
        onWillPop: () {
          var route = MaterialPageRoute(builder: (context) => Splash());
          Navigator.pushAndRemoveUntil(context, route, (route) => false);
          return;
        });
  }

  textField(String hint, String fieldtype) {
    return Container(
      height: 55,
      padding: EdgeInsets.only(left: 25, right: 25),
      child: TextFormField(
        style: TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        obscureText: fieldtype == "pass" ? showpass : false,
        decoration: InputDecoration(
            suffixIcon: fieldtype == "pass"
                ? IconButton(
                    icon: Icon(
                      showpass
                          ? FontAwesomeIcons.solidEye
                          : FontAwesomeIcons.solidEyeSlash,
                      color: Colors.white,
                      size: 15,
                    ),
                    onPressed: () {
                      setState(() {
                        showpass = !showpass;
                      });
                    },
                  )
                : null,
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            hintText: "$hint",
            hintStyle: TextStyle(color: Colors.white)),
        onChanged: (newValue) {
          fieldtype == "email"
              ? globals.lEmail = newValue
              : globals.lPassword = newValue;
        },
        validator: (value) => value.isEmpty ? "Please fill the Field" : null,
      ),
    );
  }
}
