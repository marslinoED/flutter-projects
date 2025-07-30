import 'package:talking/shared/models/chat_model.dart';

class UserChatsModel {
  final String uId;
  final Map<String, ChatModel> chats;

  UserChatsModel({required this.uId, required this.chats});

  factory UserChatsModel.fromFirestore(
    String uId,
    Map<String, dynamic> chatData,
  ) {
    Map<String, ChatModel> chatsMap = {};
    chatData.forEach((otherUserId, chatMap) {
      chatsMap[otherUserId] = ChatModel.fromMap(chatMap, otherUserId);
    });
    return UserChatsModel(uId: uId, chats: chatsMap);
  }

  get lastMessageText => null;
}
