import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping/layout/app_layout.dart';
import 'package:shopping/layout/cubit/app_cubit.dart';
import 'package:shopping/screens/login/login_screen.dart';
import 'package:shopping/screens/onboarding/onboarding.dart';
import 'package:shopping/shared/app_theme.dart';
import 'package:shopping/shared/bloc_observer.dart';
import 'package:shopping/shared/constraints/constants.dart';
import 'package:shopping/shared/network/local/cash_helper.dart';
import 'package:shopping/shared/network/remote/dio_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required for async init
  await CacheHelper.init();

  Bloc.observer = MyBlocObserver();
  DioHelper.init();

  CacheHelper.removeData(key: 'onBoarding');
  // CacheHelper.removeData(key: 'token');
  Widget startWidget;
  
  bool onBoarding = CacheHelper.getData(key: 'onBoarding') ?? false;
  token = CacheHelper.getData(key: 'token');


  if(onBoarding){
    if(token != null){
      startWidget = AppLayout();
    } else {
      startWidget = LoginScreen();
    }
  } else {
    startWidget = OnBoardingScreen();
  }

  runApp(
    MyApp(startWidget: startWidget,),
  );
}

class MyApp extends StatelessWidget {
  final Widget startWidget;


  const MyApp({super.key, required this.startWidget});
  

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..loadData(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.light,
          theme: AppTheme().light,
          darkTheme: AppTheme().dark,
          home: startWidget,
        ),
    );

  }
}

