import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talking/layout/cubit/cubit.dart';
import 'package:talking/layout/cubit/states.dart';
import 'package:talking/shared/app_theme.dart';
import 'package:talking/shared/components/components.dart';

class VerifyProfileScreen extends StatelessWidget {
  VerifyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
          appBar: _buildAppBar(cubit, context, state),
          body: _buildBody(cubit, context, state),
        );
      },
    );
  }

  AppBar _buildAppBar(cubit, context, state) {
    return AppBar(title: Text("Verify Profile"));
  }

  Widget _buildBody(cubit, context, state) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.warning, size: 150, color: Colors.red),
            SizedBox(height: 20),
            Text(
              "Please verify your profile to continue",
              style: AppTheme().bodyMedium.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            buildDefaultButton(() {
              cubit.verifyAccount(context);
            }, "send email verification"),
            SizedBox(height: 20),
            cubit.userModel!.isEmailVerified == false
                ? Text(
                  "Email Not Verified",
                  style: AppTheme().bodyMedium.copyWith(color: Colors.red),
                )
                : Text(
                  "Email Verified",
                  style: AppTheme().bodyMedium.copyWith(color: Colors.green),
                ),
            SizedBox(height: 20),
            buildDefaultButton(
              () {
                cubit.checkVerify(context);
              },
              "Referesh",
              width: 100.0,
            ),
          ],
        ),
      ),
    );
  }
}
