abstract class GameStates {}

class InitialState extends GameStates {}


class GameCompletedState extends GameStates {
  final String winner;
  GameCompletedState(this.winner);
}

class GameStatusUpdateState extends GameStates {
  final Map<String, dynamic> gameData;
  GameStatusUpdateState(this.gameData);
}

class CheckWinnerLoadingState extends GameStates {}

class CheckWinnerSuccessState extends GameStates {
  final Map<String, dynamic> gameData;
  CheckWinnerSuccessState(this.gameData);
}

class CheckWinnerErrorState extends GameStates {
  final String error;
  CheckWinnerErrorState(this.error);
}

class SurrendingLoadingState extends GameStates {}

class SurrendingSuccessState extends GameStates {}

class SurrendingErrorState extends GameStates {
  late final String error;
  SurrendingErrorState(this.error);
}