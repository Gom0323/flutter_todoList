import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'dart:io';

import 'package:tj_pjt/calendar_screen.dart';
import 'package:tj_pjt/diary_screen.dart';

class MyPage extends StatefulWidget {
  final String? cookies;

  const MyPage({super.key, this.cookies});

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  File? _image;
  String? _imageUrl;
  final picker = ImagePicker();
  late Dio dio;

  @override
  void initState() {
    super.initState();
    dio = Dio(BaseOptions(
      baseUrl: 'http://192.168.0.31:3001',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    if (widget.cookies != null) {
      dio.options.headers['cookie'] = widget.cookies!;
    }

    _loadProfilePicture();
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      await _uploadProfilePicture(_image!);
    }
  }

  Future<void> _uploadProfilePicture(File image) async {
    final formData = FormData.fromMap({
      'profile_picture':
          await MultipartFile.fromFile(image.path, filename: 'profile.jpg'),
    });

    try {
      final response =
          await dio.post('/api/upload_profile_picture', data: formData);
      if (response.statusCode == 200) {
        print('Profile picture uploaded successfully');
        _loadProfilePicture(); // 업로드 후 이미지 다시 로드
      } else {
        print('Failed to upload profile picture');
        print('Response data: ${response.data}');
      }
    } catch (e) {
      print('Failed to upload profile picture');
      print('Error: $e');
    }
  }

  Future<void> _loadProfilePicture() async {
    try {
      final response = await dio.get('/api/profile_picture');
      if (response.statusCode == 200) {
        final data = response.data;
        print('Profile picture URL: ${data['path']}');
        setState(() {
          _imageUrl = data['path'];
        });
      } else {
        print('Failed to load profile picture');
        print('Response status code: ${response.statusCode}');
        print('Response data: ${response.data}');
      }
    } catch (e) {
      print('Failed to load profile picture');
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                backgroundImage:
                    _imageUrl != null ? NetworkImage(_imageUrl!) : null,
                child: _imageUrl == null
                    ? const Icon(Icons.add_a_photo,
                        size: 50, color: Colors.white)
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CalendarScreen()),
                );
              },
              icon: const Icon(Icons.today),
              label: const Text('오늘 할일'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                minimumSize: const Size(200, 50),
                backgroundColor: Colors.blue,
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DiaryScreen()),
                );
              },
              icon: const Icon(Icons.book),
              label: const Text('오늘의 일기'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
                minimumSize: const Size(200, 50),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
