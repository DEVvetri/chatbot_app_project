import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  final String apiUrl = "http://127.0.0.1:5000"; // Replace with your server URL

  Future<String> sendMessage(String message, List<Map<String, String>> chatHistory) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "message": message,
          "chat_history": chatHistory,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['response'];
      } else {
        throw Exception('Failed to load response');
      }
    } catch (e) {
      return "Error: ${e.toString()}";
    }
  }
}
