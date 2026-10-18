import 'package:firebase_auth/firebase_auth.dart';
import '../data/demo_user.dart';
import '../models/user_profile.dart';

/// Signing in and out. [DemoAuthService] needs no backend; [FirebaseAuthService] uses Firebase Auth.
abstract class AuthService {
  /// True when sign-in is faked, so the UI can offer the one-tap demo buttons.
  bool get isDemo;

  /// The already signed-in user (e.g. after an app restart), or null.
  UserProfile? get current;

  /// Both throw [AuthException] with a message that is safe to show.
  Future<UserProfile> signIn(String email, String password);
  Future<UserProfile> register(String name, String email, String password);
  Future<void> signOut();
}

class AuthException implements Exception {
  const AuthException(this.message);
  final String message;

  @override
  String toString() => message;
}

class DemoAuthService implements AuthService {
  @override
  bool get isDemo => true;

  @override
  UserProfile? get current => null;

  @override
  Future<UserProfile> signIn(String email, String password) async => demoUser;

  @override
  Future<UserProfile> register(String name, String email, String password) async =>
      UserProfile(name: name, email: email, address: demoUser.address);

  @override
  Future<void> signOut() async {}
}

class FirebaseAuthService implements AuthService {
  FirebaseAuthService([FirebaseAuth? auth]) : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  @override
  bool get isDemo => false;

  @override
  UserProfile? get current => _profile(_auth.currentUser);

  static UserProfile? _profile(User? u) {
    if (u == null) return null;
    final email = u.email ?? '';
    final name = (u.displayName?.trim().isNotEmpty ?? false) ? u.displayName! : email.split('@').first;
    return UserProfile(name: name, email: email, address: 'No delivery address yet');
  }

  @override
  Future<UserProfile> signIn(String email, String password) => _run(() async {
        final c = await _auth.signInWithEmailAndPassword(email: email.trim(), password: password);
        return _profile(c.user)!;
      });

  @override
  Future<UserProfile> register(String name, String email, String password) => _run(() async {
        final c = await _auth.createUserWithEmailAndPassword(email: email.trim(), password: password);
        await c.user?.updateDisplayName(name.trim());
        return UserProfile(name: name.trim(), email: email.trim(), address: 'No delivery address yet');
      });

  @override
  Future<void> signOut() => _auth.signOut();

  Future<UserProfile> _run(Future<UserProfile> Function() body) async {
    try {
      return await body();
    } on FirebaseAuthException catch (e) {
      throw AuthException(_message(e.code));
    }
  }

  static String _message(String code) => switch (code) {
        'invalid-email' => 'That email address does not look right.',
        'user-not-found' || 'wrong-password' || 'invalid-credential' => 'Wrong email or password.',
        'email-already-in-use' => 'An account with this email already exists.',
        'weak-password' => 'Choose a password with at least 6 characters.',
        'network-request-failed' => 'No connection. Check your internet and try again.',
        'too-many-requests' => 'Too many attempts. Try again in a few minutes.',
        _ => 'Could not sign in. Please try again.',
      };
}
