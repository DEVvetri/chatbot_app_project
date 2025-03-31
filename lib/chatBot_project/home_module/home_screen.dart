// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:chatbot_app_project/chatBot_project/chating_module/message/group_screen.dart';
import 'package:chatbot_app_project/chatBot_project/commons.dart';
import 'package:chatbot_app_project/chatBot_project/games_modules/games_listing_screen.dart';
import 'package:chatbot_app_project/chatBot_project/learning_module/learning_listing.dart';
import 'package:chatbot_app_project/chatBot_project/questions_domain_manager_module/domains_listing_screen.dart';
import 'package:chatbot_app_project/chatbotServer/chat_UI_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userEmail = FirebaseAuth.instance.currentUser?.email ?? "";
  late DocumentSnapshot? userDocId;
  bool isStudent = true;
  Future<String?> getUserDocId(String userEmail) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('email', isEqualTo: userEmail)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          userDocId = querySnapshot.docs.first;

          isStudent = userDocId!.get('role') == 'Student';
        });
      } else {
        setState(() {
          userDocId = null;
        });
      }
    } catch (e) {
      print("Error getting userDocid: $e");
      return null;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    getUserDocId(userEmail);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
              // image: DecorationImage(
              //     image: AssetImage("assets/images/home_image.png"))
              ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                ),
                _buildPremiumPlan(context),
                SizedBox(
                  height: 40,
                ),
                SizedBox(
                  height: Commons().getSizeOf(context, "h") / 4.5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        _buildChatBox(context),
                        _buildWorkFlowBox(context)
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: Commons().getSizeOf(context, "h") / 4.5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        _buildGamesBox(context),
                        _buildGroupChatBox(context)
                      ],
                    ),
                  ),
                ),
                if (!isStudent)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card.filled(
                      color: Commons().blueColor,
                      child: ListTile(
                        title: Text("Test-Question module"),
                        subtitle: Text("add/update questions here"),
                        trailing: IconButton(
                            onPressed: () {
                              Get.to(() => DomainsListScreen());
                            },
                            icon: Icon(Icons.open_in_new)),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumPlan(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Container(
          width: Commons().getSizeOf(context, "w"),
          height: Commons().getSizeOf(context, "h") / 4.5,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
          child: Stack(
            children: [
              Row(
                children: [
                  Expanded(child: SizedBox()),
                  Stack(
                    children: [
                      Container(
                          width: 220,
                          decoration: BoxDecoration(
                            color: Commons().blueColor.withAlpha(255),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 50),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 6,
                              children: [
                                Text('Premium Plan',
                                    style: TextStyle(
                                        color: Commons().black1Color,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Get more features',
                                        style: TextStyle(
                                            color: Commons().black2Color)),
                                    Text("This is your world..",
                                        style: TextStyle(
                                            color: Commons().black1Color)),
                                  ],
                                ),
                              ],
                            ),
                          )),
                      Positioned(
                        bottom: -5,
                        right: 0,
                        child: ElevatedButton.icon(
                          style: ButtonStyle(
                              shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: Commons().blueColor, width: 2),
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(0),
                                          topLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20),
                                          bottomLeft: Radius.circular(0)))),
                              backgroundColor:
                                  WidgetStatePropertyAll(Colors.black),
                              foregroundColor:
                                  WidgetStatePropertyAll(Colors.white)),
                          onPressed: () {},
                          label: Text("Upgrade Now"),
                          icon: Icon(
                            Icons.moving_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Positioned(
                left: -14,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/home_premium.png"))),
                ),
              ),
            ],
          )),
    );
  }

  Widget _buildChatBox(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ModelChatMessageScreen(),
            )),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Stack(
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 25.0, sigmaY: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(1),
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.125),
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            color: Commons().blueColor.withAlpha(30),
                            borderRadius:
                                BorderRadius.all(Radius.circular(100))),
                        child: Icon(
                          Iconsax.message_2,
                          size: 30,
                          color: Commons().blueColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ChatBot',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Text(
                                'flow tap to move',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWorkFlowBox(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            Get.to(() => LearningListingScreen());
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Stack(
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 25.0, sigmaY: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(1),
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.125),
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            color: Commons().blueColor.withAlpha(30),
                            borderRadius:
                                BorderRadius.all(Radius.circular(100))),
                        child: Icon(
                          Iconsax.image,
                          size: 30,
                          color: Commons().blueColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Learning Flow',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Text(
                                'flow tap to move',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGamesBox(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GamesListingScreen(),
            )),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Stack(
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 25.0, sigmaY: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(1),
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.125),
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            color: Commons().blueColor.withAlpha(30),
                            borderRadius:
                                BorderRadius.all(Radius.circular(100))),
                        child: Icon(
                          Iconsax.game,
                          size: 30,
                          color: Commons().blueColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Games',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Text(
                                'flow tap to move',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGroupChatBox(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GroupScreen(),
            )),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Stack(
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 25.0, sigmaY: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(1),
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.125),
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            color: Commons().blueColor.withAlpha(30),
                            borderRadius:
                                BorderRadius.all(Radius.circular(100))),
                        child: Icon(
                          Iconsax.call,
                          size: 30,
                          color: Commons().blueColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Group Chats',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Text(
                                'flow tap to move',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
