// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:chatbot_app_project/chatBot_project/Profile_module/profile_view_screen.dart';
import 'package:chatbot_app_project/chatBot_project/commons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isprivate = false;
  bool pushNotification = true;
  final currentUser = FirebaseAuth.instance.currentUser!;
  Future<void> getDoctOfUser() async {
    final doc = await FirebaseFirestore.instance
        .collection('Users')
        .where('email', isEqualTo: currentUser.email)
        .get();
    setState(() {
      userData = doc.docs[0];
    });
  }

  late DocumentSnapshot userData;
  @override
  void initState() {
    super.initState();
    getDoctOfUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Commons().black1Color,
        body: Column(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                CircleAvatar(
                  radius: 50,
                  child: Icon(
                    Iconsax.profile_2user,
                    size: 30,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  currentUser.email.toString(),
                  style: TextStyle(color: Colors.blue),
                ),
                Text(
                  "vetrivel",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blue),
                ),
                ElevatedButton(
                    onPressed: () {
                      Get.to(() => ProfileViewScreen());
                    },
                    child: Text("View Profile"))
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.circular(25)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 80,
                        child: Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Stack(
                                children: [
                                  BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 25.0, sigmaY: 25.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0)
                                                .withOpacity(0.3),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        border: Border.all(
                                          color: const Color.fromARGB(
                                                  255, 255, 251, 251)
                                              .withOpacity(0.125),
                                          width: 1.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              color: Commons()
                                                  .blueColor
                                                  .withAlpha(90),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100))),
                                          child: Icon(Iconsax.personalcard)),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Profile view",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Spacer(),
                                      IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Iconsax.forward,
                                            color: Colors.white,
                                          ))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 80,
                        child: Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Stack(
                                children: [
                                  BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 25.0, sigmaY: 25.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0)
                                                .withOpacity(0.3),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        border: Border.all(
                                          color: const Color.fromARGB(
                                                  255, 248, 248, 248)
                                              .withOpacity(0.125),
                                          width: 1.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              color: Commons()
                                                  .blueColor
                                                  .withAlpha(90),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100))),
                                          child: Icon(Iconsax.setting)),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Support",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Spacer(),
                                      IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Iconsax.forward,
                                            color: Colors.white,
                                          ))
                                    ],
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
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.circular(25)),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 80,
                          child: Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: Stack(
                                  children: [
                                    BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 25.0, sigmaY: 25.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color:
                                              const Color.fromARGB(255, 0, 0, 0)
                                                  .withOpacity(0.3),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          border: Border.all(
                                            color: const Color.fromARGB(
                                                    255, 0, 0, 0)
                                                .withOpacity(0.125),
                                            width: 1.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                color: Commons()
                                                    .blueColor
                                                    .withAlpha(90),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(100))),
                                            child: Icon(Icons.visibility)),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Private",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Spacer(),
                                        Switch.adaptive(
                                          value: isprivate,
                                          onChanged: (value) {
                                            setState(() {
                                              isprivate = value;
                                            });
                                          },
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 80,
                          child: Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: Stack(
                                  children: [
                                    BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 25.0, sigmaY: 25.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color:
                                              const Color.fromARGB(255, 0, 0, 0)
                                                  .withOpacity(0.3),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          border: Border.all(
                                            color: const Color.fromARGB(
                                                    255, 0, 0, 0)
                                                .withOpacity(0.125),
                                            width: 1.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                color: Commons()
                                                    .blueColor
                                                    .withAlpha(90),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(100))),
                                            child: Icon(Iconsax.notification)),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "push Notification",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Spacer(),
                                        Switch.adaptive(
                                          value: pushNotification,
                                          onChanged: (value) {
                                            setState(() {
                                              pushNotification = value;
                                            });
                                          },
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 80,
                          child: Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: Stack(
                                  children: [
                                    BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 25.0, sigmaY: 25.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color:
                                              const Color.fromARGB(255, 0, 0, 0)
                                                  .withOpacity(0.3),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          border: Border.all(
                                            color: const Color.fromARGB(
                                                    255, 0, 0, 0)
                                                .withOpacity(0.125),
                                            width: 1.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                color: Commons()
                                                    .blueColor
                                                    .withAlpha(90),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(100))),
                                            child:
                                                Icon(Iconsax.profile_delete)),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "log out",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Spacer(),
                                        IconButton(
                                            onPressed: () {
                                              FirebaseAuth.instance.signOut();
                                            },
                                            icon: Icon(
                                              Iconsax.logout,
                                              color: Colors.white,
                                            ))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            )
          ],
        ));
  }
}
