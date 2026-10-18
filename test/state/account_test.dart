import 'package:flutter_test/flutter_test.dart';
import 'package:groupbuy/state/store.dart';

void main() {
  late Store s;
  setUp(() => s = Store());

  test('sign in needs an email and loads the demo profile', () {
    expect(s.signIn('  '), isFalse);
    expect(s.signedIn, isFalse);
    expect(s.signIn('a@b.c'), isTrue);
    expect(s.signedIn, isTrue);
    expect(s.user!.initials, 'PL');
  });

  test('sign out clears the user', () {
    s.signIn('a@b.c');
    s.signOut();
    expect(s.signedIn, isFalse);
    expect(s.user, isNull);
  });

  test('onboarding flag flips once', () {
    expect(s.onboarded, isFalse);
    s.finishOnboarding();
    expect(s.onboarded, isTrue);
  });

  test('wishlist toggles on and off', () {
    final p = s.productById('p1');
    s.toggleWish(p);
    expect(s.isWished(p), isTrue);
    s.toggleWish(p);
    expect(s.isWished(p), isFalse);
  });

  test('notifications: unread count drops to zero after markAllRead', () {
    expect(s.unreadCount, 2);
    s.markAllRead();
    expect(s.unreadCount, 0);
  });

  test('store notifies listeners when state changes', () {
    var calls = 0;
    s.addListener(() => calls++);
    s.addToCart(s.productById('p1'));
    s.toggleWish(s.productById('p1'));
    expect(calls, 2);
  });
}
