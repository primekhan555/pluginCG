import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:pluginCG/Screens/Splash0.dart';

void main() {
  // runApp(DevicePreview(builder: (context)=>MyApp()));
  runApp(DevicePreview(enabled: false, builder: (context) => MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Splash0(),
    );
  }
}
