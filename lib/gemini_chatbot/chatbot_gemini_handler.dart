// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

import 'package:get/get.dart';

class ChatController extends GetxController {
  var messages = <Map<String, String>>[].obs;
  var isLoading = false.obs;

  final TextEditingController messageController = TextEditingController();
  final String apiKey = "";
  late final Gemini gemini;

  @override
  void onInit() {
    super.onInit();
    gemini = Gemini.init(apiKey: apiKey);
  }

  Future<void> sendMessage() async {
    String userMessage = messageController.text.trim();
    if (userMessage.isEmpty) return;

    messages.add({"role": "user", "text": userMessage});
    messageController.clear();
    isLoading.value = true;

    String response = await getGeminiResponse(userMessage);
    messages.add({"role": "bot", "text": response});
    isLoading.value = false;
  }

  Future<String> getGeminiResponse(String prompt) async {
    try {
      final response = await gemini.text(prompt);
      return response?.output ?? "No response";
    } catch (e) {
      return "Error: ${e.toString()}";
    }
  }
}
