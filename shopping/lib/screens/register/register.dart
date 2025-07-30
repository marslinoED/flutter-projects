import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping/screens/login/login_screen.dart';
import 'package:shopping/screens/register/cubit/register_cubit.dart';
import 'package:shopping/screens/register/cubit/register_states.dart';
import 'package:shopping/shared/components/components.dart';


class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {
          if(state is RegisterSuccessState){
            print(state.UserData.message );
            errorMessage(context, state.UserData.message ?? 'Unknown error', state.UserData.status);
            if(state.UserData.status) {
                navigateTo(context, LoginScreen());
            }
          }
        },
        builder: (context, state) {
          RegisterCubit cubit = RegisterCubit.get(context);
          return Scaffold(
            appBar: _buildAppBar(context, state, cubit),
            body: _buildRegisterForm(context, state, cubit),
          );
        },
        
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(context, state, cubit) {
    return AppBar(
      title: Text(
        "Register Screen",
        ),
    );
  }

  Widget _buildRegisterForm(context, state, cubit) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                SizedBox(height: 20),
                buildDeafultTextField(nameController, "Name", Icons.person, false, context, state, cubit),
                SizedBox(height: 20),
                buildDeafultTextField(emailController, "Email Address", Icons.email, false, context, state, cubit),
                SizedBox(height: 20),
                buildDeafultTextField(phoneController, "Phone", Icons.phone, false, context, state, cubit),
                SizedBox(height: 20),
                buildDeafultTextField(passwordController, "Password", Icons.lock, true, context, state, cubit),
                SizedBox(height: 20),
                _buildRegisterButton(context, state, cubit),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      "Register",
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        ),
    );
  }

  _buildRegisterButton(context, state, cubit) {
      return state is RegisterLoadingState
      ? Center(
          child: CircularProgressIndicator(),
        )
      : buildDefaultButton(
          () {
            if(formKey.currentState!.validate()){
              cubit.userRegister(
                name: nameController.text,
                email: emailController.text,
                phone: phoneController.text,
                password: passwordController.text,
              );
            }
          },
          "REGISTER",
        );
  }
  
  
  

}