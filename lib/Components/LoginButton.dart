import 'package:flutter/material.dart';
import 'package:pluginCG/resources/Color.dart' as colors;

class LoginButton extends StatelessWidget {
  final String btnText;
  const LoginButton({Key key, this.btnText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // child: RaisedButton(
        alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.green, borderRadius: BorderRadius.circular(3)),
      height: 35,
      width: 85,
      child: Text(
        "$btnText",
        style: TextStyle(
            color: colors.pWhite,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.8),
      ),
      //   onPressed: () {},
      // ),
    );
  }
}
