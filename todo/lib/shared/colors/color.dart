import 'package:flutter/material.dart';


Color staticBaseColor = Colors.blue;
Color staticSecondColor = Colors.yellow;
double darkMode = -0.4;
double lightMode = 0.3;


Color adjustColorLightness(Color color, double lightnessAdjustment) {
  HSLColor hslColor = HSLColor.fromColor(color);
  double newLightness = (hslColor.lightness + lightnessAdjustment).clamp(0.0, 1.0);
  return hslColor.withLightness(newLightness).toColor();
}