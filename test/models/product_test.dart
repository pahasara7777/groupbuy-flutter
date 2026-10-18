import 'package:flutter_test/flutter_test.dart';
import 'package:groupbuy/models/product.dart';

Product _p({double price = 129, double group = 89, int sold = 5600}) => Product(
      id: 'x',
      title: 'Test',
      category: 'Audio',
      image: 'assets/images/headphones_pro.jpg',
      price: price,
      groupPrice: group,
      groupSize: 4,
      sold: sold,
    );

void main() {
  test('saving and percent are derived from the two prices', () {
    final p = _p();
    expect(p.saving, 40);
    expect(p.savingPercent, 31);
  });

  test('soldLabel uses k for thousands only', () {
    expect(_p(sold: 5600).soldLabel, '5.6k');
    expect(_p(sold: 860).soldLabel, '860');
  });
}
