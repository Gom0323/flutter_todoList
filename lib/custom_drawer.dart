import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text("안녕하세요"),
          ),
          ListTile(
            title: const Text("Menu 1"),
            onTap: () {
              // Do something for Menu 1
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            title: const Text("Menu 2"),
            onTap: () {
              // Do something for Menu 2
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            title: const Text("Menu 3"),
            onTap: () {
              // Do something for Menu 3
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            title: const Text("Menu 4"),
            onTap: () {
              // Do something for Menu 4
              Navigator.pop(context); // Close the drawer
            },
          ),
          // Add more ListTile widgets as needed
        ],
      ),
    );
  }
}
