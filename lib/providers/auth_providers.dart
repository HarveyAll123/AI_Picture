import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'service_providers.dart';

final authStateChangesProvider = StreamProvider<User?>(
  (ref) => ref.watch(authServiceProvider).authStateChanges(),
);

final ensureAuthProvider = FutureProvider<User>(
  (ref) async => ref.watch(authServiceProvider).ensureAnonymousUser(),
);

final userIdProvider = Provider<String?>(
  (ref) => ref.watch(authStateChangesProvider).value?.uid,
);
