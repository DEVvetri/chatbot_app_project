// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'chat_service.dart';

class ChatUIScreen extends StatefulWidget {
  const ChatUIScreen({super.key});

  @override
  _ChatUIScreenState createState() => _ChatUIScreenState();
}

class _ChatUIScreenState extends State<ChatUIScreen> {
  final TextEditingController _controller = TextEditingController();
  final ChatService _chatService = ChatService();

  final List<Map<String, String>> _chatHistory = [];
  final List<Map<String, String>> _messages = [];

  void _sendMessage(String message) async {
    setState(() {
      _messages.add({"role": "USER", "message": message});
    });
    _controller.clear();

    final response = await _chatService.sendMessage(message, _chatHistory);

    setState(() {
      _messages.add({"role": "CHATBOT", "message": response});
      _chatHistory.add({"role": "USER", "message": message});
      _chatHistory.add({"role": "CHATBOT", "message": response});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chatbot"),
      ),
      body: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 500,
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return ListTile(
                  title: Text(msg["message"]!),
                  subtitle: Text(msg["role"]!),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Type a message",
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_controller.text.trim().isNotEmpty) {
                      _sendMessage(_controller.text.trim());
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
