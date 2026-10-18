import 'package:flutter/material.dart';
import '../core/format.dart';
import '../core/navigation.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text.dart';
import '../models/group_deal.dart';
import '../widgets/widgets.dart';

/// Shown once a group is full: order confirmed at the group price.
class GroupCompleteView extends StatelessWidget {
  const GroupCompleteView(this.group, {super.key});

  final GroupDeal group;

  @override
  Widget build(BuildContext context) {
    final p = group.product;
    final now = DateTime.now();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 48, 20, 20),
                child: Column(
                  children: [
                    const SuccessBadge(),
                    const SizedBox(height: 18),
                    Text('Group complete!', style: AppText.h1),
                    const SizedBox(height: 8),
                    Text(
                      'Everyone joined, so your order is confirmed at the group price.',
                      style: AppText.body.copyWith(color: AppColors.ink2),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 18),
                    WhiteCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              ProductThumb(p),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(p.title, style: AppText.bodyStrong),
                                    const SizedBox(height: 4),
                                    SavePill(p.saving, label: 'You saved'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          SummaryRow('You paid', money(p.groupPrice), bold: true),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              AvatarStack(group.members, size: 32),
                              const SizedBox(width: 10),
                              Text('${group.members.length} of ${p.groupSize} joined', style: AppText.caption),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    WhiteCard(
                      padding: const EdgeInsets.all(16),
                      radius: 16,
                      child: Row(
                        children: [
                          const Icon(Icons.local_shipping_outlined, size: 22),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Estimated arrival', style: AppText.caption),
                              const SizedBox(height: 2),
                              Text(
                                dateRange(now.add(const Duration(days: 6)), now.add(const Duration(days: 9))),
                                style: AppText.bodyStrong,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            BottomActionBar(
              children: [
                AppButton('Track order', style: AppButtonStyle.dark, onPressed: () => goToTab(context, tabOrders)),
                AppButton('Keep shopping', style: AppButtonStyle.soft, onPressed: () => goToTab(context, tabHome)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
