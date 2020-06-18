import 'package:flutter/material.dart';
import 'package:pluginCG/resources/Color.dart' as colors;

class LoginIcon extends StatelessWidget {
  final IconData icon;
  const LoginIcon({Key key, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Icon(icon, size: 40, color: colors.pWhite),
    );
  }
}
