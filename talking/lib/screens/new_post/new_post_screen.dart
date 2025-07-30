import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talking/layout/cubit/cubit.dart';
import 'package:talking/layout/cubit/states.dart';
import 'package:talking/shared/app_theme.dart';

class NewPostScreen extends StatelessWidget {
  NewPostScreen({super.key});

  final TextEditingController can = TextEditingController();
  final formkey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
          appBar: _buildAppBar(cubit, context, state),
          body: _buildBody(cubit, context, state),
        );
      },
    );
  }

  AppBar _buildAppBar(cubit, context, state) {
    return AppBar(
      title: Text("Create Post"),
      actions: [
        TextButton(
          onPressed: () {
            if (formkey.currentState!.validate()) {
              cubit.uploadPost(can.text, context);
            }
          },
          child: Text(
            "Post",
            style: AppTheme().bodyMedium.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody(cubit, context, state) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(cubit.userModel.image),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          cubit.userModel.name,
                          style: AppTheme().bodyMedium.copyWith(
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 5),
                        cubit.userModel.isVerified
                            ? Icon(Icons.verified, color: Colors.blue, size: 16)
                            : Icon(
                              Icons.verified_outlined,
                              color: Colors.blue,
                              size: 16,
                            ),
                      ],
                    ),
                    Text("public", style: AppTheme().dateTextStyle),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Form(
                    key: formkey,
                    child: TextFormField(
                      controller: can,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Caption can't be empty";
                        }
                        return null;
                      },
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: "What's on your mind?",
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          cubit.postImage != null
              ? Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppTheme().primaryColor,
                      width: 2,
                    ),
                  ),
                  child: Image(
                    image: FileImage(cubit.postImage),
                    fit: BoxFit.cover,
                  ),
                ),
              )
              : SizedBox(),

          Container(
            padding: EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: () {
                cubit.pickPostImageFromGallery();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image, color: Colors.white),
                  SizedBox(width: 10),
                  Text(
                    "Add Photo",
                    style: AppTheme().bodyMedium.copyWith(color: Colors.white),
                  ),
                ],
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme().primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
