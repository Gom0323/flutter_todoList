import 'package:flutter/material.dart';

class TestView extends StatefulWidget {
  const TestView({super.key});

  @override
  State<TestView> createState() => _TestViewState();
}

class _TestViewState extends State<TestView> {
  bool isLightTeme = true;
  @override
  Widget build(BuildContext context) {
    bool isLightTheme = true;
    return Scaffold(
      backgroundColor: isLightTheme ? Colors.white : Colors.black87,
      appBar: AppBar(
        title: const Text("Theme Color Test"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.pink,
              ),
              child: Text("Menu 1"),
            ),
          ],
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: () {
            setState(() {
              isLightTheme = isLightTheme == true ? false : true;
            });
          },
          child: Container(
            color: Colors.blue,
            alignment: Alignment.center,
            width: 200,
            height: 40,
            child: Text("Light/Dark Theme Button"),
          ),
        ),
      ),
    );
  }
}
