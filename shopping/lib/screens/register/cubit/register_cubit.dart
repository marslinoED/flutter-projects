import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping/screens/register/cubit/register_states.dart';
import 'package:shopping/shared/models/login_model.dart';
import 'package:shopping/shared/network/end_points.dart';
import 'package:shopping/shared/network/remote/dio_helper.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  LoginModel ?registerModel;
  void userRegister({
    required String name,
    required String email, 
    required String password,
    required String phone,
    })
    {
      emit(RegisterLoadingState());
      DioHelper.postData(
        url: REGISTER,
        data: {
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
        },
        ).then((value)
        {
          registerModel = LoginModel.fromJson(value.data);
          emit(RegisterSuccessState(registerModel!));
        }).catchError((error)
        {
          print(error.toString());
          emit(RegisterErrorState(error.toString()));
        });
  }

  Icon suffix = Icon(Icons.visibility_off_outlined);
  bool isPasswordShown = false;

  void changePasswordVisibility() {
    isPasswordShown = !isPasswordShown;
    suffix = isPasswordShown ? Icon(Icons.visibility_outlined) : Icon(Icons.visibility_off_outlined);
    emit(RegisterChangePasswordVisibilityState());
  }



}