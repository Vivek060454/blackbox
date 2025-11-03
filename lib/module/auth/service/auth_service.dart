import 'package:firebase_auth/firebase_auth.dart';
import '../../../helper/shared_prefrence.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential?> signUp({
    required String email,
    required String password,
  }) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    AppSharedPreference.setLoggedIn(true);
    AppSharedPreference.setEmail(email);
    return userCredential;
  }

  Future<UserCredential?> signIn({
    required String email,
    required String password,
  }) async {
    final userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    AppSharedPreference.setLoggedIn(true);
    AppSharedPreference.setEmail(email);
    return userCredential;
  }

  Future<void> signOut() async {
    await _auth.signOut();
    AppSharedPreference.setLoggedIn(false);
  }

  bool isLoggedIn() => AppSharedPreference.isLoggedIn && currentUser != null;
}

