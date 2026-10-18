import 'package:flutter_test/flutter_test.dart';
import 'package:groupbuy/models/order.dart';
import 'package:groupbuy/state/store.dart';

void main() {
  late Store s;
  setUp(() => s = Store());

  test('adding twice counts two and totals the solo price', () {
    final p = s.productById('p4');
    s.addToCart(p);
    s.addToCart(p);
    expect(s.cartCount, 2);
    expect(s.cartTotal, p.price * 2);
  });

  test('removing the last item clears the line', () {
    final p = s.productById('p4');
    s.addToCart(p);
    s.removeFromCart(p);
    expect(s.cart, isEmpty);
    expect(s.cartLines, isEmpty);
  });

  test('removing something not in the cart is harmless', () {
    s.removeFromCart(s.productById('p4'));
    expect(s.cart, isEmpty);
  });

  test('checkout creates one solo order per unit and empties the cart', () {
    final before = s.orders.length;
    s.addToCart(s.productById('p4'));
    s.addToCart(s.productById('p4'));
    s.addToCart(s.productById('p7'));
    final placed = s.checkout();
    expect(placed.length, 3);
    expect(s.orders.length, before + 3);
    expect(s.cart, isEmpty);
    expect(placed.every((o) => o.status == OrderStatus.preparing), isTrue);
  });

  test('buySolo pays the regular price', () {
    final p = s.productById('p2');
    final o = s.buySolo(p);
    expect(o.paid, p.price);
    expect(o.group, isNull);
  });

  test('order ids keep counting up', () {
    final a = s.buySolo(s.productById('p1')).id;
    final b = s.buySolo(s.productById('p1')).id;
    expect(a, isNot(b));
    expect(a, '#GB-20481');
  });
}
