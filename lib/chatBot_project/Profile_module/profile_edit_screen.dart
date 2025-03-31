import 'package:chatbot_app_project/firebase/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileEditScreen extends StatefulWidget {
  final String docId; 

  const ProfileEditScreen({super.key, required this.docId});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();

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
  bool isprivate = false;
  UserDataReferance userDataReferance = UserDataReferance();
  bool isLoading = true;
  bool isUpdating = false;
  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.docId)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;

        setState(() {
          _usernameController.text = data['username'] ?? '';
          _nameController.text = data['name'] ?? '';
          _emailController.text = data['email'] ?? '';
          _numberController.text = data['contact_number'] ?? '';
          selectedRoleValue = data['role'] ?? 'Role';
          selectedGenderValue = data['gender'] ?? 'Gender';
          isprivate = data['private'] ?? false;
          isLoading = false;
        });
      } else {
        Get.snackbar(
          "Error",
          "User not found",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _updateUserProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      setState(() {
        isUpdating = true;
      });

      await userDataReferance
          .updateUser(
              username: _usernameController.text,
              profilePicUrl: '',
              userID: widget.docId,
              name: _nameController.text,
              gender: selectedGenderValue!,
              role: selectedRoleValue!,
              contactNumber: _numberController.text,
              private: isprivate)
          .whenComplete(
        () {
          Get.snackbar("Success", "Profile updated successfully",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white,
              animationDuration: Duration(seconds: 1));
          setState(() {
            isUpdating = false;
          });
        },
      );

      Get.snackbar(
        "Success",
        "Profile updated successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
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

    if (isLoading) {
      return Scaffold(
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            Text("Getting User Information")
          ],
        )),
      );
    }
    if (isUpdating) {
      return Scaffold(
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedPageIndicatorDot(
              activeGradient: LinearGradient(
                  colors: [Colors.blue, Colors.white, Colors.blueAccent]),
              gradient: LinearGradient(
                  colors: [Colors.blue, Colors.white, Colors.blueAccent]),
              isActive: true,
              activeHeight: 10,
              activeWidth: 200,
              height: 10,
              width: 200,
            ),
            Text("User Information Updating...")
          ],
        )),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Profile",
        ),
      ),
      body: Center(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: CircleAvatar(
                          radius: 50,
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
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _usernameController,
                                decoration: const InputDecoration(
                                  labelText: "Username",
                                  hintText: "Enter your username",
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  labelText: "Name",
                                  hintText: "Enter your name",
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  enabled: false,
                                  labelText: "Email",
                                  hintText: "Enter your email",
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
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _numberController,
                                decoration: const InputDecoration(
                                  labelText: "Contact Number",
                                  hintText: "Enter your contact number",
                                ),
                              ),
                              const SizedBox(height: 20),
                              DropdownButton<String>(
                                value: selectedRoleValue,
                                items: dropdownRoleItems.map((String item) {
                                  return DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(item),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedRoleValue = newValue;
                                  });
                                },
                                isExpanded: true,
                              ),
                              const SizedBox(height: 20),
                              DropdownButton<String>(
                                value: selectedGenderValue,
                                items: dropdownGenderItems.map((String item) {
                                  return DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(item),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedGenderValue = newValue;
                                  });
                                },
                                isExpanded: true,
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Private',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Switch.adaptive(
                                    value: isprivate,
                                    onChanged: (value) => setState(() {
                                      isprivate = value;
                                    }),
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                onPressed: _updateUserProfile,
                                child: const Text("Update Profile"),
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

class AnimatedPageIndicatorFb1 extends StatelessWidget {
  const AnimatedPageIndicatorFb1(
      {super.key,
      required this.currentPage,
      required this.numPages,
      this.dotHeight = 10,
      this.activeDotHeight = 10,
      this.dotWidth = 10,
      this.activeDotWidth = 20,
      this.gradient =
          const LinearGradient(colors: [Color(0xff4338CA), Color(0xff6D28D9)]),
      this.activeGradient =
          const LinearGradient(colors: [Color(0xff4338CA), Color(0xff6D28D9)])});

  final int
      currentPage; //the index of the active dot, i.e. the index of the page you're on
  final int
      numPages; //the total number of dots, i.e. the number of pages your displaying

  final double dotWidth; //the width of all non-active dots
  final double activeDotWidth; //the width of the active dot
  final double activeDotHeight; //the height of the active dot
  final double dotHeight; //the height of all dots
  final Gradient gradient; //the gradient of all non-active dots
  final Gradient activeGradient; //the gradient of the active dot

  double _calcRowSize() {
    //Calculates the size of the outer row that creates spacing that is equivalent to the width of a dot
    final int widthFactor = 2; //assuming spacing is equal to the width of a dot
    return (dotWidth * numPages * widthFactor) + activeDotWidth - dotWidth;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _calcRowSize(),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          numPages,
          (index) => AnimatedPageIndicatorDot(
            isActive: currentPage == index,
            gradient: gradient,
            activeGradient: activeGradient,
            activeWidth: activeDotWidth,
            activeHeight: activeDotHeight,
          ),
        ),
      ),
    );
  }
}

class AnimatedPageIndicatorDot extends StatelessWidget {
  const AnimatedPageIndicatorDot(
      {super.key,
      required this.isActive,
      this.height = 10,
      this.width = 10,
      this.activeWidth = 20,
      this.activeHeight = 10,
      required this.gradient,
      required this.activeGradient});

  final bool isActive;
  final double height;
  final double width;
  final double activeWidth;
  final double activeHeight;
  final Gradient gradient;
  final Gradient activeGradient;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: isActive ? activeWidth : width,
      height: isActive ? activeHeight : height,
      duration: Duration(milliseconds: 300),
      decoration: BoxDecoration(
          gradient: isActive ? activeGradient : gradient,
          borderRadius: BorderRadius.all(Radius.circular(30))),
    );
  }
}
