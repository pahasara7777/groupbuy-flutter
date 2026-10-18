import 'product.dart';

enum GroupStatus { open, full, expired }

/// A team of shoppers unlocking [Product.groupPrice] together.
class GroupDeal {
  GroupDeal({
    required this.id,
    required this.product,
    required this.members,
    required this.expiresAt,
  });

  final String id;
  final Product product;
  final List<String> members;
  final DateTime expiresAt;

  bool get full => members.length >= product.groupSize;
  bool isExpired([DateTime? now]) => (now ?? DateTime.now()).isAfter(expiresAt);
  bool get expired => isExpired();

  /// A full group is always "full", even if its timer ran out afterwards.
  GroupStatus statusAt([DateTime? now]) {
    if (full) return GroupStatus.full;
    if (isExpired(now)) return GroupStatus.expired;
    return GroupStatus.open;
  }

  bool get open => statusAt() == GroupStatus.open;
  int get missing => (product.groupSize - members.length).clamp(0, product.groupSize);
  double get progress => (members.length / product.groupSize).clamp(0.0, 1.0);
  String get host => members.first;
}
