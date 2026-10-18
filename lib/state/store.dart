import 'dart:async';
import 'package:flutter/foundation.dart';
import '../data/mock_coupons.dart';
import '../data/mock_groups.dart';
import '../data/mock_notifications.dart';
import '../data/mock_orders.dart';
import '../data/mock_products.dart';
import '../models/coupon.dart';
import '../models/app_notification.dart';
import '../models/group_deal.dart';
import '../models/order.dart';
import '../models/product.dart';
import '../models/user_profile.dart';
import '../data/demo_user.dart';
import '../services/auth_service.dart';
import '../services/shop_backend.dart';

/// Name used for the signed-in shopper inside group member lists.
const me = 'You';

/// Single source of truth for app state. Everything is in memory for now.
/// When Firebase is added, replace the bodies of these methods and keep the UI.
// shortcut: global singleton instead of Provider/Riverpod, upgrade when more stores appear.
class Store extends ChangeNotifier {
  final List<Product> products = mockProducts;
  late final List<GroupDeal> groups = seedGroups(products);
  late final List<Order> orders = seedOrders(products);
  final Map<String, int> cart = {}; // product id -> quantity
  late final List<AppNotification> notifications = seedNotifications();

  final List<Coupon> coupons = seedCoupons();
  final Set<String> _usedCoupons = {...usedCouponCodes};
  Coupon? appliedCoupon;

  int _orderSeq = 20480;
  int _groupSeq = 0;

  Product productById(String id) => products.firstWhere((p) => p.id == id);

  int get cartCount => cart.values.fold(0, (a, b) => a + b);

  void addToCart(Product p) {
    cart[p.id] = (cart[p.id] ?? 0) + 1;
    notifyListeners();
  }

  void removeFromCart(Product p) {
    final n = (cart[p.id] ?? 0) - 1;
    if (n <= 0) {
      cart.remove(p.id);
    } else {
      cart[p.id] = n;
    }
    notifyListeners();
  }

  /// Cart contents as (product, quantity) pairs, in insertion order.
  List<({Product product, int qty})> get cartLines =>
      [for (final e in cart.entries) (product: productById(e.key), qty: e.value)];

  double get cartTotal =>
      cartLines.fold<double>(0, (sum, l) => sum + l.product.price * l.qty);

  String _nextOrderId() => _backend == null
      ? '#GB-${++_orderSeq}'
      : '#GB-${(DateTime.now().millisecondsSinceEpoch % 100000).toString().padLeft(5, '0')}';

  /// Creates the order locally and, when [save] is true and a backend is connected, stores it there.
  Order _placeOrder(Product p, double paid, GroupDeal? g, {bool save = true}) {
    final o = Order(id: _nextOrderId(), product: p, paid: paid, at: DateTime.now(), group: g);
    orders.insert(0, o);
    if (save) _saveOrder(o);
    return o;
  }

  void _saveOrder(Order o) {
    final b = _backend;
    if (b == null) return;
    final rec = OrderRecord(
      id: '${_uid}_${o.at.microsecondsSinceEpoch}_${_orderSeq++}',
      ref: o.id,
      productId: o.product.id,
      paid: o.paid,
      at: o.at,
      groupId: o.group?.id,
    );
    b.saveOrder(rec, _uid!).catchError((Object _) => _notice('Could not save your order. Check your connection.'));
  }

  // ---- Backend (Firestore) -------------------------------------------------

  /// Set in main() once Firebase is configured. While null, everything stays in memory.
  ShopBackend? backend;
  ShopBackend? _backend;
  String? _uid;
  StreamSubscription<List<GroupRecord>>? _groupSub;
  StreamSubscription<List<OrderRecord>>? _orderSub;
  List<GroupRecord> _groupRecs = const [];
  List<OrderRecord> _orderRecs = const [];

  /// Shows a short message to the shopper (wired to a SnackBar in main()).
  void Function(String message)? onNotice;

  void _notice(String m) => onNotice?.call(m);

  /// True when groups and orders are shared through the backend instead of demo data.
  bool get isLive => _backend != null;

  /// Switches from demo data to the shared backend for the signed-in user.
  void _connect() {
    final b = backend, u = user;
    if (b == null || u == null || u.uid.isEmpty) return;
    _disconnect();
    _backend = b;
    _uid = u.uid;
    groups.clear();
    orders.clear();
    _groupSub = b.watchGroups().listen((r) {
      _groupRecs = r;
      _rebuild();
    });
    _orderSub = b.watchOrders(u.uid).listen((r) {
      _orderRecs = r;
      _rebuild();
    });
  }

