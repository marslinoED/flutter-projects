import 'package:talking/screens/user_chat/user_chat.dart';
import 'package:talking/screens/user_profile/user_profile.dart';
import 'package:talking/shared/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:talking/shared/models/post_model.dart';
import 'package:talking/shared/models/user_model.dart';

Widget buildDeafultTextField(
  TextEditingController controller,
  String label,
  IconData icon,
  bool isPassword,
  context,
  state,
  cubit,
) {
  return TextFormField(
    controller: controller,
    style: TextStyle(color: AppTheme().secondaryColor),
    obscureText: isPassword && !cubit.isPasswordShown,
    keyboardType:
        isPassword ? TextInputType.visiblePassword : TextInputType.emailAddress,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return '$label cannot be empty';
      }
      return null;
    },
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: AppTheme().secondaryColor),
      border: OutlineInputBorder(),
      prefixIcon: Icon(icon, color: Theme.of(context).iconTheme.color),
      suffixIcon:
          isPassword
              ? IconButton(
                onPressed: () {
                  cubit.changePasswordVisibility();
                },
                icon: cubit.suffix,
                color: Theme.of(context).iconTheme.color,
              )
              : null,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppTheme().secondaryColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppTheme().primaryColor),
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}

Widget buildDefaultButton(
  function,
  text, {
  textColor,
  backgroundColor,
  width,
  elevation,
  borderColor,
}) {
  return Center(
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(width ?? double.infinity, 45),
        elevation: elevation ?? 3,
        backgroundColor: backgroundColor ?? AppTheme().primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: BorderSide(color: borderColor ?? Colors.grey),
        ),
      ),
      onPressed: function,
      child: Text(
        text,
        style: AppTheme().bodyMedium.copyWith(color: textColor ?? Colors.white),
      ),
    ),
  );
}

Widget myDivider() {
  return Column(
    children: [
      SizedBox(height: 2),
      Divider(color: Colors.grey, thickness: 0.5),
      SizedBox(height: 2),
    ],
  );
}

void navigateToBack(context, screen) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
}

void navigateTo(context, screen) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => screen),
    (route) {
      return false;
    },
  );
}

String cleanString(String input) {
  if (input.startsWith("[")) {
    return input.replaceFirst(RegExp(r"\[.*?\]\s*"), "");
  }
  return input;
}

void errorMessage(BuildContext context, String message, bool state) {
  message = cleanString(message);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, textAlign: TextAlign.center),
      backgroundColor: state ? Colors.green : Colors.red,
      duration: Duration(seconds: 1 + message.length ~/ 12.5),
    ),
  );
}

void navigateToProfile(context, uId) {
  navigateToBack(context, UserProfile(uId: uId));
}

void navigateToChat(context, rId) {
  navigateToBack(context, UserChat(rId: rId));
}

PostModel findPostById(String pId, cubit) {
  return cubit.posts.firstWhere((post) => post.pId == pId);
}

UserModel findUserById(String uId, cubit) {
  return cubit.usersModel.firstWhere((user) => user.uId == uId);
}
