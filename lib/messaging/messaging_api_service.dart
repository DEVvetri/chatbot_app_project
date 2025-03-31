import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingAPI {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();

    final fCMToken = await _firebaseMessaging.getToken();
    print("got tokect: $fCMToken");
    try {
      // Reference to the Firestore collection
      CollectionReference users =
          FirebaseFirestore.instance.collection('Users');
      final currentUser = FirebaseAuth.instance.currentUser;
      // Query Firestore to find the user by email
      QuerySnapshot querySnapshot =
          await users.where('email', isEqualTo: currentUser?.email).get();
      if (querySnapshot.docs.isNotEmpty) {
        // Get the user's document ID
        String userDocId = querySnapshot.docs.first.id;
        print("user Docid:$userDocId");
        // Update the token field
        await users.doc(userDocId).update({'not_token': fCMToken.toString()});

        print('✅ Token updated successfully for user: ${currentUser?.email}');
      } else {
        print('⚠️ No user found with email: ${currentUser?.email}');
      }
      
    } catch (e) {
      print(' Error updating token: $e');
    }
    FirebaseMessaging.instance.subscribeToTopic("demo");
  }
}
