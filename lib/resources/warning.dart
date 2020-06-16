
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

showWarning(String title, String message,var context,Color color) {
    Flushbar(
      title: "$title",
      message: "$message",
      backgroundColor: color,
      duration: Duration(seconds: 2),
      flushbarPosition: FlushbarPosition.TOP,
    )..show(context);
  }
  toast(BuildContext context,String message){
  return Toast.show("$message", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
  }