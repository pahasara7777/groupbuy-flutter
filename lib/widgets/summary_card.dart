import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text.dart';

/// White rounded card holding [SummaryRow]s (subtotal, shipping, total...).
class SummaryCard extends StatelessWidget {
  const SummaryCard({super.key, required this.rows, this.color = AppColors.surface});

  final List<Widget> rows;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            for (var i = 0; i < rows.length; i++) ...[
              if (i > 0) const SizedBox(height: AppSpace.s12 - 2),
              rows[i],
            ],
          ],
        ),
      );
}

class SummaryRow extends StatelessWidget {
  const SummaryRow(this.label, this.value, {super.key, this.bold = false, this.valueColor});

  final String label, value;
  final bool bold;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: bold ? AppText.bodyStrong : AppText.body.copyWith(color: AppColors.ink2)),
          Text(value, style: AppText.bodyStrong.copyWith(color: valueColor)),
        ],
      );
}
