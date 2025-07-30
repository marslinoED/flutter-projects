import 'package:flutter/material.dart';

class CardComponent extends StatelessWidget {
  final Widget? child;
  final double width;
  final double? height;
  final Color color;
  final double borderRadius;

  const CardComponent({
    Key? key,
    this.child,
    this.width = 70,
    this.height,
    this.color = Colors.grey,
    this.borderRadius = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // If height is not provided, calculate it based on 9:16 aspect ratio
    final double cardHeight = height ?? width * 3 / 2;
    return Container(
      width: width,
      height: cardHeight,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
} 