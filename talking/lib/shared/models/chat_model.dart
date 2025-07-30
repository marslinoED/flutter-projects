import 'package:talking/shared/models/message_model.dart';

class ChatModel {
  final String otherUserId; // The ID of the other user (e.g., receiverId)
  final String lastMessageTime;
  final String lastMessageText;
  final List<MessageModel> messages;

  ChatModel({
    required this.otherUserId,
    required this.lastMessageTime,
    required this.lastMessageText,
    required this.messages,
  });

  factory ChatModel.fromMap(Map<String, dynamic> map, String otherUserId) {
    List<MessageModel> messages = [];
    if (map['messages'] != null) {
      (map['messages'] as Map<String, dynamic>).forEach((
        messageId,
        messageMap,
      ) {
        messages.add(MessageModel.fromMap(messageMap));
      });
    }
    return ChatModel(
      otherUserId: otherUserId,
      lastMessageTime: map['lastMessageTime'] ?? DateTime.now().toString(),
      lastMessageText: map['lastMessageText'] ?? '',
      messages: messages,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lastMessageTime': lastMessageTime,
      'lastMessageText': lastMessageText,
    };
  }
}
