import 'package:flutter_test/flutter_test.dart';
import 'package:groupbuy/state/store.dart';

void main() {
  final s = Store();

  test('empty query returns the whole catalogue', () {
    expect(s.search('').length, s.products.length);
  });

  test('matches titles case-insensitively', () {
    final r = s.search('HEADPHONES');
    expect(r.length, 6);
    expect(r.every((p) => p.category == 'Audio'), isTrue);
  });

  test('category filter narrows the results', () {
    expect(s.productsIn('Gaming').map((p) => p.id), ['p9']);
    expect(s.search('pro', category: 'Gaming').map((p) => p.id), ['p9']);
  });

  test('no match returns an empty list', () {
    expect(s.search('zzzz'), isEmpty);
  });

  test('trending is sorted by units sold', () {
    final t = s.trending;
    expect(t.first.id, 'p7'); // 7.9k
    for (var i = 1; i < t.length; i++) {
      expect(t[i - 1].sold >= t[i].sold, isTrue);
    }
  });
}
