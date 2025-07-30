import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping/layout/cubit/app_cubit.dart';
import 'package:shopping/layout/cubit/app_states.dart';
import 'package:shopping/screens/search/search.dart';
import 'package:shopping/shared/components/components.dart';

class AppLayout extends StatelessWidget {
  const AppLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
          appBar: _buildAppBar(cubit, context),
          body: _buildBody(cubit),
          bottomNavigationBar: _buildBottomNavigationBar(cubit), 
        );
      }
    );
  }

  PreferredSizeWidget _buildAppBar(cubit, context) {
    return AppBar(
      title: Text(cubit.bottomScreens[cubit.currentIndex].title),
      actions: [
        IconButton(
          onPressed: (){
          navigateToBack(context, SearchScreen());
          }, 
        icon: Icon(Icons.search)),
      ],
    );
  }

  Widget _buildBody(AppCubit cubit) {
    return cubit.bottomScreens[cubit.currentIndex].screen;
  }
  BottomNavigationBar _buildBottomNavigationBar(AppCubit cubit) {
    return BottomNavigationBar(  
      items: [
          BottomNavigationBarItem(icon: cubit.bottomScreens[0].icon, label: cubit.bottomScreens[0].title),
          BottomNavigationBarItem(icon: cubit.bottomScreens[1].icon, label: cubit.bottomScreens[1].title),
          BottomNavigationBarItem(icon: cubit.bottomScreens[2].icon, label: cubit.bottomScreens[2].title),
          BottomNavigationBarItem(icon: cubit.bottomScreens[3].icon, label: cubit.bottomScreens[3].title),
        ],
      currentIndex: cubit.currentIndex, 
      onTap: (index){
       cubit.changeBottomNav(index);
      },
      );
  }
  
}
