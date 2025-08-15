import 'package:flutter/material.dart';

class TestResultViewScreen extends StatelessWidget {
  final List<Map<String, dynamic>> questions;
  final String testName;
  const TestResultViewScreen(
      {super.key, required this.questions, required this.testName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(testName)),
      body: ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final result = questions[index];
          final question = result['question'];
          final options = result['options'] as List<dynamic>;
          final userPick = result['userpick'];
          final correctAnswer = result['answer'];
          final isCorrect = result['isCorrect'];

          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
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
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: ListTile(
                        title: Text(option),
                        leading: isUserPick
                            ? const Icon(Icons.person, color: Colors.blue)
                            : null,
                        trailing: isCorrectAns
                            ? const Icon(Icons.check, color: Colors.green)
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
    );
  }
}
