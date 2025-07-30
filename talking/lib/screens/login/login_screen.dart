import 'package:talking/layout/app_layout.dart';
import 'package:talking/screens/login/cubit/login_cubit.dart';
import 'package:talking/screens/login/cubit/login_states.dart';
import 'package:talking/screens/register/register.dart';
import 'package:talking/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talking/shared/network/local/cash_helper.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is AppLoginSuccessState) {
            CacheHelper.saveData(key: "uId", value: state.uId)
                .then((value) {
                  errorMessage(context, "Logined", true);
                  navigateTo(context, AppLayout());
                })
                .catchError((error) {
                  errorMessage(context, error.toString(), false);
                });
          } else if (state is AppLoginErrorState) {
            errorMessage(context, state.error, false);
          }
        },
        builder: (context, state) {
          LoginCubit cubit = LoginCubit.get(context);
          return Scaffold(
            appBar: _buildAppBar(context, state, cubit),
            body: _buildLoginForm(context, state, cubit),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(context, state, cubit) {
    return AppBar(title: Text("Login Screen"));
  }

  Widget _buildLoginForm(context, state, cubit) {
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
                buildDeafultTextField(
                  emailController,
                  "Email Address",
                  Icons.email,
                  false,
                  context,
                  state,
                  cubit,
                ),
                SizedBox(height: 20),
                buildDeafultTextField(
                  passwordController,
                  "Password",
                  Icons.lock,
                  true,
                  context,
                  state,
                  cubit,
                ),
                SizedBox(height: 20),
                _buildLoginButton(context, state, cubit),
                SizedBox(height: 20),
                _buildForgotPasswordButton(),
                _buildSignUpSection(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      "Login",
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    );
  }

  _buildLoginButton(context, state, cubit) {
    return state is AppLoginLoadingState
        ? Center(child: CircularProgressIndicator())
        : buildDefaultButton(() {
          if (formKey.currentState!.validate()) {
            cubit.userLogin(
              email: emailController.text,
              password: passwordController.text,
            );
          }
        }, "LOGIN");
  }

  Widget _buildForgotPasswordButton() {
    return Center(
      child: TextButton(onPressed: () {}, child: Text("Forgot Password?")),
    );
  }

  Widget _buildSignUpSection(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Don't have an account?", style: TextStyle(color: Colors.grey)),
        TextButton(
          onPressed: () {
            navigateToBack(context, RegisterScreen());
          },
          child: Text("REGISTER"),
        ),
      ],
    );
  }
}
