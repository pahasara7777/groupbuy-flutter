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
}

final store = Store();
