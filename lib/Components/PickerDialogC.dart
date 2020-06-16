import 'package:flutter/material.dart';

pickerContainer(String cText,Color color,Color bgColor,double height,FontWeight fontWeight,double margin) {
  return Container(
    margin: EdgeInsets.only(top:margin),
    color: bgColor,
    alignment: Alignment.center,
    height:height,
    child: Text(
      '$cText',
      style: TextStyle(
        color: color,
        fontWeight: fontWeight,
      ),
    ),
  );
}
