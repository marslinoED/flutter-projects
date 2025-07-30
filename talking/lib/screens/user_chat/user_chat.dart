import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talking/layout/cubit/cubit.dart';
import 'package:talking/layout/cubit/states.dart';
import 'package:talking/shared/app_theme.dart';
import 'package:talking/shared/components/components.dart';
import 'package:talking/shared/constraints/constaints.dart';
import 'package:talking/shared/models/user_model.dart';

class UserChat extends StatelessWidget {
  UserChat({super.key, required this.rId});

  final String rId;
  final TextEditingController messageController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final ScrollController _scrollController =
      ScrollController(); // For auto-scrolling

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        // Trigger auto-scroll only when the message is sent successfully
        if (state is AppSendMessageSuccessState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });
        }
      },
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        final UserModel receiverModel = findUserById(rId, cubit);
        return Scaffold(
          appBar: _buildAppBar(cubit, context, receiverModel),
          body: _buildBody(cubit, context, receiverModel),
        );
      },
    );
  }

  AppBar _buildAppBar(
    AppCubit cubit,
    BuildContext context,
    UserModel receiverModel,
  ) {
    return AppBar(
      title: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(receiverModel.image),
          ),
          SizedBox(width: 10),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Text(
                  receiverModel.name,
                  style: AppTheme().bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 1,
                ),
                SizedBox(width: 5),
                receiverModel.isVerified
                    ? Icon(Icons.verified, color: Colors.blue, size: 20)
                    : Icon(
                      Icons.verified_outlined,
                      color: Colors.blue,
                      size: 20,
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(
    AppCubit cubit,
    BuildContext context,
    UserModel receiverModel,
  ) {
    String senderId = cubit.userModel!.uId;
    String receiverId = receiverModel.uId;

    Stream<QuerySnapshot> messagesStream =
        FirebaseFirestore.instance
            .collection('users')
            .doc(senderId)
            .collection('chats')
            .doc(receiverId)
            .collection('messages')
            .orderBy('dateTime', descending: false)
            .snapshots();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: messagesStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No messages yet'));
                }

                var messages = snapshot.data!.docs;
                return ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var messageData =
                        messages[index].data() as Map<String, dynamic>;
                    String senderIdMsg = messageData['sId'];
                    String text = messageData['text'];
                    String Time = messageData['time'];

                    return ListTile(
                      title: _buildMessage(senderIdMsg, text, Time),
                    );
                  },
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  constraints: BoxConstraints(maxHeight: 100),
                  child: Form(
                    key: formKey,
                    child: TextFormField(
                      controller: messageController,
                      validator:
                          (value) => value!.isEmpty ? "Enter a message" : null,
                      maxLines: null,
                      minLines: 1,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        hintText: "Type a message",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 15,
                        ),
                      ),
                      scrollPhysics: BouncingScrollPhysics(),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    cubit.sendMessage(
                      senderId: cubit.userModel!.uId,
                      receiverId: receiverModel.uId,
                      text: messageController.text,
                    );
                    messageController.clear();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(String senderId, String text, String time) {
    bool isSentByMe = senderId == uId;
    return Align(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSentByMe ? Colors.blue : Colors.grey,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(isSentByMe ? 10 : 0),
            bottomRight: Radius.circular(isSentByMe ? 0 : 10),
          ),
        ),
        child: Column(
          crossAxisAlignment:
              isSentByMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            Text(text, style: TextStyle(color: Colors.white)),
            Text(
              time.substring(0, 5),
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
