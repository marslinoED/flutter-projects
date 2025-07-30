// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui';
import 'package:saints_of_silence/screens/join_session.dart';
import 'package:saints_of_silence/screens/matchmake_waiting.dart';
import 'package:saints_of_silence/screens/settings.dart';
import 'package:saints_of_silence/screens/waiting_for_player.dart';
import 'package:saints_of_silence/shared/components/components.dart';
import 'package:saints_of_silence/shared/components/pixel_button.dart';
import 'package:saints_of_silence/shared/components/custom_icon_button.dart';
import 'package:saints_of_silence/layout/cubit/cubit.dart';
import 'package:saints_of_silence/layout/cubit/states.dart';
import 'package:flutter/rendering.dart';
import 'package:saints_of_silence/shared/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch leaderboard when entering the app
    context.read<AppCubit>().fetchLeaderboard();
    context.read<AppCubit>().refreshUser();

  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomIconButton(
            icon: 'assets/icons/setting_icon.png',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          CustomIconButton(
            icon: 'assets/icons/shop_icon.png',
            onPressed: () {
              // TODO: Navigate to shop
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMainButtons(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Match Make Button and Online players counter in a row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Match Make Button - Main action
              PixelButton(
                text: 'Match Make',
                icon: Icons.search,
                onPressed: () {
                  navigateTo(context, MatchmakeWaitingScreen());
                },
              ),
              const SizedBox(width: 16),
              // Online players counter
              BlocBuilder<AppCubit, AppStates>(
                builder: (context, state) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.people, color: Colors.white.withOpacity(0.7), size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${globalOnlineUsers} available',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Bottom row with Create and Join buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Create Session Button
              PixelButton(
                text: 'Create Session',
                icon: Icons.add_circle_outline,
                onPressed: () {
                  navigateToBack(context, WaitingForPlayer());
                },
              ),
              const SizedBox(width: 16),
              // Join Session Button
              PixelButton(
                text: 'Join Session',
                icon: Icons.login,
                onPressed: () {
                  navigateToBack(context, JoinSession());
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboard() {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        final cubit = context.read<AppCubit>();
        final leaderboard = globalLeaderboard;

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 18),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                offset: const Offset(4, 4),
                blurRadius: 0,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'Leaderboard',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 24),
                // Table Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Rank',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Name',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Wins',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Column(
                  children: [
                    _buildLeaderboardLine(
                      icon: Icons.emoji_events,
                      color: Colors.amber[400]!,
                      place: 1,
                      name:
                          leaderboard.isNotEmpty
                              ? leaderboard[0].name
                              : 'No data',
                      wins: leaderboard.isNotEmpty ? leaderboard[0].wins : 0,
                    ),
                    const SizedBox(height: 12),
                    _buildLeaderboardLine(
                      icon: Icons.emoji_events,
                      color: Colors.grey[400]!,
                      place: 2,
                      name:
                          leaderboard.length > 1
                              ? leaderboard[1].name
                              : 'No data',
                      wins: leaderboard.length > 1 ? leaderboard[1].wins : 0,
                    ),
                    const SizedBox(height: 12),
                    _buildLeaderboardLine(
                      icon: Icons.emoji_events,
                      color: Colors.brown[400]!,
                      place: 3,
                      name:
                          leaderboard.length > 2
                              ? leaderboard[2].name
                              : 'No data',
                      wins: leaderboard.length > 2 ? leaderboard[2].wins : 0,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  Widget _buildLeaderboardLine({
    required IconData icon,
    required Color color,
    required int place,
    required String name,
    required int wins,
  }) {
    final currentUser = globalUser;
    final isCurrentUser = currentUser != null && currentUser.name == name;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Text(
                  '#$place',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    _truncateText(name, 12),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(color: color, fontSize: 18),
                  ),
                ),
                if (isCurrentUser) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green),
                    ),
                    child: const Text(
                      'You',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '$wins',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/backgrounds/temple_background(1).jpeg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              _buildTopBar(context),
              const Spacer(),
              _buildMainButtons(context),
              _buildLeaderboard(),
            ],
          ),
        ),
      ),
    );
  }
}
