import 'package:flutter/material.dart';
import 'Widgets/loginScreen.dart';
// import 'Widgets/messangerScreen.dart';
void main() {
     runApp(MyApp());
}

@override
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
       );
  }
}