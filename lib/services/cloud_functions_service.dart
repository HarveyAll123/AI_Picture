import 'package:cloud_functions/cloud_functions.dart';

class CloudFunctionsService {
  CloudFunctionsService(this._functions);

  final FirebaseFunctions _functions;

  Future<String> generateProfilePicture({
    required String imageUrl,
    String prompt = '',
  }) async {
    final callable = _functions.httpsCallable('generateProfilePicture');
    final response = await callable<Map<String, dynamic>>(<String, dynamic>{
      'imageUrl': imageUrl,
      'prompt': prompt,
    });
    final data = response.data;
    final generatedUrl = data['imageUrl'] as String?;
    if (generatedUrl == null || generatedUrl.isEmpty) {
      throw Exception('Generation did not return an imageUrl.');
    }
    return generatedUrl;
  }
}
