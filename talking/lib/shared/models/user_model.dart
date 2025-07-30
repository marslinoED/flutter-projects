class UserModel {
  late String uId;
  late String name;
  late String email;
  late String phone;
  late String image;
  late String cover;
  late String bio;
  late bool isVerified;
  late bool isEmailVerified;
  List<String> uPosts; // Mutable list
  List<String> likedPosts; // Mutable list

  UserModel({
    required this.uId,
    required this.name,
    required this.email,
    required this.phone,
    required this.image,
    required this.cover,
    required this.bio,
    required this.isVerified,
    required this.isEmailVerified,
    List<String>? uPosts, // Optional, defaults to empty mutable list
    List<String>? likedPosts, // Optional, defaults to empty mutable list
  }) : uPosts = uPosts ?? [], // Use null-coalescing to provide mutable default
       likedPosts =
           likedPosts ?? []; // Use null-coalescing to provide mutable default

  UserModel.fromJson(Map<String, dynamic> json)
    : uPosts = [], // Initialize as empty mutable list
      likedPosts = [] {
    // Initialize as empty mutable list
    uId = json['uId'] as String;
    name = json['name'] as String;
    email = json['email'] as String;
    phone = json['phone'] as String;
    image = json['image'] as String;
    cover = json['cover'] as String;
    bio = json['bio'] as String;
    isVerified = json['isVerified'] as bool;
    isEmailVerified = json['isEmailVerified'] as bool;

    // Safely handle uPosts
    if (json['uPosts'] != null && json['uPosts'] is List) {
      uPosts = List<String>.from(json['uPosts']);
    }

    // Safely handle likedPosts
    if (json['likedPosts'] != null && json['likedPosts'] is List) {
      likedPosts = List<String>.from(json['likedPosts']);
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'name': name,
      'email': email,
      'phone': phone,
      'image': image,
      'cover': cover,
      'bio': bio,
      'isVerified': isVerified,
      'isEmailVerified': isEmailVerified,
      'uPosts': uPosts,
      'likedPosts': likedPosts,
    };
  }
}
