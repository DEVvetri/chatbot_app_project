// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:chatbot_app_project/chatBot_project/chat_module/chat_screen.dart';
import 'package:chatbot_app_project/chatBot_project/chatbot_module/chatBot_screen.dart';
import 'package:chatbot_app_project/chatBot_project/commons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Commons().black1Color,
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
                      children: [_buildGamesBox(context)],
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(left: 20),
                //   child: Text("Notifications",
                //       style: TextStyle(
                //           fontSize: 20,
                //           fontWeight: FontWeight.bold,
                //           color: Commons().whiteColor)),
                // ),
                // _buildListOfNotifications(context)
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
              builder: (context) => ChatbotScreen(),
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
                      color: Colors.black.withOpacity(0.3),
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 25.0, sigmaY: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
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
                          borderRadius: BorderRadius.all(Radius.circular(100))),
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
    );
  }

  Widget _buildGamesBox(BuildContext context) {
    return Expanded(
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
                    color: Colors.black.withOpacity(0.3),
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
                          borderRadius: BorderRadius.all(Radius.circular(100))),
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
    );
  }

  Widget _buildListOfNotifications(BuildContext context) {
    List<String> notifications = [
      "Create a personal expense tracker app.",
      "Develop a habit tracker with gamification features.",
      "Build a social media app for niche communities.",
      "Build a portfolio website generator.",
      "Create a task management tool for remote teams.",
      "Develop an AI-powered resume builder.",
      "Create a chatbot for mental health support.",
      "Build a machine learning model for predictive analytics.",
      "Develop an AI system to generate personalized learning paths for students.",
      "Build a simple puzzle game using Unity or Flutter.",
      "Create an educational game for kids.",
      "Develop a multiplayer trivia quiz app.",
      "Work on an open-source project.",
      "Create a productivity tool for developers.",
      "Build an app that integrates multiple APIs (e.g., weather, maps, etc.).",
    ];
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SizedBox(
          height: 400,
          child: ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: SizedBox(
                      height: 60,
                      child: Stack(
                        children: [
                          BackdropFilter(
                            filter:
                                ImageFilter.blur(sigmaX: 25.0, sigmaY: 25.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                          ),
                          Center(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(
                                  color: Commons().blueColor.withOpacity(0.5),
                                  width: 1.0,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                            color: Commons()
                                                .blueColor
                                                .withAlpha(30),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(100))),
                                        child: Icon(
                                          Iconsax.notification,
                                          size: 18,
                                          color: Commons().blueColor,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: SizedBox(
                                        width: 200,
                                        child: Text(
                                          notifications[index],
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {},
                                        icon: Icon(Iconsax.arrow_right))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              })),
    );
  }
}
