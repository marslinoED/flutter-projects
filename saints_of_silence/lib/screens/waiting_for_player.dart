import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saints_of_silence/layout/cubit/cubit.dart';
import 'package:saints_of_silence/layout/cubit/states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:saints_of_silence/screens/game/game_room.dart';
import 'package:saints_of_silence/screens/home_screen.dart';
import 'package:saints_of_silence/shared/components/components.dart';
import 'dart:async';

import 'package:saints_of_silence/shared/constants.dart';
import 'package:saints_of_silence/screens/game/game_cubit/game_cubit.dart';
import 'package:saints_of_silence/screens/game/game_cubit/game_states.dart' as game_states;

class WaitingForPlayer extends StatefulWidget {
  const WaitingForPlayer({Key? key}) : super(key: key);

  @override
  State<WaitingForPlayer> createState() => _WaitingForPlayerState();
}

class _WaitingForPlayerState extends State<WaitingForPlayer> {
  String? roomId;
  late AppCubit _cubit;
  StreamSubscription<DocumentSnapshot>? _sessionSubscription;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<AppCubit>();
    _cubit.createSession().then((id) {
      setState(() {
        roomId = id;
      });
      // Start listening to session changes
      _sessionSubscription = FirebaseFirestore.instance
          .collection('waiting_sessions')
          .doc(id)
          .snapshots()
          .listen((snapshot) {
            if (snapshot.exists) {
              final data = snapshot.data() as Map<String, dynamic>;
              if (data['player2'] != 'nan') {
                // A second player has joined
                // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                _cubit.emit(
                  MatchFoundState(
                    id,
                    data['player1Name'],
                    data['player2Name'],
                    true, // isPlayer1
                    data['player1'],
                    data['player2'],
                  ),
                );
              }
            }
          });
    });
  }

  @override
  void dispose() {
    _sessionSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is MatchFoundState) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => BlocProvider<GameCubit>(
                create: (context) {
                  final gameCubit = GameCubit(game_states.InitialState());
                  gameCubit.appCubit = context.read<AppCubit>();
                  return gameCubit;
                },
                child: GameRoom(
                  player1Name: state.player1Name,
                  player2Name: state.player2Name,
                  player1ID: state.player1ID,
                  player2ID: state.player2ID,
                  roomId: state.roomId,
                  isPlayer1: state.isPlayer1,
                ),
              ),
            ),
          );
        } else if (state is DeleteSessionSuccessState) {
          navigateTo(context, const HomeScreen());
        } else if (state is CreateSessionErrorState) {
          errorMessage(
            context,
            'Failed to create game session. Please try again.',
            false,
          );
          navigateTo(context, const HomeScreen());
        }
      },
      child: BlocBuilder<AppCubit, AppStates>(
        builder: (context, state) {
          if (state is CreateSessionLoadingState) {
            return const Scaffold(
              backgroundColor: Color(0xFF2C2C2C),
              body: Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            );
          }

          return Scaffold(
            backgroundColor: const Color(0xFF2C2C2C), // Dark grey background
            appBar: AppBar(
              backgroundColor: const Color(0xFF2C2C2C),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => _cubit.deleteSession(roomId!),
              ),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    constraints: const BoxConstraints(maxWidth: 300),
                    child: Text(
                      globalUser?.name ?? "username",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Room ID: ${roomId ?? "Loading..."}',
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Waiting for Player 2...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
