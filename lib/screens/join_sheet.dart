import 'package:flutter/material.dart';
import '../core/format.dart';
import '../core/navigation.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text.dart';
import '../models/group_deal.dart';
import '../state/store.dart';
import '../widgets/widgets.dart';
import 'group_screen.dart';

/// Bottom sheet that confirms joining [group] at the group price.
Future<void> showJoinSheet(BuildContext context, GroupDeal group) => showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (_) => _JoinSheet(group),
    );

class _JoinSheet extends StatelessWidget {
  const _JoinSheet(this.group);

  final GroupDeal group;

  void _join(BuildContext context) {
    final nav = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    nav.pop();
    if (store.joinGroup(group)) {
      nav.push(MaterialPageRoute(builder: (_) => GroupScreen(group)));
    } else {
      messenger.showSnackBar(const SnackBar(content: Text('That group just filled up or expired.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = group.product;
    final missing = group.missing;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: AppColors.line, borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 16),
            Text("Join ${group.host}'s group", style: AppText.h2),
            const SizedBox(height: 8),
            Text(
              '${missing == 1 ? '1 more person' : '$missing more people'} and everyone gets the group price.',
              style: AppText.body.copyWith(color: AppColors.ink2),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            AvatarStack([...group.members, me], seats: p.groupSize, size: 56),
            const SizedBox(height: 12),
            TimerPill(group.expiresAt, prefix: 'Ends in '),
            const SizedBox(height: 16),
            SummaryCard(
              color: AppColors.bg,
              rows: [
                SummaryRow(p.title, money(p.groupPrice)),
                const SummaryRow('Shipping', 'Free'),
                SummaryRow('You save', money(p.saving), valueColor: AppColors.success),
              ],
            ),
            const SizedBox(height: 16),
            AppButton('Join group · ${money(p.groupPrice)}', onPressed: () => _join(context)),
            const SizedBox(height: 10),
            Text(
              'Group not full in time? You are refunded automatically.',
              style: AppText.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
