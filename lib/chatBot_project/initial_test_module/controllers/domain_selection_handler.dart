import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class DomainSelectionController extends GetxController {
  var selectedDomain = ''.obs;
  var filteredDomains = <String>[].obs;

  var interestedDomains = <String>[].obs;

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

  Future<void> updateProfile(String userDocid, BuildContext context) async {
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
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userDocid)
          .update({
        'selectedDomain': selectedDomain.value,
        'interestedDomains': interestedDomains,
      });
      ScaffoldMessenger.of(context).showMaterialBanner(
        MaterialBanner(
          content: Text("Profile updated successfully!"),
          backgroundColor: Colors.green,
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
    } catch (e) {
      ScaffoldMessenger.of(context).showMaterialBanner(
        MaterialBanner(
          content: Text("Failed to update profile: $e"),
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

