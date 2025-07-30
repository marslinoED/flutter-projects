class MessageModel {
  final String mId;
  final String sId;
  final String rId;
  final String text;
  final String dateTime;

  MessageModel({
    required this.mId,
    required this.sId,
    required this.rId,
    required this.text,
    required this.dateTime,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      mId: map['mId'] ?? '',
      sId: map['sId'] ?? '',
      rId: map['rId'] ?? '',
      text: map['text'] ?? '',
      dateTime: map['dateTime'] ?? DateTime.now().toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mId': mId,
      'sId': sId,
      'rId': rId,
      'text': text,
      'dateTime': dateTime,
    };
  }
}
