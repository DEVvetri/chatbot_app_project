// ignore_for_file: unused_local_variable, library_private_types_in_public_api, sort_child_properties_last

import 'package:chatbot_app_project/chatBot_project/Profile_module/profile_screen.dart';
import 'package:chatbot_app_project/chatBot_project/commons.dart';
import 'package:chatbot_app_project/chatBot_project/folder_module/cloud_storage/folders_screen.dart';
import 'package:chatbot_app_project/chatBot_project/home_module/home_screen.dart';
import 'package:chatbot_app_project/chatBot_project/post_module/post_listing_screen.dart';
import 'package:chatbot_app_project/chatBot_project/search_module/search_page.dart';
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
    PostListScreen(),
    SearchScreen(),
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
        backgroundColor: Commons().blueColor.withAlpha(255),
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Iconsax.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.activity),
            label: "Feeds",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search",
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
