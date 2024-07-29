import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late Dio dio;

  @override
  void initState() {
    super.initState();
    dio = Dio(BaseOptions(
      baseUrl: 'http://192.168.0.27:3001',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {
        'Content-Type': 'application/json',
      },
    ));
  }

  Future<void> _login() async {
    final String userId = _userIdController.text;
    final String password = _passwordController.text;

    try {
      final response = await dio.post('/api/login', data: {
        'userid': userId,
        'password': password,
      });

      if (response.statusCode == 200) {
        final cookies = response.headers.map['set-cookie'];
        if (cookies != null) {
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('cookies', cookies.join(';'));
          Navigator.pushReplacementNamed(context, '/mypage');
        } else {
          print('Login successful, but no cookies received');
        }
      } else {
        print('Failed to login');
        print('Response data: ${response.data}');
      }
    } catch (e) {
      print('Failed to login');
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _userIdController,
              decoration: const InputDecoration(labelText: 'User ID'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
