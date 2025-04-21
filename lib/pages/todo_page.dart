import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/task_service.dart';
import '../widgets/task_tile.dart';

class ToDoPage extends StatefulWidget {
  const ToDoPage({super.key});

  @override
  State<ToDoPage> createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  final TextEditingController _controller = TextEditingController();

  void _handleAddTask() {
    if (_controller.text.trim().isEmpty) return;
    TaskService.addTask(_controller.text.trim());
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: const Text('My To-Do List'),
        centerTitle: true,
        backgroundColor: Colors.yellow,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          labelText: 'Add a new task',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle, color: Colors.yellow),
                      onPressed: _handleAddTask,
                      tooltip: 'Add Task',
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: StreamBuilder<QuerySnapshot>(
                stream: TaskService.getTaskStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('Error loading tasks. Booooooo'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data!.docs;

                  if (docs.isEmpty) {
                    return const Center(
                      child: Text(
                        'All tasks done! Yippee!!!',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      return TaskTile(doc: doc);
                    },
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}