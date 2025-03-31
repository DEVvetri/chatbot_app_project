import 'package:cloud_firestore/cloud_firestore.dart';

class LearnTemplate {
  String? domainName;
  String? domainDescription;
  List? subtitles;
  String? startedBy;
  Timestamp? startedDate;
  List<dynamic>? listOfworks;
  LearnTemplate(
      {required this.domainName,
      required this.domainDescription,
      required this.subtitles,
      required this.startedBy,
      required this.startedDate,
      required this.listOfworks});
  factory LearnTemplate.toFirebase(DocumentSnapshot doc) {
    return LearnTemplate(
        domainName: doc['title'],
        domainDescription: doc['description'],
        subtitles: doc['subtitles'],
        startedBy: doc['started_by'],
        startedDate: doc['created_on'],
        listOfworks: doc['list_of_works']);
  }
}

class LearningService {
  final learnRef = FirebaseFirestore.instance.collection("Learning");

  Future<void> addLearning(LearnTemplate learn) async {
    try {
      await learnRef.add({
        'title': learn.domainName,
        'description': learn.domainDescription,
        'subtitles': learn.subtitles,
        'started_by': learn.startedBy,
        'created_on': FieldValue.serverTimestamp(),
        'list_of_works': learn.listOfworks,
      });
    } catch (e) {
      print("error: $e");
    }
  }

  Future<void> addUsersDataLearning(String email, LearnTemplate learn) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('Users');

      String userEmail = email;
      QuerySnapshot userSnapshot =
          await users.where('email', isEqualTo: userEmail).get();

      if (userSnapshot.docs.isNotEmpty) {
        DocumentReference userDoc = userSnapshot.docs.first.reference;

        DocumentSnapshot docSnapshot = await userDoc.get();
        List<dynamic> currentLearning = docSnapshot['learning'] ?? [];

        if (currentLearning.contains(learn.domainName)) {
          throw Exception("Title already exists");
        }
        await userDoc.update({
          'learning': FieldValue.arrayUnion([learn.domainName])
        });
        await addLearning(learn);
      } else {
        throw Exception("User  not found");
      }
    } catch (e) {
      // Handle the error (e.g., log it or rethrow)
      rethrow;
    }
  }

  Future<void> deleteLearn(String doc) async {
    await learnRef.doc(doc).delete();
  }

  Future<void> deleteUsersDataLearning(String email, LearnTemplate learn,String doc) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('Users');

      String userEmail = email;
      QuerySnapshot userSnapshot =
          await users.where('email', isEqualTo: userEmail).get();

      if (userSnapshot.docs.isNotEmpty) {
        DocumentReference userDoc = userSnapshot.docs.first.reference;

       
        
        await userDoc.update({
          'learning': FieldValue.arrayRemove([learn.domainName])
        });
        await deleteLearn(doc);
      } else {
        throw Exception("User  not found");
      }
    } catch (e) {
      // Handle the error (e.g., log it or rethrow)
      rethrow;
    }
  }
}
