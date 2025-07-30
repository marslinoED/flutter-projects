import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Creates a room document in chat_v2/rooms collection
  /// Returns true if room was created, false if it already exists
  Future<void> createRoom(int roomId) async {
    print("Creating Room");
    try {
      
      // Get current user and their username
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('No authenticated user found');
      }
      
      // Get username from user's display name (already saved during sign in)
      final username = currentUser.displayName ?? "Unknown";
      
      final roomRef = _firestore
          .collection('chat_v2')
          .doc("rooms")
          .collection(roomId.toString())
          .doc('information');

      // Check if room already exists
      final roomDoc = await roomRef.get();

      // If room already exists, increment online players
      if (roomDoc.exists) {
        print("Already Exist");
        await roomRef.update({
          'online_user': FieldValue.increment(1),
        });
        
        // Save join message for existing room
        await saveMessage(
          userId: '0',
          username: 'host',
          message: "[user@$username has entered the chat]",
          roomId: roomId.toString(),
        );
        return;
      }

      // Create the room document
      await roomRef.set({
        'roomid': roomId,
        'created_at': FieldValue.serverTimestamp(),
        'online_user': 1,
      });

      // Add room to rooms index
      await _addRoomToIndex(roomId.toString());

      // Save join message for new room
      await saveMessage(
        userId: '0',
        username: 'host',
        message: "[user@$username has entered the chat]",
        roomId: roomId.toString(),
      );

      print("Room Created");
      return;
    } catch (e) {
      print('Error creating room: $e');
      rethrow;
    }
  }

  /// Adds a room to the rooms index
  Future<void> _addRoomToIndex(String roomId) async {
    try {
      final indexRef = _firestore
          .collection('chat_v2')
          .doc('rooms')
          .collection('index')
          .doc('rooms');

      await indexRef.set({
        'roomIds': FieldValue.arrayUnion([roomId]),
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error adding room to index: $e');
    }
  }

  /// Saves a chat message in the specified Firestore structure
  /// chat_v2/rooms/{roomId}/history/{messageId}
  /// Returns the generated message ID
  Future<String> saveMessage({
    required String userId,
    required String username,
    required String message,
    required String roomId,
  }) async {
    try {
      // Generate a unique message ID using timestamp and random string
      final messageId = 'msg_${DateTime.now().millisecondsSinceEpoch}_${_generateRandomString(6)}';
      
      final messageRef = _firestore
          .collection('chat_v2')
          .doc('rooms')
          .collection(roomId)
          .doc('history')
          .collection('messages')
          .doc(messageId);

      await messageRef.set({
        'userid': userId,
        'username': username,
        'message': message,
        'messageid': messageId,
        'timestamp': FieldValue.serverTimestamp(),
        'date': DateTime.now().toIso8601String(),
      });

      print('Message saved successfully with ID: $messageId');
      return messageId;
    } catch (e) {
      print('Error saving message: $e');
      rethrow;
    }
  }

  /// Decreases online user count and saves leave message
  /// Called when user navigates back from chat
  Future<void> leaveRoom(int roomId) async {
    try {
      // Get current user and their username
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('No authenticated user found');
      }
      
      // Get username from user's display name
      final username = currentUser.displayName ?? "Unknown";
      
      final roomRef = _firestore
          .collection('chat_v2')
          .doc("rooms")
          .collection(roomId.toString())
          .doc('information');

      // Decrease online user count
      await roomRef.update({
        'online_user': FieldValue.increment(-1),
      });
      
      // Save leave message
      await saveMessage(
        userId: '0',
        username: 'host',
        message: "[user@$username has left the chat]",
        roomId: roomId.toString(),
      );

      print('User left room: $roomId');
    } catch (e) {
      print('Error leaving room: $e');
      rethrow;
    }
  }

  /// Generates a random string of specified length
  String _generateRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = DateTime.now().millisecondsSinceEpoch + DateTime.now().microsecond;
    final buffer = StringBuffer();
    
    for (int i = 0; i < length; i++) {
      final randomIndex = (random + i * 31) % chars.length;
      buffer.write(chars[randomIndex]);
    }
    
    return buffer.toString();
  }
}
