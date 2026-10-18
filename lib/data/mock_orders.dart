import '../models/group_deal.dart';
import '../models/order.dart';
import '../models/product.dart';

/// Past orders shown on the Orders tab: one waiting, one complete, one refunded.
List<Order> seedOrders(List<Product> products, [DateTime? now]) {
  final t = now ?? DateTime.now();
  Product p(String id) => products.firstWhere((x) => x.id == id);
  return [
    Order(
      id: '#GB-20480',
      product: p('p5'),
      paid: p('p5').groupPrice,
      at: t.subtract(const Duration(hours: 1)),
      group: GroupDeal(
        id: 'mine1',
        product: p('p5'),
        members: ['Maya', 'You'],
        expiresAt: t.add(const Duration(hours: 23, minutes: 41)),
      ),
    ),
    Order(
      id: '#GB-20412',
      product: p('p4'),
      paid: p('p4').groupPrice,
      at: t.subtract(const Duration(days: 3)),
      group: GroupDeal(
        id: 'mine2',
        product: p('p4'),
        members: ['Kasun', 'Priya', 'You'],
        expiresAt: t.subtract(const Duration(days: 2)),
      ),
    ),
    Order(
      id: '#GB-20377',
      product: p('p3'),
      paid: p('p3').groupPrice,
      at: t.subtract(const Duration(days: 6)),
      group: GroupDeal(
        id: 'mine3',
        product: p('p3'),
        members: ['Ruwan', 'You'],
        expiresAt: t.subtract(const Duration(days: 5)),
      ),
    ),
  ];
}
