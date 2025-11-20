import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/generation_result.dart';
import 'auth_providers.dart';
import 'service_providers.dart';

final resultsProvider = StreamProvider.autoDispose<List<GenerationResult>>((
  ref,
) {
  final uid = ref.watch(userIdProvider);
  if (uid == null) {
    return Stream<List<GenerationResult>>.value(const []);
  }
  return ref.watch(firestoreServiceProvider).watchResults(uid);
});
