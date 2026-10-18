/// Formats [v] as dollars. Whole amounts drop the cents ($89, not $89.00).
// shortcut: one hard-coded currency, switch to intl NumberFormat when regions are added.
String money(double v) {
  final whole = v == v.roundToDouble();
  return '\$${whole ? v.toStringAsFixed(0) : v.toStringAsFixed(2)}';
}

/// Formats a remaining [d] as HH:MM:SS, or null when it is already over.
String? formatRemaining(Duration d) {
  if (d.isNegative) return null;
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(d.inHours)}:${two(d.inMinutes % 60)}:${two(d.inSeconds % 60)}';
}
