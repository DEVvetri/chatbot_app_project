import 'package:chatbot_app_project/chatBot_project/initial_test_module/test_module/controller/test_main_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TestScreen extends StatelessWidget {
  final String domain;
  final String level;

  const TestScreen({
    super.key,
    required this.domain,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TestQuestionDataHandler());
    controller.fetchQuestions(domain, level);

    RxString selectedOption = ''.obs;

    return Scaffold(
      appBar: AppBar(
        title: Text("Test - $domain"),
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.filteredQuestionDocIds.isEmpty ||
            controller.currentQuestion.isEmpty) {
          return const Center(child: Text("No questions found."));
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ✅ Question
              Text(
                "Q${controller.currentQuestionIndex.value + 1}. ${controller.currentQuestion['question'] ?? 'No Question'}",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              /// ✅ Options
              ...controller.currentOptions.map((option) {
                return Obx(() => RadioListTile<String>(
                      title: Text(option),
                      value: option,
                      groupValue: selectedOption.value,
                      onChanged: (value) {
                        selectedOption.value = value!;
                      },
                    ));
              }),

              const Spacer(),

              /// ✅ Action Button (Next / Submit)
              Obx(() {
                final isLastQuestion = controller.currentQuestionIndex.value ==
                    controller.filteredQuestionDocIds.length - 1;

                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: selectedOption.value.isEmpty
                        ? null
                        : () async {
                            await controller.submitAnswer(selectedOption.value);
                            selectedOption.value = '';
                          },
                    child: Text(isLastQuestion ? "Submit Test" : "Next"),
                  ),
                );
              }),
            ],
          ),
        );
      }),
    );
  }
}
