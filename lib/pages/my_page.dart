import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'login_page.dart';

class MyPage extends StatelessWidget {
  void _logout(BuildContext context) async {
    final response = await http.get(
      Uri.parse('http://192.168.0.31:3001/api/logout'),
    );

    if (response.statusCode == 200) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      // Handle error
      print('Failed to logout: ${response.body}');
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
            Text('Welcome to My Page!'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _logout(context),
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
