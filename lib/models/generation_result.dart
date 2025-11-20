import 'package:cloud_firestore/cloud_firestore.dart';

class GenerationResult {
  GenerationResult({
    required this.id,
    required this.imageUrl,
    required this.imagePath,
    required this.prompt,
    this.createdAt,
  });

  final String id;
  final String imageUrl;
  final String imagePath;
  final String prompt;
  final DateTime? createdAt;

  factory GenerationResult.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    return GenerationResult(
      id: doc.id,
      imageUrl: data['imageUrl'] as String? ?? '',
      imagePath: data['imagePath'] as String? ?? '',
      prompt: data['prompt'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}
