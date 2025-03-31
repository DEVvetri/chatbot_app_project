import 'package:chatbot_app_project/chatBot_project/commons.dart';
import 'package:chatbot_app_project/chatBot_project/questions_domain_manager_module/controller_questions/test_questions_handler.dart';
import 'package:chatbot_app_project/chatBot_project/questions_domain_manager_module/questions_listing_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DomainsListScreen extends StatefulWidget {
  const DomainsListScreen({super.key});

  @override
  _DomainsListScreenState createState() => _DomainsListScreenState();
}

class _DomainsListScreenState extends State<DomainsListScreen> {
  final TestQuestionsController controller = Get.put(TestQuestionsController());

  // Track which domain is expanded
  Map<String, bool> expandedState = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(backgroundColor: Commons().blueColor, title: Text('Domains')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.domains.isEmpty) {
          return Center(child: Text('No domains found.'));
        }

        return ListView.builder(
          itemCount: controller.domains.length,
          itemBuilder: (context, index) {
            var domain = controller.domains[index];
            bool isExpanded = expandedState[domain['id']] ?? false;

            return Column(
              children: [
                Card(
                  color: Commons().blueColor,
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(domain['domain']),
                    trailing: Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                    ),
                    onTap: () {
                      setState(() {
                        expandedState[domain['id']] = !isExpanded;
                      });
                    },
                  ),
                ),

                // Animated Container for Levels (Expands when tapped)
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: isExpanded ? 50 : 0,
                  child: isExpanded
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: ['Low', 'Medium', 'High'].map((level) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: GestureDetector(
                                onTap: () {
                                  controller
                                      .fetchQuestions(domain['id'])
                                      .whenComplete(() {
                                    Get.to(() => QuestionsListScreen(
                                          domainId: domain['id'],
                                        ));
                                  });
                                },
                                child: Chip(
                                  label: Text(level),
                                  backgroundColor: level == 'Low'
                                      ? Colors.blue.shade800
                                      : level == 'High'
                                          ? Colors.redAccent.shade200
                                          : Colors.yellow.shade800,
                                  labelStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            );
                          }).toList(),
                        )
                      : SizedBox(),
                ),
              ],
            );
          },
        );
      }),
    );
  }
}
