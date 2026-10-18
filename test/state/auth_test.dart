import 'package:flutter_test/flutter_test.dart';
import 'package:groupbuy/services/auth_service.dart';
import 'package:groupbuy/models/user_profile.dart';
import 'package:groupbuy/state/store.dart';

class _Failing extends DemoAuthService {
  @override
  Future<UserProfile> signIn(String email, String password) async => throw const AuthException('Wrong email or password.');
}

void main() {
  test('email sign in loads the profile', () async {
    final s = Store();
    expect(await s.signInWithEmail('a@b.co', 'secret1'), isNull);
    expect(s.signedIn, isTrue);
    expect(s.user, isNotNull);
  });

  test('register keeps the name the user typed', () async {
    final s = Store();
    expect(await s.register('Nimal Perera', 'n@p.lk', 'secret1'), isNull);
    expect(s.user!.initials, 'NP');
  });

  test('a failed sign in returns the message and stays signed out', () async {
    final s = Store()..auth = _Failing();
    expect(await s.signInWithEmail('a@b.co', 'bad'), 'Wrong email or password.');
    expect(s.signedIn, isFalse);
  });

  test('restoreSession does nothing without a stored user', () {
    final s = Store()..restoreSession();
    expect(s.signedIn, isFalse);
  });
}
