import 'package:flutter_test/flutter_test.dart';
import 'package:groupbuy/models/group_deal.dart';
import 'package:groupbuy/models/order.dart';
import 'package:groupbuy/state/store.dart';

void main() {
  late Store s;
  setUp(() => s = Store());

  test('startGroup opens a 24h group and places a group-price order', () {
    final p = s.productById('p1');
    final g = s.startGroup(p);
    expect(g.open, isTrue);
    expect(g.members, [me]);
    expect(s.orders.first.paid, p.groupPrice);
    expect(s.orders.first.status, OrderStatus.waitingForGroup);
  });

  test('joining the last open seat completes the group', () {
    final g = s.groups.firstWhere((g) => g.id == 'seed1'); // 3 of 4
    expect(s.joinGroup(g), isTrue);
    expect(g.full, isTrue);
    expect(s.orders.first.status, OrderStatus.groupComplete);
    expect(s.orders.first.paid, g.product.groupPrice);
  });

  test('cannot join the same group twice or a full group', () {
    final g = s.groups.firstWhere((g) => g.id == 'seed1');
    expect(s.joinGroup(g), isTrue);
    expect(s.joinGroup(g), isFalse);
  });

  test('cannot join an expired group', () {
    final p = s.productById('p1');
    final g = GroupDeal(
      id: 'old',
      product: p,
      members: ['Zed'],
      expiresAt: DateTime.now().subtract(const Duration(minutes: 1)),
    );
    s.groups.add(g);
    expect(s.joinGroup(g), isFalse);
    expect(g.members, ['Zed']);
  });

  test('openGroupsFor hides groups the user already joined', () {
    final p5 = s.productById('p5');
    final before = s.openGroupsFor(p5).length;
    final g = s.openGroupsFor(p5).first;
    s.joinGroup(g);
    expect(s.openGroupsFor(p5).length, before - 1);
  });

  test('simulateFriendJoin fills the group', () {
    final g = s.startGroup(s.productById('p1'));
    while (g.open) {
      s.simulateFriendJoin(g);
    }
    expect(g.full, isTrue);
    expect(g.members.length, g.product.groupSize);
  });
}
