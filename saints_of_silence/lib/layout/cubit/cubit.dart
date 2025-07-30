// ignore_for_file: avoid_print

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'dart:math';
import '../../models/user_model.dart';
import '../../shared/network/local/cash_helper.dart';
import 'states.dart';
import '../../shared/constants.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialState());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> fetchLeaderboard() async {
    try {
      emit(CreateUserLoadingState());

      // Fetch leaderboard
      final QuerySnapshot leaderboardSnapshot =
          await _firestore
              .collection('users')
              .orderBy('wins', descending: true)
              .limit(3)
              .get();

      globalLeaderboard =
          leaderboardSnapshot.docs
              .map(
                (doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>),
              )
              .toList();

      // Count waiting users
      final QuerySnapshot waitingListSnapshot = 
          await _firestore
              .collection('waiting_list')
              .get();
      
      // Count current game users
      final QuerySnapshot currentGameSnapshot = 
          await _firestore
              .collection('current_games')
              .get();
      
      globalOnlineUsers = currentGameSnapshot.docs.length + waitingListSnapshot.docs.length;

      emit(LeaderboardLoadedState(globalLeaderboard));
    } catch (e) {
      print('Leaderboard Error: $e');
      emit(
        CreateUserErrorState('Failed to fetch leaderboard: ${e.toString()}'),
      );
    }
  }

  Future<void> _saveUserToFirestore(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).set(user.toJson());
    } on FirebaseException catch (e) {
      print('Firestore Error: ${e.code} - ${e.message}');
      if (e.code == 'unavailable') {
        throw Exception(
          'No internet connection. Please check your connection and try again.',
        );
      }
      throw Exception('Failed to save user data: ${e.message}');
    } catch (e) {
      print('Unexpected Error in _saveUserToFirestore: $e');
      throw Exception('Failed to save user data: $e');
    }
  }

  Future<void> signInAnonymously() async {
    try {
      emit(CreateUserLoadingState());
      print('Starting anonymous sign in...');

      final UserCredential userCredential = await _auth.signInAnonymously();
      print('Anonymous sign in successful. UID: ${userCredential.user?.uid}');

      final String userId = userCredential.user!.uid;
      print('Creating user model with ID: $userId');

      // Save UID to shared preferences
      await CacheHelper.saveUID(userId);

      globalUser = UserModel(
        id: userId,
        name: userId,
        avatarID: '1',
        coins: 0,
        totalGames: 0,
        wins: 0,
        bestStreak: 0,
        lastLogin: DateTime.now(),
        lastGameState: false,
        anonymous: true,
        tempStreak: 0,
      );
      print('User object created in cubit: ${globalUser?.id}');
      print('Saving new user to Firestore...');
      await _saveUserToFirestore(globalUser!);
      print('New user saved successfully to Firestore');
      print('Emitting success state with user: ${globalUser?.id}');
      emit(CreateUserSuccessState(globalUser!));
    } on FirebaseAuthException catch (e) {
      print('Auth Error: ${e.code} - ${e.message}');
      emit(CreateUserErrorState('Authentication failed: ${e.message}'));
    } on FirebaseException catch (e) {
      print('Firestore Error: ${e.code} - ${e.message}');
      emit(CreateUserErrorState('Firestore error: ${e.message}'));
    } catch (e) {
      print('Unexpected Error: $e');
      emit(
        CreateUserErrorState('An unexpected error occurred: ${e.toString()}'),
      );
    }
  }

  Future<void> logout() async {
    try {
      // Get the current user before signing out
      final currentUser = _auth.currentUser;
      if (currentUser != null && currentUser.isAnonymous == true) {
        // Delete the user document from Firestore
        await _firestore.collection('users').doc(currentUser.uid).delete();
        print('User document deleted from Firestore');

        // Delete the anonymous user account
        await currentUser.delete();
        print('Anonymous user account deleted');
      }

      await _auth.signOut();
      await CacheHelper.removeUID();
      globalUser = null;
      emit(InitialState());
    } catch (e) {
      print('Logout Error: $e');
      emit(CreateUserErrorState('Failed to logout: ${e.toString()}'));
    }
  }

  Future<void> refreshUser() async {
    if (globalUser == null) return;
    final userDoc = await _firestore.collection('users').doc(globalUser!.id).get();
    if (userDoc.exists) {
      globalUser = UserModel.fromJson(userDoc.data()!);
      emit(CreateUserSuccessState(globalUser!));
    }
  }

  Future<void> updateUserName(String newName) async {
    try {
      if (globalUser == null) return;

      // Update in Firestore
      await _firestore.collection('users').doc(globalUser!.id).update({
        'name': newName,
      });

      // Update local user model
      globalUser = globalUser!.copyWith(name: newName);
      emit(CreateUserSuccessState(globalUser!));
    } catch (e) {
      print('Update Name Error: $e');
      emit(CreateUserErrorState('Failed to update name: ${e.toString()}'));
    }
  }

  Future<void> updateUserAvatar(String avatarId) async {
    try {
      if (globalUser == null) return;

      // Update in Firestore
      await _firestore.collection('users').doc(globalUser!.id).update({
        'avatarID': avatarId,
      });

      // Update local user model
      globalUser = globalUser!.copyWith(avatarID: avatarId);
      emit(CreateUserSuccessState(globalUser!));
    } catch (e) {
      print('Update Avatar Error: $e');
      emit(CreateUserErrorState('Failed to update avatar: ${e.toString()}'));
    }
  }

  String _generateRoomId() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return List.generate(
      6,
      (index) => chars[random.nextInt(chars.length)],
    ).join();
  }

  Future<String> createSession() async {
    try {
      emit(CreateSessionLoadingState());
      if (globalUser == null) {
        throw Exception('User not logged in');
      }

      // Generate room ID
      final roomId = _generateRoomId();

      // Create session in waiting_sessions collection
      await _firestore.collection('waiting_sessions').doc(roomId).set({
        'player1': globalUser!.id,
        'player1Name': globalUser!.name,
        'player2': 'nan',
        'player2Name': 'nan',
        'roomId': roomId,
        'timestamp': FieldValue.serverTimestamp(),
      });

      emit(CreateSessionSuccessState(roomId));
      return roomId;
    } catch (e) {
      print('Create Session Error: $e');
      emit(
        CreateSessionErrorState('Failed to create session: ${e.toString()}'),
      );
      rethrow;
    }
  }

  Future<void> joinSession(String roomId) async {
    try {
      if (globalUser == null) {
        throw Exception('User not logged in');
      }

      // Check if session exists
      final sessionDoc =
          await _firestore.collection('waiting_sessions').doc(roomId).get();

      if (!sessionDoc.exists) {
        throw Exception('Session not found');
      }

      final sessionData = sessionDoc.data()!;

      // Check if session is already full
      if (sessionData['player2'] != 'nan') {
        throw Exception('Session is already full');
      }

      // Update session with player 2
      await _firestore.collection('waiting_sessions').doc(roomId).update({
        'player2': globalUser!.id,
        'player2Name': globalUser!.name,
      });

      // Emit state to navigate to game room
      emit(
        MatchFoundState(
          roomId,
          sessionData['player1Name'],
          globalUser!.name,
          false, // isPlayer1
          sessionData['player1'],
          globalUser!.id,
        ),
      );

      deleteSession(roomId);
      createGameDocument(roomId, sessionData['player1'], globalUser!.id);
    } catch (e) {
      print('Join Session Error: $e');
      emit(CreateUserErrorState('Failed to join session: ${e.toString()}'));
      rethrow;
    }
  }

  Future<void> deleteSession(String roomId) async {
    try {
      emit(DeleteSessionLoadingState());

      // Delete the session document from waiting_sessions collection
      await _firestore.collection('waiting_sessions').doc(roomId).delete();

      emit(DeleteSessionSuccessState(roomId));
    } catch (e) {
      print('Delete Session Error: $e');
      emit(
        DeleteSessionErrorState('Failed to delete session: ${e.toString()}'),
      );
      rethrow;
    }
  }

  Future<void> createGameDocument(
    String roomId,
    String player1,
    String player2,
  ) async {
    try {
      emit(CreateGameDocumentLoadingState());

      // Create game document in current_game collection
      await _firestore.collection('current_games').doc(roomId).set({
        'player1': player1,
        'player2': player2,
        'createdAt': FieldValue.serverTimestamp(),
        'winner': 'nan',
      });

      emit(CreateGameDocumentSuccessState(roomId));
    } catch (e) {
      print('Create Game Document Error: $e');
      emit(
        CreateGameDocumentErrorState(
          'Failed to create game document: ${e.toString()}',
        ),
      );
      rethrow;
    }
  }

  Future<void> startMatchmaking(String currentUserId) async {
    emit(MatchmakingLoadingState());

    final firestore = FirebaseFirestore.instance;
    final waitingList = firestore.collection('waiting_list');
    final currentGames = firestore.collection('current_games');

    try {
      final snapshot =
          await waitingList
              .where('match_token', isEqualTo: null)
              .orderBy('joinedAt')
              .limit(1)
              .get();

      if (snapshot.docs.isNotEmpty) {
        final opponentDoc = snapshot.docs.first;
        final opponentRef = opponentDoc.reference;

        // Step 1: Use transaction to claim opponent safely
        await firestore.runTransaction((transaction) async {
          final freshSnapshot = await transaction.get(opponentRef);

          // Make sure no one else claimed him already
          if (freshSnapshot['match_token'] == null) {
            // Lock it for myself
            transaction.update(opponentRef, {'match_token': currentUserId});

            // Create game room
            final roomData = {
              'player1': opponentDoc.id,
              'player2': currentUserId,
              'createdAt': FieldValue.serverTimestamp(),
              'winner': 'nan',
            };

            final roomId = _generateRoomId();
            final newRoomRef = currentGames.doc(roomId);
            transaction.set(newRoomRef, roomData);

            // update opponent from waiting list
            transaction.update(opponentRef, {
              'opponentName': globalUser!.name,
              'roomId': roomId,
            });

            // Emit success outside the transaction
            emit(
              MatchmakingSuccessState({
                'roomId': newRoomRef.id,
                'player1': opponentDoc.id,
                'player2': currentUserId,
                'player1Name': opponentDoc.data()['username'],
                'player2Name': globalUser!.name,
                'isPlayer1': false,
              }),
            );
          } else {
            // Already claimed by someone else
            emit(MatchmakingWaitingState());
          }
        });
      } else {
        // No one available — Add myself to waiting list
        final myRef = waitingList.doc(currentUserId);

        await myRef.set({
          'userID': currentUserId,
          'username': globalUser?.name,
          'joinedAt': FieldValue.serverTimestamp(),
          'match_token': null,
          'opponentName': null,
          'roomId': null,
        });
        emit(MatchmakingWaitingState());
        // Listen for changes to my own doc
        myRef.snapshots().listen((snapshot) async {
          if (snapshot.exists) {
            final data = snapshot.data()!;
            final matchToken = data['match_token'];

            if (matchToken != null) {
              // Someone matched with me! Find the game room

                emit(
                  MatchmakingSuccessState({
                    'roomId': data['roomId'],
                    'player1': matchToken,
                    'player2': currentUserId,
                    'player1Name': data['opponentName'],
                    'player2Name': globalUser?.name,
                    'isPlayer1': false,
                  }),
                );
              
            }
          }
        });
      }
    } catch (e) {
      emit(MatchmakingErrorState(e.toString()));
    }
  }

  Future<void> cancelMatchmaking() async {
    emit(MatchmakingCancelledLoadingState());
    final waitingList = FirebaseFirestore.instance.collection('waiting_list');

    try {
      final userDoc = await waitingList.doc(globalUser!.id).get();

      if (userDoc.exists) {
        await waitingList.doc(globalUser!.id).delete();
        emit(MatchmakingCancelledSuccessState());
      }
    } catch (e) {
      emit(
        MatchmakingCancelledErrorState(
          "Failed to cancel matchmaking: ${e.toString()}",
        ),
      );
    }
  }
}
