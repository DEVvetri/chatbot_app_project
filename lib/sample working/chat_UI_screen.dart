// ModelChatMessageScreen
import 'package:chatbot_app_project/sample%20working/template_model_chat_message.dart';
import 'package:flutter/material.dart';

class ModelChatMessageScreen extends StatefulWidget {
  const ModelChatMessageScreen({super.key});

  @override
  State<ModelChatMessageScreen> createState() => _ModelChatMessageScreenState();
}

class _ModelChatMessageScreenState extends State<ModelChatMessageScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ModalMessage> _messages = [
    ModalMessage(text: 'hi this is vv', isUser: true),
    ModalMessage(
        text: 'hi vv this is auramemo what plan have you had for  today',
        isUser: false),
  ];
  bool _isLoading = false;

  // callGeminiModel() async{
  //   try{
  //     if(_controller.text.isNotEmpty){
  //       _messages.add(Message(text: _controller.text, isUser: true));
  //       _isLoading = true;
  //     }

  //     final model = GenerativeModel(model: 'gemini-pro', apiKey: dotenv.env['GOOGLE_API_KEY']!);
  //     final prompt = _controller.text.trim();
  //     final content = [Content.text(prompt)];
  //     final response = await model.generateContent(content);

  //     setState(() {
  //       _messages.add(Message(text: response.text!, isUser: false));
  //       _isLoading = false;
  //     });

  //     _controller.clear();
  //   }
  //   catch(e){
  //     print("Error : $e");
  //   }
  // }

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
                  return ListTile(
                    title: Align(
                      alignment: message.isUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
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
                                  : Theme.of(context).textTheme.titleSmall)),
                    ),
                  );
                }),
          ),

          // user input
          Padding(
            padding: const EdgeInsets.only(
                bottom: 32, top: 16.0, left: 16.0, right: 16),
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
                                setState(() {
                                  _messages.add(ModalMessage(
                                      text: _controller.text, isUser: true));
                                });
                                Future.delayed(
                                    Duration(seconds: 3),
                                    () => setState(() {
                                          _messages.add(ModalMessage(
                                              text: "you reply is loading",
                                              isUser: false));
                                        }));
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
