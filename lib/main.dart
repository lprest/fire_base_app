import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  var db = FirebaseFirestore.instance;
  // Create a new user with a first and last name
  final user = <String, dynamic>{
    "first": "Ada",
    "last": "Lovelace",
    "born": 1815
  };

// Add a new document with a generated ID
  db.collection("users").add(user).then((DocumentReference doc) =>
      print('DocumentSnapshot added with ID: ${doc.id}'));

  await db.collection("users").get().then((event) {
    for (var doc in event.docs) {
      print("${doc.id} => ${doc.data()}");
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Connection Test',
      home: const FirebaseCheckPage(),
    );
  }
}

class FirebaseCheckPage extends StatefulWidget {
  const FirebaseCheckPage({super.key});

  @override
  State<FirebaseCheckPage> createState() => _FirebaseCheckPageState();
}

class _FirebaseCheckPageState extends State<FirebaseCheckPage> {
  String _statusMessage = 'Checking Firebase connection...';

  @override
  void initState() {
    super.initState();
    _checkFirebase();
  }

  Future<void> _checkFirebase() async {
    try {
      await Firebase.initializeApp();
      await FirebaseFirestore.instance.collection('test').add({'connected': true});
      setState(() {
        _statusMessage = '✅ Firebase is connected and writing to Firestore!';
      });
    } catch (e) {
      setState(() {
        _statusMessage = '❌ Firebase connection failed: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firebase Status')),
      body: Center(
        child: Text(
          _statusMessage,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
