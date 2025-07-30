import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void navigateToBack(context, screen) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
}

void navigateTo(context, screen) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => screen),
    (route) {
      return false;
    },
  );
}

void errorMessage(BuildContext context, String message, bool state) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, textAlign: TextAlign.center),
      backgroundColor: state ? Colors.green : Colors.red,
      duration: Duration(seconds: 1 + message.length ~/ 12.5),
    ),
  );
}

Widget wrapApp(Widget app) {
  if (kIsWeb) {
    return Center(
      child: SizedBox(
        width: 492, // desired width
        height: 800, // desired height
        child: app,
      ),
    );
  }
  return app;
}