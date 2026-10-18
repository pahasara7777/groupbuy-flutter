import '../models/group_deal.dart';
import '../models/product.dart';

/// Groups other shoppers already started, so the join flow has something to join.
List<GroupDeal> seedGroups(List<Product> products, [DateTime? now]) {
  final t = now ?? DateTime.now();
  Product p(String id) => products.firstWhere((x) => x.id == id);
  GroupDeal g(String id, String product, List<String> members, Duration left) =>
      GroupDeal(id: id, product: p(product), members: members, expiresAt: t.add(left));

  return [
    g('seed1', 'p5', ['Maya', 'Noor', 'Sam'], const Duration(hours: 2, minutes: 14)),
    g('seed2', 'p5', ['Leo', 'Ayesha'], const Duration(hours: 11, minutes: 40)),
    g('seed3', 'p1', ['Ayesha'], const Duration(hours: 5)),
    g('seed4', 'p4', ['Kasun', 'Priya'], const Duration(hours: 9)),
    g('seed5', 'p7', ['Omar'], const Duration(hours: 7)),
    g('seed6', 'p9', ['Sara', 'Tom'], const Duration(hours: 3)),
    g('seed7', 'p6', ['Liam'], const Duration(hours: 20)),
    g('seed8', 'p2', ['Nimal'], const Duration(hours: 12)),
    g('seed9', 'p8', ['Tara', 'Zoe', 'Ian'], const Duration(hours: 6)),
  ];
}
