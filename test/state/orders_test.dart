import 'package:flutter_test/flutter_test.dart';
import 'package:groupbuy/models/order.dart';
import 'package:groupbuy/state/store.dart';

void main() {
  late Store s;
  setUp(() => s = Store());

  test('seeded orders cover waiting, complete and refunded', () {
    expect(s.ordersWhere(OrderStatus.waitingForGroup).length, 1);
    expect(s.ordersWhere(OrderStatus.groupComplete).length, 1);
    expect(s.ordersWhere(OrderStatus.refunded).length, 1);
    expect(s.ordersWhere(null).length, 3);
  });

  test('totalSaved ignores refunded orders', () {
    expect(s.totalSaved, 60); // 40 on headphones + 20 on the clock
  });

  test('featuredGroup is the open group closest to full', () {
    final g = s.featuredGroup!;
    expect(g.open, isTrue);
    for (final other in s.groups.where((x) => x.open)) {
      expect(g.progress >= other.progress, isTrue);
    }
  });
}
