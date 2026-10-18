import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:groupbuy/widgets/widgets.dart';
import 'widget_test_helpers.dart';

void main() {
  testWidgets('AppButton shows its label and fires onPressed', (tester) async {
    var taps = 0;
    await tester.pumpWidget(host(AppButton('Pay \$89', onPressed: () => taps++)));
    expect(find.text('Pay \$89'), findsOneWidget);
    await tester.tap(find.text('Pay \$89'));
    expect(taps, 1);
  });

  testWidgets('AppButton with no handler is dimmed and does nothing', (tester) async {
    await tester.pumpWidget(host(const AppButton('Disabled', onPressed: null)));
    final opacity = tester.widget<Opacity>(
      find.descendant(of: find.byType(AppButton), matching: find.byType(Opacity)),
    );
    expect(opacity.opacity, 0.4);
  });
}
