//User API
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class UserDataReferance {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('Users');

  Future<void> addUser({
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
        'name': name,
        'contact_number': contactNumber,
        'gender': gender,
        'email': email,
        'profile_pic_Url': profilePicUrl,
        'role': role,
        'created_at': Timestamp.now(),
        'updated_at': Timestamp.now(),
        'private':false
      },
    );
  }

  Future<dynamic> updateUser({
    required String name,
    required String email,
    required String contactNumber,
    required String gender,
    required String profilePicUrl,
    required String role,
    required String dateOfBirth,
    required String userID,
  }) {
    return users.doc(userID).update(
      {
        'name': name,
        'contact_number': contactNumber,
        'gender': gender,
        'email': email,
        'profile_pic_Url': profilePicUrl,
        'role': role,
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
