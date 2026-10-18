import 'package:flutter/material.dart';
import '../state/shell_tab.dart';

const tabHome = 0, tabCart = 1, tabOrders = 2, tabMe = 3;

/// Pops back to the app shell and selects [tab].
void goToTab(BuildContext context, int tab) {
  shellTab.value = tab;
  Navigator.of(context).popUntil((route) => route.isFirst);
}

/// Standard slide-in route used across the app.
Future<T?> pushScreen<T>(BuildContext context, Widget screen) =>
    Navigator.of(context).push<T>(MaterialPageRoute(builder: (_) => screen));

void showMessage(BuildContext context, String text) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text), behavior: SnackBarBehavior.floating));
}

/// Lets the store show a SnackBar without a BuildContext (set on MaterialApp in main.dart).
final messengerKey = GlobalKey<ScaffoldMessengerState>();
