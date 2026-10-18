import 'package:flutter/material.dart';
import '../core/format.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text.dart';

/// Small red "-31%" badge for product photos.
class DiscountBadge extends StatelessWidget {
  const DiscountBadge(this.percent, {super.key});

  final int percent;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.accent,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Text('-$percent%', style: AppText.micro.copyWith(color: Colors.white)),
      );
}

/// Green "Save $40" pill.
class SavePill extends StatelessWidget {
  const SavePill(this.amount, {super.key, this.label = 'Save'});

  final double amount;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.successSoft,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Text(
          '$label ${money(amount)}',
          style: AppText.caption.copyWith(color: AppColors.success, fontWeight: FontWeight.w600),
        ),
      );
}
