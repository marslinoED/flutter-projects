// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saints_of_silence/layout/app.dart';
import 'package:saints_of_silence/screens/auth.dart';
import 'package:saints_of_silence/screens/home_screen.dart';
import 'package:saints_of_silence/shared/components/components.dart';
import 'package:saints_of_silence/shared/constants.dart';
import 'package:saints_of_silence/shared/network/local/cash_helper.dart';
import 'package:saints_of_silence/models/user_model.dart';
import 'package:saints_of_silence/layout/cubit/cubit.dart';
// import 'package:saints_of_silence/temp.dart';
import 'firebase_options.dart';

Future<void> initializeFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Initialize Firestore with retry logic
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      sslEnabled: true,
    );

    // Test the connection
    await FirebaseFirestore.instance.collection('test').doc('test').get();
  } catch (e) {
    print('Firebase initialization error: $e');
    rethrow;
  }
}

Future<UserModel?> getUserData(String uid) async {
  try {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromJson(doc.data()!);
    }
    return null;
  } catch (e) {
    print('Error fetching user data: $e');
    return null;
  }
}

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await CacheHelper.init();
    await initializeFirebase();

    final uid = CacheHelper.getUID();
    UserModel? user;

    if (uid != null) {
      user = await getUserData(uid);
    }

    runApp(
      wrapApp(
        BlocProvider(
          create: (context) {
            final cubit = AppCubit();
            if (user != null) {
              globalUser = user;
            }
            return cubit;
          },
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              scaffoldBackgroundColor: Color(0xFF2B2B2B),
              primaryColor: Colors.blue[900],
              brightness: Brightness.dark,
            ),
            home: user != null ? const HomeScreen() : const AuthScreen(),
          ),
        ),
      ),
    );
  } catch (e) {
    print('Failed to initialize app: $e');

    runApp(
      wrapApp(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Colors.blue[900],
            brightness: Brightness.dark,
          ),
          home: Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Check your internet connection',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  const Icon(
                    Icons.wifi_off,
                    size: 48,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue[900],
        brightness: Brightness.dark,
      ),
      home: const App(),
    );
  }
}
