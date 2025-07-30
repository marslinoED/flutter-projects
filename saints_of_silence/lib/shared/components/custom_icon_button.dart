import 'package:flutter/material.dart';
import 'dart:ui';

class CustomIconButton extends StatelessWidget {
  final dynamic icon; // Can be either IconData or String (for image path)
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final double? scale;
  final Color? color;

  const CustomIconButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.width = 52,
    this.height = 52,
    this.scale = 1.5,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black.withOpacity(0.3),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: IconButton(
            iconSize: 16, // keep the tap area small
            padding: EdgeInsets.zero, // remove extra padding
            constraints: const BoxConstraints(), // removes default min size
            onPressed: onPressed,
            icon: Transform.scale(
              scale: scale,
              child: icon is IconData
                  ? Icon(
                      icon,
                      size: width,
                      color: color ?? Colors.white,
                    )
                  : Image.asset(
                      icon as String,
                      width: width,
                      height: height,
                    ),
            ),
          ),
        ),
      ),
    );
  }
} 