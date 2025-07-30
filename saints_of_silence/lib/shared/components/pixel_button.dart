import 'package:flutter/material.dart';

class PixelButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final Color? baseColor;
  final Color? highlightColor;
  final Color? shadowColor;
  final double? fontSize;

  const PixelButton({
    Key? key,
    required this.text,
    required this.icon,
    required this.onPressed,
    this.width = 175,
    this.height = 48,
    this.baseColor = const Color(0xFF10263e),
    this.highlightColor = const Color(0xFF1E3A5F),
    this.shadowColor = const Color(0xFF050D14),
    this.fontSize = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: baseColor,
        border: Border(
          top: BorderSide(color: highlightColor!, width: 2),
          left: BorderSide(color: highlightColor!, width: 2),
          right: BorderSide(color: shadowColor!, width: 2),
          bottom: BorderSide(color: shadowColor!, width: 2),
        ),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(width!, height!),
          backgroundColor: baseColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          textStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: fontSize! + 4),
            SizedBox(width: 4),
            Text(text),
          ],
        ),
      ),
    );
  }
} 