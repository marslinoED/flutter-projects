import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping/layout/cubit/app_cubit.dart';
import 'package:shopping/layout/cubit/app_states.dart';
import 'package:shopping/screens/onboarding/onboarding.dart';
import 'package:shopping/screens/update/update.dart';
import 'package:shopping/shared/app_theme.dart';
import 'package:shopping/shared/components/components.dart';
import 'package:shopping/shared/network/local/cash_helper.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: state is AppLoadingUpdateUserState ?
                Center(child: CircularProgressIndicator()) :
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipOval(
                      child: Image(
                        image: NetworkImage("https://static.vecteezy.com/system/resources/thumbnails/024/983/914/small/simple-user-default-icon-free-png.png"),
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(cubit.userModel?.data!.name ?? 'No Name', style: TextStyle(fontSize: 20, color: AppTheme().secondaryColor, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Text(cubit.userModel?.data!.email ?? 'No Email', style: TextStyle(fontSize: 15, )),
                    SizedBox(height: 10),
                    Text(cubit.userModel?.data!.phone ?? 'No Phone Number', style: TextStyle(fontSize: 15, )),
                    SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          navigateToBack(context, UpdateScreen());
                        },
                        child: Container(
                          width: double.infinity,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppTheme().secondaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.edit, color: AppTheme().primaryColor,),
                              SizedBox(width: 10),
                              Text('EDIT', style: TextStyle(fontSize: 20, color: AppTheme().primaryColor, fontWeight: FontWeight.bold),),
                            ],
                            ),
                        ),
                        ),
                      ),
                    ],
                ),
              ),
              Spacer(),
              Container(
                width: double.infinity,
                height: 50,
                
                child: buildDefaultButton((){
                  CacheHelper.removeData(key: 'OnBoarding');
                  navigateTo(context, OnBoardingScreen());
                }, 'OnBoarding', textColor: Colors.green),
                
              ),
              Container(
                width: double.infinity,
                height: 50,
                
                child: buildDefaultButton((){
                  AppCubit.get(context).logout(context);

                }, 'LOGOUT', textColor: Colors.red),
                
              ),
            ],
          ),
        );
      },
    );
  }
}