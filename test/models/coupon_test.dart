import 'package:flutter_test/flutter_test.dart';
import 'package:groupbuy/models/coupon.dart';

Coupon _c(CouponKind k, double v, {double min = 0, Duration left = const Duration(days: 5)}) => Coupon(
      code: 'C',
      title: 'Test',
      kind: k,
      value: v,
      minSpend: min,
      expiresAt: DateTime.now().add(left),
    );

void main() {
  test('badge text per kind', () {
    expect(_c(CouponKind.amount, 5).badge, '\$5');
    expect(_c(CouponKind.percent, 10).badge, '10%');
    expect(_c(CouponKind.freeShipping, 0).badge, 'Free');
  });

  test('amount discount never exceeds the subtotal', () {
    expect(_c(CouponKind.amount, 5).discountFor(100), 5);
    expect(_c(CouponKind.amount, 5).discountFor(3), 3);
  });

  test('percent discount', () {
    expect(_c(CouponKind.percent, 10).discountFor(80), closeTo(8, 0.0001));
  });

  test('minimum spend and expiry are enforced', () {
    final c = _c(CouponKind.amount, 5, min: 30);
    expect(c.appliesTo(29.99), isFalse);
    expect(c.appliesTo(30), isTrue);
    expect(_c(CouponKind.amount, 5, left: const Duration(days: -1)).appliesTo(100), isFalse);
  });
}
