// ignore_for_file: unused_local_variable

import 'package:chatbot_app_project/chatBot_project/initial_test_module/welcome_text_screen.dart';
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, authSnapshot) {
          if (authSnapshot.hasData) {
            return FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('Users')
                  .where('email', isEqualTo: authSnapshot.data!.email)
                  .limit(1)
                  .get(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.done) {
                  if (userSnapshot.data != null && userSnapshot.data!.docs.isNotEmpty) {
                    Map<String, dynamic> userData =
                        userSnapshot.data!.docs.first.data() as Map<String, dynamic>;
                    
                    bool isStarts = userData['isStarts'] ?? false;
                    String role = userData['role'] ?? '';

                    if (!isStarts) {
                      return const WelcomingTestScreen(); 
                    }

                    return MainAppNavigation(); 
                  } else {
                    return const OnboardingScreen();
                  }
                } else if (userSnapshot.hasError) {
                  return Center(child: Text('Error: ${userSnapshot.error}'));
                }
                return const Center(child: CircularProgressIndicator());
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
