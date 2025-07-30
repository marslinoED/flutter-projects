import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talking/layout/cubit/cubit.dart';
import 'package:talking/layout/cubit/states.dart';
import 'package:talking/shared/app_theme.dart';
import 'package:talking/shared/components/components.dart';
import 'package:talking/shared/constraints/constaints.dart';
import 'package:talking/shared/models/user_model.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

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
                  itemBuilder:
                      (context, index) =>
                          _buildPost(cubit.usersModel![index], context),
                  separatorBuilder: (context, index) => SizedBox(),
                  itemCount: cubit.usersModel!.length,
                ),
              ),
            );
      },
    );
  }

  Widget _buildPost(UserModel userModel, context) {
    return userModel.uId == uId
        ? SizedBox()
        : InkWell(
          onTap: () {
            navigateToProfile(context, userModel.uId);
          },
          child: Card(
            elevation: 2,
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
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  maxLines: 1,
                                ),
                                SizedBox(width: 5),
                                userModel.isVerified
                                    ? Icon(
                                      Icons.verified,
                                      color: Colors.blue,
                                      size: 16,
                                    )
                                    : Icon(
                                      Icons.verified_outlined,
                                      color: Colors.blue,
                                      size: 16,
                                    ),
                              ],
                            ),
                            Text(
                              userModel.email,
                              style: AppTheme().dateTextStyle,
                            ),
                          ],
                        ),
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
