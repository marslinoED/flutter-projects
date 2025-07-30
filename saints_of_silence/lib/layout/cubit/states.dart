import '../../models/user_model.dart';

abstract class AppStates {}

class InitialState extends AppStates {}

class CreateUserLoadingState extends AppStates {}

class CreateUserSuccessState extends AppStates {
  final UserModel user;
  CreateUserSuccessState(this.user);
}

class CreateUserErrorState extends AppStates {
  final String error;
  CreateUserErrorState(this.error);
}

class CreateSessionLoadingState extends AppStates {}

class CreateSessionSuccessState extends AppStates {
  CreateSessionSuccessState(String roomId);
}

class CreateSessionErrorState extends AppStates {
  late final String error;
  CreateSessionErrorState(this.error);
}

class DeleteSessionLoadingState extends AppStates {}

class DeleteSessionSuccessState extends AppStates {
  DeleteSessionSuccessState(String roomId);
}

class DeleteSessionErrorState extends AppStates {
  late final String error;
  DeleteSessionErrorState(this.error);
}

class CreateGameDocumentLoadingState extends AppStates {}

class CreateGameDocumentSuccessState extends AppStates {
  CreateGameDocumentSuccessState(String roomId);
}

class CreateGameDocumentErrorState extends AppStates {
  late final String error;
  CreateGameDocumentErrorState(this.error);
}


class MatchFoundState extends AppStates {
  final String roomId;
  final String player1Name;
  final String player2Name;
  final String player1ID;
  final String player2ID;

  final bool isPlayer1;

  MatchFoundState(this.roomId, this.player1Name, this.player2Name, this.isPlayer1, this.player1ID, this.player2ID);
}

class LeaderboardLoadedState extends AppStates {
  final List<UserModel> leaderboard;
  LeaderboardLoadedState(this.leaderboard);
}

class LeaderboardLoadingState extends AppStates {}

class LeaderboardErrorState extends AppStates {
  final String error;
  LeaderboardErrorState(this.error);
}



class MatchmakingLoadingState extends AppStates {}

class MatchmakingWaitingState extends AppStates {}

class MatchmakingSuccessState extends AppStates {
    final Map<String, dynamic> roomData;
  MatchmakingSuccessState(this.roomData);
}

class MatchmakingErrorState extends AppStates {
  final String error;
  MatchmakingErrorState(this.error);
}


class MatchmakingCancelledLoadingState extends AppStates {}

class MatchmakingCancelledSuccessState extends AppStates {}

class MatchmakingCancelledErrorState extends AppStates {
  final String error;
  MatchmakingCancelledErrorState(this.error);
}
