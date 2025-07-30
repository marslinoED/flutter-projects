class PostModel {
  late String uId;
  late String pId;
  late String uName;
  late String uImage;
  late bool uVerifed;
  late String pText;
  late String pImage;
  late String pDate;
  late String pTime;
  late int pLikes;
  late int pComments;
  late int pShares;
  List<String> pLikesId; // Mutable list
  List<String> pCommentsId; // Mutable list
  List<String> pSharesId; // Mutable list

  PostModel({
    required this.uId,
    required this.pId,
    required this.uName,
    required this.uImage,
    required this.uVerifed,
    required this.pText,
    required this.pImage,
    required this.pDate,
    required this.pTime,
    required this.pLikes,
    required this.pComments,
    required this.pShares,
    List<String>? pLikesId, // Optional, defaults to empty mutable list
    List<String>? pCommentsId, // Optional, defaults to empty mutable list
    List<String>? pSharesId, // Optional, defaults to empty mutable list
  }) : pLikesId = pLikesId ?? [], // Mutable default
       pCommentsId = pCommentsId ?? [], // Mutable default
       pSharesId = pSharesId ?? []; // Mutable default

  PostModel.fromJson(Map<String, dynamic> json)
    : pLikesId = [], // Initialize as empty mutable list
      pCommentsId = [], // Initialize as empty mutable list
      pSharesId = [] {
    // Initialize as empty mutable list
    uId = json['uId'] as String;
    pId = json['pId'] as String;
    uName = json['uName'] as String;
    uImage = json['uImage'] as String;
    uVerifed = json['uVerifed'] as bool;
    pText = json['pText'] as String;
    pImage = json['pImage'] as String;
    pDate = json['pDate'] as String;
    pTime = json['pTime'] as String;
    pLikes = json['pLikes'] as int;
    pComments = json['pComments'] as int;
    pShares = json['pShares'] as int;

    // Safely handle pLikesId
    if (json['pLikesId'] != null && json['pLikesId'] is List) {
      pLikesId = List<String>.from(json['pLikesId']);
    }

    // Safely handle pCommentsId
    if (json['pCommentsId'] != null && json['pCommentsId'] is List) {
      pCommentsId = List<String>.from(json['pCommentsId']);
    }

    // Safely handle pSharesId
    if (json['pSharesId'] != null && json['pSharesId'] is List) {
      pSharesId = List<String>.from(json['pSharesId']);
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'pId': pId,
      'uName': uName,
      'uImage': uImage,
      'uVerifed': uVerifed,
      'pText': pText,
      'pImage': pImage,
      'pDate': pDate,
      'pTime': pTime,
      'pLikes': pLikes,
      'pComments': pComments,
      'pShares': pShares,
      'pLikesId': pLikesId,
      'pCommentsId': pCommentsId,
      'pSharesId': pSharesId,
    };
  }
}
