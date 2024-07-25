import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../calendar_screen.dart';
import '../diary_screen.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  File? _image;
  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                backgroundImage: _image != null ? FileImage(_image!) : null,
                child: _image == null
                    ? Icon(Icons.add_a_photo, size: 50, color: Colors.white)
                    : null,
              ),
            ),
            SizedBox(height: 20), // 프로필 사진과 버튼 사이 간격
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CalendarScreen()),
                );
              },
              icon: Icon(Icons.today), // 아이콘 추가
              label: const Text('오늘 할일'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, minimumSize: Size(200, 50),
                backgroundColor: Colors.blue, // 글자색 설정
                textStyle: TextStyle(fontSize: 18), // 텍스트 스타일 설정
              ),
            ),
            SizedBox(height: 20), // 버튼 사이에 간격 추가
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DiaryScreen()),
                );
              },
              icon: Icon(Icons.book), // 아이콘 추가
              label: const Text('오늘의 일기'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.green,
                minimumSize: Size(200, 50), // 글자색 설정
                textStyle: TextStyle(fontSize: 18), // 텍스트 스타일 설정
              ),
            ),
          ],
        ),
      ),
    );
  }
}
