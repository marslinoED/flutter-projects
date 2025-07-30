import 'package:cosmic/screens/loginScreen/login_screen.dart';
import 'package:cosmic/shared/component/components.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Match the background color
      body: _buildBody(),
    );
  }
}

Widget _buildBody() {
  return Container(
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/background/background.png'),
        fit: BoxFit.cover,
      ),
    ),
    child: Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Image(image: AssetImage('assets/logo/logo.png')),
        ),
        Center(
          child: AnimatedCircularIndicator(
            size: 300, // Size of the circle
            targetProgress: 1, // 1.0 means 100%
            duration: 2, // Animation duration in seconds
          ),
        ),
      ],
    ),
  );
}

class AnimatedCircularIndicator extends StatefulWidget {
  final double size;
  final double targetProgress; // Value between 0.0 and 1.0
  final int duration; // Duration in seconds

  const AnimatedCircularIndicator({
    Key? key,
    required this.size,
    required this.targetProgress,
    required this.duration,
  }) : super(key: key);

  @override
  _AnimatedCircularIndicatorState createState() =>
      _AnimatedCircularIndicatorState();
}

class _AnimatedCircularIndicatorState extends State<AnimatedCircularIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Initialize the AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.duration),
    );

    // Create a Tween animation from 0 to targetProgress
    _animation = Tween<double>(
      begin: 0.0,
      end: widget.targetProgress,
    ).animate(_controller)..addListener(() {
      setState(() {}); // Update the UI as the animation progresses
    })..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        navigateTo(context, LoginScreen());
      }
    });


    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(widget.size, widget.size),
      painter: CircularIndicatorPainter(
        progress: _animation.value, // Pass the animated progress value
        strokeWidth: 8.0, // Thickness of the arc
        color: Colors.white, // Color of the arc
      ),
    );
  }
}

class CircularIndicatorPainter extends CustomPainter {
  final double progress; // Value between 0.0 and 1.0
  final double strokeWidth;
  final Color color;

  CircularIndicatorPainter({
    required this.progress,
    required this.strokeWidth,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Define the paint properties for the background circle (optional)
    final backgroundPaint =
        Paint()
          ..color = Colors.white.withOpacity(0.2)
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke;

    // Define the paint properties for the progress arc
    final progressPaint =
        Paint()
          ..color = color
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    // Calculate the center and radius
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Draw the background circle (optional)
    canvas.drawCircle(center, radius, backgroundPaint);

    // Calculate the sweep angle for the arc (progress * 2π)
    final sweepAngle = 2 * math.pi * progress;

    // Draw the progress arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // Start from the top (90 degrees)
      sweepAngle, // Sweep angle based on progress
      false, // Use center (false for an arc)
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CircularIndicatorPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
