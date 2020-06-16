import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:pluginCG/Components/AButton.dart';
import 'package:pluginCG/Components/LoginButton.dart';
import 'package:pluginCG/Components/LogoText.dart';
import 'package:pluginCG/Mainsection/MainScreen.dart';
import 'package:pluginCG/resources/Color.dart' as colors;
import 'package:pluginCG/Globals/Globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flushbar/flushbar.dart';

class UserInformation extends StatefulWidget {
  final List<int> data;
  final String source;
  UserInformation({Key key, this.data, this.source}) : super(key: key);

  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInformation> {
  List<String> fieldTitle = [
    "What's Your Name?",
    "What's Your Age",
    "What's Your Country or Region?",
    "What's Your Gender"
  ];
  int index = 0;
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: colors.pBlue,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              height: 150,
              child: LogoText(padding: height / 10, margin: 1.0),
            ),
            Container(
              child: Text(
                "${fieldTitle[widget.data[index]]}",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900),
              ),
            ),
            widget.data[index] == 0
                ? textField(TextInputType.text)
                : widget.data[index] == 1
                    ? textField(TextInputType.phone)
                    : widget.data[index] == 2
                        ? Container(
                            padding: const EdgeInsets.only(right: 10),
                            child: Column(
                              children: <Widget>[
                                CountryCodePicker(
                                  enabled: true,
                                  onChanged: (value) =>
                                      globals.lCountry = value.name.toString(),
                                  initialSelection: 'PK',
                                  showCountryOnly: true,
                                  showOnlyCountryWhenClosed: false,
                                  showFlag: false,
                                  showFlagMain: false,
                                  alignLeft: true,
                                  builder: (countryCode) {
                                    return Container(
                                        padding: EdgeInsets.only(top: 17),
                                        child: Text('${countryCode.name}',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 17)));
                                  },
                                ),
                                Divider(
                                  indent: 25,
                                  endIndent: 25,
                                  color: Colors.grey[800],
                                )
                              ],
                            ))
                        : widget.data[index] == 3
                            ? Container(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    container(LoginButton(btnText: "Female"),
                                        "female"),
                                    container(
                                        LoginButton(btnText: "Male"), "male"),
                                    container(
                                        LoginButton(btnText: "Other"), "other"),
                                  ],
                                ),
                              )
                            : Container(),
            widget.data[index] < 3
                ? InkWell(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      if (widget.data[index] == 0) {
                        if (globals.lName == "") {
                          showWarning("Alert", "Enter Name");
                          return;
                        }
                      }
                      if (widget.data[index] == 1) {
                        if (globals.lAge == "") {
                          showWarning("Alert", "Enter Age");
                          return;
                        }
                      }
                      setState(() {
                        if (index < 3) {
                          _controller.clear();
                          index = index + 1;
                        }
                      });
                    },
                    child: Container(
                      child: LoginButton(
                        btnText: "NEXT",
                      ),
                    ),
                  )
                : Container(),
            Container(
              height: 70,
              child: AButton(color: colors.pCyan, name: "SIGN IN"),
            )
          ],
        ),
      ),
    );
  }

  container(Widget child, String type) {
    return InkWell(
      onTap: () async {
        if (type == "female") {
          globals.lGender = "female";
        } else if (type == "male") {
          globals.lGender = "male";
        } else {
          globals.lGender = "other";
        }
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String uid = prefs.getString("uid");
        await Firestore.instance.collection("users").document("$uid").setData({
          "uid": uid,
          "name": globals.lName,
          "country": globals.lCountry,
          "email": globals.lEmail,
          "age": globals.lAge,
          "gender": globals.lGender,
          "picUrl": globals.lUrl,
          "token":""
        }).whenComplete(() {
          var newRoute = MaterialPageRoute(builder: (context) => MainScreen());
          Navigator.pushAndRemoveUntil(context, newRoute, (route) => false);
        });
      },
      child: Container(
          margin: EdgeInsets.only(bottom: 5), width: 150, child: child),
    );
  }

  textField(TextInputType type) => Container(
        padding: EdgeInsets.only(left: 25, right: 25),
        child: Form(
            child: TextFormField(
          controller: _controller,
          keyboardType: type,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          onChanged: (value) {
            if (widget.data[index] == 0) {
              globals.lName = value;
            } else {
              globals.lAge = value;
            }
          },
        )),
      );
  showWarning(String title, String message) {
    Flushbar(
      title: "$title",
      message: "$message",
      backgroundColor: Colors.red,
      duration: Duration(seconds: 2),
      flushbarPosition: FlushbarPosition.TOP,
    )..show(context);
  }
}
