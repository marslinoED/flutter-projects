import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talking/layout/cubit/cubit.dart';
import 'package:talking/layout/cubit/states.dart';
import 'package:talking/shared/app_theme.dart';
import 'package:talking/shared/components/components.dart';

class UpdateProfileScreen extends StatelessWidget {
  UpdateProfileScreen({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  @override
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
      title: Text("Edit Profile"),
      actions: [
        TextButton(
          onPressed: () {
            cubit.updateUserData(
              nameController.text,
              bioController.text,
              context,
            );
          },
          child: Text(
            "Update",
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
    nameController.text = cubit.userModel.name;
    bioController.text = cubit.userModel.bio;
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 220,
              child: Stack(
                // alignment: Alignment.bottomRight,
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: double.infinity,
                    height: 200,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(150),
                      ),
                      child:
                          cubit.coverImage == null
                              ? Image.network(
                                cubit.userModel.cover,
                                fit: BoxFit.cover,
                              )
                              : Image.file(cubit.coverImage, fit: BoxFit.cover),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 20,
                    child: Material(
                      elevation: 5,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: Icon(Icons.camera_alt, color: Colors.blue),
                          onPressed: () {
                            cubit.pickCoverImageFromGallery();
                          },
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -30,
                    left: 20,
                    child: CircleAvatar(
                      radius: 77,
                      backgroundColor: Colors.white,
                      child: Material(
                        elevation: 5,
                        shape: CircleBorder(),
                        child: CircleAvatar(
                          radius: 70,
                          backgroundImage:
                              cubit.profileImage == null
                                  ? NetworkImage(cubit.userModel.image)
                                  : FileImage(cubit.profileImage),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 150,
                    child: Material(
                      elevation: 5,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: Icon(Icons.camera_alt, color: Colors.blue),
                          onPressed: () {
                            cubit.pickProfileImageFromGallery();
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 70),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  buildDeafultTextField(
                    nameController,
                    "Name",
                    Icons.person,
                    false,
                    context,
                    state,
                    cubit,
                  ),
                  SizedBox(height: 30),
                  buildDeafultTextField(
                    bioController,
                    "Bio",
                    Icons.description_rounded,
                    false,
                    context,
                    state,
                    cubit,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
