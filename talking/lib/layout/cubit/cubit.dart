import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:talking/layout/app_layout.dart';
import 'package:talking/layout/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talking/screens/chats/chats_screen.dart';
import 'package:talking/screens/feeds/feeds_screen.dart';
import 'package:talking/screens/login/login_screen.dart';
import 'package:talking/screens/new_post/new_post_screen.dart';
import 'package:talking/screens/settings/settings_screen.dart';
import 'package:talking/screens/users/users_screen.dart';
import 'package:talking/shared/cloudinary_config.dart';
import 'package:talking/shared/components/components.dart';
import 'package:talking/shared/constraints/constaints.dart';
import 'package:talking/shared/models/post_model.dart';
import 'package:talking/shared/models/screens_model.dart';
import 'package:talking/shared/models/user_chat_model.dart';
import 'package:talking/shared/models/user_model.dart';
import 'package:talking/shared/network/local/cash_helper.dart';
import 'package:intl/intl.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  void intializeData() {
    currentIndex = 0;
    getUserData();
    getPostData();
    getUsersData();
    getChats();
  }

  UserModel? userModel;
  void getUserData() {
    emit(AppGetUserDataLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .get()
        .then((value) {
          userModel = UserModel.fromJson(value.data()!);
          emit(AppGetUserDataSuccessState());
        })
        .catchError((error) {
          print(error.toString());
          emit(AppGetUserDataErrorState(error.toString()));
        });
  }

  List<UserModel>? usersModel = [];
  void getUsersData() {
    emit(AppGetUsersDataLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .orderBy('name')
        .get()
        .then((value) {
          usersModel = [];
          value.docs.forEach((element) {
            usersModel?.add(UserModel.fromJson(element.data()));
          });
          emit(AppGetUsersDataSuccessState());
        })
        .catchError((error) {
          print(error.toString());
          emit(AppGetUsersDataErrorState(error.toString()));
        });
  }

  List<PostModel> posts = [];
  void getPostData() {
    emit(AppGetPostDataLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('pDate', descending: true)
        .get()
        .then((value) {
          posts = [];
          value.docs.forEach((element) {
            posts.add(PostModel.fromJson(element.data()));
          });
          emit(AppGetPostDataSuccessState());
        })
        .catchError((error) {
          print(error.toString());
          emit(AppGetPostDataErrorState(error.toString()));
        });
  }

  void postLike(String pId) {
    if (userModel!.likedPosts.contains(pId)) {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(pId)
          .update({
            'pLikesId': FieldValue.arrayRemove([
              uId,
            ]), // Add uId to pLikesId array
            'pLikes': FieldValue.increment(
              -1,
            ), // Optionally increment pLikes count
          })
          .then((value) {
            print("User $uId added to pLikesId for post $pId");

            posts.forEach((element) {
              if (element.pId == pId) {
                element.pLikes--;
                element.pLikesId.remove(uId!);
              }
            });
            emit(AppUnLikePostSuccessState());
          })
          .catchError((error) {
            print("Error adding like: $error");
            emit(AppUnLikePostErrorState());
          });
      FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .update({
            'likedPosts': FieldValue.arrayRemove([pId]),
          })
          .then((value) {
            userModel!.likedPosts.remove(pId);
            emit(AppRemoveUserLikedSuccessState());
          })
          .catchError((error) {
            print(error.toString());
            emit(AppRemoveUserLikedErrorState());
          });
    } else {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(pId)
          .update({
            'pLikesId': FieldValue.arrayUnion([
              uId,
            ]), // Add uId to pLikesId array
            'pLikes': FieldValue.increment(
              1,
            ), // Optionally increment pLikes count
          })
          .then((value) {
            print("User $uId added to pLikesId for post $pId");

            posts.forEach((element) {
              if (element.pId == pId) {
                element.pLikes++;
                element.pLikesId.add(uId!);
              }
            });
            emit(AppLikePostSuccessState());
          })
          .catchError((error) {
            print("Error adding like: $error");
            emit(AppLikePostErrorState());
          });
      FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .update({
            'likedPosts': FieldValue.arrayUnion([pId]),
          })
          .then((value) {
            userModel!.likedPosts.add(pId);
            emit(AppAddUserLikedSuccessState());
          })
          .catchError((error) {
            print(error.toString());
            emit(AppAddUserLikedErrorState());
          });
    }
  }

  void verifyAccount(context) {
    FirebaseAuth.instance.currentUser!
        .sendEmailVerification()
        .then((value) {
          errorMessage(context, "Check Your Email", true);
          emit(AppUserVerifySuccessState());
        })
        .catchError((error) {
          errorMessage(context, error.toString(), false);
          emit(AppUserVerifyErrorState(error));
        });
  }

  void checkVerify(context) {
    FirebaseAuth.instance.currentUser!.reload().then((value) {
      if (FirebaseAuth.instance.currentUser!.emailVerified) {
        userModel!.isEmailVerified = true;
        FirebaseFirestore.instance.collection('users').doc(uId).update({
          'isEmailVerified': true,
        });
        errorMessage(context, "Email Verified", true);
        emit(AppUserVerifySuccessState());
      } else {
        errorMessage(context, "Check your email then Login again", false);
        emit(AppUserVerifyErrorState("Verify Your Email"));
      }
    });
  }

  int currentIndex = 0;
  List<Screens> screensData = [
    Screens(
      title: 'Feeds',
      icon: Icon(Icons.home_outlined),
      screen: FeedsScreen(),
    ),
    Screens(
      title: 'Chats',
      icon: Icon(Icons.chat_bubble_outline),
      screen: ChatsScreen(),
    ),
    Screens(
      title: 'New Post',
      icon: Icon(Icons.add_circle_outline),
      screen: NewPostScreen(),
    ),
    Screens(
      title: 'Users',
      icon: Icon(Icons.location_on_outlined),
      screen: UsersScreen(),
    ),
    Screens(
      title: 'Settings',
      icon: Icon(Icons.settings_outlined),
      screen: SettingsScreen(),
    ),
  ];
  void changeIndex(int index) {
    if (index == 2) {
      emit(AppNewPostState());
    } else {
      if (index == 0) {
        getPostData();
      }
      if (index == 1) {
        getChats();
      }
      if (index == 3) {
        getUsersData();
      }
      if (index == 4) {
        getUserData();
      }
      currentIndex = index;
      emit(AppChangeBottomNavState(index));
    }
  }

  void logout(context) {
    uId = null;
    CacheHelper.removeData(key: 'uId');
    navigateTo(context, LoginScreen());
    currentIndex = 0;
    emit(AppLogoutState());
  }

  File? profileImage;
  var profilePickedImage;
  Future pickProfileImageFromGallery() async {
    profilePickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (profilePickedImage != null) {
      profileImage = File(profilePickedImage.path);
      emit(AppProfileImagePickedSuccessState());
    } else {
      print("No Image Selected");
      emit(AppProfileImagePickedErrorState());
    }
  }

  File? coverImage;
  var coverPickedImage;
  Future pickCoverImageFromGallery() async {
    coverPickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (coverPickedImage != null) {
      coverImage = File(coverPickedImage.path);
      emit(AppCoverImagePickedSuccessState());
    } else {
      print("No Image Selected");
      emit(AppCoverImagePickedErrorState());
    }
  }

  void updateUserData(name, bio, context) {
    emit(AppUpdateUserDataLoadingState());

    if (profileImage != null) {
      emit(AppUploadProfileImageLoadingState());
      pickAndUploadImage(profilePickedImage, profileImage, 'users_photos/$uId')
          .then((value) {
            print("Profile Image Uploaded");
            FirebaseFirestore.instance.collection('users').doc(uId).update({
              'image': value,
            });
            userModel!.image = value;
            emit(AppUploadProfileImageSuccessState());
          })
          .catchError((error) {
            print("Error Uploading Profile Image: $error");
            emit(AppUploadProfileImageErrorState(error));
          });
    }
    if (coverImage != null) {
      emit(AppUploadCoverImageLoadingState());
      pickAndUploadImage(coverPickedImage, coverImage, "users_photos/$uId")
          .then((value) {
            print("Cover Image Uploaded");
            FirebaseFirestore.instance.collection('users').doc(uId).update({
              'cover': value,
            });
            userModel!.cover = value;
            emit(AppUploadCoverImageSuccessState());
          })
          .catchError((error) {
            print("Error Uploading Profile Image: $error");
            emit(AppUploadCoverImageErrorState(error));
          });
    }
    if (name != userModel!.name || bio != userModel!.bio) {
      FirebaseFirestore.instance.collection('users').doc(uId).update({
        'name': name,
        'bio': bio,
      });
      userModel!.name = name;
      userModel!.bio = bio;
    }

    currentIndex = 4;
    navigateTo(context, AppLayout());
    errorMessage(context, "Updated", true);
    emit(AppUserUpdateSuccessState());
  }

  File? postImage;
  var postPickedImage;
  Future pickPostImageFromGallery() async {
    postPickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (postPickedImage != null) {
      postImage = File(postPickedImage.path);
      emit(AppPostImagePickedSuccessState());
    } else {
      print("No Image Selected");
      emit(AppPostImagePickedErrorState());
    }
  }

  PostModel? postModel;

  void createPost({
    required String pId,
    required String pText,
    required String pImage,
  }) {
    postModel = PostModel(
      pId: pId,
      pText: pText,
      pImage: pImage,
      pDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      pTime: DateFormat('HH:mm:ss').format(DateTime.now()),
      uId: userModel!.uId,
      uName: userModel!.name,
      uImage: userModel!.image,
      uVerifed: userModel!.isVerified,
      pComments: 0,
      pLikes: 0,
      pShares: 0,
      pLikesId: [],
      pCommentsId: [],
      pSharesId: [],
    );
  }

  void uploadPost(pText, context) async {
    emit(AppUpdateUserDataLoadingState());
    String pId = FirebaseFirestore.instance.collection('posts').doc().id;
    File? copyOfPostImage = postImage;
    createPost(pId: pId, pText: pText, pImage: "");
    userModel!.uPosts.add(pId);
    FirebaseFirestore.instance.collection('users').doc(uId).update({
      'uPosts': FieldValue.arrayUnion([pId]),
    });
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(pId)
        .set(postModel!.toMap())
        .then((value) {})
        .catchError((error) {
          print(error.toString());
        });

    if (copyOfPostImage != null) {
      pickAndUploadImage(postPickedImage, copyOfPostImage, 'post_photos/$pId')
          .then((value) {
            print("Post Image Uploaded");
            FirebaseFirestore.instance.collection('posts').doc(pId).update({
              'pImage': value,
            });
            postModel!.pImage = value;
            emit(AppUploadPostImageSuccessState());
          })
          .catchError((error) {
            print("Error Uploading Post Image: $error");
            emit(AppUploadPostImageErrorState(error));
          });
    }

    currentIndex = 0;
    navigateTo(context, AppLayout());
    postImage = null;
    errorMessage(context, "Post Submitted", true);
  }

  void sendMessage({
    required String senderId,
    required String receiverId,
    required String text,
  }) async {
    emit(AppSendMessageLoadingState());

    try {
      String messageId = FirebaseFirestore.instance.collection('temp').doc().id;

      String dateTime = DateTime.now().toString();
      String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
      String time = DateFormat('HH:mm:ss').format(DateTime.now());

      Map<String, dynamic> messageData = {
        'mId': messageId,
        'sId': senderId,
        'rId': receiverId,
        'text': text,
        'dateTime': dateTime,
        'date': date,
        'time': time,
      };

      // Ensure the sender's chats document has a field
      await FirebaseFirestore.instance
          .collection('users')
          .doc(senderId)
          .collection('chats')
          .doc(receiverId)
          .set({
            'lastMessageTime': dateTime,
            'lastMessageText': text,
          }, SetOptions(merge: true));

      // Add the message under sender's chats
      await FirebaseFirestore.instance
          .collection('users')
          .doc(senderId)
          .collection('chats')
          .doc(receiverId)
          .collection('messages')
          .doc(messageId)
          .set(messageData);

      // Ensure the receiver's chats document has a field
      await FirebaseFirestore.instance
          .collection('users')
          .doc(receiverId)
          .collection('chats')
          .doc(senderId)
          .set({
            'lastMessageTime': dateTime,
            'lastMessageText': text,
          }, SetOptions(merge: true));

      // Add the message under receiver's chats
      await FirebaseFirestore.instance
          .collection('users')
          .doc(receiverId)
          .collection('chats')
          .doc(senderId)
          .collection('messages')
          .doc(messageId)
          .set(messageData);

      emit(AppSendMessageSuccessState());
      print("Message sent: $messageId from $senderId to $receiverId");
    } catch (error) {
      emit(AppSendMessageErrorState(error.toString()));
      print("Error sending message: $error");
    }
  }

  UserChatsModel? userChats;

  Future<void> getChats() async {
    emit(AppGetChatsLoadingState());
    try {
      CollectionReference chatsRef = FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .collection('chats');

      QuerySnapshot chatSnapshot = await chatsRef.get();

      Map<String, dynamic> chatData = {};
      for (var chatDoc in chatSnapshot.docs) {
        String otherUserId = chatDoc.id;
        Map<String, dynamic> chatFields =
            chatDoc.data() as Map<String, dynamic>;

        // Fetch messages for this chat
        QuerySnapshot messagesSnapshot =
            await chatsRef.doc(otherUserId).collection('messages').get();
        Map<String, dynamic> messagesMap = {};
        for (var messageDoc in messagesSnapshot.docs) {
          messagesMap[messageDoc.id] = messageDoc.data();
        }
        chatFields['messages'] = messagesMap;
        chatData[otherUserId] = chatFields;
      }

      userChats = UserChatsModel.fromFirestore(uId!, chatData);
      print('Fetched chats: ${userChats!.chats}');
      emit(AppGetChatsSuccessState());
    } catch (e) {
      print('Error fetching chats: $e');
      emit(AppGetChatsErrorState('Failed to load chats: $e'));
    }
  }
}
