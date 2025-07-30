import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String avatarID;
  final int coins;
  final int totalGames;
  final int wins;
  final int bestStreak;
  final int tempStreak;
  final DateTime lastLogin;
  final bool lastGameState;
  final bool anonymous;

  UserModel({
    required this.id,
    required this.name,
    required this.avatarID,
    this.coins = 0,
    this.totalGames = 0,
    this.wins = 0,
    this.bestStreak = 0,
    this.tempStreak = 0,
    required this.lastLogin,
    this.lastGameState = false,
    required this.anonymous,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    DateTime parseLastLogin(dynamic value) {
      if (value is Timestamp) {
        return value.toDate();
      } else if (value is String) {
        return DateTime.parse(value);
      } else {
        return DateTime.now();
      }
    }

    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      avatarID: json['avatarID'] as String,
      coins: json['coins'] as int? ?? 0,
      totalGames: json['totalGames'] as int? ?? 0,
      wins: json['wins'] as int? ?? 0,
      bestStreak: json['bestStreak'] as int? ?? 0,
      tempStreak: json['tempStreak'] as int? ?? 0,
      lastLogin: parseLastLogin(json['lastLogin']),
      lastGameState: json['lastGameState'] as bool? ?? false,
      anonymous: json['anonymous'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatarID': avatarID,
      'coins': coins,
      'totalGames': totalGames,
      'wins': wins,
      'bestStreak': bestStreak,
      'tempStreak': tempStreak,
      'lastLogin': lastLogin.toIso8601String(),
      'lastGameState': lastGameState,
      'anonymous': anonymous,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? avatarID,
    int? coins,
    int? totalGames,
    int? wins,
    int? bestStreak,
    int? tempStreak,
    DateTime? lastLogin,
    bool? lastGameState,
    bool? anonymous,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarID: avatarID ?? this.avatarID,
      coins: coins ?? this.coins,
      totalGames: totalGames ?? this.totalGames,
      wins: wins ?? this.wins,
      bestStreak: bestStreak ?? this.bestStreak,
      tempStreak: tempStreak ?? this.tempStreak,
      lastLogin: lastLogin ?? this.lastLogin,
      lastGameState: lastGameState ?? this.lastGameState,
      anonymous: anonymous ?? this.anonymous,
    );
  }

  // Helper methods
  double get winRate => totalGames > 0 ? wins / totalGames : 0.0;
  
}
