import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:groupbuy/data/mock_products.dart';
import 'package:groupbuy/widgets/widgets.dart';
import 'widget_test_helpers.dart';

void main() {
  testWidgets('ProductCard shows title, prices, badge and group info', (tester) async {
    final p = mockProducts.firstWhere((p) => p.id == 'p5');
    var opened = 0;
    await tester.pumpWidget(host(SizedBox(width: 171, child: ProductCard(p, onTap: () => opened++))));
    expect(find.text('Studio Headphones Pro'), findsOneWidget);
    expect(find.text('\$89'), findsOneWidget);
    expect(find.text('\$129'), findsOneWidget);
    expect(find.text('-31%'), findsOneWidget);
    expect(find.text('4 to unlock · 5.6k sold'), findsOneWidget);
    await tester.tap(find.text('Studio Headphones Pro'));
    expect(opened, 1);
  });

  testWidgets('heart switches icon when wished', (tester) async {
    final p = mockProducts.first;
    await tester.pumpWidget(host(SizedBox(width: 171, child: ProductCard(p, onTap: () {}, wished: true))));
    expect(find.byIcon(Icons.favorite), findsOneWidget);
    expect(find.byIcon(Icons.favorite_border), findsNothing);
  });
}
