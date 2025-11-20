import 'dart:typed_data';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiImageService {
  static const _modelName = 'gemini-1.5-flash';

  String _readApiKey() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception(
        'GEMINI_API_KEY is missing or empty. '
        'Add it to a .env file at the project root.',
      );
    }
    return apiKey;
  }

  Future<Uint8List> generateProfileVariant({
    required Uint8List baseImageBytes,
    required String stylePrompt,
  }) async {
    final apiKey = _readApiKey();
    final model = GenerativeModel(model: _modelName, apiKey: apiKey);

    final prompt =
        'Generate a high-quality profile picture variant of this person in '
        'this style: $stylePrompt. Keep face identity consistent, realistic, '
        'and suitable for social media avatars.';

    try {
      final response = await model.generateContent([
        Content.multi([
          TextPart(prompt),
          DataPart('image/jpeg', baseImageBytes),
        ]),
      ]);

      final candidates = response.candidates.toList();
      if (candidates.isEmpty) {
        throw Exception('Gemini returned no candidates for the request.');
      }

      // Find the first inline data part (image) in the response.
      for (final candidate in candidates) {
        final parts = candidate.content.parts;
        for (final part in parts) {
          if (part is DataPart && part.bytes.isNotEmpty) {
            return part.bytes;
          }
        }
      }

      throw Exception('Gemini response did not contain image bytes.');
    } on GenerativeAIException catch (error) {
      throw Exception('Gemini API error: ${error.message}');
    } catch (error) {
      throw Exception('Failed to generate image with Gemini: $error');
    }
  }
}
