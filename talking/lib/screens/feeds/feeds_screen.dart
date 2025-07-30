import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talking/layout/cubit/cubit.dart';
import 'package:talking/layout/cubit/states.dart';
import 'package:talking/shared/app_theme.dart';
import 'package:talking/shared/components/components.dart';
import 'package:talking/shared/models/post_model.dart';

class FeedsScreen extends StatelessWidget {
  const FeedsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return cubit.posts.length == 0
            ? Center(
              child: Text("No Posts Yet", style: AppTheme().bodyExtraLarge),
            )
            : Expanded(
              child: SingleChildScrollView(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder:
                      (context, index) => _buildPost(
                        cubit.posts[index],
                        cubit.userModel!.image,
                        cubit,
                        context,
                      ),
                  separatorBuilder: (context, index) => SizedBox(height: 10),
                  itemCount: cubit.posts.length,
                ),
              ),
            );
      },
    );
  }

  Widget _buildPost(PostModel post, String image, AppCubit cubit, context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => navigateToProfile(context, post.uId),
              child: Row(
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
                            post.uVerifed
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
                          "${post.pTime.substring(0, 5)} -- ${post.pDate}",
                          style: AppTheme().dateTextStyle,
                        ),
                      ],
                    ),
                  ),
                  IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz)),
                ],
              ),
            ),
            myDivider(),
            Text(
              post.pText,
              style: AppTheme().bodyMedium.copyWith(
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 10),
            post.pImage != ''
                ? Card(
                  elevation: 5,
                  clipBehavior: Clip.antiAlias,
                  margin: EdgeInsets.all(0),
                  child: Image.network('${post.pImage}'),
                )
                : SizedBox(),
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
                      "${post.pComments.toString()} Comments",
                      style: AppTheme().bodySmall,
                    ),
                  ],
                ),
              ],
            ),

            myDivider(),
            Row(
              children: [
                CircleAvatar(radius: 20, backgroundImage: NetworkImage(image)),
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
