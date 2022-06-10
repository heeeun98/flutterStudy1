import 'package:flutter/material.dart';
import 'package:heeeun/act/SettingAct.dart';

typedef VoidCallback = void Function();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "MaterialApp",
      home: const SettingAct(),
      theme: ThemeData(
        brightness: Brightness.dark
      ),
    );
  }
}