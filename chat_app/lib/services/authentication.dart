import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream of auth changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Sign in anonymously and save user data to Firestore
  Future<UserCredential?> signInAnonymously({required String username}) async {
    try {
      // Sign in anonymously
      UserCredential userCredential = await _auth.signInAnonymously();
      
      // Get the user
      User? user = userCredential.user;
      
      if (user != null) {
        // Update the user's display name to store the username
        await user.updateDisplayName(username);
        
        // Create user document in Firestore
        await _saveUserToFirestore(user, username);
      }
      
      return userCredential;
    } catch (e) {
      print('Error signing in anonymously: $e');
      return null;
    }
  }

  /// Save user data to Firestore collection 'chat_v2/users'
  Future<void> _saveUserToFirestore(User user, String username) async {
    try {
      // Create user data map
      Map<String, dynamic> userData = {
        'username': username, // Use the provided username
        'userid': user.uid,
        'created_at': FieldValue.serverTimestamp(), // Use server timestamp for consistency
      };

      // Save to Firestore
      await _firestore
          .collection('chat_v2')
          .doc('users')
          .collection('users')
          .doc(user.uid)
          .set(userData);

      print('User data saved to Firestore successfully');
    } catch (e) {
      print('Error saving user data to Firestore: $e');
      rethrow;
    }
  }

  /// Sign out the current user
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  /// Get user data from Firestore
  Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('chat_v2')
          .doc('users')
          .collection('users')
          .doc(userId)
          .get();

      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  /// Update user data in Firestore
  Future<void> updateUserData(String userId, Map<String, dynamic> data) async {
    try {
      await _firestore
          .collection('chat_v2')
          .doc('users')
          .collection('users')
          .doc(userId)
          .update(data);
    } catch (e) {
      print('Error updating user data: $e');
      rethrow;
    }
  }
}
