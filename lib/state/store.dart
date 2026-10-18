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
}

final store = Store();
