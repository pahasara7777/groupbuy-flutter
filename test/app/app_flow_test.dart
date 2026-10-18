import 'package:flutter/widgets.dart' show ValueKey;
import 'package:flutter_test/flutter_test.dart';
import 'package:groupbuy/main.dart';
import 'package:groupbuy/state/store.dart';

void main() {
  testWidgets('onboarding, sign in, then the shell appears', (tester) async {
    await tester.pumpWidget(const GroupBuyApp(splash: Duration.zero));
    expect(find.text('Better prices, together'), findsOneWidget);

    store.finishOnboarding();
    await tester.pump();
    expect(find.text('Welcome back'), findsOneWidget);

    store.signIn('a@b.co');
    await tester.pump();
    expect(find.byKey(const ValueKey('nav-0')), findsOneWidget);
  });
}