  void _disconnect() {
    _groupSub?.cancel();
    _orderSub?.cancel();
    _groupSub = _orderSub = null;
    _backend = null;
    _uid = null;
    _groupRecs = const [];
    _orderRecs = const [];
    groups.clear();
    orders.clear();
  }

  Product? _productOrNull(String id) {
    for (final p in products) {
      if (p.id == id) return p;
    }
    return null;
  }

  /// Rebuilds [groups] and [orders] from the latest backend snapshots.
  /// Existing [GroupDeal] objects are updated in place so open screens keep working.
  void _rebuild() {
    final existing = {for (final g in groups) g.id: g};
    final next = <GroupDeal>[];
    for (final r in _groupRecs) {
      final p = _productOrNull(r.productId);
      if (p == null) continue;
      final members = [
        for (var i = 0; i < r.memberUids.length; i++) r.memberUids[i] == _uid ? me : r.memberNames[i],
      ];
      final g = existing[r.id];
      if (g == null) {
        next.add(GroupDeal(id: r.id, product: p, members: members, expiresAt: r.expiresAt));
      } else {
        g.members
          ..clear()
          ..addAll(members);
        next.add(g);
      }
    }
    groups
      ..clear()
      ..addAll(next);

    final byId = {for (final g in groups) g.id: g};
    final recs = [..._orderRecs]..sort((a, b) => b.at.compareTo(a.at));
    orders.clear();
    for (final r in recs) {
      final p = _productOrNull(r.productId);
      if (p == null) continue;
      var g = r.groupId == null ? null : byId[r.groupId];
      // Group too old to be listed any more: it has certainly expired.
      if (r.groupId != null && g == null) {
        g = GroupDeal(id: r.groupId!, product: p, members: [me], expiresAt: r.at);
      }
      orders.add(Order(id: r.ref, product: p, paid: r.paid, at: r.at, group: g));
    }
    notifyListeners();
  }

  /// Groups for [p] that [me] can still join.
  List<GroupDeal> openGroupsFor(Product p) => groups
      .where((g) => g.product.id == p.id && g.open && !g.members.contains(me))
      .toList();

  /// Starts a new 24 hour group with [me] as the first member.
  GroupDeal startGroup(Product p) {
    final g = GroupDeal(
      id: _backend == null ? 'g${_groupSeq++}' : '${_uid}_${DateTime.now().microsecondsSinceEpoch}',
      product: p,
      members: [me],
      expiresAt: DateTime.now().add(const Duration(hours: 24)),
    );
    groups.add(g);
    final o = _placeOrder(p, p.groupPrice, g, save: false);
    final b = _backend;
    if (b != null) {
      b
          .createGroup(GroupRecord(
            id: g.id,
            productId: p.id,
            groupSize: p.groupSize,
            memberUids: [_uid!],
            memberNames: [user!.name],
            expiresAt: g.expiresAt,
          ))
          .then((_) => _saveOrder(o))
          .catchError((Object _) {
        groups.remove(g);
        orders.remove(o);
        _notice('Could not start the group. Check your connection and try again.');
        notifyListeners();
      });
    }
    notifyListeners();
    return g;
  }

  /// Joins [g] at the group price. Returns false if it is full, expired or already joined.
  bool joinGroup(GroupDeal g) {
    if (!g.open || g.members.contains(me)) return false;
    g.members.add(me);
    final o = _placeOrder(g.product, g.product.groupPrice, g, save: false);
    final b = _backend;
    if (b != null) {
      void undo(String why) {
        g.members.remove(me);
        orders.remove(o);
        _notice(why);
        notifyListeners();
      }

      b.joinGroup(g.id, _uid!, user!.name).then((ok) {
        if (ok) {
          _saveOrder(o);
        } else {
          undo('Sorry, that group just filled up or ended.');
        }
      }).catchError((Object _) => undo('Could not join the group. Check your connection and try again.'));
    }
    notifyListeners();
    return true;
  }

  /// Buys [p] alone at the regular price.
  Order buySolo(Product p) {
    final o = _placeOrder(p, p.price, null);
    notifyListeners();
    return o;
  }

  /// Demo helper: pretend a friend opened your invite link.
  void simulateFriendJoin(GroupDeal g) {
    if (_backend != null || !g.open) return;
    g.members.add('Friend ${g.members.length}');
    notifyListeners();
  }

