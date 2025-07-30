import 'dart:io';
import 'package:image_picker/image_picker.dart'; 

// Removed global variable as we'll manage state locally in AppLayout
// File? selectedImage;

Future<File?> pickImageFromGallery() async {
  final pickedImage = await ImagePicker().pickImage(
    source: ImageSource.gallery,
  );
  if (pickedImage != null) {
    return File(pickedImage.path);
  }
  return null;
}