import 'package:cloud_firestore/cloud_firestore.dart';

class FollowersHandle {
  final followerRepo = FirebaseFirestore.instance.collection("Users");

  Future<void> followUser(
      String hisid, String? myemail, String hisemail) async {
    await followerRepo.doc(hisid).update({
      "followers": FieldValue.arrayUnion([myemail]),
    });
    String? documentId = await getUserDocumentIdByEmail(myemail);

    await followerRepo.doc(documentId).update({
      "following": FieldValue.arrayUnion([hisemail]),
    });
  }

  Future<void> removefollowedUser(
      String hisid, String? myemail, String hisemail) async {
    await followerRepo.doc(hisid).update({
      "followers": FieldValue.arrayRemove([myemail]),
    });
    String? documentId = await getUserDocumentIdByEmail(myemail);

    await followerRepo.doc(documentId).update({
      "following": FieldValue.arrayRemove([hisemail]),
    });
  }

  Future<String?> getUserDocumentIdByEmail(String? email) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Users")
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.id;
      } else {
        print("No user found with email $email");
        return null;
      }
    } catch (e) {
      print("Error fetching user document ID: $e");
      return null;
    }
  }
}
