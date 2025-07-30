import 'package:flutter/material.dart';

class LoginTypes extends StatelessWidget {
  const LoginTypes({super.key});

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
              // Handle Gmail login
            },
            icon: Icon(Icons.email),
            label: const Text('Login with Gmail', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
              // Handle Email login
            },
            icon: Icon(Icons.email),
            label: const Text('Login with Email', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}