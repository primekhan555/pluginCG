import 'package:flutter/material.dart';
import 'package:pluginCG/resources/Assets.dart' as assets;

class LogoText extends StatelessWidget {
  final margin,padding;
  const LogoText({Key key, this.margin,this.padding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(bottom: margin),
        padding: EdgeInsets.only(
          top: padding,
        ),
        height: 200,
        width: 200,
        child: assets.logo
      ),
    );
  }
}
