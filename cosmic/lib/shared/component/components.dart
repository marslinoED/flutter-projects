import 'package:cosmic/shared/app_theme.dart';
import 'package:flutter/material.dart';

Widget buildDeafultTextField(TextEditingController controller, String label) {
  return TextFormField(
    controller: controller,
    style: AppTheme().bodyMedium,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return '$label cannot be empty';
      }
      return null;
    },

    decoration: InputDecoration(
      prefix: SizedBox(width: 20),
      hintText: label,
      hintStyle: TextStyle(color: Colors.grey),

      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(50),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(50),
      ),
      fillColor: AppTheme().darkBG,
      filled: true,
    ),
  );
}

Widget buildDefaultButton(function, text) {
  return Container(
    clipBehavior: Clip.antiAlias, // Add border radius to clip children
    width: double.infinity,
    height: 55,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(50),
      image: DecorationImage(
        image: AssetImage(
          'assets/background/button_background.png',
        ), // Your image path
        fit: BoxFit.cover, // Adjust how the image fits
      ),
    ),
    child: ElevatedButton(
      onPressed: function,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      child: Center(child: Text(text, style: AppTheme().buttonTextStyle)),
    ),
  );
}

Widget circularButton(icon, Color borderColor, function, {Color? backgroundColor}) {
  return Container(
    decoration: BoxDecoration(
      color: backgroundColor ?? Colors.transparent,
      shape: BoxShape.circle,
      border: Border.all(
        color: borderColor, // Stroke color
        width: 2.0, // Stroke width
      ),
    ),
    child: CircleAvatar(
      radius: 22,
      backgroundColor: Colors.transparent,
      child: IconButton(onPressed: function, icon: icon),
    ),
  );
}

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

String cleanString(String input) {
  if (input.startsWith("[")) {
    return input.replaceFirst(RegExp(r"\[.*?\]\s*"), "");
  }
  return input;
}

void errorMessage(BuildContext context, String message, bool state) {
  message = cleanString(message);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, textAlign: TextAlign.center),
      backgroundColor: state ? Colors.green : Colors.red,
      duration: Duration(seconds: 1 + message.length ~/ 12.5),
    ),
  );
}
