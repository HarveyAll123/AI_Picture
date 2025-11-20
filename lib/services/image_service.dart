import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageService {
  static Future<bool> saveImageToGallery(String imageUrl) async {
    try {
      // Request storage permission
      final status = await Permission.photos.status;
      if (!status.isGranted) {
        final result = await Permission.photos.request();
        if (!result.isGranted) {
          return false;
        }
      }

      // Download image
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode != 200) {
        return false;
      }

      // Save to gallery
      final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.bodyBytes),
        quality: 100,
        name: 'ai_profile_${DateTime.now().millisecondsSinceEpoch}',
      );

      return result['isSuccess'] == true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> saveFileToGallery(File file) async {
    try {
      final status = await Permission.photos.status;
      if (!status.isGranted) {
        final result = await Permission.photos.request();
        if (!result.isGranted) {
          return false;
        }
      }

      final bytes = await file.readAsBytes();
      final result = await ImageGallerySaver.saveImage(
        bytes,
        quality: 100,
        name: 'ai_profile_${DateTime.now().millisecondsSinceEpoch}',
      );

      return result['isSuccess'] == true;
    } catch (e) {
      return false;
    }
  }
}

