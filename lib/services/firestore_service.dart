import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/generation_result.dart';

class FirestoreService {
  FirestoreService(this._firestore);

  final FirebaseFirestore _firestore;

  Stream<List<GenerationResult>> watchResults(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('results')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(GenerationResult.fromDoc)
              .toList(growable: false),
        );
  }
}
