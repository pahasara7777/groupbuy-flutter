import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// White rounded container used for list rows and sections.
class WhiteCard extends StatelessWidget {
  const WhiteCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.radius = 20,
    this.onTap,
    this.color = AppColors.surface,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final VoidCallback? onTap;
  final Color color;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: double.infinity,
          padding: padding,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(radius)),
          child: child,
        ),
      );
}
