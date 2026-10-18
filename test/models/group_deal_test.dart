import 'package:flutter_test/flutter_test.dart';
import 'package:groupbuy/models/group_deal.dart';
import 'package:groupbuy/models/product.dart';

const _p = Product(
  id: 'x',
  title: 'Test',
  category: 'Audio',
  image: 'a.jpg',
  price: 100,
  groupPrice: 70,
  groupSize: 3,
  sold: 1,
);

GroupDeal _g(List<String> members, Duration left) => GroupDeal(
      id: 'g',
      product: _p,
      members: members,
      expiresAt: DateTime.now().add(left),
    );

void main() {
  test('open while there is room and time', () {
    final g = _g(['A'], const Duration(hours: 1));
    expect(g.statusAt(), GroupStatus.open);
    expect(g.missing, 2);
    expect(g.progress, closeTo(1 / 3, 0.001));
    expect(g.host, 'A');
  });

  test('full wins over expired', () {
    final g = _g(['A', 'B', 'C'], const Duration(hours: -1));
    expect(g.statusAt(), GroupStatus.full);
    expect(g.open, isFalse);
  });

  test('expired when time is up and not full', () {
    final g = _g(['A'], const Duration(minutes: -1));
    expect(g.statusAt(), GroupStatus.expired);
    expect(g.expired, isTrue);
  });
}
