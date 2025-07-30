import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping/layout/app_layout.dart';
import 'package:shopping/layout/cubit/app_cubit.dart';
import 'package:shopping/layout/cubit/app_states.dart';
import 'package:shopping/shared/components/components.dart';

class UpdateScreen extends StatelessWidget {
  const UpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context, state) {
        if (state is AppSuccessUpdateUserState) {
          errorMessage(context, 'User Updated Successfully', true);
          navigateTo(context, AppLayout());
        }
        if (state is AppUnSuccessUpdateUserState) {
          errorMessage(context, state.error, false);
        }
        if (state is AppErrorUpdateUserState) {
          errorMessage(context, 'Error Updating User', false);
        }
      },
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        TextEditingController userNameController = TextEditingController();
        TextEditingController emailController = TextEditingController();
        TextEditingController phoneController = TextEditingController();
        final formKey = GlobalKey<FormState>();
        
        userNameController.text = cubit.userModel?.data!.name ?? '';
        emailController.text = cubit.userModel?.data!.email ?? '';
        phoneController.text = cubit.userModel?.data!.phone ?? '';
        return Scaffold(
          appBar: AppBar(
            title: Text("Update"),
          ),
          body: state is AppLoadingUpdateUserState ?
          Center(child: CircularProgressIndicator()) :
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: formKey, 
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildDeafultTextField(userNameController, 'UserName', Icons.person, false, context, state, cubit),
                      SizedBox(height: 10),
                      buildDeafultTextField(emailController, 'Email',Icons.email, false, context, state, cubit),
                      SizedBox(height: 10),
                      buildDeafultTextField(phoneController, 'Phone Number', Icons.phone, false, context, state, cubit),
                      SizedBox(height: 30),
                      buildDefaultButton(() {
                        if(formKey.currentState!.validate()){
                        cubit.updateUserData(
                          name: userNameController.text,
                          email: emailController.text,
                          phone: phoneController.text,
                        );
                      }
                        
                      }, 'Update', ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}
