import 'package:flutter_test/flutter_test.dart';
import 'package:groupbuy/core/format.dart';

void main() {
  group('money', () {
    test('drops the cents on whole amounts', () => expect(money(89), '\$89'));
    test('keeps two decimals otherwise', () => expect(money(29.5), '\$29.50'));
  });

  group('formatRemaining', () {
    test('pads hours, minutes and seconds', () {
      expect(formatRemaining(const Duration(hours: 2, minutes: 14, seconds: 9)), '02:14:09');
    });
    test('keeps counting past 24 hours', () {
      expect(formatRemaining(const Duration(hours: 26)), '26:00:00');
    });
    test('returns null once the time is over', () {
      expect(formatRemaining(const Duration(seconds: -1)), isNull);
    });
  });
}
