import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../services/auth_service.dart';
import '../services/cloud_functions_service.dart';
import '../services/firestore_service.dart';
import '../services/storage_service.dart';
import '../services/gemini_image_service.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>(
  (_) => FirebaseAuth.instance,
);

final firebaseStorageProvider = Provider<FirebaseStorage>(
  (_) => FirebaseStorage.instance,
);

final firebaseFunctionsProvider = Provider<FirebaseFunctions>(
  (_) => FirebaseFunctions.instanceFor(region: 'us-central1'),
);

final firestoreProvider = Provider<FirebaseFirestore>(
  (_) => FirebaseFirestore.instance,
);

final imagePickerProvider = Provider<ImagePicker>((_) => ImagePicker());

final authServiceProvider = Provider<AuthService>(
  (ref) => AuthService(ref.watch(firebaseAuthProvider)),
);

final storageServiceProvider = Provider<StorageService>(
  (ref) => StorageService(ref.watch(firebaseStorageProvider)),
);

final cloudFunctionsServiceProvider = Provider<CloudFunctionsService>(
  (ref) => CloudFunctionsService(ref.watch(firebaseFunctionsProvider)),
);

final firestoreServiceProvider = Provider<FirestoreService>(
  (ref) => FirestoreService(ref.watch(firestoreProvider)),
);

final geminiImageServiceProvider = Provider<GeminiImageService>(
  (_) => GeminiImageService(),
);
