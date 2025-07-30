import 'package:flutter/material.dart';

class AppTheme {

  Color primaryColor = Colors.blue;
  Color secondaryColor = const Color.fromARGB(255, 9, 57, 96);
  
  final ThemeData light = ThemeData.light().copyWith(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    colorScheme: ColorScheme.light(
    primary: Colors.blue, // Controls primary text color (buttons, links, etc.)
    secondary: Colors.blueAccent, // For secondary elements
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black87),
    ),

    iconTheme: IconThemeData(
      color: const Color.fromARGB(255, 9, 57, 96), // Set your desired color
      size: 24,           // Optional: Change size globally
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
    ),

  );

  final ThemeData dark = ThemeData.dark().copyWith(
    brightness: Brightness.dark,
    primaryColor: const Color.fromARGB(255, 9, 57, 96),
    scaffoldBackgroundColor: const Color.fromARGB(255, 9, 57, 96),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    colorScheme: ColorScheme.light(
    primary: Colors.blue, // Controls primary text color (buttons, links, etc.)
    secondary: Colors.blueAccent, // For secondary elements
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
    ),

    iconTheme: IconThemeData(
      color: const Color.fromARGB(255, 19, 105, 176), // Set your desired color
      size: 24,           // Optional: Change size globally
    ),

  );



}
