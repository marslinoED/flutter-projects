import 'package:shopping/shared/models/login_model.dart';

abstract class AppStates {}

class AppInitialState extends AppStates {}

class AppChangeBottomNavState extends AppStates {}

class AppLoadingHomeDataState extends AppStates {}
class AppSuccessHomeDataState extends AppStates {}
class AppErrorHomeDataState extends AppStates {}

class AppLoadingCategoryDataState extends AppStates {}
class AppSuccessCategoryDataState extends AppStates {}
class AppErrorCategoryDataState extends AppStates {}

class AppLoadingFavoritesDataState extends AppStates {}
class AppSuccessFavoritesDataState extends AppStates {}
class AppErrorFavoritesDataState extends AppStates {}

class AppLoadingUserDataState extends AppStates {}
class AppSuccessUserDataState extends AppStates {}
class AppErrorUserDataState extends AppStates {}

class AppChangeFavoritesState extends AppStates {}
class AppSuccessChangeFavoritesState extends AppStates {
  final bool changeFavourites;
  AppSuccessChangeFavoritesState(this.changeFavourites);
}
class AppUnSuccessChangeFavoritesState extends AppStates {
  final String error;
  AppUnSuccessChangeFavoritesState(this.error);
}
class AppErrorChangeFavoritesState extends AppStates {}

class AppLogoutState extends AppStates {}

class AppUpdateChangePasswordVisibilityState extends AppStates {}

class AppLoadingUpdateUserState extends AppStates {}

class AppSuccessUpdateUserState extends AppStates
{
  final LoginModel loginModel;

  AppSuccessUpdateUserState(this.loginModel);
}
class AppUnSuccessUpdateUserState extends AppStates {
  final String error;
  AppUnSuccessUpdateUserState(this.error);
}

class AppErrorUpdateUserState extends AppStates {}

