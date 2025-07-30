import 'package:cosmic/layout/app_layout.dart';
import 'package:cosmic/shared/app_theme.dart';
import 'package:cosmic/shared/component/components.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  var context;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    this.context = context;

    return Scaffold(backgroundColor: Colors.black, body: _buildBody());
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 100),
            Image(image: AssetImage('assets/logo/logo.png')),
            const SizedBox(height: 200),
            _buildForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
        border: Border(
          top: BorderSide(color: Colors.black.withOpacity(0.4), width: 2),
        ),
      ),

      padding: const EdgeInsets.all(44),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Sign in", style: AppTheme().bodyExtraLarge),
          SizedBox(height: 24),
          buildDeafultTextField(emailController, "Email"),
          SizedBox(height: 24),
          buildDeafultTextField(passwordController, "Password"),
          SizedBox(height: 16),
          _buildTextButton(),
          SizedBox(height: 24),
          buildDefaultButton(() {
            navigateTo(context, AppLayout());
          }, "Sign in"),
          SizedBox(height: 24),
          _divider(),
          SizedBox(height: 24),
          _verficationMethods(),
          SizedBox(height: 24),
          _sign_up(),
        ],
      ),
    );
  }

  Widget _buildTextButton() {
    return TextButton(
      onPressed: () => {},
      child: Text(
        "Forget Password",
        style: AppTheme().textButtonTextStyle.copyWith(
          color: AppTheme().darkAccent,
        ),
      ),
    );
  }

  Widget _divider() {
    return Row(
      children: [
        Expanded(child: Container(color: Colors.grey[600], height: 1)),
        SizedBox(width: 16),
        Text(
          "Or Sign With",
          style: AppTheme().bodyMedium.copyWith(color: Colors.grey[600]),
        ),
        SizedBox(width: 16),
        Expanded(child: Container(color: Colors.grey[600], height: 1)),
      ],
    );
  }

  Widget _verficationMethods() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        circularButton(
          Image(
            height: 50,
            width: 50,
            image: AssetImage('assets/icons/appsicons/twitter.png'),
            fit: BoxFit.cover,
          ),
          Colors.blue,
          () {},
        ),
        circularButton(
          Image(
            height: 50,
            width: 50,
            image: AssetImage('assets/icons/appsicons/facebook.png'),
            fit: BoxFit.cover,
          ),
          Color.fromARGB(255, 66, 103, 178),
          () {},
        ),
        circularButton(
          Image(
            height: 50,
            width: 50,
            image: AssetImage('assets/icons/appsicons/google.png'),
            fit: BoxFit.cover,
          ),
          Color.fromARGB(255, 255, 193, 7),
          () {},
        ),
      ],
    );
  }

  Widget _sign_up() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: AppTheme().bodyMedium.copyWith(
            color: Colors.grey[600],
            fontWeight: FontWeight.normal,
          ),
        ),
        TextButton(
          onPressed: () => {},
          child: Text(
            "Sign up",
            style: AppTheme().textButtonTextStyle.copyWith(
              color: AppTheme().darkAccent,
            ),
          ),
        ),
      ],
    );
  }
}
