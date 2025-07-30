import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:talking/layout/cubit/cubit.dart';
import 'package:talking/layout/cubit/states.dart';
import 'package:talking/shared/app_theme.dart';
import 'package:talking/shared/components/components.dart';
import 'package:talking/shared/constraints/constaints.dart';
import 'package:talking/shared/models/chat_model.dart';
import 'package:talking/shared/models/user_model.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return cubit.posts.length == 0
            ? Center(
              child: Text("No Chats Yet", style: AppTheme().bodyExtraLarge),
            )
            : Expanded(
              child: SingleChildScrollView(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    String otherUserId = cubit.userChats!.chats.keys.elementAt(
                      index,
                    );
                    ChatModel chat = cubit.userChats!.chats[otherUserId]!;
                    UserModel user = findUserById(otherUserId, cubit);
                    return _buildChat(user, chat, context);
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 10),
                  itemCount: cubit.userChats!.chats.length,
                ),
              ),
            );
      },
    );
  }

  Widget _buildChat(UserModel userModel, ChatModel chatModel, context) {
    return userModel.uId == uId
        ? SizedBox()
        : InkWell(
          onTap: () => navigateToChat(context, userModel.uId),
          child: Card(
            elevation: 5,
            margin: EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(userModel.image),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  userModel.name,
                                  style: AppTheme().bodyMedium.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              chatModel.lastMessageText,
                              style: AppTheme().dateTextStyle,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "${DateFormat('yyyy-MM-dd').format(DateTime.parse(chatModel.lastMessageTime))}",
                            style: AppTheme().bodySmall,
                          ),
                          Text(
                            "${DateFormat('HH:mm').format(DateTime.parse(chatModel.lastMessageTime))}",
                            style: AppTheme().bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
  }
}
