import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String? fcmToken;

  @override
  void initState() {
    super.initState();
    _initFirebaseMessaging();
  }

  Future<void> _initFirebaseMessaging() async {
    final firebaseMessaging = FirebaseMessaging.instance;
    // Request notification permissions
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('✅ Notifications authorized');
      await firebaseMessaging.requestPermission();

      // final fCMToken = await firebaseMessaging.getToken();
      // Get the FCM token
      setState(() {});
      // print('🆔 FCM Token: $fCMToken');
      final currentUser = FirebaseAuth.instance.currentUser!.email;
      // Update user token in Firestore
      await _updateUserToken(currentUser!, fcmToken!);

      // Listen for token refresh
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
        print('🔄 Token refreshed: $newToken');
        _updateUserToken(currentUser, newToken);
      });

      // Handle messages while the app is in the foreground
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print(
            '📲 Foreground Message: ${message.notification?.title} - ${message.notification?.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('New Message: ${message.notification?.body}')),
        );
      });

      // Handle messages when the app is opened from a notification
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('🔍 Opened from notification: ${message.notification?.title}');
      });
    } else {
      print('❌ Notifications not authorized');
    }
  }

  Future<void> _updateUserToken(String email, String token) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('Users');

      // Query for the user's document ID
      QuerySnapshot querySnapshot =
          await users.where('email', isEqualTo: email).get();
      if (querySnapshot.docs.isNotEmpty) {
        String userDocId = querySnapshot.docs.first.id;

        // Update the token field
        await users.doc(userDocId).update({'not_token': token});
        print('✅ Token updated successfully for user: $email');
      } else {
        print('⚠️ No user found with email: $email');
      }
    } catch (e) {
      print('❌ Error updating token: $e');
    }
  }

  Future<void> _sendNotification() async {
    if (fcmToken == null) {
      print('❌ FCM Token is null. Cannot send notification.');
      return;
    }

    const String serverKey =
        'YOUR_SERVER_KEY_HERE'; // Replace with your FCM server key

    final Uri url = Uri.parse('https://fcm.googleapis.com');

    final Map<String, dynamic> notificationPayload = {
      "to": fcmToken,
      "notification": {
        "title": "🚀 Hello from Flutter!",
        "body": "🎯 This is a test notification.",
        "sound": "default"
      },
      "priority": "high"
    };

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "key=$serverKey",
        },
        body: jsonEncode(notificationPayload),
      );

      if (response.statusCode == 200) {
        print('✅ Notification sent successfully!');
      } else {
        print('❌ Failed to send notification: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (e) {
      print('❌ Error sending notification: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FCM Messaging')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('FCM Token:\n$fcmToken', textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendNotification,
              child: const Text('📨 Send Notification'),
            ),
          ],
        ),
      ),
    );
  }
}
