import 'package:talking/screens/register/cubit/register_states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:talking/shared/constraints/constaints.dart';
import 'package:talking/shared/models/user_model.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);


  void userRegister({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) {
    emit(AppRegisterLoadingState());
    FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email, 
      password: password
      ).then((value){
        userCreate(uId: value.user!.uid, name: name, email: email, phone: phone);
        emit(AppRegisterSuccessState(value.user!.uid));
      }).catchError((error){
        print(error.toString());
        emit(AppRegisterErrorState(error.toString()));
      });
  }
  
  void userCreate({
    required String uId,
    required String name,
    required String email,
    required String phone,

  }) async{
    emit(AppUserCreateLoadingState());
    
    UserModel userModel = UserModel(
      uId: uId,
      name: name,
      email: email,
      phone: phone,
      image: defaultProfileImage,
      cover: defaultCoverImage,
      bio: 'Write your bio ...',
      isVerified: false,
      isEmailVerified: false,
      uPosts: [],
      likedPosts: [],
    );

    await FirebaseFirestore.instance.collection('users').doc(uId)
    .set(
      await userModel.toMap()
      ).then((value){
      emit(AppUserCreateSuccessState());
    }).catchError((error){
      emit(AppUserCreateErrorState(error.toString()));
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