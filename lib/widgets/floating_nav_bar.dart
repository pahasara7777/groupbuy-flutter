import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text.dart';

/// Standard bottom navigation: four tabs, labels always visible, hairline on top.
class FloatingNavBar extends StatelessWidget {
  const FloatingNavBar({super.key, required this.index, required this.onChanged, this.cartCount = 0});

  final int index;
  final ValueChanged<int> onChanged;
  final int cartCount;

  static const _items = [
    (Icons.home_outlined, Icons.home, 'Home'),
    (Icons.shopping_cart_outlined, Icons.shopping_cart, 'Cart'),
    (Icons.inventory_2_outlined, Icons.inventory_2, 'Orders'),
    (Icons.person_outline, Icons.person, 'Me'),
  ];

  @override
  Widget build(BuildContext context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.line)),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              for (var i = 0; i < _items.length; i++)
                Expanded(
                  child: GestureDetector(
                    key: ValueKey('nav-$i'),
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onChanged(i),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Badge(
                            label: Text('$cartCount'),
                            isLabelVisible: i == 1 && cartCount > 0,
                            child: Icon(
                              i == index ? _items[i].$2 : _items[i].$1,
                              size: 24,
                              color: i == index ? AppColors.ink : AppColors.ink2,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _items[i].$3,
                            style: AppText.micro.copyWith(
                              color: i == index ? AppColors.ink : AppColors.ink2,
                              fontWeight: i == index ? FontWeight.w700 : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
}
