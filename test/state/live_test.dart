import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:groupbuy/models/user_profile.dart';
import 'package:groupbuy/services/auth_service.dart';
import 'package:groupbuy/services/shop_backend.dart';
import 'package:groupbuy/state/store.dart';

/// In-memory stand-in for Firestore: pushes snapshots like the real stream does.
class FakeBackend implements ShopBackend {
  final groups = <GroupRecord>[];
  final orders = <OrderRecord>[];
  final _g = StreamController<List<GroupRecord>>.broadcast();
  final _o = StreamController<List<OrderRecord>>.broadcast();
  bool joinResult = true;
  bool failWrites = false;

  void push() {
    _g.add(List.of(groups));
    _o.add(List.of(orders));
  }

  @override
  Stream<List<GroupRecord>> watchGroups() async* {
    yield List.of(groups);
    yield* _g.stream;
  }

  @override
  Stream<List<OrderRecord>> watchOrders(String uid) async* {
    yield List.of(orders);
    yield* _o.stream;
  }

  @override
  Future<void> createGroup(GroupRecord g) async {
    if (failWrites) throw Exception('offline');
    groups.add(g);
    push();
  }

  @override
  Future<bool> joinGroup(String groupId, String uid, String name) async {
    if (!joinResult) return false;
    final i = groups.indexWhere((g) => g.id == groupId);
    final g = groups[i];
    groups[i] = GroupRecord(
      id: g.id,
      productId: g.productId,
      groupSize: g.groupSize,
      memberUids: [...g.memberUids, uid],
      memberNames: [...g.memberNames, name],
      expiresAt: g.expiresAt,
    );
    push();
    return true;
  }

  @override
  Future<void> saveOrder(OrderRecord o, String uid) async {
    orders.add(o);
    push();
  }
}

class _Auth extends DemoAuthService {
  @override
  Future<UserProfile> signIn(String email, String password) async =>
      const UserProfile(name: 'Test User', email: 'a@b.co', address: '', uid: 'u1');
}

Future<void> settle() => Future<void>.delayed(const Duration(milliseconds: 20));

void main() {
  late FakeBackend fake;
  late Store s;
  final notices = <String>[];

  setUp(() async {
    fake = FakeBackend();
    notices.clear();
    s = Store()
      ..auth = _Auth()
      ..backend = fake
      ..onNotice = notices.add;
    await s.signInWithEmail('a@b.co', 'pw');
    await settle();
  });

  test('signing in switches to live mode with no demo groups or orders', () {
    expect(s.isLive, isTrue);
    expect(s.groups, isEmpty);
    expect(s.orders, isEmpty);
  });

  test('starting a group stores the group and the order', () async {
    final p = s.productById('p1');
    final g = s.startGroup(p);
    await settle();
    expect(fake.groups.single.memberUids, ['u1']);
    expect(fake.orders.single.groupId, g.id);
    expect(s.groups.single, same(g)); // updated in place, screens keep their reference
    expect(s.orders.single.paid, p.groupPrice);
  });

  test("joining someone else's group adds you and saves the order", () async {
    final p = s.productById('p1');
    fake.groups.add(GroupRecord(
      id: 'other',
      productId: p.id,
      groupSize: 3,
      memberUids: ['u2'],
      memberNames: ['Maya'],
      expiresAt: DateTime.now().add(const Duration(hours: 5)),
    ));
    fake.push();
    await settle();
    expect(s.openGroupsFor(p), hasLength(1));
    expect(s.joinGroup(s.groups.single), isTrue);
    await settle();
    expect(s.groups.single.members, ['Maya', me]);
    expect(fake.orders.single.groupId, 'other');
  });

  test('losing the race for the last slot rolls the join back', () async {
    final p = s.productById('p1');
    fake.groups.add(GroupRecord(
      id: 'other',
      productId: p.id,
      groupSize: 3,
      memberUids: ['u2'],
      memberNames: ['Maya'],
      expiresAt: DateTime.now().add(const Duration(hours: 5)),
    ));
    fake.push();
    await settle();
    fake.joinResult = false;
    s.joinGroup(s.groups.single);
    await settle();
    expect(s.groups.single.members, ['Maya']);
    expect(s.orders, isEmpty);
    expect(fake.orders, isEmpty);
    expect(notices.single, contains('filled up'));
  });

  test('a failed group start is undone and the shopper is told', () async {
    fake.failWrites = true;
    s.startGroup(s.productById('p1'));
    await settle();
    expect(s.groups, isEmpty);
    expect(s.orders, isEmpty);
    expect(notices, hasLength(1));
  });

  test('signing out leaves live mode', () async {
    s.signOut();
    expect(s.isLive, isFalse);
    expect(s.groups, isEmpty);
  });
}
