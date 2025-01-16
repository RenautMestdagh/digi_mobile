import 'package:flutter/material.dart';
import 'src/screens/login_screen.dart';

GlobalKey navigatorKey = GlobalKey();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      key: navigatorKey,
      title: 'Flutter Digi Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}
