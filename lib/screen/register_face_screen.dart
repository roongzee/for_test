// register_face_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // MediaType import
import 'package:mime/mime.dart';

class RegisterFaceScreen extends StatefulWidget {
  @override
  _RegisterFaceScreenState createState() => _RegisterFaceScreenState();
}

class _RegisterFaceScreenState extends State<RegisterFaceScreen> {
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _selectedImages = [];

  Future<void> _pickImages() async {
    final pickedFiles = await _picker.pickMultiImage(
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 80,
    );

    if (pickedFiles != null && pickedFiles.length <= 20) {
      setState(() {
        _selectedImages = pickedFiles;
      });
    } else if (pickedFiles != null && pickedFiles.length > 20) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You can select up to 20 images.')),
      );
    }
  }

  Future<void> _uploadImages() async {
    if (_selectedImages == null || _selectedImages!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select some images first.')),
      );
      return;
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://localhost:8000/api/users/register_face/'), // Django 백엔드 API URL
    );

    for (var image in _selectedImages!) {
      var mimeType = lookupMimeType(image.path);
      var mediaType = mimeType != null ? MediaType.parse(mimeType) : null;
      request.files.add(await http.MultipartFile.fromPath(
        'faces', // 이 키는 Django에서 파일을 받을 때 사용해야 하는 키입니다.
        image.path,
        contentType: mediaType,
      ));
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Face registration successful.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Face registration failed.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Face'),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _pickImages,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: Text('Select Images', style: TextStyle(fontSize: 18)),
            ),
            SizedBox(height: 20),
            _selectedImages != null && _selectedImages!.isNotEmpty
                ? Text('${_selectedImages!.length} images selected')
                : Text('No images selected'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadImages,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: Text('Upload Images', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}