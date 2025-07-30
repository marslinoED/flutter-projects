import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saints_of_silence/screens/home_screen.dart';
import 'package:saints_of_silence/screens/game/game_room.dart';
import 'package:saints_of_silence/shared/components/components.dart';
import 'package:saints_of_silence/layout/cubit/cubit.dart';
import 'package:saints_of_silence/layout/cubit/states.dart';
import 'package:saints_of_silence/shared/constants.dart';
import 'package:saints_of_silence/screens/game/game_cubit/game_cubit.dart';
import 'package:saints_of_silence/screens/game/game_cubit/game_states.dart' as game_states;

class MatchmakeWaitingScreen extends StatefulWidget {
  const MatchmakeWaitingScreen({super.key});

  @override
  State<MatchmakeWaitingScreen> createState() => _MatchmakeWaitingScreenState();
}

class _MatchmakeWaitingScreenState extends State<MatchmakeWaitingScreen> {
  late final AppCubit _appCubit;

  @override
  void initState() {
    super.initState();
    _appCubit = context.read<AppCubit>();
    if (globalUser != null) {
      _appCubit.startMatchmaking(globalUser!.id);
    }
  }

  @override
  void dispose() {
    _appCubit.cancelMatchmaking();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is MatchmakingSuccessState) {
          // Navigate to game room when matchmaking is successful
          navigateTo(
            context,
            BlocProvider<GameCubit>(
              create: (context) {
                final gameCubit = GameCubit(game_states.InitialState());
                gameCubit.appCubit = context.read<AppCubit>();
                return gameCubit;
              },
              child: GameRoom(
                player1Name: state.roomData['player1Name'],
                player2Name: state.roomData['player2Name'],
                player1ID: state.roomData['player1'],
                player2ID: state.roomData['player2'],
                roomId: state.roomData['roomId'],
                isPlayer1: state.roomData['player1'] == globalUser!.id,
              ),
            ),
          );
        } else if (state is MatchmakingCancelledSuccessState) {
          // Navigate to home screen when matchmaking is cancelled
          navigateTo(context, const HomeScreen());
        } else if (state is CreateUserErrorState) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFF2C2C2C), // Dark grey background
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                const SizedBox(height: 24),
                const Text(
                  'WAITING',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 48),
                ElevatedButton(
                  onPressed: () {
                    _appCubit.cancelMatchmaking();
                    navigateTo(context, const HomeScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                  child: const Text(
                    'CANCEL',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
