import 'package:flutter/material.dart';
import 'package:pluginCG/resources/Color.dart' as colors;

class AButton extends StatelessWidget {
  final Color color;
  final String name;
  final double hei;
  final Widget screen;
  AButton({Key key, this.color, this.name, this.hei, this.screen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        if (screen.toString() != "null") {
          var route = MaterialPageRoute(builder: (context) => screen);
          Navigator.pushAndRemoveUntil(context, route, (route) => false);
        }
      },
      child: Container(
        color: color,
        width: width,
        height: hei, //height / hei,
        child: Center(
          child: Text(
            "$name",
            style: TextStyle(
                color: colors.pWhite,
                fontSize: 20,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5),
          ),
        ),
      ),
    );
  }
}
