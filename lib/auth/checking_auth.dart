import 'package:chatbot_app_project/chatBot_project/navigation_section/main_app_navigation.dart';
import 'package:chatbot_app_project/onboarding/onboarding_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CheckingAuth extends StatefulWidget {
  const CheckingAuth({super.key});

  @override
  State<CheckingAuth> createState() => _CheckingAuthState();
}

class _CheckingAuthState extends State<CheckingAuth> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('Users')
                  .where('email', isEqualTo: snapshot.data!.email)
                  .limit(1)
                  .get(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data != null && snapshot.data!.docs.isNotEmpty) {
                    Map<String, dynamic> userData = snapshot.data!.docs.first
                        .data() as Map<String, dynamic>;
                    String role = userData['role'];
                    if (role == 'Student') {
                      return const MainAppNavigation();
                    } else if (role == 'Teacher') {
                      return const MainAppNavigation();
                    } else if (role == 'Parents') {
                      return const MainAppNavigation();
                    }
                  } else {
                    return const OnboardingScreen();
                  }
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                return Center(
                    child: ElevatedButton(
                  onPressed: () => FirebaseAuth.instance.signOut(),
                  child: Text("out"),
                ));
              },
            );
          } else {
            return const OnboardingScreen();
          }
        },
      ),
    );
  }
}
