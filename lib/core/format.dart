/// Formats [v] as dollars. Whole amounts drop the cents ($89, not $89.00).
// shortcut: one hard-coded currency, switch to intl NumberFormat when regions are added.
String money(double v) {
  final whole = v == v.roundToDouble();
  return '\$${whole ? v.toStringAsFixed(0) : v.toStringAsFixed(2)}';
}
