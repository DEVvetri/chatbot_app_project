import 'package:chatbot_app_project/chatBot_project/commons.dart';
import 'package:chatbot_app_project/chatBot_project/questions_domain_manager_module/controller_questions/test_questions_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuestionsListScreen extends StatefulWidget {
  final String domainId;

  const QuestionsListScreen({super.key, required this.domainId});

  @override
  _QuestionsListScreenState createState() => _QuestionsListScreenState();
}

class _QuestionsListScreenState extends State<QuestionsListScreen> {
  final TestQuestionsController controller = Get.find();
  Map<int, bool> expandedStates = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Commons().blueColor.withAlpha(250),
      appBar: AppBar(
        title: Text('Questions'),
        backgroundColor: Commons().blueColor,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.questions.isEmpty) {
          return Center(child: Text('No questions found.'));
        }

        return ListView.builder(
          itemCount: controller.questions.length,
          itemBuilder: (context, index) {
            var question = controller.questions[index];
            bool isExpanded = expandedStates[index] ?? false;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    expandedStates[index] = !isExpanded;
                  });
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  margin: EdgeInsets.all(8),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 4),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        spacing: 5,
                        children: [
                          Icon(
                            Icons.question_answer,
                            size: 25,
                          ),
                          Expanded(
                            child: Text(
                              question['question'],
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Icon(
                            isExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Text('Level: ${question['level']}'),
                      if (isExpanded) ...[
                        SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(question['options'].length,
                              (index) {
                            // Convert 'A', 'B', 'C', 'D' to index (A = 0, B = 1, C = 2, D = 3)
                            int correctIndex =
                                question['answer'].codeUnitAt(0) -
                                    'A'.codeUnitAt(0);
                            bool isCorrect = index == correctIndex;
                            List<String> optionsSet = ["A", "B", "C", "D"];

                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isCorrect
                                      ? Colors.green.shade200
                                      : Colors.blue.shade200,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: isCorrect
                                          ? Colors.green.shade300
                                          : Colors.blueAccent,
                                      child: Text(optionsSet[index]),
                                    ),
                                    SizedBox(
                                        width:
                                            10), // Space between avatar and text
                                    Expanded(
                                      // Ensures text wraps within the container
                                      child: Text(
                                        question['options'][index],
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: isCorrect
                                              ? Colors.green.shade800
                                              : Colors.black87,
                                          fontWeight: isCorrect
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                        softWrap: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      ]
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
