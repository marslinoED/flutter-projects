import 'dart:io';
import 'package:image_picker/image_picker.dart'; // image_picker: ^1.0.8

// andriod manifest
/*
<mainfest>
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.CAMERA"/>
    <uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>

    <application>
    ....
    </application>
    ....
</mainfest>
*/

File? selectedImage;

Future pickImageFromGallery() async {
  final pickedImage = await ImagePicker().pickImage(
    source: ImageSource.gallery,
  );
  // set state
  if (pickedImage != null) {
    selectedImage = File(pickedImage.path);
  }
}

Future pickImageFromCamera() async {
  final pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);

  // set state
  if (pickedImage != null) {
    selectedImage = File(pickedImage.path);
  }
}
