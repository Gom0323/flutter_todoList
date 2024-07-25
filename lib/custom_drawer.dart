import 'package:flutter/material.dart';
import 'package:tj_pjt/pages/my_page.dart';
import 'calendar_screen.dart';
import 'diary_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My App',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '집에가고싶다',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('To-do List'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CalendarScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text('Diary'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DiaryScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('My Page'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
