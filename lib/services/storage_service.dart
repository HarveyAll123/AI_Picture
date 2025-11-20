import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageUploadResult {
  StorageUploadResult({required this.path, required this.downloadUrl});

  final String path;
  final String downloadUrl;
}

class StorageService {
  StorageService(this._storage);

  final FirebaseStorage _storage;
  final _uuid = const Uuid();

  Future<StorageUploadResult> uploadOriginalImage({
    required String uid,
    required File file,
  }) async {
    final ext = file.path.split('.').last.toLowerCase();
    final id = _uuid.v4();
    final path = 'users/$uid/original/$id.$ext';

    final ref = _storage.ref().child(path);
    final metadata = SettableMetadata(contentType: 'image/$ext');
    await ref.putFile(file, metadata);
    final downloadUrl = await ref.getDownloadURL();

    return StorageUploadResult(path: path, downloadUrl: downloadUrl);
  }
}
