import 'package:chatbot_app_project/auth/signin_screen.dart';
import 'package:chatbot_app_project/firebase/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:uuid/uuid.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  UserDataReferance userDataReferance = UserDataReferance();
  bool _obscureText = true;
  bool _obscureText1 = true;
  String? selectedRoleValue = "Role";
  final List<String> dropdownRoleItems = [
    'Role',
    'Student',
    'Teacher',
    'Parent'
  ];
  String? selectedGenderValue = "Gender";
  final List<String> dropdownGenderItems = [
    'Gender',
    'Male',
    'Female',
    'Others'
  ];

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUpUser() async {
    if (!_formKey.currentState!.validate()) {
      return; // Form is invalid
    }

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (password != _confirmPasswordController.text.trim()) {
      Get.showSnackbar(
        GetSnackBar(
          isDismissible: true,
          backgroundColor: Colors.red,

          title: "Error!",
          message: "Passwords do not match",
          duration: Duration(seconds: 3), // Duration the snackbar is visible
        ),
      );

      return;
    }

    try {
      // Firebase Authentication
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .whenComplete(() {
        userDataReferance.addUser(
            name: _nameController.text,
            email: email,
            contactNumber: _numberController.text,
            gender: selectedGenderValue.toString(),
            profilePicUrl: '',
            role: selectedRoleValue.toString());
      }).whenComplete(() {
        Get.to(() => SigninScreen()); // Navigate to the Sign-in screen
        Get.snackbar(
          "Success",
          "Account created successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      });
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
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
                    horizontal: (totalWidth > 800) ? 40 : 24,
                    vertical: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      Center(
                        child: Text(
                          "AURAMEMO",
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(14.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Text(
                                'Sign up',
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Register Please enter your details',
                              ),
                              const SizedBox(height: 15),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "userName",
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _usernameController,
                                    cursorColor: Colors.amberAccent,
                                    decoration: const InputDecoration(
                                      prefixIconColor: Colors.blueGrey,
                                      prefixIcon: Icon(
                                        Icons.email,
                                        size: 24,
                                      ),
                                      hintText: 'Enter your userName',
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Name",
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _nameController,
                                    cursorColor: Colors.amberAccent,
                                    decoration: const InputDecoration(
                                      prefixIconColor: Colors.blueGrey,
                                      prefixIcon: Icon(
                                        Icons.email,
                                        size: 24,
                                      ),
                                      hintText: 'Enter your Name',
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Email",
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _emailController,
                                    cursorColor: Colors.amberAccent,
                                    decoration: const InputDecoration(
                                      prefixIconColor: Colors.blueGrey,
                                      prefixIcon: Icon(
                                        Icons.email,
                                        size: 24,
                                      ),
                                      hintText: 'Enter your email',
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your email';
                                      }
                                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                          .hasMatch(value)) {
                                        return 'Please enter a valid email';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    'Password',
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _passwordController,
                                    cursorColor: Colors.blue,
                                    obscureText: _obscureText,
                                    decoration: InputDecoration(
                                      prefixIconColor: Colors.blueGrey,
                                      prefixIcon: Icon(
                                        Icons.security,
                                        size: 24,
                                      ),
                                      hintText: 'Enter your password',
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscureText
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: Colors.blue,
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
                                        return 'Please enter your password';
                                      }
                                      if (value.length < 6) {
                                        return 'Password must be at least 6 characters';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    'Confirm password',
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _confirmPasswordController,
                                    cursorColor: Colors.blue,
                                    obscureText: _obscureText1,
                                    decoration: InputDecoration(
                                      prefixIconColor: Colors.blueGrey,
                                      prefixIcon: const Icon(
                                        Icons.security_update_good,
                                        size: 24,
                                      ),
                                      hintText: 'Confirm your password',
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscureText1
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: Colors.blue,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _obscureText1 = !_obscureText1;
                                          });
                                        },
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please confirm your password';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    'Contact Number',
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _numberController,
                                    cursorColor: Colors.blue,
                                    obscureText: _obscureText1,
                                    decoration: InputDecoration(
                                      prefixIconColor: Colors.blueGrey,
                                      prefixIcon: const Icon(
                                        Icons.call,
                                        size: 24,
                                      ),
                                      hintText: 'Enter your number',
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please confirm your Number';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                              const SizedBox(height: 20),
                              DropdownButton<String>(
                                value:
                                    selectedRoleValue, // The currently selected value
                                hint: Text(
                                    'Select Role'), // Hint when no value is selected
                                items: dropdownRoleItems.map((String item) {
                                  return DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(item),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedRoleValue =
                                        newValue; // Update selected value
                                  });
                                },
                                isExpanded:
                                    true, // Expands the dropdown to fit width
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                                dropdownColor: Colors.white,
                              ),
                              const SizedBox(height: 20),
                              DropdownButton<String>(
                                value:
                                    selectedGenderValue, // The currently selected value
                                hint: Text(
                                    'Select Gender'), // Hint when no value is selected
                                items: dropdownGenderItems.map((String item) {
                                  return DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(item),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedGenderValue =
                                        newValue; // Update selected value
                                  });
                                },
                                isExpanded:
                                    true, // Expands the dropdown to fit width
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                                dropdownColor: Colors.white,
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width:
                                    (totalWidth > 800) ? double.infinity : 300,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          WidgetStatePropertyAll(Colors.black),
                                      foregroundColor:
                                          WidgetStatePropertyAll(Colors.white)),
                                  onPressed: () {
                                    if (selectedRoleValue == 'Role' ||
                                        selectedGenderValue == 'Gender') {
                                      Get.snackbar(
                                        "Error",
                                        'check role and gender',
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: Colors.red,
                                        colorText: Colors.white,
                                      );
                                    } else {
                                      _signUpUser();
                                    }
                                  },
                                  child: const Text('Sign up'),
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
                                    'Already have an account?',
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Get.to(() => SigninScreen());
                                    },
                                    child: Text(
                                      'Sign In',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
