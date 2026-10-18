import 'package:flutter/foundation.dart';
import '../data/mock_groups.dart';
import '../data/mock_orders.dart';
import '../data/mock_products.dart';
import '../models/group_deal.dart';
import '../models/order.dart';
import '../models/product.dart';

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

  String _nextOrderId() => '#GB-${++_orderSeq}';

  Order _placeOrder(Product p, double paid, GroupDeal? g) {
    final o = Order(id: _nextOrderId(), product: p, paid: paid, at: DateTime.now(), group: g);
    orders.insert(0, o);
    return o;
  }

  /// Groups for [p] that [me] can still join.
  List<GroupDeal> openGroupsFor(Product p) => groups
      .where((g) => g.product.id == p.id && g.open && !g.members.contains(me))
      .toList();

  /// Starts a new 24 hour group with [me] as the first member.
  GroupDeal startGroup(Product p) {
    final g = GroupDeal(
      id: 'g${_groupSeq++}',
      product: p,
      members: [me],
      expiresAt: DateTime.now().add(const Duration(hours: 24)),
    );
    groups.add(g);
    _placeOrder(p, p.groupPrice, g);
    notifyListeners();
    return g;
  }

  /// Joins [g] at the group price. Returns false if it is full, expired or already joined.
  bool joinGroup(GroupDeal g) {
    if (!g.open || g.members.contains(me)) return false;
    g.members.add(me);
    _placeOrder(g.product, g.product.groupPrice, g);
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
    if (!g.open) return;
    g.members.add('Friend ${g.members.length}');
    notifyListeners();
  }
}

final store = Store();
