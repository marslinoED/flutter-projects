import 'package:flutter/material.dart';

class SignUpTypes extends StatelessWidget {
  const SignUpTypes({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.black,
                ),
            onPressed: () {
              // Handle Gmail SignUp
            },
            icon: Icon(Icons.email),
            label: const Text('Sign Up with Gmail', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 40),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.black,
                ),
            onPressed: () {
              // Handle Email SignUp
            },
            icon: Icon(Icons.email),
            label: const Text('Sign Up with Email', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}