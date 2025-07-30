import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:todo/shared/cubit/bloc_observer.dart';
import 'dart:io'; // لاستعمال Platform لمعرفة نظام التشغيل
import 'layout/home_screen.dart';

void main() async {

  Bloc.observer = MyBlocObserver();


  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة قاعدة البيانات لـ Windows أو Linux
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit(); // تهيئة مكتبة FFI  
    databaseFactory = databaseFactoryFfi; // تعيين قاعدة البيانات
  }

  runApp(MyApp());
}
@override
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
       );
  }
}