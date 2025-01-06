import 'package:chatbot_app_project/auth/checking_auth.dart';
import 'package:chatbot_app_project/auth/signup_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscureText = true;
  bool _isChecked = false;

  Future<void> signin(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password)
            .then((userCredential) async {
          String uid = userCredential.user!.uid;

          final userDocRef =
              FirebaseFirestore.instance.collection('Users').doc(uid);
          debugPrint('-----Sign-in Successful-----');

          final userDoc = await userDocRef.get();
          if (!userDoc.exists) {
            debugPrint('----------');
          } else {
            debugPrint('-----User data already exists in Firestore-----');
          }

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const CheckingAuth(),
            ),
          );
        });
      } on FirebaseAuthException catch (e) {
        String errorMessage = '';
        if (e.code == 'user-not-found') {
          errorMessage =
              'User not located. Please verify the details and try again.';
        } else if (e.code == 'wrong-password') {
          errorMessage =
              'Access denied. The password you provided is incorrect.';
        } else {
          errorMessage = 'Email or Password invalid.';
        }
        showErrorSnackBar(errorMessage);
      }
    }
  }

  void showErrorSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      elevation: 10,
      duration: const Duration(seconds: 4),
      action: SnackBarAction(label: 'Close', onPressed: () {}),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final double totalWidth = MediaQuery.of(context).size.width;
    final double totalHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: totalWidth > 800 ? 40 : 24,
                    vertical: 24,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "AURAMEMO",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Container(
                          padding: const EdgeInsets.all(14.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Sign In',
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Welcome back! Please enter your details.',
                              ),
                              const SizedBox(height: 15),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Email",
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _emailController,
                                    cursorColor: Colors.blue,
                                    decoration: const InputDecoration(
                                      prefixIcon: Icon(
                                        FluentIcons.mail_16_regular,
                                        size: 24,
                                      ),
                                      hintText: 'Enter your email',
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your email.';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    "Password",
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: _obscureText,
                                    cursorColor: Colors.blue,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        FluentIcons.lock_closed_16_regular,
                                        size: 24,
                                      ),
                                      hintText: 'Enter your password',
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscureText
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _obscureText = !_obscureText;
                                          });
                                        },
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your password.';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: _isChecked,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                _isChecked = value ?? false;
                                              });
                                            },
                                          ),
                                          Text(
                                            'Remember me',
                                          ),
                                        ],
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Get.toNamed("/forgotpassword");
                                        },
                                        child: Text(
                                          'Forgot password?',
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: totalWidth > 800 ? double.infinity : 300,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          WidgetStatePropertyAll(Colors.black),
                                      foregroundColor:
                                          WidgetStatePropertyAll(Colors.white)),
                                  onPressed: () {
                                    signin(
                                      _emailController.text.trim(),
                                      _passwordController.text.trim(),
                                    );
                                  },
                                  child: const Text('Sign In'),
                                ),
                              ),
                              const SizedBox(height: 15),
                              Row(
                                children: [
                                  Expanded(
                                      child: Divider(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface)),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      'OR',
                                    ),
                                  ),
                                  Expanded(
                                      child: Divider(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface)),
                                ],
                              ),
                              const SizedBox(height: 23),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Don’t have an account?',
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Get.to(() => SignupScreen());
                                    },
                                    child: Text(
                                      'Sign up',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
