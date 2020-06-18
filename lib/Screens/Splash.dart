import 'package:flutter/material.dart';
import 'package:pluginCG/Components/AButton.dart';
import 'package:pluginCG/Screens/SignIn.dart';
import 'package:pluginCG/Screens/SignUp.dart';
import 'package:pluginCG/resources/Assets.dart' as assets;
import 'package:pluginCG/resources/Color.dart' as colors;

class Splash extends StatelessWidget {
  const Splash({Key key}) : super(key: key);

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