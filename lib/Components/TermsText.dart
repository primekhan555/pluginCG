import 'package:flutter/material.dart';

class TermsText extends StatelessWidget {
  const TermsText({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Text(
        "By signing up, you agree to the Terms of use",
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
}
