abstract class RegisterStates {}

class RegisterInitialState extends RegisterStates {}

class AppRegisterLoadingState extends RegisterStates {}
class AppRegisterSuccessState extends RegisterStates {
  final String uId;

  AppRegisterSuccessState(this.uId);
}
class AppRegisterErrorState extends RegisterStates {
  final String error;

  AppRegisterErrorState(this.error);
}

class AppUserCreateLoadingState extends RegisterStates {}
class AppUserCreateSuccessState extends RegisterStates {}
class AppUserCreateErrorState extends RegisterStates {
  final String error;

  AppUserCreateErrorState(this.error);
}

class RegisterChangePasswordVisibilityState extends RegisterStates {}