import 'package:flutter/material.dart';
import './custom_drawer.dart'; // import custom_drawer.dart file

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TestView(),
    );
  }
}

class TestView extends StatefulWidget {
  const TestView({super.key});

  @override
  State<TestView> createState() => _TestViewState();
}

class _TestViewState extends State<TestView> {
  bool isLightTheme = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isLightTheme ? Colors.white : Colors.black,
      appBar: AppBar(
        title: Text("Test Title"),
      ),
      drawer: const CustomDrawer(), // Use CustomDrawer
      body: Center(
        child: Text(
          'Current theme is ${isLightTheme ? "Light" : "Dark"}',
          style: TextStyle(color: isLightTheme ? Colors.black : Colors.white),
        ),
      ),
    );
  }
}
