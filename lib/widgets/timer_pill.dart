import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text.dart';
import 'countdown.dart';

/// Red pill with a clock and a live countdown, e.g. "Closes in 23:41:08".
class TimerPill extends StatelessWidget {
  const TimerPill(this.until, {super.key, this.prefix = 'Closes in '});

  final DateTime until;
  final String prefix;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.accentSoft,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.schedule, size: 14, color: AppColors.accent),
            const SizedBox(width: 6),
            Countdown(
              until,
              prefix: prefix,
              style: AppText.caption.copyWith(color: AppColors.accent, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
}
