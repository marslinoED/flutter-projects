import 'package:cosmic/screens/startScreen/start_screen.dart';
import 'package:cosmic/shared/app_theme.dart';
import 'package:flutter/material.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cosmic',
      debugShowCheckedModeBanner: false,
      theme: AppTheme().dark,
      themeMode: ThemeMode.dark,
      home: StartScreen(),
    );
  }
}
