import 'package:cloud_firestore/cloud_firestore.dart';
import 'shop_backend.dart';

/// Firestore layout: `groups/{id}` and `orders/{id}` (see firestore.rules).
class FirestoreBackend implements ShopBackend {
  FirestoreBackend([FirebaseFirestore? db]) : _db = db ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  @override
  Stream<List<GroupRecord>> watchGroups() => _db
      .collection('groups')
      .where('expiresAt', isGreaterThan: Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 30))))
      .snapshots()
      .map((s) => [for (final d in s.docs) _group(d.id, d.data())]);

  @override
  Stream<List<OrderRecord>> watchOrders(String uid) => _db
      .collection('orders')
      .where('uid', isEqualTo: uid)
      .snapshots()
      .map((s) => [for (final d in s.docs) _order(d.id, d.data())]);

  @override
  Future<void> createGroup(GroupRecord g) => _db.collection('groups').doc(g.id).set({
        'productId': g.productId,
        'groupSize': g.groupSize,
        'memberUids': g.memberUids,
        'memberNames': g.memberNames,
        'expiresAt': Timestamp.fromDate(g.expiresAt),
      });

  @override
  Future<bool> joinGroup(String groupId, String uid, String name) {
    final ref = _db.collection('groups').doc(groupId);
    return _db.runTransaction((tx) async {
      final snap = await tx.get(ref);
      final d = snap.data();
      if (d == null) return false;
      final uids = List<String>.from(d['memberUids'] as List);
      final names = List<String>.from(d['memberNames'] as List);
      final expires = (d['expiresAt'] as Timestamp).toDate();
      if (uids.contains(uid) || uids.length >= (d['groupSize'] as int) || expires.isBefore(DateTime.now())) {
        return false;
      }
      tx.update(ref, {'memberUids': [...uids, uid], 'memberNames': [...names, name]});
      return true;
    });
  }

  @override
  Future<void> saveOrder(OrderRecord o, String uid) => _db.collection('orders').doc(o.id).set({
        'uid': uid,
        'ref': o.ref,
        'productId': o.productId,
        'paid': o.paid,
        'at': Timestamp.fromDate(o.at),
        if (o.groupId != null) 'groupId': o.groupId,
      });

  static GroupRecord _group(String id, Map<String, dynamic> d) => GroupRecord(
        id: id,
        productId: d['productId'] as String,
        groupSize: d['groupSize'] as int,
        memberUids: List<String>.from(d['memberUids'] as List),
        memberNames: List<String>.from(d['memberNames'] as List),
        expiresAt: (d['expiresAt'] as Timestamp).toDate(),
      );

  static OrderRecord _order(String id, Map<String, dynamic> d) => OrderRecord(
        id: id,
        ref: d['ref'] as String,
        productId: d['productId'] as String,
        paid: (d['paid'] as num).toDouble(),
        at: (d['at'] as Timestamp).toDate(),
        groupId: d['groupId'] as String?,
      );
}
