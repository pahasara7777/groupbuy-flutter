import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text.dart';

/// Rounded label with an optional leading icon (timers, perks, status).
class InfoPill extends StatelessWidget {
  const InfoPill(
    this.label, {
    super.key,
    this.icon,
    this.background = AppColors.accentSoft,
    this.foreground = AppColors.accent,
    this.radius = AppRadius.pill,
  });

  final String label;
  final IconData? icon;
  final Color background, foreground;
  final double radius;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(radius)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[Icon(icon, size: 14, color: foreground), const SizedBox(width: 6)],
            Text(label, style: AppText.caption.copyWith(color: foreground, fontWeight: FontWeight.w600)),
          ],
        ),
      );
}
