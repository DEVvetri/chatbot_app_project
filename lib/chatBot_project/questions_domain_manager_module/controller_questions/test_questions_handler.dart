import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class TestQuestionsController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var domains = <Map<String, dynamic>>[].obs; // List to store domains
  var questions = <Map<String, dynamic>>[].obs; // List to store questions
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDomains(); // Load domains on init
  }

  /// Fetch the list of domains from Firestore
  Future<void> fetchDomains() async {
    isLoading.value = true;
    try {
      QuerySnapshot querySnapshot =
          await firestore.collection('Test-Questions').get();

      domains.value = querySnapshot.docs
          .map((doc) => {
                'id': doc.id, // Store doc ID
                'domain': doc['domain'],
              })
          .toList();
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch domains: $e");
    }
    isLoading.value = false;
  }

  Future<void> fetchQuestions(String domainId) async {
    isLoading.value = true;
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('Test-Questions')
          .doc(domainId)
          .collection('Questions')
          // .where('level', isEqualTo: level) // 🔥 Added level filter
          .get();

      questions.value = querySnapshot.docs
          .map((doc) => {
                'id': doc.id,
                'question': doc['question'],
                'options': doc['options'],
                'answer': doc['answer'],
                'level': doc['level'],
              })
          .toList();
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch questions: $e");
    }
    isLoading.value = false;
  }
}
