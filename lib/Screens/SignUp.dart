import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pluginCG/Components/AButton.dart';
import 'package:pluginCG/Components/ContinueText.dart';
import 'package:pluginCG/Components/LoginButton.dart';
import 'package:pluginCG/Components/LoginIcon.dart';
import 'package:pluginCG/Components/LogoText.dart';
import 'package:pluginCG/Components/TermsText.dart';
import 'package:pluginCG/Mainsection/MainScreen.dart';
import 'package:pluginCG/Screens/SignIn.dart';
import 'package:pluginCG/Screens/SignUpEmail.dart';
import 'package:pluginCG/Screens/Splash.dart';
import 'package:pluginCG/Screens/UserInformation.dart';
import 'fbLogin.dart' as fbLogin;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pluginCG/resources/Color.dart' as colors;
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class SignUp extends StatefulWidget {
  SignUp({Key key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String password, email;
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
                    children: <Widget>[
                      LogoText(
                        margin: height / 10,
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
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w900),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          print(this.email);
                          print(this.password);
                          final form = _formKey.currentState;
                          
                          if (form.validate()) {
                            form.save();
                            SharedPreferences prefs=await SharedPreferences.getInstance();
                            AuthResult user =
                                await _auth.signInWithEmailAndPassword(
                                    email: this.email, password: this.password).then((currentUser) {
                                      prefs.setString("uid", "${currentUser.user.uid}");
                                      var newRoute=MaterialPageRoute(builder: (context)=>UserInformation(data:[0,1,2,3]));
                                      Navigator.pushAndRemoveUntil(context, newRoute, (route) => false);
                                    });
                                    
                            user.user.sendEmailVerification();
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
        decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            hintText: "$hint",
            hintStyle: TextStyle(color: Colors.white)),
        onChanged: (newValue) {
          fieldtype == "email"
              ? this.email = newValue
              : this.password = newValue;
        },
        validator: (value) => value.isEmpty ? "Please fill the Field" : null,
      ),
    );
  }

  // Future _handleFBSignIn() async {
  //   FacebookLogin facebookLogin = FacebookLogin();
  //   FacebookLoginResult facebookLoginResult =
  //       await facebookLogin.logIn(['email']);
  //   switch (facebookLoginResult.status) {
  //     case FacebookLoginStatus.cancelledByUser:
  //       print("Cancelled");
  //       break;
  //     case FacebookLoginStatus.error:
  //       print("error");
  //       Toast.show("an error occured While login through facebook", context,
  //           gravity: Toast.BOTTOM, duration: Toast.LENGTH_SHORT);
  //       break;
  //     case FacebookLoginStatus.loggedIn:
  //       print("Logged In");
  //       final accessToken = facebookLoginResult.accessToken.token;
  //       final facebookAuthCred =
  //           FacebookAuthProvider.getCredential(accessToken: accessToken);
  //       final user = await _auth.signInWithCredential(facebookAuthCred);
  //       var graph = await http.get(
  //           "https://graph.facebook.com/v6.0/me?fields=name,first_name,last_name,email,picture.height(320).width(320)&access_token=$accessToken");
  //       var profile = json.decode(graph.body);
  //       setState(() {
  //         globals.lName = profile['name'];
  //         globals.lEmail = profile['email'];
  //         globals.uid = user.user.uid;
  //         globals.lUrl = profile['picture']['data']['url'];
  //       });
  //       SharedPreferences prefs = await SharedPreferences.getInstance();
  //       prefs.setString("uid", "${user.user.uid}");
  //       prefs.setBool("partialRegister", true);
  //       prefs.setBool("fullRegister", false);
  //       Firestore.instance
  //           .collection("users")
  //           .document("${user.user.uid}")
  //           .setData({
  //         "uid": "${user.user.uid}",
  //         "name": "${profile['name']}",
  //         "email": "${profile['email']}",
  //         "picUrl": "${profile['picture']['data']['url']}"
  //       });
  //       var newRoute = MaterialPageRoute(builder: (context) => MainScreen());
  //       Navigator.pushAndRemoveUntil(context, newRoute, (route) => false);
  //       break;
  //   }
  //   // return facebookLoginResult;
  // }
}
