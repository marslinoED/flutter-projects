import 'package:chat_app/services/authentication.dart';
import 'package:chat_app/utils/audio.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Utility function to detect Arabic text
bool isArabicText(String text) {
  final arabicRegex = RegExp(
    r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]',
  );
  return arabicRegex.hasMatch(text);
}

class HostScreen extends StatefulWidget {
  const HostScreen({super.key});

  @override
  State<HostScreen> createState() => _HostScreenState();
}

class _HostScreenState extends State<HostScreen> {
  List<RoomInfo> _rooms = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRooms();
  }

  Future<void> _fetchRooms() async {
    try {
      setState(() {
        _isLoading = true;
        _rooms = []; // Clear existing rooms
      });

      // Try to get rooms from the index first
      try {
        final indexDoc = await FirebaseFirestore.instance
            .collection('chat_v2')
            .doc('rooms')
            .collection('index')
            .doc('rooms')
            .get();
        
        if (indexDoc.exists) {
          final data = indexDoc.data();
          if (data != null) {
            final List<dynamic> roomIds = data['roomIds'] ?? [];
            
            for (final roomId in roomIds) {
              _fetchRoomAsync(roomId.toString());
            }
          }
        }
      } catch (e) {
        print('Error fetching rooms index: $e');
      }

      // If no rooms found from index, fallback to checking common room IDs
      if (_rooms.isEmpty) {
        print('No rooms found in index, checking common room IDs...');
        final List<String> possibleRoomIds = ['0', '1', '2', '3', '4', '5', '10', '15', '20'];
        
        for (final roomId in possibleRoomIds) {
          _fetchRoomAsync(roomId);
        }
      }

      // Set loading to false after a short delay to show any found rooms
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });
    } catch (e) {
      print('Error fetching rooms: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchRoomAsync(String roomId) async {
    try {
      final roomInfoDoc = await FirebaseFirestore.instance
          .collection('chat_v2')
          .doc('rooms')
          .collection(roomId)
          .doc('information')
          .get();
      
      if (roomInfoDoc.exists) {
        final roomData = roomInfoDoc.data();
        if (roomData != null) {
          final onlineUsers = roomData['online_user'] as int? ?? 0;
          
          // Get message count
          final messagesSnapshot = await FirebaseFirestore.instance
              .collection('chat_v2')
              .doc('rooms')
              .collection(roomId)
              .doc('history')
              .collection('messages')
              .get();
          
          final messageCount = messagesSnapshot.docs.length;

          final roomInfo = RoomInfo(
            roomId: roomId,
            onlineUsers: onlineUsers,
            messageCount: messageCount,
          );
          
          print('Found room: $roomId with $onlineUsers users and $messageCount messages');
          
          if (mounted) {
            setState(() {
              _rooms.add(roomInfo);
              // Sort rooms by ID numerically
              _rooms.sort((a, b) {
                final aId = int.tryParse(a.roomId) ?? 0;
                final bId = int.tryParse(b.roomId) ?? 0;
                return aId.compareTo(bId);
              });
            });
          }
        }
      }
    } catch (e) {
      print('Error fetching room $roomId: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C0C0C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        title: const Text(
          'Chat Rooms',
          style: TextStyle(
            fontFamily: 'WindowsCommandPrompt',
            color: Color(0xFF00FF41),
            fontSize: 18,
            letterSpacing: 1,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF00FF41)),
            onPressed: () {
              playTapSound();
              _fetchRooms();
            },
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
        child: _isLoading
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
                      'Loading rooms...',
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
            : _rooms.isEmpty
                ? const Center(
                    child: Text(
                      'No rooms found',
                      style: TextStyle(
                        fontFamily: 'WindowsCommandPrompt',
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _rooms.length,
                    itemBuilder: (context, index) {
                      return RoomCard(room: _rooms[index]);
                    },
                  ),
      ),
    );
  }
}

class RoomInfo {
  final String roomId;
  final int onlineUsers;
  final int messageCount;

  RoomInfo({
    required this.roomId,
    required this.onlineUsers,
    required this.messageCount,
  });
}

class RoomCard extends StatelessWidget {
  final RoomInfo room;

  const RoomCard({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF00FF41).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            playTapSound();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TempChatScreen(roomId: room.roomId),
              ),
            );
          },
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Room ID: ${room.roomId}',
                      style: const TextStyle(
                        fontFamily: 'WindowsCommandPrompt',
                        color: Color(0xFF00FF41),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00FF41).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.person,
                            color: Color(0xFF00FF41),
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${room.onlineUsers}',
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
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.message,
                      color: Colors.grey,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${room.messageCount} messages',
                      style: const TextStyle(
                        fontFamily: 'WindowsCommandPrompt',
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TempChatScreen extends StatefulWidget {
  final String roomId;

  const TempChatScreen({super.key, required this.roomId});

  @override
  State<TempChatScreen> createState() => _TempChatScreenState();
}

class _TempChatScreenState extends State<TempChatScreen> {
  final ScrollController _scrollController = ScrollController();
  List<ChatMessage> _messages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  Future<void> _fetchMessages() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final messagesRef = FirebaseFirestore.instance
          .collection('chat_v2')
          .doc('rooms')
          .collection(widget.roomId)
          .doc('history')
          .collection('messages')
          .orderBy('timestamp', descending: false);

      final messagesSnapshot = await messagesRef.get();
      final List<ChatMessage> messages = [];

      for (final doc in messagesSnapshot.docs) {
        final data = doc.data();
        final timestamp = data['timestamp'] as Timestamp?;

        if (timestamp != null) {
          final messageTime = timestamp.toDate();
          final currentUser = AuthenticationService().currentUser;
          final isFromUser = data['userid'] == currentUser?.uid;

          messages.add(
            ChatMessage(
              username: data['username'] ?? 'Anonymous',
              message: data['message'] ?? '',
              timestamp: messageTime,
              isFromUser: isFromUser,
            ),
          );
        }
      }

      setState(() {
        _messages = messages;
        _isLoading = false;
      });

      // Scroll to bottom after messages are loaded
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    } catch (e) {
      print('Error fetching messages: $e');
      setState(() {
        _isLoading = false;
      });
    }
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
          'Room ${widget.roomId}',
          style: const TextStyle(
            fontFamily: 'WindowsCommandPrompt',
            color: Color(0xFF00FF41),
            fontSize: 18,
            letterSpacing: 1,
          ),
        ),
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
            child: _isLoading
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
                          'No messages in this room',
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
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
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
      child: message.username == 'host'
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
                            color: message.isFromUser
                                ? const Color(0xFF00FF41)
                                : Colors.grey[400],
                            fontSize: 16,
                          ),
                        ),
                        TextSpan(
                          text: message.message,
                          style: TextStyle(
                            fontFamily: messageFont,
                            color: message.isFromUser
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
