import 'group_deal.dart';
import 'product.dart';

enum OrderStatus { preparing, waitingForGroup, groupComplete, refunded }

class Order {
  Order({
    required this.id,
    required this.product,
    required this.paid,
    required this.at,
    this.group,
  });

  final String id;
  final Product product;
  final double paid;
  final DateTime at;

  /// Null when the product was bought alone.
  final GroupDeal? group;

  OrderStatus get status {
    final g = group;
    if (g == null) return OrderStatus.preparing;
    switch (g.statusAt()) {
      case GroupStatus.full:
        return OrderStatus.groupComplete;
      case GroupStatus.expired:
        return OrderStatus.refunded;
      case GroupStatus.open:
        return OrderStatus.waitingForGroup;
    }
  }

  String get statusLabel {
    switch (status) {
      case OrderStatus.preparing:
        return 'Preparing shipment';
      case OrderStatus.waitingForGroup:
        return 'Waiting for group';
      case OrderStatus.groupComplete:
        return 'Complete';
      case OrderStatus.refunded:
        return 'Refunded';
    }
  }
}
