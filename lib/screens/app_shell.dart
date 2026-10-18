import 'package:flutter/material.dart';
import '../state/shell_tab.dart';
import '../state/store.dart';
import '../widgets/widgets.dart';
import 'cart_screen.dart';
import 'home_screen.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';

/// The four tabs (Home, Cart, Orders, Me) with the bottom navigation bar.
class AppShell extends StatelessWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<int>(
        valueListenable: shellTab,
        builder: (context, tab, _) => Scaffold(
          body: IndexedStack(
            index: tab,
            children: const [HomeScreen(), CartScreen(), OrdersScreen(), ProfileScreen()],
          ),
          bottomNavigationBar: ListenableBuilder(
            listenable: store,
            builder: (context, _) => FloatingNavBar(
              index: tab,
              cartCount: store.cartCount,
              onChanged: (i) => shellTab.value = i,
            ),
          ),
        ),
      );
}
