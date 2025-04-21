import 'package:cloud_firestore/cloud_firestore.dart';

class TaskService {
  static final CollectionReference tasks =
  FirebaseFirestore.instance.collection('tasks');

  static Future<void> addTask(String task) async {
    if (task.trim().isEmpty) return;
    await tasks.add({
      'task': task.trim(),
      'isDone': false,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> deleteTask(String id) async {
    await tasks.doc(id).delete();
  }

  static Future<void> toggleDone(DocumentSnapshot doc) async {
    final current = doc['isDone'] as bool;
    await tasks.doc(doc.id).update({'isDone': !current});
  }

  static Stream<QuerySnapshot> getTaskStream() {
    return tasks.orderBy('timestamp', descending: true).snapshots();
  }
}