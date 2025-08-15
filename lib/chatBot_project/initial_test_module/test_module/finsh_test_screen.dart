import 'package:chatbot_app_project/chatBot_project/initial_test_module/test_module/controller/test_main_handler.dart';
import 'package:chatbot_app_project/chatBot_project/navigation_section/main_app_navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TestResultScreen extends StatelessWidget {
  const TestResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TestQuestionDataHandler>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Test Summary"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Final Score: ${controller.totalScore.value}/${controller.filteredQuestionDocIds.length}",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                  "✔️ Correct Answers: ${controller.correctAnswersCount.value}"),
              Text("❌ Wrong Answers: ${controller.wrongAnswersCount.value}"),
              const Divider(height: 32),
              const Text("📝 Your Answers:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: controller.finalResultDataList.length,
                  itemBuilder: (context, index) {
                    final result = controller.finalResultDataList[index];
                    final question = result['question'];
                    final options = result['options'] as List<String>;
                    final userPick = result['userpick'];
                    final correctAnswer = result['answer'];
                    final isCorrect = result['isCorrect'];

                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Q${index + 1}: $question",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Icon(
                                  isCorrect ? Icons.check_circle : Icons.cancel,
                                  color: isCorrect ? Colors.green : Colors.red,
                                )
                              ],
                            ),
                            const SizedBox(height: 8),
                            ...options.map((option) {
                              final isUserPick = option == userPick;
                              final isCorrectAns = option == correctAnswer;

                              Color tileColor = Colors.transparent;

                              if (isUserPick && isCorrectAns) {
                                tileColor = Colors.green.withOpacity(0.2);
                              } else if (isUserPick && !isCorrectAns) {
                                tileColor = Colors.red.withOpacity(0.2);
                              } else if (isCorrectAns) {
                                tileColor = Colors.green.withOpacity(0.1);
                              }

                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                decoration: BoxDecoration(
                                  color: tileColor,
                                  borderRadius: BorderRadius.circular(8),
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                ),
                                child: ListTile(
                                  title: Text(option),
                                  leading: isUserPick
                                      ? const Icon(Icons.person,
                                          color: Colors.blue)
                                      : null,
                                  trailing: isCorrectAns
                                      ? const Icon(Icons.check,
                                          color: Colors.green)
                                      : null,
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    controller
                        .addTestResultToFirebase()
                        .whenComplete(() => Get.to(() => MainAppNavigation()));
                  },
                  child: const Text("Finish"),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
