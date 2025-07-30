import 'package:chat_app/services/firestore.dart';
import 'package:chat_app/services/authentication.dart';
import 'package:chat_app/utils/audio.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

// Utility function to detect Arabic text
bool isArabicText(String text) {
  final arabicRegex = RegExp(
    r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]',
  );
  return arabicRegex.hasMatch(text);
}

class ChatScreen extends StatefulWidget {
  final String roomId;

  const ChatScreen({super.key, required this.roomId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final FirestoreService _firestoreService = FirestoreService();
  final AuthenticationService _authService = AuthenticationService();

  // Real messages from Firestore
  List<ChatMessage> _messages = [];
  StreamSubscription<QuerySnapshot>? _messagesSubscription;
  StreamSubscription<DocumentSnapshot>? _roomSubscription;
  DateTime? _joinTime;
  bool _isLoading = true;
  int _onlineUsers = 1; // Default to 1 (current user)
  int _messageCount = 0; // Track the number of messages

  @override
  void initState() {
    super.initState();
    _joinTime = DateTime.now();
    _setupMessageStream();
    _setupRoomStream();

    // Scroll to bottom after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _setupMessageStream() {
    final messagesRef = FirebaseFirestore.instance
        .collection('chat_v2')
        .doc('rooms')
        .collection(widget.roomId)
        .doc('history')
        .collection('messages')
        .orderBy('timestamp', descending: false);

    _messagesSubscription = messagesRef.snapshots().listen(
      (snapshot) {
        final newMessages = <ChatMessage>[];

        for (final doc in snapshot.docs) {
          final data = doc.data();
          final timestamp = data['timestamp'] as Timestamp?;

          if (timestamp != null) {
            final messageTime = timestamp.toDate();

            // Only include messages from when user joined
            if (_joinTime == null || messageTime.isAfter(_joinTime!)) {
              final currentUser = _authService.currentUser;
              final isFromUser = data['userid'] == currentUser?.uid;

              newMessages.add(
                ChatMessage(
                  username: data['username'] ?? 'Anonymous',
                  message: data['message'] ?? '',
                  timestamp: messageTime,
                  isFromUser: isFromUser,
                ),
              );
            }
          }
        }

        setState(() {
          _messages = newMessages;
          _isLoading = false;
        });

        // Check if message count changed and update the variable
        if (_messageCount != newMessages.length) {
          playMessageSound();
          setState(() {
            _messageCount = newMessages.length;
          });
          print('Message count changed: $_messageCount messages');
        }

        // Scroll to bottom when new messages arrive
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      },
      onError: (error) {
        print('Error listening to messages: $error');
        setState(() {
          _isLoading = false;
        });
      },
    );
  }

  void _setupRoomStream() {
    final roomRef = FirebaseFirestore.instance
        .collection('chat_v2')
        .doc('rooms')
        .collection(widget.roomId)
        .doc('information');

    _roomSubscription = roomRef.snapshots().listen(
      (snapshot) {
        if (snapshot.exists) {
          final data = snapshot.data();
          if (data != null) {
            final onlineUsers = data['online_user'] as int? ?? 1;
            setState(() {
              _onlineUsers = onlineUsers;
            });
          }
        }
      },
      onError: (error) {
        print('Error listening to room updates: $error');
      },
    );
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() async {
    playTapSound();
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      try {
        final currentUser = _authService.currentUser;
        if (currentUser != null) {
          // Get username from user's display name
          final username = currentUser.displayName ?? 'Anonymous';
          // Save message to Firestore
          await _firestoreService.saveMessage(
            userId: currentUser.uid,
            username: username,
            message: message,
            roomId: widget.roomId,
          );
        }
      } catch (e) {
        print('Error sending message: $e');
        // You might want to show a snackbar or dialog here
      }

      _messageController.clear();
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C0C0C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF00FF41)),
          onPressed: () => {playTapSound(), Navigator.of(context).pop()},
        ),
        title: Text(
          'roomid@${widget.roomId}',
          style: const TextStyle(
            fontFamily: 'WindowsCommandPrompt',
            color: Color(0xFF00FF41),
            fontSize: 18,
            letterSpacing: 1,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.person, color: Color(0xFF00FF41), size: 20),
                const SizedBox(height: 2),
                Text(
                  '$_onlineUsers',
                  style: const TextStyle(
                    fontFamily: 'WindowsCommandPrompt',
                    color: Color(0xFF00FF41),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0C0C0C), Color(0xFF111111)],
          ),
        ),
        child: Column(
          children: [
            // Chat messages area
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF00FF41).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child:
                      _isLoading
                          ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  color: Color(0xFF00FF41),
                                  strokeWidth: 3,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Loading messages...',
                                  style: TextStyle(
                                    fontFamily: 'WindowsCommandPrompt',
                                    color: Color(0xFF00FF41),
                                    fontSize: 14,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          )
                          : _messages.isEmpty
                          ? const Center(
                            child: Text(
                              'No messages yet. Start the conversation!',
                              style: TextStyle(
                                fontFamily: 'WindowsCommandPrompt',
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          )
                          : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.all(16),
                            itemCount: _messages.length,
                            itemBuilder: (context, index) {
                              return MessageWidget(message: _messages[index]);
                            },
                          ),
                ),
              ),
            ),
            // Input area
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFF00FF41).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  const Text(
                    '> ',
                    style: TextStyle(
                      fontFamily: 'WindowsCommandPrompt',
                      color: Color(0xFF00FF41),
                      fontSize: 16,
                    ),
                  ),
                  Expanded(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxHeight: 120, // Approximately 5 lines
                      ),
                      child: SingleChildScrollView(
                        child: TextField(
                          controller: _messageController,
                          focusNode: _focusNode,
                          maxLines: null,
                          minLines: 1,
                          style: const TextStyle(
                            fontFamily: 'WindowsCommandPrompt',
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Type your message here...',
                            hintStyle: TextStyle(
                              fontFamily: 'WindowsCommandPrompt',
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _sendMessage,
                    icon: const Icon(
                      Icons.send,
                      color: Color(0xFF00FF41),
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messagesSubscription?.cancel();
    _roomSubscription?.cancel();
    _scrollController.dispose();
    _messageController.dispose();
    _focusNode.dispose();

    // Decrease online user count when leaving
    _firestoreService.leaveRoom(int.parse(widget.roomId));

    super.dispose();
  }
}

class ChatMessage {
  final String username;
  final String message;
  final DateTime timestamp;
  final bool isFromUser;

  ChatMessage({
    required this.username,
    required this.message,
    required this.timestamp,
    required this.isFromUser,
  });
}

class MessageWidget extends StatelessWidget {
  final ChatMessage message;

  const MessageWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final timeString =
        '${message.timestamp.hour.toString().padLeft(2, '0')}:'
        '${message.timestamp.minute.toString().padLeft(2, '0')}:'
        '${message.timestamp.second.toString().padLeft(2, '0')}';

    final isArabic = isArabicText(message.message);
    final messageFont =
        isArabic ? 'ArabicWindowsCommandPrompt' : 'WindowsCommandPrompt';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child:
          message.username == 'host'
              ? Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: message.message,
                        style: TextStyle(
                          fontFamily: messageFont,
                          color: Colors.grey[400],
                          fontSize: isArabic ? 10 : 16,
                        ),
                      ),
                    ],
                  ),
                  textAlign: isArabic ? TextAlign.right : TextAlign.center,
                  textDirection:
                      isArabic ? TextDirection.rtl : TextDirection.ltr,
                ),
              )
              : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '[$timeString] ',
                    style: TextStyle(
                      fontFamily: 'WindowsCommandPrompt',
                      color: Colors.grey[500],
                      fontSize: 16,
                    ),
                  ),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '<${message.username}> ',
                            style: TextStyle(
                              fontFamily: 'WindowsCommandPrompt',
                              color:
                                  message.isFromUser
                                      ? const Color(0xFF00FF41)
                                      : Colors.grey[400],
                              fontSize: 16,
                            ),
                          ),
                          TextSpan(
                            text: message.message,
                            style: TextStyle(
                              fontFamily: messageFont,
                              color:
                                  message.isFromUser
                                      ? const Color(0xFF00FF41)
                                      : Colors.grey[300],
                              fontSize: isArabic ? 10 : 16,
                            ),
                          ),
                        ],
                      ),
                      textAlign: isArabic ? TextAlign.right : TextAlign.left,
                      textDirection:
                          isArabic ? TextDirection.rtl : TextDirection.ltr,
                    ),
                  ),
                ],
              ),
    );
  }
}
