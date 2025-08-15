// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class DomainSelectionController extends GetxController {
  var selectedDomain = ''.obs;
  var filteredDomains = <String>[].obs;

  var interestedDomains = <String>[].obs;
  final List<String> levelList = ['Low', 'Medium', 'High'];
  var selectedLevel = 'Low'.obs;
  final List<String> availableDomains = [
    "software development",
    "app development",
    "web development",
    "data science",
    "Cyber security",
    "artificial intelligence",
    "Devops",
    "Flutter",
    "React",
    "Angular",
    "Vue",
    "Blockchain",
    "iot"
  ];

  void toggleInterest(String domain, BuildContext context) {
    if (interestedDomains.contains(domain)) {
      interestedDomains.remove(domain);
    } else {
      interestedDomains.add(domain);
    }
  }

  Future<String?> getCurrentUserDocId() async {
    try {
      String? myemail = FirebaseAuth.instance.currentUser!.email;

      final snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('email', isEqualTo: myemail ?? '')
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.id;
      } else {
        print("No document found user");
        return null;
      }
    } catch (e) {
      print("Error getting doc ID: $e");
      return null;
    }
  }

  Future<void> updateProfile(BuildContext context) async {
    if (selectedDomain.value.isEmpty) {
      ScaffoldMessenger.of(context).showMaterialBanner(
        MaterialBanner(
          content: Text("Please select a primary domain."),
          backgroundColor: Colors.red,
          actions: [
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              },
              child:
                  const Text("DISMISS", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
      return;
    }

    if (interestedDomains.isEmpty) {
      ScaffoldMessenger.of(context).showMaterialBanner(
        MaterialBanner(
          content: Text("Please select at least one interested domain."),
          backgroundColor: Colors.red,
          actions: [
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              },
              child:
                  const Text("DISMISS", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );

      return;
    }

    try {
      String? userid = await getCurrentUserDocId();
      print(userid ?? '');

      await FirebaseFirestore.instance.collection('Users').doc(userid).update({
        'selectedDomain': selectedDomain.value,
        'interestedDomains': interestedDomains.toList(),
        'levelOfDifficulty': selectedLevel.value
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Domain details updated'),
          duration: Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Domain details failed $e'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  void filterDomains(String query) {
    if (query.isEmpty) {
      filteredDomains.assignAll(availableDomains);
    } else {
      filteredDomains.assignAll(availableDomains.where(
          (domain) => domain.toLowerCase().contains(query.toLowerCase())));
    }
  }

  void addInterest(String domain) {
    if (!interestedDomains.contains(domain)) {
      interestedDomains.add(domain);
    }
  }

  void removeInterest(String domain) {
    interestedDomains.remove(domain);
  }
}
