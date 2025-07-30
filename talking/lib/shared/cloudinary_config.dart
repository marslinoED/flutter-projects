import 'dart:io';
import 'package:dio/dio.dart';

class CloudinaryUploader {
  final String cloudName = "dc58nkzwh"; // Your Cloudinary cloud name
  final String uploadPreset = "users_photos"; // Your Cloudinary upload preset

  Future<String?> uploadImage(File imageFile, folderName) async {
    try {
      String url = "https://api.cloudinary.com/v1_1/$cloudName/image/upload";

      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(imageFile.path),
        'folder': folderName, // Optional folder name in Cloudinary
        "upload_preset": uploadPreset, // Needed for unsigned uploads
      });

      Response response = await Dio().post(url, data: formData);

      if (response.statusCode == 200) {
        return response.data["secure_url"]; // Cloudinary image URL
      } else {
        print("Upload failed: ${response.statusMessage}");
      }
    } catch (e) {
      print("Error uploading: $e");
    }
    return null;
  }
}

Future<String> pickAndUploadImage(picker, Image, folderName) async {
  if (Image != null) {
    File imageFile = File(Image.path);
    CloudinaryUploader uploader = CloudinaryUploader();

    String? imageUrl = await uploader.uploadImage(imageFile, folderName);
    if (imageUrl != null) {
      return imageUrl;
    } else {
      print("Image upload failed.");
    }
  }
  return "";
}
