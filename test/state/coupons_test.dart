import 'package:flutter_test/flutter_test.dart';
import 'package:groupbuy/state/store.dart';

void main() {
  late Store s;
  setUp(() => s = Store());

  test('minimum spend blocks a coupon on a small cart', () {
    s.addToCart(s.productById('p7')); // $42
    final welcome = s.coupons.firstWhere((c) => c.code == 'WELCOME5');
    expect(s.applyCoupon(welcome), isTrue);
    s.removeFromCart(s.productById('p7'));
    expect(s.applyCoupon(welcome), isFalse);
  });

  test('applied coupon lowers the payable total', () {
    s.addToCart(s.productById('p1')); // $49
    s.applyCoupon(s.coupons.firstWhere((c) => c.code == 'WELCOME5'));
    expect(s.cartDiscount, 5);
    expect(s.cartPayable, 44);
  });

  test('percent coupon takes a share of the subtotal', () {
    s.addToCart(s.productById('p5')); // $129
    s.applyCoupon(s.coupons.firstWhere((c) => c.code == 'POWER10'));
    expect(s.cartDiscount, closeTo(12.9, 0.0001));
  });

  test('a used coupon cannot be applied again', () {
    final ship = s.coupons.firstWhere((c) => c.code == 'SHIPFREE');
    s.addToCart(s.productById('p5'));
    expect(s.isCouponUsed(ship), isTrue);
    expect(s.applyCoupon(ship), isFalse);
  });

  test('checkout spends the coupon and splits the discount across orders', () {
    final welcome = s.coupons.firstWhere((c) => c.code == 'WELCOME5');
    s.addToCart(s.productById('p1')); // $49
    s.addToCart(s.productById('p4')); // $59 -> total $108
    s.applyCoupon(welcome);
    final placed = s.checkout();
    final paid = placed.fold<double>(0, (a, o) => a + o.paid);
    expect(paid, closeTo(103, 0.0001));
    expect(s.isCouponUsed(welcome), isTrue);
    expect(s.appliedCoupon, isNull);
  });

  test('usableCoupons respects used, minimum spend and expiry', () {
    final codes = s.usableCoupons(100).map((c) => c.code).toList();
    expect(codes, containsAll(['WELCOME5', 'POWER10']));
    expect(codes, isNot(contains('SHIPFREE')));
    expect(s.usableCoupons(10).map((c) => c.code), ['POWER10']);
  });
}
