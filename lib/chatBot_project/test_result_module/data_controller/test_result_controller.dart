import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class TestResultForDAtaController extends GetxController {
  RxList<Map<String, dynamic>> testResults = <Map<String, dynamic>>[].obs;

  Future<void> fetchTestResults() async {
    try {
      final email = FirebaseAuth.instance.currentUser?.email;

      final snapshot = await FirebaseFirestore.instance
          .collection('TestResults')
          .where('user_email', isEqualTo: email)
          .get();

      testResults.clear();

      for (int i = 0; i < snapshot.docs.length; i++) {
        final doc = snapshot.docs[i];
        final questionsSnap = await doc.reference.collection('Questions').get();

        final List<Map<String, dynamic>> questionList = [];

        for (int j = 0; j < questionsSnap.docs.length; j++) {
          final questionDoc = questionsSnap.docs[j];
          final data = questionDoc.data();

          questionList.add({
            'id': questionDoc.id,
            'index': j,
            'question': data['question'],
            'options': data['options'],
            'userpick': data['userpick'],
            'answer': data['answer'],
            'isCorrect': data['isCorrect'],
          });
        }

        testResults.add({
          'id': doc.id,
          'index': i,
          'correct': doc['correct_answer_count'],
          'wrong': doc['wrong_answer_count'],
          'questions': questionList,
        });
      }
    } catch (e) {
      Get.snackbar(
        "Error Fetching Results",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
      print("❌ Error while fetching test results: $e");
    }
  }
}
