import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../../../resources/constants/url_s.dart';

class AIService {
  Future<List<String>> recognizeIngredients(File image) async {
    final apiKey = dotenv.env['GEMINI_API_KEY']?.trim() ?? '';

    if (apiKey.isEmpty) {
      throw Exception('GEMINI_API_KEY missing from .env file.');
    }

    final imageBytes = await image.readAsBytes();
    final base64Image = base64Encode(imageBytes);

    final extension = image.path.split('.').last.toLowerCase();
    final mimeType = extension == 'png'
        ? 'image/png'
        : extension == 'webp'
            ? 'image/webp'
            : 'image/jpeg';

    const prompt = '''
Look at this image and identify all visible food ingredients.
Return ONLY a comma-separated list of specific ingredient names.
Rules:
- Be specific (e.g. "carrot" not "vegetable", "chicken breast" not "meat")
- Only real food ingredients, no brand names
- Maximum 5 ingredients
- If no food is visible, return: none
Example output: tomato, onion, garlic, chicken, bell pepper
''';

    final requestBody = {
      'contents': [
        {
          'parts': [
            {'text': prompt},
            {
              'inline_data': {
                'mime_type': mimeType,
                'data': base64Image,
              }
            }
          ]
        }
      ],
      'generationConfig': {
        'temperature': 0.1,
        'maxOutputTokens': 100,
      }
    };

    try {
      final response = await http
          .post(
            Uri.parse(UsedUrls.geminiUrl(apiKey)),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(requestBody),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final text = data['candidates']?[0]?['content']?['parts']?[0]?['text']
                as String? ??
            '';

        final trimmed = text.trim().toLowerCase();

        if (trimmed == 'none' || trimmed.isEmpty) {
          return [];
        }

        final ingredients = trimmed
            .split(',')
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty && s != 'none')
            .toList();

        return ingredients;
      } else if (response.statusCode == 403) {
        throw Exception(
            'Gemini API key invalid or not enabled. Check .env file.');
      } else {
        throw Exception(
            'Gemini API error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
