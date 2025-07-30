import 'package:firebase_auth/firebase_auth.dart';
import 'package:talking/screens/login/cubit/login_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talking/shared/constraints/constaints.dart';
import 'package:talking/shared/network/local/cash_helper.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  void userLogin({required String email, required String password}) async {
    emit(AppLoginLoadingState());
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
          uId = value.user!.uid;
          CacheHelper.saveData(key: 'uId', value: uId);
          emit(AppLoginSuccessState(value.user!.uid));
        })
        .catchError((error) {
          emit(AppLoginErrorState(error.toString()));
        });
  }

  Icon suffix = Icon(Icons.visibility_off_outlined);
  bool isPasswordShown = false;

  void changePasswordVisibility() {
    isPasswordShown = !isPasswordShown;
    suffix =
        isPasswordShown
            ? Icon(Icons.visibility_outlined)
            : Icon(Icons.visibility_off_outlined);
    emit(LoginChangePasswordVisibilityState());
  }
}
