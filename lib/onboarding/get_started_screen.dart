import 'package:chatbot_app_project/auth/signin_screen.dart';
import 'package:chatbot_app_project/auth/signup_screen.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  @override
  Widget build(BuildContext context) {
    // final totalHeight = MediaQuery.of(context).size.height;
    final totalWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(totalWidth * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Text(
                "AURAMEMO",
              ),
              const SizedBox(height: 30),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  height: 300,
                  "assets/images/splash3.png",
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Let's Started",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                "Easily discover the best turfs around your location. Filter by price, facilities, and availability.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.black),
                          foregroundColor:
                              WidgetStatePropertyAll(Colors.white)),
                      onPressed: () {
                        Get.to(() => SigninScreen());
                      },
                      child: Text("Sign in"))),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.black),
                      foregroundColor: WidgetStatePropertyAll(Colors.white)),
                  onPressed: () {
                    Get.to(() => SignupScreen());
                  },
                  child: const Text(
                    "Sign up",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
