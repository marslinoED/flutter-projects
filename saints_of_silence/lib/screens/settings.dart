import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saints_of_silence/shared/network/local/cash_helper.dart';
import '../layout/cubit/cubit.dart';
import '../layout/cubit/states.dart';
import 'auth.dart';
import '../shared/constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    // Refresh user data when entering the screen
    context.read<AppCubit>().refreshUser();
    context.read<AppCubit>().fetchLeaderboard();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    String? selectedAvatarId;
    
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is InitialState) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const AuthScreen(),
            ),
            (route) => false,
          );
        }
      },
      builder: (context, state) {
        final user = globalUser;
        final uid = CacheHelper.getUID();
        if (user == null || uid == null) {
          return const Scaffold(
            body: Center(
              child: Text('User data not available', style: TextStyle(color: Colors.white)),
            ),
          );
        }
        
        return Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: const Color(0xFF1E1E1E), // Dark gray background
          body: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/backgrounds/temple_background(2).jpeg',
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                color: Colors.black.withOpacity(0.7), // Optional: dark overlay for readability
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 45,
                            backgroundColor: Colors.grey[800],
                            child: Text(
                              user.avatarID,
                              style: const TextStyle(
                                fontSize: 32,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 24),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 270,
                                child: Text(
                                  user.name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'ID: $uid',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[400],
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextButton.icon(
                                onPressed: () {
                                  nameController.text = user.name;
                                  selectedAvatarId = user.avatarID;
                                  showDialog(
                                    context: context,
                                    builder: (context) => StatefulBuilder(
                                      builder: (context, setState) => AlertDialog(
                                        backgroundColor: const Color(0xFF2D2D2D),
                                        title: const Text(
                                          'Change Profile',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextField(
                                              controller: nameController,
                                              style: const TextStyle(color: Colors.white),
                                              decoration: InputDecoration(
                                                hintText: 'Enter new name',
                                                hintStyle: TextStyle(color: Colors.grey[400]),
                                                enabledBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.grey[600]!),
                                                ),
                                                focusedBorder: const UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.white),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 24),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: List.generate(
                                                4,
                                                (index) => Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        selectedAvatarId = (index + 1).toString();
                                                      });
                                                    },
                                                    child: Stack(
                                                      children: [
                                                        CircleAvatar(
                                                          radius: 30,
                                                          backgroundColor: Colors.grey[800],
                                                          child: Text(
                                                            '${index + 1}',
                                                            style: const TextStyle(
                                                              fontSize: 24,
                                                              color: Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                        if (selectedAvatarId == (index + 1).toString())
                                                          Positioned(
                                                            right: 0,
                                                            bottom: 0,
                                                            child: Container(
                                                              padding: const EdgeInsets.all(4),
                                                              decoration: BoxDecoration(
                                                                color: Colors.green,
                                                                borderRadius: BorderRadius.circular(12),
                                                              ),
                                                              child: const Icon(
                                                                Icons.check,
                                                                color: Colors.white,
                                                                size: 20,
                                                              ),
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: const Text(
                                              'Cancel',
                                              style: TextStyle(color: Colors.grey),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              final newName = nameController.text.trim();
                                              if (newName.isNotEmpty && selectedAvatarId != null) {
                                                await context.read<AppCubit>().updateUserName(newName);
                                                await context.read<AppCubit>().updateUserAvatar(selectedAvatarId!);
                                                await context.read<AppCubit>().refreshUser();
                                                await context.read<AppCubit>().fetchLeaderboard();
                                                if (context.mounted) {
                                                  Navigator.pop(context);
                                                }
                                              }
                                            },
                                            child: const Text(
                                              'Change',
                                              style: TextStyle(color: Colors.blue),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                                label: const Text(
                                  'Change Profile and Avatar',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'Stats:',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Games: ${user.totalGames}',
                        style: const TextStyle(
                          fontSize: 22,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Wins: ${user.wins}',
                        style: const TextStyle(
                          fontSize: 22,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Win Streak: ${user.bestStreak}',
                        style: const TextStyle(
                          fontSize: 22,
                          color: Colors.white70,
                        ),
                      ),
                      const Spacer(), // Add this to push the button to the bottom
                      Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton.icon(
                          onPressed: () {
                            context.read<AppCubit>().logout();
                          },
                          icon: const Icon(Icons.logout, color: Colors.red),
                          label: const Text(
                            'Logout',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          appBar: AppBar(
            backgroundColor: Colors.transparent, 
            elevation: 0.5, // Slightly lighter dark gray
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Settings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Icon(Icons.monetization_on, color: Colors.amber, size: 28),
                    const SizedBox(width: 8),
                    Text(
                      '${user.coins}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
