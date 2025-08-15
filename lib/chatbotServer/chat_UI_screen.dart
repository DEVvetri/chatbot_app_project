// ModelChatMessageScreen
// ignore_for_file: file_names, deprecated_member_use

import 'package:chatbot_app_project/chatBot_project/games_modules/games_listing_screen.dart';
import 'package:chatbot_app_project/chatbotServer/template_model_chat_message.dart';
import 'package:chatbot_app_project/firebase/learning_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ModelChatMessageScreen extends StatefulWidget {
  const ModelChatMessageScreen({super.key});

  @override
  State<ModelChatMessageScreen> createState() => _ModelChatMessageScreenState();
}

class _ModelChatMessageScreenState extends State<ModelChatMessageScreen> {
  final TextEditingController _controller = TextEditingController();
  LearningService learningService = LearningService();
  final currentUser = FirebaseAuth.instance.currentUser!;
  final List<ModalMessage> _messages = [];
  bool _isLoading = false;
  bool isreadytoLearn = false;

  final String apiKey = "AIzaSyDsvXbunACMLCU19rWDDa-lrF1DSK6x5Lo";
  late final Gemini gemini;

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

  Future yesOrNoTraker(LearnTemplate learn) {
    return showAdaptiveDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          "Selected",
          // style: CustomTextStyle.titleMedium(context)
          //     .copyWith(color: Theme.of(context).colorScheme.onSurface),
        ),
        content: Text(
          "Are you sure? add ${learn.domainName} to learning process",
          // style: CustomTextStyle.labelMedium(context)
          //     .copyWith(color: Theme.of(context).colorScheme.onSurface),
        ),
        actions: [
          TextButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            onPressed: () => Get.back(),
            child: Text(
              "Cancel",
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await learningService
                    .addUsersDataLearning(learn.startedBy!, learn)
                    .whenComplete(
                      () => Get.back(),
                    );
                Get.showSnackbar(GetSnackBar(
                  message:
                      "Your selected domain has been added to the learning module.",
                ));
                Get.back();
              } catch (e) {
                // Check if the error is due to the title already existing
                if (e.toString() == "Exception: Title already exists") {
                  Get.showSnackbar(GetSnackBar(
                    message:
                        "This title already exists in your learning module.",
                  ));
                } else {
                  Get.showSnackbar(GetSnackBar(
                    message: "An error occurred: ${e.toString()}",
                  ));
                }
              }
            },
            child: const Text(
              "Add",
            ),
          ),
        ],
      ),
    );
  }

  Future<String?> generateStudyPromptForGemini() async {
    try {
      final email = FirebaseAuth.instance.currentUser?.email;
      if (email == null) return null;

      // Query the document by user_email
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) return null;

      final userDoc = querySnapshot.docs.first;
      final data = userDoc.data();

      if (!(data['isStarts'] == true)) return null;

      final level = data['levelOfDifficulty'] ?? 'Not specified';
      final domain = data['selectedDomain'] ?? 'Unknown domain';
      final firstScore = data['firstTestMark'] ?? '0/10';
      final highScore = data['highestScore'] ?? '0/10';
      final lowestScore = data['lowestScore'] ?? '0/10';
      String prompt = '''
A user is learning "$domain". They have taken assessment tests.

Details:
- Preferred Difficulty Level: $level
- First Test Score: $firstScore
- lowest Score Achieved: $lowestScore
- Highest Score Achieved: $highScore

Please provide a personalized study plan that includes:
1. Likely weak areas based on scores.
2. Suggested next topics to focus on in "$domain".
3. Tips to improve their understanding and retain concepts.
4. Motivation or feedback based on their current progress.
''';

      return prompt;
    } catch (e) {
      print("Error generating study prompt: $e");
      return null;
    }
  }

  Future<void> auramemoAiChatbot(String userMessage) async {
    await Future.delayed(Duration(seconds: 2));
    userMessage = userMessage.trim();
    String modalMessage = "";
    if (userMessage == 'analysis me') {
      final prompt = await generateStudyPromptForGemini();
      print(prompt);
      String response = await getGeminiResponse(prompt ?? '');
      modalMessage = response;
    } else if (userMessage.split(' ').contains('bored')) {
      Get.to(() => GamesListingScreen());
    } else if (userMessage == "hi" ||
        userMessage == "hey" ||
        userMessage == "Hello" ||
        userMessage == "Hey There") {
      modalMessage = "Hello there! This is AURAMEMO.AI. How can I assist you?";
    } else if (userMessage == "tell me about you" ||
        userMessage == "who are you") {
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
    } else if (userMessage == "learn software development") {
      modalMessage =
          "Software development involves building, testing, and maintaining software systems. Here's a roadmap to get you started:\n\n"
          "* Programming languages: Python, Java, C++, JavaScript\n"
          "* Development frameworks: Spring, Django, React, Angular\n"
          "* Databases: MySQL, MongoDB, PostgreSQL\n"
          "* Version control: Git, SVN\n"
          "* Agile methodologies: Scrum, Kanban";
    } else if (userMessage == "learn app development") {
      modalMessage =
          "App development involves building mobile applications for Android and iOS devices. Here's a roadmap to get you started:\n\n"
          "* Programming languages: Java, Swift, Kotlin, React Native\n"
          "* Development frameworks: Android Studio, Xcode, Flutter\n"
          "* Databases: Firebase, Realm\n"
          "* Design principles: Material Design, Human Interface Guidelines";
    } else if (userMessage == "learn web development") {
      modalMessage =
          "Web development involves building websites and web applications. Here's a roadmap to get you started:\n\n"
          "* Programming languages: HTML, CSS, JavaScript, PHP\n"
          "* Development frameworks: React, Angular, Vue.js\n"
          "* Databases: MySQL, MongoDB, PostgreSQL\n"
          "* Version control: Git, SVN\n"
          "* Design principles: Responsive Web Design, Accessibility";
    } else if (userMessage == "learn data science") {
      modalMessage =
          "Data science involves extracting insights from data using statistical and computational methods. Here's a roadmap to get you started:\n\n"
          "* Programming languages: Python, R, SQL\n"
          "* Data analysis libraries: Pandas, NumPy, Matplotlib\n"
          "* Machine learning libraries: Scikit-learn, TensorFlow\n"
          "* Data visualization tools: Tableau, Power BI\n"
          "* Statistics and probability: Hypothesis testing, Confidence intervals";
    } else if (userMessage == "learn Cyber security") {
      modalMessage =
          "Cyber security involves protecting computer systems and networks from cyber threats. Here's a roadmap to get you started:\n\n"
          "* Security frameworks: NIST, ISO 27001\n"
          "* Threat analysis: Risk assessment, Vulnerability scanning\n"
          "* Security protocols: SSL/TLS, Firewall configuration\n"
          "* Incident response: Disaster recovery, Forensic analysis\n"
          "* Security certifications: CompTIA Security+, CISSP";
    } else if (userMessage == "learn artificial intelligence") {
      modalMessage =
          "Artificial intelligence involves building intelligent systems that can perform tasks that typically require human intelligence. Here's a roadmap to get you started:\n\n"
          "* Programming languages: Python, Java, C++\n"
          "* AI frameworks: TensorFlow, PyTorch\n"
          "* Machine learning algorithms: Supervised learning, Unsupervised learning\n"
          "* Deep learning architectures: CNN, RNN, LSTM\n"
          "* AI applications: Computer vision, Natural language processing";
    } else if (userMessage == "learn Devops") {
      modalMessage =
          "DevOps involves bridging the gap between development and operations teams. Here's a roadmap to get you started:\n\n"
          "* DevOps tools: Jenkins, Docker, Kubernetes\n"
          "* Agile methodologies: Scrum, Kanban\n"
          "* Continuous integration: CI/CD pipelines\n"
          "* Continuous monitoring: Logging, Monitoring\n"
          "* DevOps certifications: DevOps Foundation Certification, Certified Scrum Master";
    } else if (userMessage == "learn Flutter") {
      modalMessage =
          "Flutter involves building natively compiled applications for mobile, web, and desktop. Here's a roadmap to get you started:\n\n"
          "* Programming language: Dart\n"
          "* Flutter framework: Flutter SDK\n"
          "* UI components: Widgets, Layouts\n"
          "* State management: Provider, Riverpod\n"
          "* Networking: HTTP, WebSocket";
    } else if (userMessage == "learn React") {
      modalMessage =
          "React involves building reusable UI components for web applications. Here's a roadmap to get you started:\n\n"
          "* Programming language: JavaScript\n"
          "* React framework: React Library\n"
          "* UI components: JSX, Components\n"
          "* State management: Redux, Context API\n"
          "* Routing: React Router";
    } else if (userMessage == "learn Angular") {
      modalMessage =
          "Angular involves building complex web applications using an opinionated framework. Here's a roadmap to get you started:\n\n"
          "* Programming language: TypeScript\n"
          "* Angular framework: Angular CLI\n"
          "* UI components: Components, Templates\n"
          "* State management: Services, Observables\n"
          "* Routing: Angular Router";
    } else if (userMessage == "learn Vue") {
      modalMessage =
          "Vue involves building progressive and flexible web applications. Here's a roadmap to get you started:\n\n"
          "* Programming language: JavaScript\n"
          "* Vue.js framework: Vue CLI\n"
          "* UI components: Components, Templates\n"
          "* State management: Vuex, Vue Router\n"
          "* Routing: Vue Router";
    } else if (userMessage == "learn Blockchain") {
      modalMessage =
          "Blockchain involves building decentralized and secure networks using distributed ledger technology. Here's a roadmap to get you started:\n\n"
          "* Programming language: Solidity, JavaScript\n"
          "* Blockchain platforms: Ethereum, Hyperledger Fabric\n"
          "* Smart contracts: ERC-20, ERC-721\n"
          "* Cryptography: Hash functions, Digital signatures\n"
          "* Blockchain certifications: Certified Blockchain Developer, Blockchain Council";
    } else if (userMessage == "learn iot") {
      modalMessage =
          "IoT involves building connected devices and networks that interact with the physical world. Here's a roadmap to get you started:\n\n"
          "* Programming language: C, Python, JavaScript\n"
          "* IoT platforms: Arduino, Raspberry Pi\n"
          "* Sensors and actuators: Temperature sensors, LED lights\n"
          "* Communication protocols: HTTP, MQTT, CoAP\n"
          "* IoT certifications: Certified IoT Developer, IoT Council";
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
      String response = await getGeminiResponse(userMessage);
      modalMessage = response;
    }

    setState(() {
      _messages.removeLast();
      _messages.add(ModalMessage(text: modalMessage, isUser: false));
      _isLoading = false;
    });

    if (checkers.contains(userMessage)) {
      List<String> splitedWords = userMessage.split(' ');

      if (splitedWords.length % 2 == 0) {
        String title = splitedWords[splitedWords.length - 1];
        String description = extractIntroduction(modalMessage);
        List<Map<String, dynamic>> listofwords = extractTopics(modalMessage);
        List<String> subtitles = extractTSubtitles(listofwords);
        String startBy = currentUser.email!;
        LearnTemplate learnTemplate = LearnTemplate(
            domainName: title,
            domainDescription: description,
            subtitles: subtitles,
            startedBy: startBy,
            startedDate: null,
            listOfworks: listofwords);

        yesOrNoTraker(learnTemplate);
      } else {
        String title =
            "${splitedWords[splitedWords.length - 2]} ${splitedWords[splitedWords.length - 1]}";
        String description = extractIntroduction(modalMessage);
        List<Map<String, dynamic>> listofwords = extractTopics(modalMessage);
        List<String> subtitles = extractTSubtitles(listofwords);
        String startBy = currentUser.email!;
        LearnTemplate learnTemplate = LearnTemplate(
            domainName: title,
            domainDescription: description,
            subtitles: subtitles,
            startedBy: startBy,
            startedDate: null,
            listOfworks: listofwords);

        yesOrNoTraker(learnTemplate);
      }
    }
  }

  Future<String> getGeminiResponse(String prompt) async {
    try {
      final response = await gemini.text(prompt);
      return response?.output ?? "No response";
    } catch (e) {
      return "Error: ${e.toString()}";
    }
  }

  List<String> extractTSubtitles(
      List<Map<String, dynamic>> topicsWithSubtopics) {
    List<String> topics = [];

    for (var item in topicsWithSubtopics) {
      if (item.containsKey('topic')) {
        topics.add(item['topic']);
      }
    }

    return topics;
  }

  String extractIntroduction(String message) {
    List<String> lines = message.split('\n');

    String introduction = lines[0].trim();

    return introduction;
  }

  List<Map<String, dynamic>> extractTopics(String message) {
    List<Map<String, dynamic>> result = [];

    List<String> lines = message.split('\n');

    for (String line in lines) {
      if (line.trim().startsWith('*')) {
        String trimmedLine = line.replaceFirst('*', '').trim();

        List<String> parts = trimmedLine.split(':');
        if (parts.length == 2) {
          String topic = parts[0].trim();
          String subtopics = parts[1].trim();

          result.add({'topic': topic, 'subtopics': subtopics});
        }
      }
    }

    return result;
  }

  List<String> recommendedInputs = [
    "analysis me",
    "learn software development",
    "learn app development",
    "learn web development",
    "learn data science",
    "learn Cyber security",
    "learn artificial intelligence",
    "learn Devops",
    "learn Flutter",
    "learn React",
    "learn Angular",
    "learn Vue",
    "learn Blockchain",
    "learn iot"
  ];
  List<String> checkers = [
    "learn software development",
    "learn app development",
    "learn web development",
    "learn data science",
    "learn Cyber security",
    "learn artificial intelligence",
    "learn Devops",
    "learn Flutter",
    "learn React",
    "learn Angular",
    "learn Vue",
    "learn Blockchain",
    "learn iot"
  ];
  @override
  void initState() {
    super.initState();
    gemini = Gemini.init(apiKey: apiKey);
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
  void dispose() {
    super.dispose();
    gemini.cancelRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  _messages.clear();
                });
              },
              icon: Icon(Iconsax.close_circle)),
        ],
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
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.fade))
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
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10))))),
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
                              // yesOrNoTraker(_controller.text);
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
