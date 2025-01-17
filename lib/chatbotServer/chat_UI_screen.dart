// ModelChatMessageScreen
// ignore_for_file: file_names, deprecated_member_use

import 'package:chatbot_app_project/chatbotServer/template_model_chat_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ModelChatMessageScreen extends StatefulWidget {
  const ModelChatMessageScreen({super.key});

  @override
  State<ModelChatMessageScreen> createState() => _ModelChatMessageScreenState();
}

class _ModelChatMessageScreenState extends State<ModelChatMessageScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ModalMessage> _messages = [];
  bool _isLoading = false;

  addUserMessage(String userMessage) {
    setState(() {
      _messages.add(ModalMessage(text: userMessage, isUser: true));
      _messages.add(ModalMessage(text: '.....', isUser: false));
      _isLoading = true;
    });
    auramemoAiChatbot(userMessage);
  }

  void copyToClipboardText(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Copied to clipboard!")),
    );
  }

  Future<void> auramemoAiChatbot(String userMessage) async {
    await Future.delayed(Duration(seconds: 2));
    userMessage = userMessage.trim().toLowerCase();
    String modalMessage = "";

    if (userMessage == "hi") {
      modalMessage = "Hello there! This is AURAMEMO.AI. How can I assist you?";
    } else if (userMessage == "tell me about you") {
      modalMessage =
          "I am AURAMEMO.AI, a chatbot designed to help students learn domain-specific technologies to support their future growth. At present, I specialize in software development topics. Feel free to ask me anything!";
    } else if (userMessage == "i feel bored" ||
        userMessage == "i am unable to complete") {
      modalMessage =
          "Believe in yourself! Every day is a new opportunity to grow and succeed. Take small steps toward your goal, and remember: consistency is key!";
    } else if (userMessage == "what is oops?") {
      modalMessage =
          "Object-Oriented Programming (OOPs) is a programming paradigm based on objects, which can contain data in the form of fields (attributes) and code in the form of procedures (methods). Key principles include encapsulation, inheritance, polymorphism, and abstraction.";
    } else if (userMessage == "what is data structure?") {
      modalMessage =
          "A data structure is a way of organizing and storing data so it can be accessed and modified efficiently. Examples include arrays, linked lists, stacks, queues, trees, and graphs.";
    } else if (userMessage == "explain machine learning") {
      modalMessage =
          "Machine Learning is a field of AI that allows systems to learn and improve from experience without being explicitly programmed. It involves algorithms that use data to identify patterns and make decisions. Examples include supervised, unsupervised, and reinforcement learning.";
    } else if (userMessage == "what is cloud computing?") {
      modalMessage =
          "Cloud computing refers to delivering computing services like servers, storage, databases, networking, and software over the internet ('the cloud'). It allows users to access resources on-demand without managing physical hardware.";
    } else if (userMessage == "how to learn coding?") {
      modalMessage =
          "To learn coding, start with a beginner-friendly language like Python or JavaScript. Practice regularly, build projects, explore online courses, and participate in coding challenges or communities.";
    } else if (userMessage == "what is big data?") {
      modalMessage =
          "Big Data refers to large and complex datasets that are difficult to process using traditional data management tools. It involves techniques for capturing, storing, and analyzing data to derive insights.";
    } else if (userMessage == "i need to learn software development") {
      modalMessage =
          "That's great! Software development involves several key techniques and technologies. Here's a list to get you started:\n\n"
          "1. **Programming Languages**: Python, Java, JavaScript, C++, C#.\n"
          "2. **Web Development**: HTML, CSS, JavaScript, React, Angular.\n"
          "3. **Backend Development**: Node.js, Django, Flask, Spring Boot.\n"
          "4. **Database Management**: MySQL, PostgreSQL, MongoDB.\n"
          "5. **Version Control**: Git, GitHub, GitLab.\n"
          "6. **Software Development Methodologies**: Agile, Scrum, Waterfall.\n"
          "7. **DevOps Tools**: Docker, Kubernetes, Jenkins.\n"
          "8. **Mobile App Development**: Flutter, React Native, Kotlin.\n"
          "9. **Testing**: Unit Testing, Integration Testing, Selenium.\n"
          "10. **Cloud Platforms**: AWS, Azure, Google Cloud Platform.\n\n"
          "Focus on one area at a time and build projects to reinforce your learning. Let me know if you'd like resources for any specific topic!";
    } else if (userMessage == "motivate me to study") {
      modalMessage =
          "Success doesn't come overnight, but every bit of effort you put in today will compound into greatness tomorrow. Stay consistent, stay curious, and trust the process—you are capable of amazing things!";
    } else if (userMessage ==
        "what are the best resources to learn programming?") {
      modalMessage =
          "Here are some of the best resources to learn programming:\n\n"
          "1. **Online Courses**: Udemy, Coursera, Codecademy, edX.\n"
          "2. **Interactive Platforms**: LeetCode, HackerRank, freeCodeCamp, W3Schools.\n"
          "3. **Books**: 'Clean Code' by Robert C. Martin, 'You Don’t Know JS' series.\n"
          "4. **YouTube Channels**: Programming with Mosh, Traversy Media, The Net Ninja.\n"
          "5. **Communities**: GitHub, Stack Overflow, Reddit (r/learnprogramming).\n\n"
          "Choose a resource based on your learning style and start practicing consistently!";
    } else if (userMessage ==
        "what is the best way to prepare for interviews?") {
      modalMessage = "To prepare for interviews:\n\n"
          "1. **Technical Skills**: Practice data structures, algorithms, and coding problems (use LeetCode, HackerRank).\n"
          "2. **System Design**: Learn to design scalable systems; resources like 'System Design Primer' on GitHub can help.\n"
          "3. **Mock Interviews**: Practice with peers or platforms like Pramp or Interviewing.io.\n"
          "4. **Behavioral Questions**: Prepare answers to common HR questions using the STAR (Situation, Task, Action, Result) method.\n"
          "5. **Projects**: Showcase personal or team projects on your resume and GitHub.\n\n"
          "Consistent preparation and practicing mock interviews will help you succeed!";
    } else {
      modalMessage =
          "I'm sorry, I didn't understand that. Could you please rephrase or ask something else?";
    }

    setState(() {
      _messages.removeLast();
      _messages.add(ModalMessage(text: modalMessage, isUser: false));
      _isLoading = false;
    });
  }

  List<String> recommendedInputs = [
    "hi",
    "tell me about you",
    "i feel bored",
    "i am unable to complete",
    "what is oops?",
    "what is data structure?",
    "explain machine learning",
    "what is cloud computing?",
    "how to learn coding?",
    "what is big data?",
    "i need to learn software development",
    "motivate me to study",
    "what are the best resources to learn programming?",
    "what is the best way to prepare for interviews?",
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(seconds: 1),
      () => setState(() {
        _messages.add(ModalMessage(
            text: "Hello there! This is AURAMEMO.AI. How can I assist you?",
            isUser: false));
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 1,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset('assets/images/gpt-robot.png'),
                SizedBox(
                  width: 10,
                ),
                Text('AURAMEMO AI',
                    style: TextStyle(fontWeight: FontWeight.bold))
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return Stack(
                    children: [
                      ListTile(
                        title: Align(
                          alignment: message.isUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: () =>
                                copyToClipboardText(context, message.text),
                            child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: message.isUser
                                        ? Colors.blueGrey
                                        : Colors.blueAccent,
                                    borderRadius: message.isUser
                                        ? BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            bottomRight: Radius.circular(20),
                                            bottomLeft: Radius.circular(20))
                                        : BorderRadius.only(
                                            topRight: Radius.circular(20),
                                            topLeft: Radius.circular(20),
                                            bottomRight: Radius.circular(20))),
                                child: Text(message.text,
                                    style: message.isUser
                                        ? Theme.of(context).textTheme.titleSmall
                                        : Theme.of(context)
                                            .textTheme
                                            .titleSmall)),
                          ),
                        ),
                      ),
                      message.isUser
                          ? Positioned(
                              right: 0,
                              child: CircleAvatar(
                                radius: 15,
                                backgroundImage: NetworkImage(
                                    "https://th.bing.com/th/id/OIP._OMjqSmWgbPetSaIqtkTYwHaHa?pid=ImgDet&w=206&h=206&c=7&dpr=1.1"),
                              ))
                          : Positioned(
                              bottom: 0,
                              child: CircleAvatar(
                                radius: 15,
                                backgroundImage:
                                    AssetImage('assets/images/gpt-robot.png'),
                              ))
                    ],
                  );
                }),
          ),

          // user input
          Visibility(
            replacement: SizedBox(),
            visible: _isLoading ? false : true,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                decoration: BoxDecoration(
                    // color: Colors.grey,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25))),
                height: 35,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: recommendedInputs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ElevatedButton(
                        onPressed: () {
                          addUserMessage(recommendedInputs[index]);
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.lightBlueAccent),
                            shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder())),
                        child: Text(recommendedInputs[index]),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                bottom: 32, top: 10.0, left: 16.0, right: 16),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3))
                  ]),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: Theme.of(context).textTheme.titleSmall,
                      decoration: InputDecoration(
                          hintText: 'Write your message',
                          hintStyle: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 20)),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  _isLoading
                      ? Padding(
                          padding: EdgeInsets.all(8),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: GestureDetector(
                            child: Image.asset('assets/images/send.png'),
                            onTap: () {
                              if (_controller.text.isNotEmpty) {
                                addUserMessage(_controller.text);
                                _controller.clear();
                              } else {
                                Get.showSnackbar(GetSnackBar(
                                  duration: Duration(seconds: 1),
                                  isDismissible: true,
                                  message:
                                      "No message founded fill field to get respones",
                                ));
                              }
                            },
                            // callGeminiModel,
                          ),
                        )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
