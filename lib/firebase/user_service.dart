//User API
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class UserDataReferance {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('Users');

  Future<void> addUser({
    required String username,
    required String name,
    required String email,
    required String contactNumber,
    required String gender,
    required String profilePicUrl,
    required String role,
  }) async {
    String customId = Uuid().v1();

    await users.doc(customId).set(
      {
        'id': customId,
        'username': username,
        'name': name,
        'contact_number': contactNumber,
        'gender': gender,
        'email': email,
        'profile_pic_Url': profilePicUrl,
        'isStarts':false,
        'selectedDomain':'',
        'interestedDomains':'',
        'highestScore':'',
        'lowestScore':'',
        'levelOfDifficulty':'',
        'role': role,
        'created_at': Timestamp.now(),
        'updated_at': Timestamp.now(),
        'private': false,
        'followers': [],
        'following': []
      },
    );
  }

  Future<dynamic> updateUser(
      {required String username,
      required String name,
      required String contactNumber,
      required String gender,
      required String profilePicUrl,
      required String role,
      required String userID,
      required bool private}) {
    return users.doc(userID).update(
      {
        'username': username,
        'name': name,
        'contact_number': contactNumber,
        'gender': gender,
        'profile_pic_Url': profilePicUrl,
        'role': role,
        'private': private,
        'updated_at': Timestamp.now(),
      },
    );
  }

  Future<dynamic> deleteUser(String documentId) {
    return users.doc(documentId).delete();
  }

  Future<Map<String, dynamic>?> getUser(String userId) async {
    try {
      DocumentSnapshot documentSnapshot = await users.doc(userId).get();
      if (documentSnapshot.exists) {
        return documentSnapshot.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
  }
}
