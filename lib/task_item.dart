import 'package:flutter/material.dart';

class TaskItem extends StatelessWidget {
  final Map<String, dynamic> task;
  final Function(int) onDelete;
  final Function(Map<String, dynamic>) onEdit;
  final Function(int, bool) onToggle;

  const TaskItem({
    required this.task,
    required this.onDelete,
    required this.onEdit,
    required this.onToggle,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int taskId = task['id'] is int ? task['id'] : int.parse(task['id']);
    bool isCompleted = task['isCompleted'] == 1;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        elevation: 4,
        child: ListTile(
          leading: Checkbox(
            value: isCompleted,
            onChanged: (bool? value) {
              onToggle(taskId, value!);
            },
          ),
          title: Text(
            task['task'],
            style: TextStyle(
              decoration: isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  onEdit(task);
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  onDelete(taskId);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
