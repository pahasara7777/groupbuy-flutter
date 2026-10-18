import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:groupbuy/widgets/widgets.dart';
import 'widget_test_helpers.dart';

void main() {
  testWidgets('FloatingNavBar shows only the selected label and reports taps', (tester) async {
    int? tapped;
    await tester.pumpWidget(host(FloatingNavBar(index: 0, onChanged: (i) => tapped = i)));
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Cart'), findsNothing);
    await tester.tap(find.byKey(const ValueKey('nav-2')));
    expect(tapped, 2);
  });

  testWidgets('cart badge appears only when the cart has items', (tester) async {
    await tester.pumpWidget(host(FloatingNavBar(index: 0, onChanged: (_) {}, cartCount: 3)));
    expect(find.text('3'), findsOneWidget);
    await tester.pumpWidget(host(FloatingNavBar(index: 0, onChanged: (_) {})));
    expect(find.text('0'), findsNothing);
  });
}
