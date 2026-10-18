/// A group as stored in the backend. Members are stored by uid plus display name.
class GroupRecord {
  const GroupRecord({
    required this.id,
    required this.productId,
    required this.groupSize,
    required this.memberUids,
    required this.memberNames,
    required this.expiresAt,
  });

  final String id, productId;
  final int groupSize;
  final List<String> memberUids, memberNames;
  final DateTime expiresAt;
}

/// An order as stored in the backend. [ref] is the "#GB-12345" number shown to the shopper.
class OrderRecord {
  const OrderRecord({
    required this.id,
    required this.ref,
    required this.productId,
    required this.paid,
    required this.at,
    this.groupId,
  });

  final String id, ref, productId;
  final double paid;
  final DateTime at;
  final String? groupId;
}

/// Where groups and orders live. The app talks to this, never to Firestore directly.
abstract class ShopBackend {
  Stream<List<GroupRecord>> watchGroups();
  Stream<List<OrderRecord>> watchOrders(String uid);
  Future<void> createGroup(GroupRecord g);

  /// Adds [uid] to the group only if it is still open and has a free slot.
  /// Returns false if someone else took the last slot or the timer ran out.
  Future<bool> joinGroup(String groupId, String uid, String name);
  Future<void> saveOrder(OrderRecord o, String uid);
}
