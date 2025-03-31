// ignore_for_file: deprecated_member_use

import 'package:chatbot_app_project/chatBot_project/learning_module/timeLine_screen.dart';
import 'package:chatbot_app_project/firebase/learning_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: unused_import
import 'package:iconsax/iconsax.dart';

class LearningListingScreen extends StatefulWidget {
  const LearningListingScreen({super.key});

  @override
  State<LearningListingScreen> createState() => _LearningListingScreenState();
}

class _LearningListingScreenState extends State<LearningListingScreen> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("Learning List"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height - 80,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Learning")
                    .where('started_by', isEqualTo: currentUser.email)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }

                  if (!snapshot.hasData) {
                    return Center(child: Text("No learning data available."));
                  }

                  List<DocumentSnapshot> learningList = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: learningList.length,
                    itemBuilder: (context, index) {
                      LearnTemplate learnTemplate =
                          LearnTemplate.toFirebase(learningList[index]);
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Get.to(() => TimelineScreen(
                                  docId: learningList[index],
                                ));
                            print(index);
                          },
                          child: InfoCard(
                              title: learnTemplate.domainName!,
                              learn: learnTemplate,
                              body: learnTemplate.listOfworks
                                  .toString()
                                  .replaceAll('[', "")
                                  .replaceAll(']', "")
                                  .replaceAll('{', "")
                                  .replaceAll('}', ""),
                              docid: learningList[index].id,
                              onMoreTap: () {}),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String body;
  final Function() onMoreTap;
  final String docid;
  final Widget subIcon;
  final LearnTemplate learn;

  const InfoCard(
      {required this.title,
      required this.body,
      required this.learn,
      required this.onMoreTap,
      required this.docid,
      this.subIcon = const CircleAvatar(
        backgroundColor: Colors.blue,
        radius: 20,
        child: Icon(
          Icons.arrow_forward_ios,
          color: Colors.white,
        ),
      ),
      super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(25.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.05),
                  offset: Offset(0, 10),
                  blurRadius: 0,
                  spreadRadius: 0,
                )
              ],
              gradient: RadialGradient(
                colors: [Colors.blueAccent, Colors.blue],
                focal: Alignment.topCenter,
                radius: .85,
              )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                body,
                style: TextStyle(
                    color: Colors.white.withOpacity(.75), fontSize: 14),
              ),
              SizedBox(height: 15),
              Container(
                width: double.infinity,
                height: 75,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "MORE",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 10),
                      // subIcon,
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        Positioned(
          right: 0,
          child: IconButton(
              onPressed: () {
                LearningService learningService = LearningService();
                learningService.deleteUsersDataLearning(
                    learn.startedBy!, learn, docid);
              },
              icon: Icon(
                Icons.cancel,
                color: Colors.redAccent[100],
              )),
        ),
      ],
    );
  }
}
