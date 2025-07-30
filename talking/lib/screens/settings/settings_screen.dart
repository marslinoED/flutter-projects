import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talking/layout/cubit/cubit.dart';
import 'package:talking/layout/cubit/states.dart';
import 'package:talking/screens/update_profile/update_profile.dart';
import 'package:talking/screens/verify_profile/verify_profile.dart';
import 'package:talking/shared/app_theme.dart';
import 'package:talking/shared/components/components.dart';
import 'package:talking/shared/constraints/constaints.dart';
import 'package:talking/shared/models/post_model.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Expanded(
          child: SingleChildScrollView(
            // Scroll the entire screen
            child: Column(
              children: [
                _buildUser(cubit, context),
                if (cubit.userModel!.uPosts.isNotEmpty)
                  Column(
                    children:
                        List.generate(cubit.userModel!.uPosts.length, (index) {
                          String postId = cubit.userModel!.uPosts[index];
                          PostModel post = findPostById(postId, cubit);
                          return _buildUserPost(post, cubit);
                        }).toList(),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "No posts yet",
                      style: AppTheme().bodyMedium.copyWith(color: Colors.grey),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildUser(AppCubit cubit, BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Minimize height to fit content
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(100),
                ),
                child: Image.network(
                  cubit.userModel?.cover ?? defaultCoverImage,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: -50,
              left: 20,
              child: CircleAvatar(
                radius: 77,
                backgroundColor: Colors.white,
                child: Material(
                  elevation: 5,
                  shape: CircleBorder(),
                  child: CircleAvatar(
                    radius: 70,
                    backgroundImage: NetworkImage(
                      cubit.userModel?.image ?? defaultProfileImage,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    cubit.userModel?.name ?? 'No Name',
                    style: TextStyle(
                      fontSize: 20,
                      color: AppTheme().secondaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(
                    cubit.userModel?.isVerified ?? false
                        ? Icons.verified
                        : Icons.verified_outlined,
                    color: Colors.blue,
                    size: 20,
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                cubit.userModel?.bio ?? "Write your bio ...",
                style: AppTheme().bodyMedium.copyWith(
                  color: Colors.grey[700],
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 4,
              ),
              SizedBox(height: 10),
              Text(
                cubit.userModel?.email ?? 'No Email',
                style: AppTheme().bodySmall,
              ),
              SizedBox(height: 10),
              Text(
                cubit.userModel?.phone ?? 'No Phone Number',
                style: AppTheme().bodySmall,
              ),
              SizedBox(height: 20),
              myDivider(),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      child: Column(
                        children: [
                          Text("100", style: AppTheme().bodyMedium),
                          Text(
                            "Posts",
                            style: AppTheme().bodyMedium.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      child: Column(
                        children: [
                          Text("100", style: AppTheme().bodyMedium),
                          Text(
                            "Photos",
                            style: AppTheme().bodyMedium.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      child: Column(
                        children: [
                          Text("100", style: AppTheme().bodyMedium),
                          Text(
                            "Followers",
                            style: AppTheme().bodyMedium.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      child: Column(
                        children: [
                          Text("100", style: AppTheme().bodyMedium),
                          Text(
                            "Following",
                            style: AppTheme().bodyMedium.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              myDivider(),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: buildDefaultButton(
                      () {
                        if (cubit.userModel?.isEmailVerified == false) {
                          navigateToBack(context, VerifyProfileScreen());
                        } else {
                          navigateToBack(context, UpdateProfileScreen());
                        }
                      },
                      'Edit Profile',
                      textColor: Colors.white,
                      backgroundColor: AppTheme().primaryColor,
                    ),
                  ),
                  SizedBox(width: 10),
                  buildDefaultButton(
                    () {
                      cubit.logout(context);
                    },
                    'Logout',
                    width: 20.0,
                    elevation: 1.0,
                    borderColor: Colors.grey[100],
                    textColor: AppTheme().primaryColor,
                    backgroundColor: Colors.white,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserPost(PostModel post, AppCubit cubit) {
    return Card(
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
                  backgroundImage: NetworkImage(post.uImage),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            post.uName,
                            style: AppTheme().bodyMedium.copyWith(
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 5),
                          // Assuming uVerified is a typo; replace with proper field if exists
                          Icon(
                            Icons.verified_outlined,
                            color: Colors.blue,
                            size: 16,
                          ),
                        ],
                      ),
                      Text(
                        "${post.pTime.substring(0, 5)} -- ${post.pDate}",
                        style: AppTheme().dateTextStyle,
                      ),
                    ],
                  ),
                ),
                IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz)),
              ],
            ),
            myDivider(),
            Text(
              post.pText,
              style: AppTheme().bodyMedium.copyWith(
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 10),
            if (post.pImage.isNotEmpty)
              Card(
                elevation: 5,
                clipBehavior: Clip.antiAlias,
                margin: EdgeInsets.all(0),
                child: Image.network(post.pImage),
              ),
            SizedBox(height: 10),
            Row(
              children: [
                Row(
                  children: [
                    Icon(Icons.favorite, color: Colors.red, size: 20),
                    SizedBox(width: 5),
                    Text(post.pLikes.toString(), style: AppTheme().bodySmall),
                  ],
                ),
                Spacer(),
                Row(
                  children: [
                    Icon(Icons.comment, color: Colors.orange, size: 20),
                    SizedBox(width: 5),
                    Text(
                      "${post.pComments} Comments",
                      style: AppTheme().bodySmall,
                    ),
                  ],
                ),
              ],
            ),
            myDivider(),
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    cubit.userModel?.image ?? defaultProfileImage,
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  "Write Your Comment",
                  style: AppTheme().bodySmall.copyWith(color: Colors.grey[500]),
                ),
                Spacer(),
                MaterialButton(
                  padding: EdgeInsets.zero,
                  minWidth: 0,
                  onPressed: () {
                    cubit.postLike(post.pId);
                  },
                  child: Row(
                    children: [
                      cubit.userModel!.likedPosts.contains(post.pId)
                          ? Icon(Icons.favorite, color: Colors.red, size: 20)
                          : Icon(
                            Icons.favorite_outline,
                            color: Colors.red,
                            size: 20,
                          ),
                      SizedBox(width: 5),
                      Text("Like", style: AppTheme().bodySmall),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                MaterialButton(
                  padding: EdgeInsets.zero,
                  minWidth: 0,
                  onPressed: () {},
                  child: Row(
                    children: [
                      Icon(
                        Icons.ios_share_rounded,
                        color: Colors.green,
                        size: 20,
                      ),
                      SizedBox(width: 5),
                      Text("Share", style: AppTheme().bodySmall),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
