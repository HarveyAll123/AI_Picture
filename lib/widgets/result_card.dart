import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/generation_result.dart';
import '../services/image_service.dart';

class ResultCard extends StatelessWidget {
  const ResultCard({super.key, required this.result, required this.onTap});

  final GenerationResult result;
  final VoidCallback onTap;

  Future<void> _copyPrompt(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: result.prompt));
    Fluttertoast.showToast(
      msg: 'Prompt copied to clipboard',
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  Future<void> _downloadImage(BuildContext context) async {
    final success = await ImageService.saveImageToGallery(result.imageUrl);
    if (context.mounted) {
      Fluttertoast.showToast(
        msg: success
            ? 'Image saved to gallery'
            : 'Failed to save image. Please check permissions.',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            GridTile(
              footer: Container(
                padding: const EdgeInsets.all(8),
                color: Colors.black54,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        result.prompt,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => _copyPrompt(context),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.copy,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              child: CachedNetworkImage(
                imageUrl: result.imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Container(color: Colors.grey.shade200),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () => _downloadImage(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.download,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
