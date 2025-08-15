// ignore_for_file: deprecated_member_use, unused_local_variable, use_super_parameters

import 'package:chatbot_app_project/chatBot_project/Profile_module/follower_listing_scrren.dart';
import 'package:chatbot_app_project/chatBot_project/Profile_module/profile_edit_screen.dart';
import 'package:chatbot_app_project/chatBot_project/Profile_module/profile_info_component.dart';
import 'package:chatbot_app_project/chatBot_project/commons.dart';
import 'package:chatbot_app_project/chatBot_project/leaderboard_module/stage_board_screen.dart';
import 'package:chatbot_app_project/chatBot_project/reward_module/reward_main_sreen.dart';
import 'package:chatbot_app_project/chatBot_project/test_result_module/test_result_listing_scren.dart';
import 'package:chatbot_app_project/onboarding/onboarding_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';

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

  String convertTimestampToTimeString(Timestamp timestamp) {
    final DateTime dateTime =
        timestamp.toDate(); // Convert Timestamp to DateTime
    final DateFormat formatter = DateFormat('hh:mma'); // Define format
    return formatter.format(dateTime).toLowerCase(); // Convert to "11:00am"
  }

  late DocumentSnapshot userData;

  @override
  void initState() {
    super.initState();
    getDoctOfUser();
  }

  Future<void> signOut() async {
    Get.back();
    await FirebaseAuth.instance.signOut();
    Get.offAll(() => OnboardingScreen());
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Log out successfully.')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Commons().whiteColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Users')
                    .where('email', isEqualTo: currentUser.email)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No user data found.'));
                  }

                  // Assuming only one user document is returned
                  final userData =
                      snapshot.data!.docs.first.data() as Map<String, dynamic>;

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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.to(() => FollowerListingScreen(
                                    userDocid: userData['id'],
                                    tag: 'followers'));
                              },
                              child: CardFb1(
                                  text: "Follower",
                                  userdata: userData['followers']),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.to(() => FollowerListingScreen(
                                    userDocid: userData['id'],
                                    tag: 'following'));
                              },
                              child: CardFb1(
                                  text: "Following",
                                  userdata: userData['following']),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Card(
                          color: Commons().whiteColor,
                          child: Column(
                            children: [
                              ListTile(
                                onTap: () {
                                  Get.to(() => ProfileInfoComponent());
                                },
                                leading: Icon(
                                  Icons.person_2_outlined,
                                  color: Colors.black,
                                ),
                                title: Text(
                                  "Profile Info",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                trailing: Icon(
                                  Icons.chevron_right,
                                  color: Colors.black,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Divider(
                                  color: Colors.black,
                                ),
                              ),
                              ListTile(
                                onTap: () {
                                  Get.to(() => ProfileEditScreen(
                                        docId: userData['id'],
                                      ));
                                },
                                leading: Icon(
                                  Icons.person_2,
                                  color: Colors.black,
                                ),
                                title: Text(
                                  "Profile Edit",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                trailing: Icon(
                                  Icons.chevron_right,
                                  color: Colors.black,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Divider(
                                  color: Colors.black,
                                ),
                              ),
                              ListTile(
                                onTap: () {
                                  Get.to(() => LeaderBoardMainScreen());
                                },
                                leading: Icon(
                                  Icons.analytics,
                                  color: Colors.black,
                                ),
                                title: Text(
                                  "LeaderBoard",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                trailing: Icon(
                                  Icons.chevron_right,
                                  color: Colors.black,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Divider(
                                  color: Colors.black,
                                ),
                              ),
                              ListTile(
                                onTap: () {
                                  Get.to(() => TestResultsListingScreen());
                                },
                                leading: Icon(
                                  Icons.analytics_outlined,
                                  color: Colors.black,
                                ),
                                title: Text(
                                  "Test Results",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                trailing: Icon(
                                  Icons.chevron_right,
                                  color: Colors.black,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Divider(
                                  color: Colors.black,
                                ),
                              ),
                              ListTile(
                                onTap: () {
                                  Get.to(() => RewardMainSreen());
                                },
                                leading: Icon(
                                  Icons.analytics,
                                  color: Colors.black,
                                ),
                                title: Text(
                                  "Rewards",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                trailing: Icon(
                                  Icons.chevron_right,
                                  color: Colors.black,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Divider(
                                  color: Colors.black,
                                ),
                              ),
                              ListTile(
                                onTap: () {},
                                leading: Icon(
                                  Icons.settings,
                                  color: Colors.black,
                                ),
                                title: Text(
                                  "Support",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                trailing: Icon(
                                  Icons.chevron_right,
                                  color: Colors.black,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Divider(
                                  color: Colors.black,
                                ),
                              ),
                              ListTile(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      backgroundColor: Colors.blue.shade50,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      title: Row(
                                        children: [
                                          Icon(
                                            Icons.warning_amber_rounded,
                                            color: Colors.black,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            "Logout",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue.shade900,
                                            ),
                                          ),
                                        ],
                                      ),
                                      content: Text(
                                        "Are you sure you want to logout?",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.blue.shade800,
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          style: ButtonStyle(
                                            shape: WidgetStateProperty.all(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                            ),
                                          ),
                                          onPressed: () => Get.back(),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.close,
                                                color: Colors.blue.shade800,
                                                size: 18,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                "No",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.blue.shade800,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.blue.shade600,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                          ),
                                          onPressed: () {
                                            signOut();
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.check,
                                                size: 18,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                "Yes",
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                leading: Icon(
                                  Icons.exit_to_app,
                                  color: Colors.red,
                                ),
                                title: Text(
                                  "Logout",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                                trailing: Icon(
                                  Icons.chevron_right,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ));
  }
}

class CircleAvatarWithTransition extends StatelessWidget {
  final Color primaryColor;

  final ImageProvider image;

  final double size;

  final double transitionBorderwidth;

  const CircleAvatarWithTransition(
      {Key? key,
      required this.primaryColor,
      required this.image,
      this.size = 190.0,
      this.transitionBorderwidth = 20.0})
      : super(key: key);
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
  final List<dynamic> userdata;

  const CardFb1({required this.text, required this.userdata, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 100,
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.5),
        boxShadow: [
          BoxShadow(
              offset: const Offset(10, 20),
              blurRadius: 10,
              spreadRadius: 0,
              color: Colors.grey.withOpacity(.05)),
        ],
      ),
      child: Column(
        children: [
          Text(userdata.length.toString(),
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
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
