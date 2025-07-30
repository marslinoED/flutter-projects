import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talking/layout/cubit/cubit.dart';
import 'package:talking/layout/cubit/states.dart';
import 'package:talking/screens/new_post/new_post_screen.dart';
import 'package:talking/screens/verify_profile/verify_profile.dart';
import 'package:talking/shared/app_theme.dart';
import 'package:talking/shared/components/components.dart';

class AppLayout extends StatelessWidget {
  const AppLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AppInitialState) {
          AppCubit.get(context).intializeData();
        }
        if (state is AppNewPostState) {
          if (AppCubit.get(context).userModel?.isEmailVerified == false) {
            navigateToBack(context, VerifyProfileScreen());
          } else {
            navigateToBack(context, NewPostScreen());
          }
        } else if (state is AppChangeBottomNavState) {
          if (state.index == 4) {
            AppCubit.get(context).getUserData();
          }
        }
      },
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
          appBar: _buildAppBar(cubit),
          body: _buildBody(cubit, context),
          bottomNavigationBar: _buildBottomNavBar(cubit),
        );
      },
    );
  }

  AppBar _buildAppBar(AppCubit cubit) {
    return AppBar(
      title: Text(cubit.screensData[cubit.currentIndex].title),
      actions: [
        IconButton(
          icon: Icon(Icons.notifications),
          onPressed: () {
            // print("DebugWord  ${cubit.userChats!.chats['tuyehtTpLXRgkjVgdXgzuiGUxFM2']!.messages[0].text}");
            // print("DebugWord  ${cubit.userChats!.chats.keys}");
            // print("DebugWord  ${cubit.userChats!.uId}");

            // cubit.notifications(context);
          },
        ),
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            // cubit.search(context);
          },
        ),
      ],
    );
  }

  Widget _buildBody(cubit, context) {
    return Column(
      children: [
        _buildWarning(cubit, context),
        cubit.screensData[cubit.currentIndex].screen,
      ],
    );
  }

  Widget _buildWarning(cubit, context) {
    // print(cubit.userModel);
    return cubit.userModel?.isEmailVerified == false
        ? Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.4),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.info_outline, color: Colors.black, size: 25),
                SizedBox(width: 5),
                Text(
                  'Please Verify Your Account',
                  style: AppTheme().bodyMedium,
                ),
                TextButton(
                  onPressed: () {
                    navigateToBack(context, VerifyProfileScreen());
                  },
                  child: Text(
                    "click here",
                    style: AppTheme().bodyMedium.copyWith(
                      color: AppTheme().primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
        : SizedBox();
  }

  Widget _buildBottomNavBar(AppCubit cubit) {
    return BottomNavigationBar(
      currentIndex: cubit.currentIndex,
      onTap: (index) {
        cubit.changeIndex(index);
      },
      items:
          cubit.screensData
              .map((e) => BottomNavigationBarItem(icon: e.icon, label: e.title))
              .toList(),
    );
  }
}
