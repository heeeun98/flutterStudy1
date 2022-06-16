import 'package:flutter/material.dart';
import 'package:heeeun/act/SettingAct.dart';

typedef VoidCallback = void Function();
typedef VoidCallbackCheckBox = void Function(bool value);
typedef ListCallback = void Function(int index);

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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.redAccent,
        // textTheme: const TextTheme(
        //   bodyText2: TextStyle(color: Colors.white54)
        // )
      ),
    );
  }
}