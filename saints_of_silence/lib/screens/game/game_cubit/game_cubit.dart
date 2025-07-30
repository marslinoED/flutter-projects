import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saints_of_silence/screens/game/game_cubit/game_states.dart';
import 'package:saints_of_silence/layout/cubit/cubit.dart';
import 'package:saints_of_silence/shared/constants.dart';

class GameCubit extends Cubit<GameStates> {
  late AppCubit appCubit;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  StreamSubscription<DocumentSnapshot>? _winnerSubscription;
  bool _isClosed = false;

  GameCubit(super.initialState);

  @override
  Future<void> close() {
    _isClosed = true;
    _winnerSubscription?.cancel();
    return super.close();
  }

  void _safeEmit(GameStates state) {
    if (!_isClosed) emit(state);
  }

  void checkForWinner(String roomId) {
    _winnerSubscription?.cancel();
    _safeEmit(CheckWinnerLoadingState());
    _winnerSubscription = _firestore
        .collection('current_games')
        .doc(roomId)
        .snapshots()
        .listen((doc) async {
      if (!doc.exists) {
        _safeEmit(CheckWinnerErrorState('Game not found'));
        return;
      }
      final gameData = doc.data()!;
      if (gameData['winner'] != null && gameData['winner'] != 'nan') {
        // Move to history_games collection
        gameData['endTime'] = FieldValue.serverTimestamp();
        await _firestore.collection('history_games').doc(roomId).set(gameData);
        await _firestore.collection('current_games').doc(roomId).delete();
        _safeEmit(GameCompletedState(gameData['winner']));
      } else {
        _safeEmit(GameStatusUpdateState(gameData));
      }
    }, onError: (e) {
      _safeEmit(CheckWinnerErrorState('Failed to check game status: [31m${e.toString()}[0m'));
    });
  }

  Future<void> surrender(String roomId, String opponentId) async {
    try {
      emit(SurrendingLoadingState());

      // Update the game document to set the winner
      await _firestore.collection('current_games').doc(roomId).update({
        'winner': opponentId,
      });

      // Get current user data
      final opponentDoc =
          await _firestore.collection('users').doc(opponentId).get();
      final currentData = opponentDoc.data()!;
      final currentTempStreak =
          (currentData['tempStreak'] as int? ?? 0) +
          1; // Add 1 for the current win
      final currentBestStreak = currentData['bestStreak'] as int? ?? 0;
      final newBestStreak =
          currentTempStreak > currentBestStreak
              ? currentTempStreak
              : currentBestStreak;

      // Update the opponent's stats
      await _firestore.collection('users').doc(opponentId).update({
        'coins': FieldValue.increment(10),
        'wins': FieldValue.increment(1),
        'totalGames': FieldValue.increment(1),
        'tempStreak': FieldValue.increment(1),
        'lastGameState': true,
        'bestStreak': newBestStreak,
      });

      await _firestore.collection('users').doc(globalUser!.id).update({
        'coins': FieldValue.increment(2),
        'totalGames': FieldValue.increment(1),
        'tempStreak': 0,
        'lastGameState': false,
      });

      // await appCubit.refreshUser();
      // await appCubit.fetchLeaderboard();

      emit(SurrendingSuccessState());
    } catch (e) {
      print('Surrender Error: $e');
      emit(
        SurrendingErrorState('Failed to process surrender: ${e.toString()}'),
      );
    }
  }
}
