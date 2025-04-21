import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/task_service.dart';

class TaskTile extends StatelessWidget {
  final DocumentSnapshot doc;

  const TaskTile({super.key, required this.doc});

  @override
  Widget build(BuildContext context) {
    final taskText = doc['task'];
    final isDone = doc['isDone'] as bool;

    return ListTile(
      leading: Checkbox(
        value: isDone,
        onChanged: (_) => TaskService.toggleDone(doc),
      ),
      title: Text(
        taskText,
        style: TextStyle(
          decoration: isDone
              ? TextDecoration.lineThrough
              : TextDecoration.none,
          color: isDone ? Colors.grey : Colors.black,
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () => TaskService.deleteTask(doc.id),
      ),
    );
  }
}