  /// Turns every cart line into solo orders and empties the cart.
  /// A coupon discount is spread across the lines in proportion to their price.
  List<Order> checkout() {
    final total = cartTotal;
    final ratio = total == 0 ? 1.0 : cartPayable / total;
    final placed = <Order>[];
    for (final l in cartLines) {
      for (var i = 0; i < l.qty; i++) {
        placed.add(_placeOrder(l.product, l.product.price * ratio, null));
      }
    }
    final c = appliedCoupon;
    if (c != null) _usedCoupons.add(c.code);
    appliedCoupon = null;
    cart.clear();
    notifyListeners();
    return placed;
  }

  bool isCouponUsed(Coupon c) => _usedCoupons.contains(c.code);

  /// Coupons still usable for [subtotal] (unused, not expired, minimum spend met).
  List<Coupon> usableCoupons(double subtotal) =>
      coupons.where((c) => !isCouponUsed(c) && c.appliesTo(subtotal)).toList();

  /// Applies [c] to the cart; pass null to remove. Returns false if it cannot be used.
  bool applyCoupon(Coupon? c) {
    if (c != null && (isCouponUsed(c) || !c.appliesTo(cartTotal))) return false;
    appliedCoupon = c;
    notifyListeners();
    return true;
  }

  double get cartDiscount => appliedCoupon?.discountFor(cartTotal) ?? 0;
  double get cartPayable => cartTotal - cartDiscount;

  final Set<String> _wishlist = {};

  bool isWished(Product p) => _wishlist.contains(p.id);

  void toggleWish(Product p) {
    if (!_wishlist.remove(p.id)) _wishlist.add(p.id);
    notifyListeners();
  }

  /// Case-insensitive match on title, category and description. Empty query = all.
  List<Product> search(String query, {String? category}) {
    final q = query.trim().toLowerCase();
    return products.where((p) {
      if (category != null && p.category != category) return false;
      if (q.isEmpty) return true;
      return p.title.toLowerCase().contains(q) ||
          p.category.toLowerCase().contains(q) ||
          p.description.toLowerCase().contains(q);
    }).toList();
  }

  List<Product> productsIn(String category) => search('', category: category);

  /// Best sellers first.
  List<Product> get trending => [...products]..sort((a, b) => b.sold.compareTo(a.sold));

  /// The product whose open group is closest to filling up (for the Deals banner).
  GroupDeal? get featuredGroup {
    final open = groups.where((g) => g.open).toList();
    if (open.isEmpty) return null;
    open.sort((a, b) => b.progress.compareTo(a.progress));
    return open.first;
  }

  int get unreadCount => notifications.where((n) => !n.read).length;

  void markAllRead() {
    for (final n in notifications) {
      n.read = true;
    }
    notifyListeners();
  }

  /// Orders filtered by [status]; null returns everything.
  List<Order> ordersWhere(OrderStatus? status) =>
      status == null ? List.of(orders) : orders.where((o) => o.status == status).toList();

  double get totalSaved => orders
      .where((o) => o.group != null && o.status != OrderStatus.refunded)
      .fold<double>(0, (s, o) => s + (o.product.price - o.paid));

  bool signedIn = false;
  bool onboarded = false;
  UserProfile? user;

  /// Swapped for [FirebaseAuthService] in main() once Firebase is configured.
  AuthService auth = DemoAuthService();

  /// Restores a session that outlived the app (Firebase keeps the user signed in).
  void restoreSession() {
    final u = auth.current;
    if (u == null) return;
    user = u;
    signedIn = true;
    onboarded = true;
    _connect();
    notifyListeners();
  }

  /// Returns an error message to show, or null on success.
  Future<String?> signInWithEmail(String email, String password) =>
      _authenticate(() => auth.signIn(email, password));

  Future<String?> register(String name, String email, String password) =>
      _authenticate(() => auth.register(name, email, password));

  Future<String?> _authenticate(Future<UserProfile> Function() attempt) async {
    try {
      user = await attempt();
      signedIn = true;
      _connect();
      notifyListeners();
      return null;
    } on AuthException catch (e) {
      return e.message;
    }
  }

  void finishOnboarding() {
    onboarded = true;
    notifyListeners();
  }

  /// Demo sign-in: accepts any non-empty email and loads the demo profile.
  // shortcut: no real auth, replace with FirebaseAuth when it is connected.
  bool signIn(String email) {
    if (email.trim().isEmpty) return false;
    user = demoUser;
    signedIn = true;
    notifyListeners();
    return true;
  }

  void signOut() {
    auth.signOut();
    _disconnect();
    user = null;
    signedIn = false;
    notifyListeners();
  }

  void markRead(AppNotification n) {
    if (n.read) return;
    n.read = true;
    notifyListeners();
  }
}

final store = Store();
