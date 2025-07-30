abstract class LoginStates {}

class LoginInitialState extends LoginStates {}

class AppLoginLoadingState extends LoginStates {}

class AppLoginSuccessState extends LoginStates {
  final String uId;

  AppLoginSuccessState(this.uId);
}

class AppLoginErrorState extends LoginStates {
  final String error;

  AppLoginErrorState(this.error);
}

class LoginChangePasswordVisibilityState extends LoginStates {}
