import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mime/mime.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  String? _prediction;
  double? _confidence;
  bool _isLoading = false;

  // Function to pick image from gallery
  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          _prediction = null; // Reset prediction
          _confidence = null; // Reset confidence
        });
        await _predictImage(_image!); // Call API to predict
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  // Function to send image to API and get prediction
  Future<void> _predictImage(File image) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://web-production-60ce4.up.railway.app/predict'),
      );
      final mimeType = lookupMimeType(image.path);
      final typeSplit = mimeType?.split('/') ?? ['image', 'jpeg'];

      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          image.path,
          contentType: MediaType(typeSplit[0], typeSplit[1]),
        ),
      );

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final result = jsonDecode(responseBody);
        setState(() {
          _prediction = result['class']; // 'Bird' or 'Forest'
          _confidence = result['confidence'] * 100; // Convert to percentage
        });
      } else {
        setState(() {
          _prediction = 'Error';
          _confidence = null;
        });
        print('API error: $responseBody');
      }
    } catch (e) {
      setState(() {
        _prediction = 'Error';
        _confidence = null;
      });
      print('Error predicting image: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color.fromRGBO(252, 253, 255, 1),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(252, 253, 255, 1),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.2),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: const Text(
                  'Is it a Bird? 🐥\nOr it is just a Tree. 🌳',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(0, 0, 0, 1),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 3),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(500),
                  child:
                      _image != null
                          ? Image.file(
                            _image!,
                            width: 250,
                            height: 250,
                            fit: BoxFit.cover,
                          )
                          : Image.asset(
                            'assets/temp.gif',
                            width: 250,
                            height: 250,
                            fit: BoxFit.cover,
                          ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _pickImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Upload your Local Image 🌳',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              if (_image != null) ...[
                const SizedBox(height: 30),
                _isLoading
                    ? const CircularProgressIndicator()
                    : Text(
                      _prediction != null
                          ? "I see a $_prediction ${_prediction == 'Bird' ? '🐦' : '🌳'}\nConfidence: ${_confidence?.toStringAsFixed(0)}%"
                          : 'Processing...',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(0, 0, 0, 1),
                      ),
                      textAlign: TextAlign.center,
                    ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _image = null;
                      _prediction = null;
                      _confidence = null;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Clear Image 🧹',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
