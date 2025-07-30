import 'package:flutter/material.dart';
import 'package:saints_of_silence/screens/home_screen.dart';
import 'package:saints_of_silence/screens/game/game_cubit/game_cubit.dart';
import 'package:saints_of_silence/screens/game/game_cubit/game_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class GameRoom extends StatefulWidget {
  final String player1Name;
  final String player2Name;
  final String player1ID;
  final String player2ID;
  final String roomId;
  final bool isPlayer1;

  const GameRoom({
    Key? key,
    required this.player1Name,
    required this.player2Name,
    required this.player1ID,
    required this.player2ID,
    required this.roomId,
    required this.isPlayer1,
  }) : super(key: key);

  @override
  State<GameRoom> createState() => _GameRoomState();
}

class _GameRoomState extends State<GameRoom> {
  @override
  void initState() {
    super.initState();
    
    // TODO: think again
    // // Check if game room exists
    // FirebaseFirestore.instance
    //     .collection('current_games')
    //     .doc(widget.roomId)
    //     .get()
    //     .then((doc) {
    //   if (!doc.exists) {
    //     // Game room doesn't exist, return to home screen
    //     navigateTo(context, MatchmakeWaitingScreen());
    //     return;
    //   }
      
    //   // Game room exists, start checking for winner
    // });
      context.read<GameCubit>().checkForWinner(widget.roomId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GameCubit, GameStates>(
      listener: (context, state) {
        if (state is InitialState) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const HomeScreen()),
            (route) => false,
          );
        } else if (state is GameCompletedState) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              backgroundColor: const Color(0xFF1A1A1A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Colors.white24, width: 1),
              ),
              alignment: Alignment.center,
              title: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: state.winner == (widget.isPlayer1 ? widget.player1ID : widget.player2ID)
                          ? Colors.green.withOpacity(0.3)
                          : Colors.red.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  state.winner == (widget.isPlayer1 ? widget.player1ID : widget.player2ID)
                      ? 'Victory Achieved'
                      : 'Defeat',
                  style: TextStyle(
                    color: state.winner == (widget.isPlayer1 ? widget.player1ID : widget.player2ID)
                        ? Colors.green
                        : Colors.red,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              content: Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      state.winner == (widget.isPlayer1 ? widget.player1ID : widget.player2ID)
                          ? Icons.emoji_events
                          : Icons.warning_rounded,
                      size: 64,
                      color: state.winner == (widget.isPlayer1 ? widget.player1ID : widget.player2ID)
                          ? Colors.amber
                          : Colors.red,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      state.winner == widget.player1ID 
                          ? "${widget.player1Name} has Won"
                          : "${widget.player2Name} has Won",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (_) => const HomeScreen()),
                            (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.1),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: Colors.white24),
                          ),
                        ),
                        child: const Text(
                          'Return to Lobby',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(6.0),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () async {
                final shouldSurrender = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: const Color(0xFF1A1A1A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(color: Colors.white24, width: 1),
                    ),
                    title: const Text(
                      'Surrender?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: const Text(
                      'Are you sure you want to abandon your quest?',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text(
                          'Continue Battle',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.withOpacity(0.2),
                          foregroundColor: Colors.red,
                        ),
                        child: const Text('Surrender'),
                      ),
                    ],
                  ),
                );

                if (shouldSurrender == true) {
                  final opponentId = widget.isPlayer1 ? widget.player2ID : widget.player1ID;
                  await context.read<GameCubit>().surrender(widget.roomId, opponentId);
                }
              },
            ),
          ),
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/backgrounds/temple_background(6).jpeg',
                fit: BoxFit.cover,
              ),
            ),
            SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Opponent name at the top
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        widget.isPlayer1 ? widget.player2Name : widget.player1Name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // Room ID in the middle
                    Text(
                      'Room ID: ${widget.roomId}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Player's own name at the bottom
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        width: double.infinity,
                        child: Text(
                          widget.isPlayer1 ? widget.player1Name : widget.player2Name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
