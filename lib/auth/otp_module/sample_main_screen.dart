import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SampleMainScreen extends StatefulWidget {
  const SampleMainScreen({super.key});

  @override
  State<SampleMainScreen> createState() => _SampleMainScreenState();
}

class _SampleMainScreenState extends State<SampleMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            child: Text("Out")),
      ),
    );
  }
}
