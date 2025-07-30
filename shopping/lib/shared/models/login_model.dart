class LoginModel {
  late bool status;
  String? message;
  UserData? data;

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new UserData.fromJson(json['data']) : null;
  }
}

class UserData {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? image;
  int? points;
  int? credit;
  String? token;

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? 'Unknown';
    email = json['email'] ?? '';  // Provide empty string if null
    phone = json['phone'] ?? 'No Phone';
    image = json['image'] ?? 'https://default-user-image.com';
    points = json['points'] ?? 0;
    credit = json['credit'] ?? 0;
    token = json['token'] ?? '';
  }
}

