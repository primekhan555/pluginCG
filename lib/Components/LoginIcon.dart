import 'package:flutter/material.dart';

class LoginIcon extends StatelessWidget {
  final IconData icon;
  const LoginIcon({Key key, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Icon(icon, size: 40, color: Colors.white),
    );
  }
}
