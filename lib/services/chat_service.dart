import 'dart:convert';
import 'package:http/http.dart' as http;
//https://huggingface.co/deepseek-ai/DeepSeek-R1
//login account in huggingface -> account setting -> access token -> create new token

class AIService {
  final String apiKey = "";  // GET YOUR OWN API KEY in FaceHugging website
  final String apiUrl = "https://router.huggingface.co/sambanova/v1/chat/completions";

  Future<String> sendMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $apiKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "messages": [
            {
                "role": "user",
                "content": message
            }
        ],
        "max_tokens": 500,
        "model": "DeepSeek-R1",
        "stream": false
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["choices"][0]["message"]["content"];  
      } else {
        return "Error: ${response.statusCode} - ${response.body}";
      }
    } catch (e) {
      return "Error: $e";
    }
  }
}
