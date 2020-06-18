import 'package:flutter/material.dart';
import 'package:pluginCG/resources/Color.dart' as colors;

class ContinueText extends StatelessWidget {
  const ContinueText({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 15),
          child: Text(
            "or",
            style: TextStyle(
                color: colors.pWhite,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 15),
          child: Text(
            "Continue with",
            style: TextStyle(color:colors.pWhite, fontSize: 11),
          ),
        ),
      ],
    ));
  }
}
