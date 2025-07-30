abstract class NewsStates {}

class NewsInitialState extends NewsStates {}

class NewsBottomNavigationState extends NewsStates {}

class NewsSettingState extends NewsStates {}

class NewsLoadingState extends NewsStates {}

class NewsGetDataSuccessState extends NewsStates {}

class NewsGetDataErrorState extends NewsStates {
  final String error;

  NewsGetDataErrorState(this.error);
}

class NewsGetSearchDataSuccessState extends NewsStates {}

class NewsGetSearchDataErrorState extends NewsStates {
  final String error;

  NewsGetSearchDataErrorState(this.error);
}

class NewsToggleSearchState extends NewsStates {}

class NewsToggleColorModeState extends NewsStates {}

class NewsChangeLanguageState extends NewsStates {}

