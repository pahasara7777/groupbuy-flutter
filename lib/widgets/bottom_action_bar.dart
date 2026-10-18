import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// Sticky bar for the main call to action(s) at the bottom of a screen.
class BottomActionBar extends StatelessWidget {
  const BottomActionBar({super.key, required this.children, this.row = false});

  final List<Widget> children;

  /// Lay the children out side by side (equal width) instead of stacked.
  final bool row;

  @override
  Widget build(BuildContext context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.line)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: row
                ? Row(
                    children: [
                      for (var i = 0; i < children.length; i++) ...[
                        if (i > 0) const SizedBox(width: 12),
                        Expanded(child: children[i]),
                      ],
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var i = 0; i < children.length; i++) ...[
                        if (i > 0) const SizedBox(height: 10),
                        children[i],
                      ],
                    ],
                  ),
          ),
        ),
      );
}
