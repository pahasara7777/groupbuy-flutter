import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// Big green check used on the "Group complete" and "Order placed" screens.
class SuccessBadge extends StatelessWidget {
  const SuccessBadge({super.key, this.size = 104});

  final double size;

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(color: AppColors.successSoft, shape: BoxShape.circle),
        child: Icon(Icons.check_rounded, size: size * 0.46, color: AppColors.success),
      );
}
