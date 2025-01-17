// ignore_for_file: file_names

import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/material.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  late DialogFlowtter dialogFlowtter;
  final TextEditingController messageInsert = TextEditingController();
  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    initializeDialogFlowtter();
  }

  void initializeDialogFlowtter() async {
    try {
      dialogFlowtter =
          await DialogFlowtter.fromFile(path: "assets/service.json");
    } catch (e) {
      debugPrint("Error initializing DialogFlowtter: $e");
    }
  }

  void sendMessage(String text) async {
    if (text.isEmpty) return;

    setState(() {
      messages.insert(0, {"data": 1, "message": text});
    });

    try {
      DetectIntentResponse response = await dialogFlowtter.detectIntent(
        queryInput: QueryInput(text: TextInput(text: text)),
      );

      if (response.message == null || response.message!.text == null) return;

      setState(() {
        messages.insert(
            0, {"data": 0, "message": response.message!.text!.text![0]});
      });
    } catch (e) {
      debugPrint("Error sending message: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chatbot"),
      ),
      body: Container(
          // child: Column(
          //   children: <Widget>[
          //     Container(
          //       padding: const EdgeInsets.only(top: 15, bottom: 10),
          //       child: Text(
          //         "Today, ${TimeOfDay.now().format(context)}",
          //         style: const TextStyle(fontSize: 20),
          //       ),
          //     ),
          //     Flexible(
          //       child: ListView.builder(
          //         reverse: true,
          //         itemCount: messages.length,
          //         itemBuilder: (context, index) => chat(
          //           messages[index]["message"].toString(),
          //           messages[index]["data"],
          //         ),
          //       ),
          //     ),
          //     const SizedBox(height: 20),
          //     const Divider(height: 5.0, color: Colors.greenAccent),
          //     ListTile(
          //       leading: IconButton(
          //         icon: const Icon(
          //           Icons.camera_alt,
          //           color: Colors.greenAccent,
          //           size: 35,
          //         ),
          //         onPressed: () {},
          //       ),
          //       title: Container(
          //         height: 35,
          //         decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(15),
          //           color: const Color.fromRGBO(220, 220, 220, 1),
          //         ),
          //         padding: const EdgeInsets.only(left: 15),
          //         child: TextFormField(
          //           controller: messageInsert,
          //           decoration: const InputDecoration(
          //             hintText: "Enter a Message...",
          //             hintStyle: TextStyle(color: Colors.black26),
          //             border: InputBorder.none,
          //           ),
          //           style: const TextStyle(fontSize: 16, color: Colors.black),
          //         ),
          //       ),
          //       trailing: IconButton(
          //         icon: const Icon(
          //           Icons.send,
          //           size: 30.0,
          //           color: Colors.greenAccent,
          //         ),
          //         onPressed: () {
          //           if (messageInsert.text.isNotEmpty) {
          //             sendMessage(messageInsert.text);
          //             messageInsert.clear();
          //           }
          //         },
          //       ),
          //     ),
          //     const SizedBox(height: 15.0),
          //   ],
          // ),
          ),
    );
  }

  Widget chat(String message, int data) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      // child: Row(
      //   mainAxisAlignment:
      //       data == 1 ? MainAxisAlignment.end : MainAxisAlignment.start,
      //   children: [
      //     if (data == 0)
      //       const CircleAvatar(
      //         backgroundImage: AssetImage("assets/robot.jpg"),
      //         radius: 30,
      //       ),
      //     Padding(
      //       padding: const EdgeInsets.all(10.0),
      //       child: Bubble(
      //         radius: const Radius.circular(15.0),
      //         color: data == 0
      //             ? const Color.fromRGBO(23, 157, 139, 1)
      //             : Colors.orangeAccent,
      //         elevation: 0.0,
      //         child: Padding(
      //           padding: const EdgeInsets.all(2.0),
      //           child: Row(
      //             mainAxisSize: MainAxisSize.min,
      //             children: <Widget>[
      //               const SizedBox(width: 10.0),
      //               Flexible(
      //                 child: Container(
      //                   constraints: const BoxConstraints(maxWidth: 200),
      //                   child: Text(
      //                     message,
      //                     style: const TextStyle(
      //                       color: Colors.white,
      //                       fontWeight: FontWeight.bold,
      //                     ),
      //                   ),
      //                 ),
      //               )
      //             ],
      //           ),
      //         ),
      //       ),
      //     ),
      //     if (data == 1)
      //       const CircleAvatar(
      //         backgroundImage: AssetImage("assets/images/splash1.png"),
      //         radius: 30,
      //       ),
      //   ],
      // ),
    );
  }
}
