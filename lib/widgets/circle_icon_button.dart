import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// 40px round icon button (back, share, heart, bell).
class CircleIconButton extends StatelessWidget {
  const CircleIconButton(
    this.icon, {
    super.key,
    this.onTap,
    this.size = 40,
    this.border = false,
    this.background = AppColors.surface,
    this.iconColor = AppColors.ink,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final double size;
  final bool border;
  final Color background, iconColor;
  final String? tooltip;

  @override
  Widget build(BuildContext context) => Tooltip(
        message: tooltip ?? '',
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: background,
              shape: BoxShape.circle,
              border: border ? Border.all(color: AppColors.line) : null,
            ),
            child: Icon(icon, size: size * 0.5, color: iconColor),
          ),
        ),
      );
}
