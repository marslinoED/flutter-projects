import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shopping/shared/app_theme.dart';

Widget buildDeafultTextField(TextEditingController controller, String label, IconData icon, bool isPassword, context, state, cubit) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: AppTheme().secondaryColor),
      obscureText: isPassword && !cubit.isPasswordShown,
      keyboardType: isPassword ? TextInputType.visiblePassword : TextInputType.emailAddress,
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
        suffixIcon: isPassword ? IconButton(
          onPressed: (){
            cubit.changePasswordVisibility();
          }, 
          icon: cubit.suffix,
          color: Theme.of(context).iconTheme.color,
        ) : null,
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

Widget buildDefaultButton(function, text,{textColor}) {
      return Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 3,
            backgroundColor: AppTheme().secondaryColor,
            ),
          onPressed: function,
          child: Text(text, style: TextStyle(color: textColor),),
        ),
      );
}

void navigateToBack(context, screen){
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => screen), 
  );
}
void navigateTo(context, screen){
  Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(
    builder: (context) => screen,
  ),
  (route)
  {
    return false;
  },
);
}

void errorMessage(
  BuildContext context, 
  String message, 
  bool state,
  ){
  if (Platform.isAndroid || Platform.isIOS) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: state ? Colors.green : Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
      content: Text(message), 
      backgroundColor: state ? Colors.green : Colors.red),
    );
  }

}

  