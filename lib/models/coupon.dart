enum CouponKind { amount, percent, freeShipping }

class Coupon {
  const Coupon({
    required this.code,
    required this.title,
    required this.kind,
    required this.value,
    required this.minSpend,
    required this.expiresAt,
  });

  final String code, title;
  final CouponKind kind;

  /// Dollars for [CouponKind.amount], percent for [CouponKind.percent].
  final double value, minSpend;
  final DateTime expiresAt;

  /// Short label for the coupon tile: "$5", "10%" or "Free".
  String get badge {
    switch (kind) {
      case CouponKind.amount:
        return '\$${value.toStringAsFixed(0)}';
      case CouponKind.percent:
        return '${value.toStringAsFixed(0)}%';
      case CouponKind.freeShipping:
        return 'Free';
    }
  }

  bool appliesTo(double subtotal, [DateTime? now]) =>
      subtotal >= minSpend && (now ?? DateTime.now()).isBefore(expiresAt);

  /// Money taken off [subtotal]. Never more than the subtotal itself.
  double discountFor(double subtotal) {
    switch (kind) {
      case CouponKind.amount:
        return value > subtotal ? subtotal : value;
      case CouponKind.percent:
        return subtotal * value / 100;
      case CouponKind.freeShipping:
        return 0; // shipping is already free for now
    }
  }
}
