import 'package:chat_app/screens/host.dart';
import 'package:chat_app/services/firestore.dart';
import 'package:chat_app/screens/chat.dart';
import 'package:chat_app/utils/audio.dart';
import 'package:chat_app/services/authentication.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _input = '';
  bool _isLoading = false;
  String _username = '';
  bool _isUpdatingUsername = false;
  final TextEditingController _usernameController = TextEditingController();
  final AuthenticationService _authService = AuthenticationService();

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _loadUsername() async {
    final currentUser = _authService.currentUser;
    if (currentUser != null) {
      setState(() {
        _username = currentUser.displayName ?? 'Anonymous';
        _usernameController.text = _username;
      });
    }
  }

  Future<void> _updateUsername() async {
    if (_usernameController.text.trim().isEmpty) return;

    setState(() {
      _isUpdatingUsername = true;
    });

    try {
      final currentUser = _authService.currentUser;
      if (currentUser != null) {
        // Update display name in Firebase Auth
        await currentUser.updateDisplayName(_usernameController.text.trim());

        // Update username in Firestore
        await _authService.updateUserData(currentUser.uid, {
          'username': _usernameController.text.trim(),
        });

        setState(() {
          _username = _usernameController.text.trim();
          _isUpdatingUsername = false;
        });
      }
    } catch (e) {
      print('Error updating username: $e');
      setState(() {
        _isUpdatingUsername = false;
      });
    }
  }

  void _onButtonPressed(String value) {
    playTapSound();
    setState(() {
      if (value == 'X') {
        _input = '';
      } else if (value == '<') {
        if (_input.isNotEmpty) {
          _input = _input.substring(0, _input.length - 1);
        }
      } else {
        if (_input.length < 17) {
          _input += value;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> buttons = [
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      'X',
      '0',
      '<',
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF111216),
      body: Column(
        children: [
          // Username editing bar at the top
          Container(
            margin: const EdgeInsets.fromLTRB(16, 60, 16, 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF23272F),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _usernameController,
                    style: const TextStyle(
                      fontFamily: 'WindowsCommandPrompt',
                      fontSize: 18,
                      color: Color(0xFF00FF41),
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Change username',
                      hintStyle: TextStyle(
                        color: Color(0xFF666666),
                        fontFamily: 'WindowsCommandPrompt',
                      ),
                    ),
                    onSubmitted: (_) => _updateUsername(),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap:
                      _isUpdatingUsername
                          ? null
                          : () {
                            playTapSound();
                            _updateUsername();
                          },
                  child:
                      _isUpdatingUsername
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Color(0xFF00FF41),
                              strokeWidth: 2,
                            ),
                          )
                          : const Icon(
                            Icons.edit,
                            color: Color(0xFF00FF41),
                            size: 20,
                          ),
                ),
              ],
            ),
          ),
          // Main content
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    // Hint label explaining how the app works
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        '> Enter any number to join infinite chat worlds ∞',
                        style: const TextStyle(
                          fontFamily: 'WindowsCommandPrompt',
                          fontSize: 28,
                          color: Color(0xFF888888),
                          letterSpacing: 1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 18,
                      ),
                      margin: const EdgeInsets.only(bottom: 32),
                      decoration: BoxDecoration(
                        color: const Color(0xFF23272F),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        _input.isEmpty ? '>' : '> $_input',
                        style: const TextStyle(
                          fontFamily: 'WindowsCommandPrompt',
                          fontSize: 28,
                          color: Color(0xFF00FF41),
                          letterSpacing: 2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
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
                          ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: 220,
                              minWidth: 180,
                            ),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: buttons.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    mainAxisSpacing: 8,
                                    crossAxisSpacing: 8,
                                    childAspectRatio: 1.1,
                                  ),
                              itemBuilder: (context, index) {
                                final label = buttons[index];
                                final isAction = label == 'X' || label == '<';
                                return SizedBox(
                                  height: 44,
                                  width: 44,
                                  child: ElevatedButton(
                                    onPressed: () => _onButtonPressed(label),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          isAction
                                              ? const Color(0xFF2D2F36)
                                              : const Color(0xFF181A20),
                                      foregroundColor:
                                          isAction
                                              ? const Color(0xFFFF5370)
                                              : const Color(0xFF38ad53),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: EdgeInsets.zero,
                                      elevation: 2,
                                      textStyle: const TextStyle(
                                        fontFamily: 'WindowsCommandPrompt',
                                        fontSize: 25,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                    child: Text(label),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 18),
                          ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: 180,
                              minWidth: 140,
                            ),
                            child: SizedBox(
                              height: 48,
                              child: ElevatedButton(
                                onPressed:
                                    (_input.isNotEmpty && !_isLoading)
                                        ? _input == "01228767453"
                                            ? () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder:
                                                      (context) => HostScreen(),
                                                ),
                                              );
                                            }
                                            : () async {
                                              playTapSound();
                                              setState(() {
                                                _isLoading = true;
                                              });

                                              try {
                                                final firestoreService =
                                                    FirestoreService();
                                                final roomIdInt = int.tryParse(
                                                  _input,
                                                );
                                                await firestoreService.createRoom(
                                                  roomIdInt!,
                                                );
                                                // Navigate to chat screen
                                                final roomIdString = _input;
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder:
                                                        (context) => ChatScreen(
                                                          roomId: roomIdString,
                                                        ),
                                                  ),
                                                );
                                                setState(() {
                                                  _input = '';
                                                  _isLoading = false;
                                                });
                                              } catch (e) {
                                                setState(() {
                                                  _isLoading = false;
                                                });
                                              }
                                            }
                                        : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF38ad53),
                                  disabledBackgroundColor: const Color(0xFF2D2F36),
                                  foregroundColor: const Color(0xFF181A20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                  elevation: 8,
                                  shadowColor: const Color(
                                    0xFF38ad53,
                                  ).withOpacity(0.5),
                                  textStyle: const TextStyle(
                                    fontFamily: 'WindowsCommandPrompt',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    letterSpacing: 2.5,
                                  ),
                                ).copyWith(
                                  elevation:
                                      MaterialStateProperty.resolveWith<double>(
                                        (states) =>
                                            states.contains(MaterialState.disabled)
                                                ? 2
                                                : 12,
                                      ),
                                  shadowColor: MaterialStateProperty.all(
                                    const Color(0xFF00FF41),
                                  ),
                                ),
                                child:
                                    _isLoading
                                        ? const SizedBox(
                                          width: 20,
                                          height: 20,
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
                                            fontSize: 22,
                                            letterSpacing: 2.5,
                                          ),
                                        ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
