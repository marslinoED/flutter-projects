import 'package:flutter/material.dart';

class AppTheme {
  TextStyle bodyExtraLarge = const TextStyle(color: Colors.white,fontSize: 50, fontWeight: FontWeight.bold);
  TextStyle buttonTextStyle = const TextStyle(color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold);
  TextStyle textButtonTextStyle = const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold);
  TextStyle bodyMedium = const TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.w800,
    
  );
  TextStyle bodySmall = const TextStyle(color: Colors.white, fontSize: 16);
  TextStyle bodyExtraSmall = const TextStyle(
    color: Colors.white,
    fontSize: 14,
  );

  TextStyle dateTextStyle = const TextStyle(color: Colors.grey, fontSize: 18);


  Color primaryColor = Colors.blue;
  Color secondaryColor = const Color.fromARGB(255, 9, 57, 96);
  Color darkBG = Color.fromARGB(200, 13, 43, 63);
  Color darkAccent = Colors.cyanAccent;
  Color backgroundTransparent = const Color.fromARGB(255, 3, 23, 39);

 
  final ThemeData dark = ThemeData.dark().copyWith(
    brightness: Brightness.dark,
    primaryColor: const Color.fromARGB(255, 9, 57, 96),
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.black,
      elevation: 0,
    ),
    colorScheme: ColorScheme.light(
      primary:
          Colors.black, // Controls primary text color (buttons, links, etc.)
      secondary: const Color.fromARGB(255, 9, 57, 96), // For secondary elements
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
    ),

    iconTheme: IconThemeData(
      color: Colors.white, // Set your desired color
      size: 24, // Optional: Change size globally
    ),
  );
}
