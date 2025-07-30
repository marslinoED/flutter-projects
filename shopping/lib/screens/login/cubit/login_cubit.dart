import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping/screens/login/cubit/login_states.dart';
import 'package:shopping/shared/models/login_model.dart';
import 'package:shopping/shared/network/end_points.dart';
import 'package:shopping/shared/network/remote/dio_helper.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  LoginModel ?loginModel;
  void userLogin({
    required String email, 
    required String password
    })
    {
      emit(LoginLoadingState());
      DioHelper.postData(
        url: LOGIN,
        data: {
          'email': email,
          'password': password,
        },
        ).then((value)
        {
          print(value.data['message']);
          loginModel = LoginModel.fromJson(value.data);
          emit(LoginSuccessState(loginModel!));
        }).catchError((error)
        {
          print(error.toString());
          emit(LoginErrorState(error.toString()));
        });
  }

  Icon suffix = Icon(Icons.visibility_off_outlined);
  bool isPasswordShown = false;

  void changePasswordVisibility() {
    isPasswordShown = !isPasswordShown;
    suffix = isPasswordShown ? Icon(Icons.visibility_outlined) : Icon(Icons.visibility_off_outlined);
    emit(LoginChangePasswordVisibilityState());
  }



}