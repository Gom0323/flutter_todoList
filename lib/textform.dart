import 'package:flutter/material.dart';

class Textform extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onAdd;

  const Textform({super.key, required this.controller, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: '할 일 추가',
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: onAdd,
          ),
        ],
      ),
    );
  }
}
