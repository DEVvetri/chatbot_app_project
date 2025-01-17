// ignore_for_file: must_be_immutable, deprecated_member_use

import 'package:chatbot_app_project/firebase/follow_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SelectedProfileView extends StatefulWidget {
  String email;
  SelectedProfileView({super.key, required this.email});

  @override
  State<SelectedProfileView> createState() => _SelectedProfileViewState();
}

class _SelectedProfileViewState extends State<SelectedProfileView> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  String currentprofileData = "";
  Future<String> getCurrentprofileData() async {
    final data = await FirebaseFirestore.instance
        .collection("Users")
        .where("email", isEqualTo: widget.email)
        .get();
    DocumentSnapshot dataFiles = data.docs.first;
    currentprofileData = dataFiles["profileData"] ?? "";
    return currentprofileData;
  }

  String profileData = "";
  @override
  void initState() {
    super.initState();
    // user
  }

  String convertTimestampToTimeString(Timestamp timestamp) {
    final DateTime dateTime =
        timestamp.toDate(); // Convert Timestamp to DateTime
    final DateFormat formatter = DateFormat('hh:mma'); // Define format
    return formatter.format(dateTime).toLowerCase(); // Convert to "11:00am"
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("profile"),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .where('email', isEqualTo: widget.email)
              .snapshots(),
          builder: (context, snapshot) {
            // Check for errors or loading state
            if (snapshot.hasError) {
              return const Center(child: Text("Something went wrong"));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // Parse the data
            final data = snapshot.data;
            final docs = data!.docs; // List of matching documents

            if (docs.isEmpty) {
              return Center(child: Text("No data found ${docs.length}"));
            }
            DocumentSnapshot profileData = docs.first;

            bool alreadyFollowed = false;

            List<dynamic> followers = profileData["followers"];

            for (var i = 0; i < followers.length; i++) {
              if (followers[i] == currentUser.email) {
                alreadyFollowed = true;
                break;
              }
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: CircleAvatarWithTransition(
                        primaryColor: Colors.blue,
                        image: AssetImage(
                          'assets/images/splash2.png',
                        )),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          profileData['name'],
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right,
                        ),
                        Text(
                          profileData['email'],
                          style: TextStyle(fontSize: 14),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CardFb1(
                          text: "Follower",
                          profileData: profileData['followers']),
                      SizedBox(
                        width: 15,
                      ),
                      CardFb1(
                          text: "Following",
                          profileData: profileData['following'])
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                          foregroundColor: WidgetStatePropertyAll(
                              alreadyFollowed ? Colors.black : Colors.white),
                          backgroundColor: WidgetStatePropertyAll(
                              alreadyFollowed ? Colors.white : Colors.blue)),
                      onPressed: () {
                        FollowersHandle followersService = FollowersHandle();

                        alreadyFollowed
                            ? followersService.removefollowedUser(
                                profileData.id,
                                currentUser.email,
                                profileData["email"])
                            : followersService.followUser(profileData.id,
                                currentUser.email, profileData["email"]);
                        // Navigate to Edit Profile
                      },
                      child: Text(alreadyFollowed ? "Unfollow" : "Follow"),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class CircleAvatarWithTransition extends StatelessWidget {
  /// the base color of the images background and its concentric circles.
  final Color primaryColor;

  /// the profile image to be displayed.
  final ImageProvider image;

  ///the diameter of the entire widget, including the concentric circles.
  final double size;

  /// the width between the edges of each concentric circle.
  final double transitionBorderwidth;

  const CircleAvatarWithTransition(
      {super.key,
      required this.primaryColor,
      required this.image,
      this.size = 190.0,
      this.transitionBorderwidth = 20.0});
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: primaryColor.withOpacity(0.05)),
        ),
        Container(
            height: size - transitionBorderwidth,
            width: size - transitionBorderwidth,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                  stops: [0.01, 0.5],
                  colors: [Colors.white, primaryColor.withOpacity(0.1)]),
            )),
        Container(
            height: size - (transitionBorderwidth * 2),
            width: size - (transitionBorderwidth * 2),
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: primaryColor.withOpacity(0.4))),
        Container(
            height: size - (transitionBorderwidth * 3),
            width: size - (transitionBorderwidth * 3),
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: primaryColor.withOpacity(0.5))),
        Container(
            height: size - (transitionBorderwidth * 4),
            width: size - (transitionBorderwidth * 4),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(fit: BoxFit.fill, image: image)))
      ],
    );
  }
}

class CardFb1 extends StatelessWidget {
  final String text;
  final List<dynamic> profileData;

  const CardFb1({required this.text, required this.profileData, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 80,
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.5),
        boxShadow: [
          BoxShadow(
              offset: const Offset(10, 20),
              blurRadius: 10,
              spreadRadius: 0,
              color: Colors.grey.withOpacity(0.5)),
        ],
      ),
      child: Column(
        children: [
          Text(profileData.length.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              )),
          const Spacer(),
          Text(text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              )),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}
