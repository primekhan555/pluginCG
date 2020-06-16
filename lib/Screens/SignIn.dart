import 'package:flutter/material.dart';
import 'package:pluginCG/Components/AButton.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pluginCG/Components/ContinueText.dart';
import 'package:pluginCG/Components/LoginButton.dart';
import 'package:pluginCG/Components/LoginIcon.dart';
import 'package:pluginCG/Components/LogoText.dart';
import 'package:pluginCG/Components/TermsText.dart';
import 'package:pluginCG/Screens/PinVerification.dart';
import 'package:pluginCG/Screens/SignUp.dart';
import 'package:pluginCG/Screens/SignUpEmail.dart';
import 'package:pluginCG/Screens/Splash.dart';
import 'package:pluginCG/resources/Color.dart' as colors;
import 'fbLogin.dart' as fbLogin;

class SignIn extends StatefulWidget {
  SignIn({Key key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final number = TextEditingController();
  String countrycode = "+92";

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
        child: Scaffold(
            backgroundColor: colors.pBlue,
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  LogoText(
                    margin: height / 10,
                    padding: height / 5,
                  ),
                  Container(
                    height: 47.8,
                    margin: EdgeInsets.only(
                        left: width / 10, right: width / 10, bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(right: 10),
                          child: CountryCodePicker(
                            enabled: true,
                            onChanged: (value) {
                              countrycode = value.toString();
                              print(countrycode);
                            },
                            initialSelection: 'PK',
                            showCountryOnly: false,
                            showOnlyCountryWhenClosed: false,
                            showFlag: false,
                            showFlagMain: false,
                            alignLeft: true,
                            builder: (countryCode) {
                              return Container(
                                  padding: EdgeInsets.only(top: 17),
                                  child: Text(
                                    '${countryCode.dialCode}',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 17),
                                  ));
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 10, bottom: 0),
                          margin: EdgeInsets.only(top: 10),
                          height: 20,
                          child: VerticalDivider(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        Flexible(
                            flex: 1,
                            child: Container(
                              height: 45,
                              padding: EdgeInsets.only(top: 30),
                              child: TextField(
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                cursorColor: Colors.white,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white)),
                                    border: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white)),
                                    fillColor: Colors.white,
                                    hintText: "Phone number",
                                    hintStyle: TextStyle(
                                      color: Colors.white,
                                    )),
                                controller: number,
                              ),
                            )),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      String fieldnmbr = number.text;
                      String fullNumber = countrycode + fieldnmbr;
                      print(fullNumber);
                      var route = MaterialPageRoute(
                          builder: (_) => PinVerification(
                                number: fullNumber,
                              ));
                      Navigator.push(context, route);
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
                            onTap: () {
                             fbLogin.handleFBSignIn(context);
                            },
                            child: LoginIcon(
                              icon: FontAwesomeIcons.facebookSquare,
                            ),
                          ),
                          Container(width: 15),
                          InkWell(
                            onTap: () {
                              var newRoute=MaterialPageRoute(builder: (context)=>SignUpEmail());
                              Navigator.pushAndRemoveUntil(context, newRoute, (route) => false);
                            },
                            child: LoginIcon(
                              icon: FontAwesomeIcons.at,
                            ),
                          ),
                        ],
                      )),
                  TermsText(),
                  Container(
                    height: height / 10,
                    margin: EdgeInsets.only(top: height / 5.13),
                    child: AButton(
                      color: Colors.cyan[300],
                      name: "SIGN IN",
                      hei: height / 10,
                      screen: SignUp(),
                    ),
                  ),
                ],
              ),
            )),
        onWillPop: () {
          var route = MaterialPageRoute(builder: (context) => Splash());
          Navigator.pushAndRemoveUntil(context, route, (route) => false);
          return;
        });
  }
}
