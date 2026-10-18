import 'package:flutter/material.dart';
import '../core/format.dart';
import '../core/navigation.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text.dart';
import '../models/group_deal.dart';
import '../widgets/widgets.dart';

/// Shown when the timer ran out before the group filled: the shopper is refunded.
class GroupExpiredView extends StatelessWidget {
  const GroupExpiredView(this.group, {super.key});

  final GroupDeal group;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 104,
                        height: 104,
                        decoration: const BoxDecoration(color: AppColors.line, shape: BoxShape.circle),
                        child: const Icon(Icons.history_toggle_off, size: 48, color: AppColors.ink2),
                      ),
                      const SizedBox(height: 18),
                      Text('Group expired', style: AppText.h1),
                      const SizedBox(height: 8),
                      Text(
                        'Not enough people joined ${group.product.title} in time, so we refunded '
                        '${money(group.product.groupPrice)} to your payment method.',
                        style: AppText.body.copyWith(color: AppColors.ink2),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              BottomActionBar(
                children: [AppButton('Back to shop', onPressed: () => goToTab(context, tabHome))],
              ),
            ],
          ),
        ),
      );
}
