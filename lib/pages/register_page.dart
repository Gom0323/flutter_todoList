import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatelessWidget {
  final TextEditingController _useridController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  void _register(BuildContext context) async {
    final response = await http.post(
      Uri.parse('http://192.168.0.31:3001/api/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userid': _useridController.text,
        'password': _passwordController.text,
        'email': _emailController.text,
      }),
    );

    if (response.statusCode == 201) {
      Navigator.pop(context);
    } else {
      // Handle error
      print('Failed to register: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _useridController,
              decoration: InputDecoration(labelText: 'Userid'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _register(context),
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
