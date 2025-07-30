import 'package:chat_app/services/authentication.dart';
import 'package:chat_app/utils/audio.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/screens/home.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _isNameValid = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_validateName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _validateName() {
    setState(() {
      _isNameValid = _nameController.text.trim().isNotEmpty;
    });
  }

  void _onEnterPressed() async {
    playTapSound();
    if (_isNameValid) {
      setState(() {
        _isLoading = true;
      });
      
      try {
        await AuthenticationService().signInAnonymously(username: _nameController.text);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        // You might want to show an error message here
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111216),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF23272F),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Text field
              Container(
                width: 280,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFF181A20),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _isNameValid 
                        ? const Color(0xFF00FF41) 
                        : const Color(0xFF2D2F36),
                    width: 2,
                  ),
                ),
                child: TextField(
                  controller: _nameController,
                  style: const TextStyle(
                    fontFamily: 'WindowsCommandPrompt',
                    fontSize: 24,
                    color: Color(0xFF00FF41),
                    letterSpacing: 1.5,
                  ),
                  decoration: const InputDecoration(
                    hintText: '> Enter your name here...',
                    hintStyle: TextStyle(
                      fontFamily: 'WindowsCommandPrompt',
                      fontSize: 20,
                      color: Color(0xFF666666),
                      letterSpacing: 1,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                  ),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _onEnterPressed(),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Enter button
              SizedBox(
                width: 200,
                height: 56,
                child: ElevatedButton(
                  onPressed: (_isNameValid && !_isLoading) ? _onEnterPressed : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF38ad53),
                    disabledBackgroundColor: const Color(0xFF2D2F36),
                    foregroundColor: const Color(0xFF181A20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    elevation: 8,
                    shadowColor: const Color(0xFF38ad53).withOpacity(0.5),
                    textStyle: const TextStyle(
                      fontFamily: 'WindowsCommandPrompt',
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      letterSpacing: 2.5,
                    ),
                  ).copyWith(
                    elevation: MaterialStateProperty.resolveWith<double>(
                      (states) =>
                          states.contains(MaterialState.disabled) ? 2 : 12,
                    ),
                    shadowColor: MaterialStateProperty.all(
                      const Color(0xFF00FF41),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.black,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'ENTER',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'WindowsCommandPrompt',
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            letterSpacing: 2.5,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 