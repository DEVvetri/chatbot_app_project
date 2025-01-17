// ignore_for_file: avoid_print, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class PostHandler {
  final postRef = FirebaseFirestore.instance.collection("Posts");

  Future<void> addPost(
    String? postedBy,
    String postText,
  ) async {
    String uniquId = createUniqueId();

    await postRef.doc(uniquId).set({
      "postId": uniquId,
      "context": postText,
      "postedBy": postedBy,
      "likedBy": [],
      'time': Timestamp.now()
    });
    getDocIdByEmail(postedBy, uniquId);
  }

  Future<void> deletePost(String postId) async {
    await postRef.doc(postId).delete();
  }

  Future<void> UpdatePost(
    String postId,
    String postText,
  ) async {
    await postRef.doc(postId).update({
      "context": postText,
    });
  }

  Future<void> getDocIdByEmail(String? currentUserEmail, String postid) async {
    String? myid = "";
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection("Users")
          .where("email", isEqualTo: currentUserEmail)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        myid = querySnapshot.docs.first.id;
      } else {
        print("No document found for the given email");
        myid = null;
      }

      await FirebaseFirestore.instance.collection("Users").doc(myid).update({
        "posts": FieldValue.arrayUnion([postid])
      });
    } catch (e) {
      print("Error getting document ID: $e");
      myid = null;
    }
  }

  String createUniqueId() {
    return const Uuid().v1();
  }
}
