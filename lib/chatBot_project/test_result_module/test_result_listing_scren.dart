import 'package:chatbot_app_project/chatBot_project/test_result_module/data_controller/test_result_controller.dart';
import 'package:chatbot_app_project/chatBot_project/test_result_module/test_result_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';

class TestResultsListingScreen extends StatelessWidget {
  const TestResultsListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TestResultForDAtaController());
    controller.fetchTestResults();

    return Scaffold(
      appBar: AppBar(title: const Text(" Your Test Results")),
      body: Obx(() {
        if (controller.testResults.isEmpty) {
          return const Center(child: Text("No Test Results Found"));
        }

        return ListView.builder(
          itemCount: controller.testResults.length,
          itemBuilder: (context, index) {
            final test = controller.testResults[index];
            return Card(
              child: ListTile(
                title: Text("Test ${test['index'] + 1}"),
                subtitle: Text(
                    "✔️ Correct: ${test['correct']} | ❌ Wrong: ${test['wrong']}"),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Get.to(() => TestResultViewScreen(
                        questions: test['questions'],
                        testName: "Test ${test['index'] + 1}",
                      ));
                },
              ),
            );
          },
        );
      }),
    );
  }
}
