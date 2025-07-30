import 'package:flutter/material.dart';
import 'package:talking/layout/app_layout.dart';
import 'package:talking/layout/cubit/cubit.dart';
import 'package:talking/screens/login/login_screen.dart';
import 'package:talking/shared/app_theme.dart';
import 'package:talking/shared/bloc_observer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:talking/shared/constraints/constaints.dart';
import 'package:talking/shared/network/local/cash_helper.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();

  runApp(
    BlocProvider(
      create: (BuildContext context) => AppCubit()..intializeData(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // remove cache helper
    // CacheHelper.removeData(key:'uId');

    uId = CacheHelper.getData(key: "uId");
    // ignore: unnecessary_null_comparison
    Widget startWidget = uId == null ? LoginScreen() : AppLayout();

    return MaterialApp(
      theme: AppTheme().light,
      darkTheme: AppTheme().dark,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: startWidget,
    );
  }
}
