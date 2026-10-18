import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text.dart';

/// Floating pill navigation. The selected tab shows its label on a dark pill.
class FloatingNavBar extends StatelessWidget {
  const FloatingNavBar({super.key, required this.index, required this.onChanged, this.cartCount = 0});

  final int index;
  final ValueChanged<int> onChanged;
  final int cartCount;

  static const _items = [
    (Icons.home_outlined, 'Home'),
    (Icons.shopping_cart_outlined, 'Cart'),
    (Icons.inventory_2_outlined, 'Orders'),
    (Icons.person_outline, 'Me'),
  ];

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: AppColors.ink.withValues(alpha: 0.14),
              blurRadius: 28,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < _items.length; i++)
              GestureDetector(
                key: ValueKey('nav-$i'),
                behavior: HitTestBehavior.opaque,
                onTap: () => onChanged(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(horizontal: i == index ? 18 : 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: i == index ? AppColors.ink : Colors.transparent,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Badge(
                        label: Text('$cartCount'),
                        isLabelVisible: i == 1 && cartCount > 0,
                        child: Icon(
                          _items[i].$1,
                          size: 22,
                          color: i == index ? Colors.white : AppColors.ink2,
                        ),
                      ),
                      if (i == index) ...[
                        const SizedBox(width: 8),
                        Text(_items[i].$2, style: AppText.caption.copyWith(color: Colors.white)),
                      ],
                    ],
                  ),
                ),
              ),
          ],
        ),
      );
}
