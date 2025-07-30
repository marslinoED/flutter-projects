import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/shared/cubit/cubit.dart';
import 'package:news/shared/cubit/states.dart';
import 'package:news/widgets/search_screen.dart';

class NewsLayout extends StatelessWidget {
  const NewsLayout({super.key});

  @override
  Widget build(BuildContext context) {
      return BlocConsumer<NewsCubit, NewsStates>(
        listener: (BuildContext context, NewsStates state) {
        },
        builder: (BuildContext context, NewsStates state) {
          
          NewsCubit cubit = NewsCubit.get(context);

    return Scaffold(
      appBar: _buildAppBar(cubit, context),
      body: _buildBody(cubit),
      bottomNavigationBar: _buildBottomNavigationBar(cubit),
          );
        },
    );
  }
  
  _buildAppBar(cubit, context) {
    return AppBar(
      // leading: IconButton(
      //   onPressed: (){
      //     cubit.isSettingsScreen();
      //   }, 
      //   icon: Icon(Icons.settings)),
      title: const Text('News App'),
      actions: [
        IconButton(
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchScreen()), 
            );
          }, 
          icon: Icon(Icons.search)
        ),
        IconButton(
          onPressed: cubit.toggleColorMode,
          icon: Icon(cubit.isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined),
          ),
        DropdownButton<String>(
          borderRadius: BorderRadius.circular(10),
          dropdownColor: Colors.grey[700],
          iconEnabledColor: Colors.deepOrange,
          focusColor: Colors.transparent,

          value: cubit.isEn ? 'en' : 'ar',
          items: const [
            DropdownMenuItem(value: 'en', child: Text('en', style: TextStyle(color: Colors.deepOrange))),
            DropdownMenuItem(value: 'ar', child: Text('ar', style: TextStyle(color: Colors.deepOrange))),
          ],
          onChanged: (String? newValue) {
            if (newValue != null) {
              cubit.toggleLanguage(newValue);
            }
          },
        ),
      ],
    );
  }
  
  _buildBody(cubit) {
    return cubit.isSettings ? cubit.screens[3].screen :
    cubit.screens[cubit.currentIndex].screen;
      
  }
  
  _buildBottomNavigationBar(cubit) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.business),
          label: 'Business',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.sports),
          label: 'Sports',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.science),
          label: 'Science',
        ),
      ],
      onTap: (index) {
        cubit.changeBottomNav(index);
      },
      currentIndex: cubit.currentIndex,
    );
  }

}
