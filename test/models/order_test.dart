import 'package:flutter_test/flutter_test.dart';
import 'package:groupbuy/models/group_deal.dart';
import 'package:groupbuy/models/order.dart';
import 'package:groupbuy/models/product.dart';

const _p = Product(
  id: 'x',
  title: 'Test',
  category: 'Audio',
  image: 'a.jpg',
  price: 100,
  groupPrice: 70,
  groupSize: 2,
  sold: 1,
);

Order _o(GroupDeal? g) => Order(id: '#1', product: _p, paid: 70, at: DateTime.now(), group: g);

GroupDeal _g(List<String> m, Duration left) =>
    GroupDeal(id: 'g', product: _p, members: m, expiresAt: DateTime.now().add(left));

void main() {
  test('solo order is just preparing', () {
    expect(_o(null).status, OrderStatus.preparing);
  });

  test('group order follows the group', () {
    expect(_o(_g(['A'], const Duration(hours: 1))).status, OrderStatus.waitingForGroup);
    expect(_o(_g(['A', 'B'], const Duration(hours: 1))).status, OrderStatus.groupComplete);
    expect(_o(_g(['A'], const Duration(hours: -1))).status, OrderStatus.refunded);
  });

  test('status labels are human readable', () {
    expect(_o(_g(['A', 'B'], const Duration(hours: 1))).statusLabel, 'Complete');
    expect(_o(_g(['A'], const Duration(hours: -1))).statusLabel, 'Refunded');
  });
}
