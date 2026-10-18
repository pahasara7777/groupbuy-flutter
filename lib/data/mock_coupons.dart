import '../models/coupon.dart';

List<Coupon> seedCoupons([DateTime? now]) {
  final t = now ?? DateTime.now();
  return [
    Coupon(
      code: 'WELCOME5',
      title: 'Welcome bonus',
      kind: CouponKind.amount,
      value: 5,
      minSpend: 30,
      expiresAt: t.add(const Duration(days: 43)),
    ),
    Coupon(
      code: 'POWER10',
      title: 'Group power-up',
      kind: CouponKind.percent,
      value: 10,
      minSpend: 0,
      expiresAt: t.add(const Duration(days: 58)),
    ),
    Coupon(
      code: 'SHIPFREE',
      title: 'Shipping boost',
      kind: CouponKind.freeShipping,
      value: 0,
      minSpend: 50,
      expiresAt: t.add(const Duration(days: 30)),
    ),
  ];
}

/// Coupons the demo user has already spent.
const usedCouponCodes = {'SHIPFREE'};
