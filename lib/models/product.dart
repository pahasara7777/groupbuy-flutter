/// A product that can be bought alone ([price]) or with a group ([groupPrice]).
class Product {
  const Product({
    required this.id,
    required this.title,
    required this.category,
    required this.image,
    required this.price,
    required this.groupPrice,
    required this.groupSize,
    required this.sold,
    this.rating = 4.8,
    this.description = '',
  });

  /// [image] is the asset path of the product photo.
  final String id, title, category, image, description;

  final double price, groupPrice, rating;
  final int groupSize, sold;

  double get saving => price - groupPrice;
  int get savingPercent => ((1 - groupPrice / price) * 100).round();

  /// "2.1k" for thousands, plain number below that.
  String get soldLabel => sold >= 1000 ? '${(sold / 1000).toStringAsFixed(1)}k' : '$sold';
}
