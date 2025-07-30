abstract class AppStates {}

class AppInitialState extends AppStates {}

class AppGetUserDataLoadingState extends AppStates {}

class AppGetUserDataSuccessState extends AppStates {}

class AppGetUserDataErrorState extends AppStates {
  final String error;

  AppGetUserDataErrorState(this.error);
}

class AppGetUsersDataLoadingState extends AppStates {}

class AppGetUsersDataSuccessState extends AppStates {}

class AppGetUsersDataErrorState extends AppStates {
  final String error;

  AppGetUsersDataErrorState(this.error);
}

class AppGetPostDataLoadingState extends AppStates {}

class AppGetPostDataSuccessState extends AppStates {}

class AppGetPostDataErrorState extends AppStates {
  final String error;

  AppGetPostDataErrorState(this.error);
}

class AppUserVerifySuccessState extends AppStates {}

class AppUserVerifyErrorState extends AppStates {
  final String error;

  AppUserVerifyErrorState(this.error);
}

class AppCheckUserVerifySuccessState extends AppStates {}

class AppCheckUserVerifyErrorState extends AppStates {}

class AppUserUpdateSuccessState extends AppStates {}

class AppUserUpdateErrorState extends AppStates {
  final String error;

  AppUserUpdateErrorState(this.error);
}

class AppChangeBottomNavState extends AppStates {
  final int index;

  AppChangeBottomNavState(this.index);
}

class AppNewPostState extends AppStates {}

class AppLogoutState extends AppStates {}

class AppProfileImagePickedSuccessState extends AppStates {}

class AppProfileImagePickedErrorState extends AppStates {}

class AppCoverImagePickedSuccessState extends AppStates {}

class AppCoverImagePickedErrorState extends AppStates {}

class AppPostImagePickedSuccessState extends AppStates {}

class AppPostImagePickedErrorState extends AppStates {}

class AppUploadProfileImageLoadingState extends AppStates {}

class AppUploadProfileImageSuccessState extends AppStates {}

class AppUploadProfileImageErrorState extends AppStates {
  final String error;

  AppUploadProfileImageErrorState(this.error);
}

class AppUploadCoverImageLoadingState extends AppStates {}

class AppUploadCoverImageSuccessState extends AppStates {}

class AppUploadCoverImageErrorState extends AppStates {
  final String error;

  AppUploadCoverImageErrorState(this.error);
}

class AppUploadPostImageLoadingState extends AppStates {}

class AppUploadPostImageSuccessState extends AppStates {}

class AppUploadPostImageErrorState extends AppStates {
  final String error;

  AppUploadPostImageErrorState(this.error);
}

class AppUpdateUserDataLoadingState extends AppStates {}

class AppUpdateUserDataSuccessState extends AppStates {}

class AppUpdateUserDataErrorState extends AppStates {
  final String error;

  AppUpdateUserDataErrorState(this.error);
}

class AppLikePostSuccessState extends AppStates {}

class AppLikePostErrorState extends AppStates {}

class AppUnLikePostSuccessState extends AppStates {}

class AppUnLikePostErrorState extends AppStates {}

class AppAddUserLikedSuccessState extends AppStates {}

class AppAddUserLikedErrorState extends AppStates {}

class AppRemoveUserLikedSuccessState extends AppStates {}

class AppRemoveUserLikedErrorState extends AppStates {}

class AppSendMessageLoadingState extends AppStates {}

class AppSendMessageSuccessState extends AppStates {}

class AppSendMessageErrorState extends AppStates {
  final String error;

  AppSendMessageErrorState(this.error);
}

class AppGetChatsLoadingState extends AppStates {}

class AppGetChatsSuccessState extends AppStates {}

class AppGetChatsErrorState extends AppStates {
  final String error;

  AppGetChatsErrorState(this.error);
}

class AppGetMessagesLoadingState extends AppStates {}

class AppGetMessagesSuccessState extends AppStates {}

class AppGetMessagesErrorState extends AppStates {
  final String error;

  AppGetMessagesErrorState(this.error);
}
