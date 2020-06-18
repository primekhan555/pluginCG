import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pluginCG/Components/AButton.dart';
import 'package:pluginCG/Components/ContinueText.dart';
import 'package:pluginCG/Components/LoginButton.dart';
import 'package:pluginCG/Components/LoginIcon.dart';
import 'package:pluginCG/Components/LogoText.dart';
import 'package:pluginCG/Components/TermsText.dart';
import 'package:pluginCG/Mainsection/MainScreen.dart';
import 'package:pluginCG/Screens/ForgotPassword.dart';
import 'package:pluginCG/Screens/SignIn.dart';
import 'package:pluginCG/Screens/SignUpEmail.dart';
import 'package:pluginCG/Screens/Splash.dart';
import 'package:pluginCG/Screens/UserInformation.dart';
import 'fbLogin.dart' as fbLogin;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pluginCG/resources/Color.dart' as colors;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pluginCG/resources/warning.dart' as alert;
import 'package:pluginCG/Globals/Globals.dart' as globals;

class SignUp extends StatefulWidget {
  SignUp({Key key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String password, email;
  bool showpass = true;

  emailCheck() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("info")) {
      String info = prefs.getString("info");
      if (info == "pending") {
        alert.showWarning("Email Verification", "Please Check Your Mail Box",
            context, Colors.red);
      }
    }
    if (prefs.containsKey("reset")) {
      String key = prefs.getString("reset");
      if (key == "hitAlert") {
        alert.showWarning(
            "ResetPassword", "Please Check Your Email", context, Colors.red);
      }
    }
    prefs.remove("reset");
  }

  @override
  void initState() {
    super.initState();
    emailCheck();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: colors.pCyan,
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      LogoText(
                        margin: height / 15.5,
                        padding: height / 5,
                      ),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              textField("Email / Number", "email"),
                              textField("Password", "pass"),
                            ],
                          )),
                      Container(
                        padding: EdgeInsets.only(right: 25, top: 5),
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () {
                            var route = MaterialPageRoute(
                                builder: (context) => ForgotPassword());
                            Navigator.push(context, route);
                          },
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          final form = _formKey.currentState;
                          if (form.validate()) {
                            form.save();
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await _auth
                                .signInWithEmailAndPassword(
                                    email: this.email, password: this.password)
                                .then((currentUser) {
                              if (currentUser.user.isEmailVerified) {
                                prefs.setString(
                                    "uid", "${currentUser.user.uid}");
                                globals.lEmail = this.email;
                                globals.lPassword = this.password;
                                if (prefs.containsKey("info")) {
                                  String info = prefs.getString("info");
                                  if (info == "pending") {
                                    navigate(context,
                                        UserInformation(data: [0, 1, 2, 3]));
                                  } else {
                                    navigate(context, MainScreen());
                                  }
                                }
                              } else {
                                alert.showWarning(
                                    "Verification Alert",
                                    "Please Check Your Email",
                                    context,
                                    Colors.red);
                              }
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
                          btnText: "SIGN IN",
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
                                      builder: (context) => SignUpEmail());
                                  Navigator.pushAndRemoveUntil(
                                      context, newRoute, (route) => false);
                                },
                                child: LoginIcon(
                                  icon: FontAwesomeIcons.at,
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
                    color: colors.pBlue,
                    name: "SIGN UP",
                    hei: height / 10,
                    screen: SignIn(),
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
      height: 50,
      padding: EdgeInsets.only(left: 25, right: 25),
      // color: Colors.blue,
      child: TextFormField(
        style: TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        obscureText: fieldtype == "pass" ? showpass : false,
        decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            hintText: "$hint",
            hintStyle: TextStyle(color: Colors.white),
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
            ),
        onChanged: (newValue) {
          fieldtype == "email"
              ? this.email = newValue
              : this.password = newValue;
        },
        validator: (value) => value.isEmpty ? "Please fill the Field" : null,
      ),
    );
  }

  navigate(BuildContext context, Widget screen) {
    var newRoute = MaterialPageRoute(builder: (context) => screen);
    Navigator.pushAndRemoveUntil(context, newRoute, (route) => false);
  }
}
