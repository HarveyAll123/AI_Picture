import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService(this._firebaseAuth);

  final FirebaseAuth _firebaseAuth;

  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  Future<User> ensureAnonymousUser() async {
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser != null) {
      return currentUser;
    }
    final credential = await _firebaseAuth.signInAnonymously();
    return credential.user!;
  }
}
