import 'package:flutter/material.dart';
import 'message.dart';
import 'storiesWidget.dart';

class DataModel {
  final String imageUrl;
  final String name;
  final String lastMessage;
  final bool isOnline;

  const DataModel({
    required this.imageUrl,
    required this.name,
    required this.lastMessage,
    required this.isOnline,
  });
}

class MessengerScreen extends StatelessWidget {
  const MessengerScreen({super.key});

  static const List<DataModel> Data = [
    DataModel(imageUrl: "assets/images/myProfilePic.jpg", name: "Marslino Edward", isOnline: true, lastMessage: "Hello"),
    DataModel(imageUrl: "assets/images/myProfilePic.jpg", name: "Ahmed Mohamed", isOnline: true, lastMessage: "Hi"),
    DataModel(imageUrl: "assets/images/myProfilePic.jpg", name: "Samir Saeed", isOnline: true, lastMessage: "Hey"),
    DataModel(imageUrl: "assets/images/myProfilePic.jpg", name: "Artificial Intelligence", isOnline: false, lastMessage: "Hello"),
    DataModel(imageUrl: "assets/images/myProfilePic.jpg", name: "BMW", isOnline: false, lastMessage: "Hi"),
    DataModel(imageUrl: "assets/images/myProfilePic.jpg", name: "Skoda", isOnline: false, lastMessage: "Hey"),
    DataModel(imageUrl: "assets/images/myProfilePic.jpg", name: "Skoda", isOnline: false, lastMessage: "Hey"),
    DataModel(imageUrl: "assets/images/myProfilePic.jpg", name: "Skoda", isOnline: false, lastMessage: "Hey"),
    DataModel(imageUrl: "assets/images/myProfilePic.jpg", name: "Skoda", isOnline: false, lastMessage: "Hey"),
    DataModel(imageUrl: "assets/images/myProfilePic.jpg", name: "Skoda", isOnline: false, lastMessage: "Hey"),
    DataModel(imageUrl: "assets/images/myProfilePic.jpg", name: "Skoda", isOnline: false, lastMessage: "Hey"),
    DataModel(imageUrl: "assets/images/myProfilePic.jpg", name: "Skoda", isOnline: false, lastMessage: "Hey"),
    DataModel(imageUrl: "assets/images/myProfilePic.jpg", name: "Skoda", isOnline: false, lastMessage: "Hey"),
    DataModel(imageUrl: "assets/images/myProfilePic.jpg", name: "Skoda", isOnline: false, lastMessage: "Hey"),
    DataModel(imageUrl: "assets/images/myProfilePic.jpg", name: "Skoda", isOnline: false, lastMessage: "Hey"),
    DataModel(imageUrl: "assets/images/myProfilePic.jpg", name: "Skoda", isOnline: false, lastMessage: "Hey"),
    DataModel(imageUrl: "assets/images/myProfilePic.jpg", name: "Skoda", isOnline: false, lastMessage: "Hey"),
    DataModel(imageUrl: "assets/images/myProfilePic.jpg", name: "Skoda", isOnline: false, lastMessage: "Hey"),
    DataModel(imageUrl: "assets/images/myProfilePic.jpg", name: "Skoda", isOnline: false, lastMessage: "Hey"),
    DataModel(imageUrl: "assets/images/myProfilePic.jpg", name: "Skoda", isOnline: false, lastMessage: "Hey"),
    DataModel(imageUrl: "assets/images/myProfilePic.jpg", name: "Skoda", isOnline: false, lastMessage: "Hey"),
    DataModel(imageUrl: "assets/images/myProfilePic.jpg", name: "Skoda", isOnline: false, lastMessage: "Hey"),
    DataModel(imageUrl: "assets/images/myProfilePic.jpg", name: "Skoda", isOnline: false, lastMessage: "Hey"),
    DataModel(imageUrl: "assets/images/myProfilePic.jpg", name: "Skoda", isOnline: false, lastMessage: "Hey"),
    DataModel(imageUrl: "assets/images/myProfilePic.jpg", name: "Skoda", isOnline: false, lastMessage: "Hey"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 8,
        title: Row(
          children: const [
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage("assets/images/myProfilePic.jpg"),
            ),
            SizedBox(width: 10),
            Text("Chats"),
          ],
        ),
        actions: [
          _buildIcon(Icons.camera_alt),
          _buildIcon(Icons.edit),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
        child: Column(
          children: [
            _buildSearchField(),
            const SizedBox(height: 10),
            _buildStoriesList(),
            const SizedBox(height: 10),
            _buildMessagesList(),
          ],
        ),
      ),
    );
  }

  /// Widget لإنشاء أيقونات الشريط العلوي
  static Widget _buildIcon(IconData icon) {
    return IconButton(
      onPressed: () {},
      icon: CircleAvatar(
        radius: 15,
        backgroundColor: Colors.grey,
        foregroundColor: Colors.black,
        child: Icon(icon, size: 20),
      ),
    );
  }

  /// مربع البحث
  Widget _buildSearchField() {
    return Container(
      height: 35,
      child: TextFormField(
        decoration: InputDecoration(
          labelText: "Search",
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  /// قائمة القصص الأفقية
  Widget _buildStoriesList() {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: Data.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Storieswidget(
              imageUrl: Data[index].imageUrl,
              name: Data[index].name,
              isOnline: Data[index].isOnline,
            ),
          );
        },
      ),
    );
  }

  /// قائمة الرسائل
  Widget _buildMessagesList() {
    return Expanded(
      child: ListView.builder(
        itemCount: Data.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
            child: Message(
              imageUrl: Data[index].imageUrl,
              name: Data[index].name,
              lastMessage: Data[index].lastMessage,
            ),
          );
        },
      ),
    );
  }
}
