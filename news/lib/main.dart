import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/layout/news_layout.dart';
import 'package:news/shared/cubit/bloc_observer.dart';
import 'package:news/shared/cubit/cubit.dart';
import 'package:news/shared/cubit/states.dart';
import 'package:news/shared/network/local/cache_helper.dart';
import 'package:news/shared/network/remote/dio_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required for async init
  await CacheHelper.init();
  
  Bloc.observer = MyBlocObserver();
  DioHelper.init();

 
  runApp(
    BlocProvider(
      create: (BuildContext context) => NewsCubit()..getData(NewsCubit().currentIndex == 0 ? 'business' : NewsCubit().currentIndex == 1 ? 'sports' : 'science'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    MaterialColor lightFirstColor = Colors.deepOrange;
    MaterialColor darkFirstColor = Colors.deepOrange;
    
    return BlocConsumer<NewsCubit, NewsStates>(
        listener: (context, State){},
        builder: (context, State){
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: NewsCubit.get(context).isDark ? ThemeMode.dark : ThemeMode.light,
            theme: ThemeData(
              progressIndicatorTheme: ProgressIndicatorThemeData(
                color: Colors.deepOrange,
                // circularTrackColor: Colors.deepOrange,
              ),
              primarySwatch: lightFirstColor,
              scaffoldBackgroundColor: Colors.white,
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                backgroundColor: Colors.white,
                selectedItemColor: lightFirstColor,
                elevation: 20.0,
              ),
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.white,
                elevation: 2.0,
                iconTheme: IconThemeData(
                  color: Colors.black
                )
              ),

            ),
            darkTheme: ThemeData(
              progressIndicatorTheme: ProgressIndicatorThemeData(
                color: Colors.deepOrange,
                // circularTrackColor: Colors.grey,
              ),
              primarySwatch: darkFirstColor,
              scaffoldBackgroundColor: Colors.grey[900],
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                backgroundColor: Colors.grey[900],
                selectedItemColor: darkFirstColor,
                unselectedItemColor: Colors.grey[300],
                elevation: 20.0,
              ),
              appBarTheme: AppBarTheme(
                titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold
                ),
                backgroundColor: Colors.grey[900],
                elevation: 0.0,
                iconTheme: IconThemeData(
                  color: Colors.white
                )
              ),
              
              textTheme: TextTheme(
              bodyMedium: TextStyle( // bodyMedium replaces bodyText1
                color: Colors.white,
                fontSize: 16.0, // Set explicitly if needed
                // fontWeight: FontWeight.w600,
              ),
            ),
              iconTheme: IconThemeData(
                color: darkFirstColor,
              ),  
            ),
            home: NewsLayout(), 
          );
        },
    );
  }
}
