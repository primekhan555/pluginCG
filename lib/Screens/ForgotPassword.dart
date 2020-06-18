import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pluginCG/Screens/SignUp.dart';
import 'package:pluginCG/resources/Logo.dart' as logo;
import 'package:pluginCG/resources/Color.dart' as colors;
import 'package:pluginCG/Components/LoginButton.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({Key key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  GlobalKey<FormState> _form = GlobalKey<FormState>();
  final emailController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: logo.logo(),
        backgroundColor: colors.pBlue,
        centerTitle: true,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context)),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        height: 250,
        // color: colors.pBlue,
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 30),
              child: Text(
                "Reset Password",
                style: TextStyle(color: Colors.grey[400], fontSize: 20),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 25, right: 25, bottom: 30, top: 50),
              child: Form(
                  key: _form,
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(hintText: "Enter Email"),
                  )),
            ),
            InkWell(
                onTap: () {
                  final form = _form.currentState;
                  if (form.validate()) {
                    form.save();
                    _auth
                        .sendPasswordResetEmail(email: emailController.text)
                        .whenComplete(() async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setString("reset", "hitAlert");
                      var newRoute =
                          MaterialPageRoute(builder: (context) => SignUp());
                      Navigator.pushAndRemoveUntil(
                          context, newRoute, (route) => false);
                    });
                  }
                },
                child: LoginButton(btnText: "Reset"))
          ],
        ),
      ),
    );
  }
}
