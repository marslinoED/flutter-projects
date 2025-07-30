import 'package:flutter/material.dart';
import 'messangerScreen.dart';

class LoginScreen extends StatefulWidget {
  static Color staticBaseColor = Colors.blue;
  static Color baseColor = Colors.blue;
  static IconData modeIcon = Icons.dark_mode;
  static bool isPasswordVisible = false;
  static bool wrongCredentials = false;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Color adjustColorLightness(Color color, double lightnessAdjustment) {
    HSLColor hslColor = HSLColor.fromColor(color);
    double newLightness = (hslColor.lightness + lightnessAdjustment).clamp(0.0, 1.0);
    return hslColor.withLightness(newLightness).toColor();
  }

  void toggleColorMode() {
    setState(() {
      if (LoginScreen.modeIcon == Icons.dark_mode) {
        LoginScreen.baseColor = adjustColorLightness(LoginScreen.staticBaseColor, 0.4);
        LoginScreen.modeIcon = Icons.light_mode;
      } else {
        LoginScreen.baseColor = adjustColorLightness(LoginScreen.staticBaseColor, 0);
        LoginScreen.modeIcon = Icons.dark_mode;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: adjustColorLightness(LoginScreen.baseColor, -0.45),
      appBar: _buildAppBar(),
      body: _buildLoginForm(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: adjustColorLightness(LoginScreen.baseColor, -0.5),
      title: Text(
        "Title",
        style: TextStyle(color: adjustColorLightness(LoginScreen.baseColor, 1)),
      ),
      actions: [
        IconButton(
          icon: Icon(LoginScreen.modeIcon, color: adjustColorLightness(LoginScreen.baseColor, 1)),
          onPressed: toggleColorMode,
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
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
                _buildTextField(emailController, "Email Address", Icons.email, false),
                SizedBox(height: 20),
                _buildTextField(passwordController, "Password", Icons.lock, true),
                SizedBox(height: 20),
                _buildLoginButton(),
                SizedBox(height: 20),
                _buildForgotPasswordButton(),
                _buildSignUpSection(),
                _buildErrorMessage(),
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
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: adjustColorLightness(LoginScreen.baseColor, 1),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, bool isPassword) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword && !LoginScreen.isPasswordVisible,
      keyboardType: isPassword ? TextInputType.visiblePassword : TextInputType.emailAddress,
      style: TextStyle(color: adjustColorLightness(LoginScreen.baseColor, 0.1)),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return isPassword ? 'Password cannot be empty' : 'Email cannot be empty';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: adjustColorLightness(LoginScreen.baseColor, -0.1)),
        border: OutlineInputBorder(),
        prefixIcon: Icon(icon, color: adjustColorLightness(LoginScreen.baseColor, -0.1)),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  LoginScreen.isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: adjustColorLightness(LoginScreen.baseColor, -0.1),
                ),
                onPressed: () {
                  setState(() {
                    LoginScreen.isPasswordVisible = !LoginScreen.isPasswordVisible;
                  });
                },
              )
            : null,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: adjustColorLightness(LoginScreen.baseColor, -0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: adjustColorLightness(LoginScreen.baseColor, 0.1), width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: adjustColorLightness(LoginScreen.baseColor, -0.3),
        ),
        onPressed: () {
          setState(() {
            if (formKey.currentState!.validate()) {
              print("Validated");
            }
            LoginScreen.wrongCredentials = true;
          });
        },
        child: Text("Enter", style: TextStyle(color: adjustColorLightness(LoginScreen.baseColor, 0.1))),
      ),
    );
  }

  Widget _buildForgotPasswordButton() {
    return Center(
      child: TextButton(
        onPressed: () {},
        child: Text("Forgot Password?", style: TextStyle(color: adjustColorLightness(LoginScreen.baseColor, 0.1))),
      ),
    );
  }

  Widget _buildSignUpSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Don't have an account?", style: TextStyle(color: adjustColorLightness(LoginScreen.baseColor, 1))),
        TextButton(
          onPressed: () {},
          child: Text("Sign Up", style: TextStyle(color: adjustColorLightness(LoginScreen.baseColor, 0.1))),
        )
      ],
    );
  }

  Widget _buildErrorMessage() {
    return Visibility(
      visible: LoginScreen.wrongCredentials,
      child: Column(
        children: [
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Wrong Credentials", style: TextStyle(color: adjustColorLightness(LoginScreen.baseColor, 1), fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () {
                  setState(() {
                    LoginScreen.wrongCredentials = false;
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MessengerScreen()));
                  });
                },
                child: Text("SKIP", style: TextStyle(color: adjustColorLightness(LoginScreen.baseColor, 0.1))),
              )
            ],
          ),
        ],
      ),
    );
  }
}
