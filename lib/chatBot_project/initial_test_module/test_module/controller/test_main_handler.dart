import 'package:chatbot_app_project/chatBot_project/initial_test_module/test_module/finsh_test_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class TestQuestionDataHandler extends GetxController {
  RxList<String> filteredQuestionDocIds = <String>[].obs;

  RxMap<String, dynamic> currentQuestion = <String, dynamic>{}.obs;
  RxList<String> currentOptions = <String>[].obs;
  RxList<String> correctAnswerList = <String>[].obs;
  RxString correctAnswer = ''.obs;
  final correctAnswerIndex = RxInt(-1);

  RxInt currentQuestionIndex = 0.obs;
  RxBool isLoading = false.obs;

  RxList<String> userAnswers = <String>[].obs;
  RxInt totalScore = 0.obs;
  RxInt correctAnswersCount = 0.obs;
  RxInt wrongAnswersCount = 0.obs;

  late String _domainDocId;
  RxBool updatIng = false.obs;
  // results variables
  RxList<Map<String, dynamic>> finalResultDataList =
      <Map<String, dynamic>>[].obs;

  Future<void> fetchQuestions(String domain, String level) async {
    try {
      isLoading.value = true;
      print("🔍 Fetching domain for: $domain");

      final domainSnapshot = await FirebaseFirestore.instance
          .collection('Test-Questions')
          .where('domain', isEqualTo: domain)
          .limit(1)
          .get();

      if (domainSnapshot.docs.isEmpty) {
        print("❌ No domain found for: $domain");
        filteredQuestionDocIds.clear();
        return;
      }

      _domainDocId = domainSnapshot.docs.first.id;
      print("✅ Found domain docId: $_domainDocId");

      final questionsSnapshot = await FirebaseFirestore.instance
          .collection('Test-Questions')
          .doc(_domainDocId)
          .collection('Questions')
          .get();

      filteredQuestionDocIds.value = questionsSnapshot.docs
          .where((doc) => doc['level'] == level.toLowerCase())
          .map((doc) => doc.id)
          .toList();
      correctAnswerList.value = questionsSnapshot.docs
          .where((doc) => doc['level'] == level.toLowerCase())
          .map((doc) => doc['answer'] as String)
          .toList();

      print(
          "📌 Filtered Question Doc IDs for level [$level]: $filteredQuestionDocIds");

      // Reset test state
      currentQuestionIndex.value = 0;
      totalScore.value = 0;
      correctAnswersCount.value = 0;
      wrongAnswersCount.value = 0;
      userAnswers.clear();

      if (filteredQuestionDocIds.isNotEmpty) {
        print("🟢 Loading first question...");
        await loadQuestionByIndex(0);
      } else {
        print("⚠️ No questions found for the level: $level");
        currentQuestion.clear();
      }
    } catch (e) {
      print("🚨 Error fetching questions: $e");
      filteredQuestionDocIds.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadQuestionByIndex(int index) async {
    if (index >= filteredQuestionDocIds.length) {
      print("⚠️ Index $index out of range for question list.");
      return;
    }

    try {
      isLoading.value = true;
      String docId = filteredQuestionDocIds[index];
      print("📥 Loading question at index [$index], docId: $docId");

      final docSnapshot = await FirebaseFirestore.instance
          .collection('Test-Questions')
          .doc(_domainDocId)
          .collection('Questions')
          .doc(docId)
          .get();

      if (docSnapshot.exists) {
        currentQuestion.value = docSnapshot.data()!;
        currentOptions.value =
            List<String>.from(currentQuestion['options'] ?? []);
        String answerLetter = currentQuestion['answer'] ?? '';

        // Map letter (A, B, C, D) to index (0, 1, 2, 3)
        Map<String, int> answerMap = {'A': 0, 'B': 1, 'C': 2, 'D': 3};
        int? answerIndex = answerMap[answerLetter.toUpperCase()];

        if (answerIndex == null || answerIndex >= currentOptions.length) {
          print(
              "❗ Invalid answer '$answerLetter' for options: $currentOptions");
          correctAnswerIndex.value = -1;
        } else {
          correctAnswerIndex.value = answerIndex;
          print("✅ Question Loaded: ${currentQuestion['question']}");
          print("🔘 Options: $currentOptions");
          print(
              "🟩 Correct Answer: Index $answerIndex, Value: ${currentOptions[answerIndex]}");
        }
      } else {
        print("❌ Question document not found for ID: $docId");
      }
    } catch (e) {
      print("🚨 Error loading question: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitAnswer(String selectedOption) async {
    print("📤 Submitting answer: $selectedOption");
    userAnswers.add(selectedOption);

    // Check correctness
    bool isCorrectAnswer = selectedOption == currentAnswerText();

    // Store everything in one place
    finalResultDataList.add({
      'question': currentQuestion['question'],
      'options': currentOptions.toList(),
      'userpick': selectedOption,
      'answer': currentAnswerText(),
      'isCorrect': isCorrectAnswer,
    });

    // Score update
    if (isCorrectAnswer) {
      totalScore.value += 1;
      correctAnswersCount.value += 1;
      print("✅ Correct Answer! Total Score: ${totalScore.value}");
    } else {
      wrongAnswersCount.value += 1;
      print("❌ Wrong Answer. Correct was: ${currentAnswerText()}");
    }

    // Navigate or go next
    if (currentQuestionIndex.value == filteredQuestionDocIds.length - 1) {
      print('🧾 Final Results: $finalResultDataList');
      Get.to(() => TestResultScreen());
    } else {
      await goToNextQuestion();
    }
  }

  String currentAnswerText() {
    if (correctAnswerIndex.value >= 0 &&
        correctAnswerIndex.value < currentOptions.length) {
      return currentOptions[correctAnswerIndex.value];
    }
    return '';
  }

  // ✅ New Function: Move to next question if exists
  Future<void> goToNextQuestion() async {
    if (currentQuestionIndex.value + 1 < filteredQuestionDocIds.length) {
      currentQuestionIndex.value += 1;
      await loadQuestionByIndex(currentQuestionIndex.value);
    } else {
      print("🎉 Test Completed!");
      print("✅ Score: ${totalScore.value}");
      print("✅ Correct: ${correctAnswersCount.value}");
      print("❌ Wrong: ${wrongAnswersCount.value}");
    }
  }

  Future<String?> getCurrentUserDocId() async {
    try {
      String? myemail = FirebaseAuth.instance.currentUser!.email;

      final snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('email', isEqualTo: myemail ?? '')
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.id;
      } else {
        print("No document found user");
        return null;
      }
    } catch (e) {
      print("Error getting doc ID: $e");
      return null;
    }
  }

  Future<void> addTestResultToFirebase() async {
    updatIng.value = true;
    try {
      final controller = Get.find<TestQuestionDataHandler>();
      final userEmail = FirebaseAuth.instance.currentUser?.email;
      String? userid = await getCurrentUserDocId();
      if (userid != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(userid)
            .get();

        if (userDoc.exists) {
          final data = userDoc.data()!;
          final currentCorrect = controller.correctAnswersCount.value;
          final totalQuestions = controller.filteredQuestionDocIds.length;

          final currentScore = currentCorrect; // Just the number (e.g., 8)

          // Parse previous highest and lowest scores
          int previousHigh = 0;
          int previousLow = totalQuestions;

          if (data['highestScore'] != null) {
            final highParts = (data['highestScore'] as String).split('/');
            previousHigh = int.tryParse(highParts.first) ?? 0;
          }

          if (data['lowestScore'] != null) {
            final lowParts = (data['lowestScore'] as String).split('/');
            previousLow = int.tryParse(lowParts.first) ?? totalQuestions;
          }

          // Compare scores
          final newHighScore = currentScore > previousHigh
              ? '$currentCorrect/$totalQuestions'
              : data['highestScore'];
          print('Previous${previousHigh}');
          final newLowScore = currentScore < previousLow
              ? '$currentCorrect/$totalQuestions'
              : data['lowestScore'];

          // Update Firestore
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(userid)
              .update({
            'isStarts': true,
            'firstTestMark': '$currentCorrect/$totalQuestions',
            'highestScore': newHighScore,
            'lowestScore': newLowScore,
          });
        }
      } else {}

      final testResultRef =
          await FirebaseFirestore.instance.collection('TestResults').add({
        'user_email': userEmail,
        'created_at': Timestamp.now(),
        'correct_answer_count': controller.correctAnswersCount.value,
        'wrong_answer_count': controller.wrongAnswersCount.value,
      });

      // Add each question as a document in subcollection
      for (var item in controller.finalResultDataList) {
        await testResultRef.collection('Questions').add({
          'question': item['question'],
          'options': item['options'],
          'userpick': item['userpick'],
          'answer': item['answer'],
          'isCorrect': item['isCorrect'],
        });
      }

      print("✅ Test result saved to Firebase!");
    } catch (e) {
      print("❌ Error saving test result: $e");
    } finally {
      updatIng.value = false;
    }
  }
}
