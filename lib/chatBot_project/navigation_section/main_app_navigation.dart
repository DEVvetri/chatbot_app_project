import 'package:chatbot_app_project/chatBot_project/Profile_module/profile_screen.dart';
import 'package:chatbot_app_project/chatBot_project/chat_module/chat_screen.dart';
import 'package:chatbot_app_project/chatBot_project/chatbot_module/message/chat_list.dart';
import 'package:chatbot_app_project/chatBot_project/chatbot_module/message/group_screen.dart';
import 'package:chatbot_app_project/chatBot_project/commons.dart';
import 'package:chatbot_app_project/chatBot_project/folder_module/cloud_storage/folders_screen.dart';
import 'package:chatbot_app_project/chatBot_project/folder_module/folder_screen.dart';
import 'package:chatbot_app_project/chatBot_project/home_module/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class MainAppNavigation extends StatefulWidget {
  const MainAppNavigation({super.key});

  @override
  State<MainAppNavigation> createState() => _MainAppNavigationState();
}

class _MainAppNavigationState extends State<MainAppNavigation> {
  int currentIndex = 0;

  final List<Widget> pages = [
    HomeScreen(),
    GroupScreen(),
    FoldersScreen(),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Commons().black1Color,
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        selectedItemColor: Commons().blueColor,
        unselectedItemColor: Commons().whiteColor,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Iconsax.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.message),
            label: "Chat",
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.folder_2),
            label: "Folder",
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.profile_circle5),
            label: "Account",
          ),
        ],
      ),
    );
  }
}
