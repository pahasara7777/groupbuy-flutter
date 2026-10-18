import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/format.dart';
import '../core/navigation.dart';
import '../core/theme/app_text.dart';
import '../models/group_deal.dart';
import '../state/store.dart';
import '../widgets/widgets.dart';

/// Shown while a group is still filling up: progress ring, timer, seats and invite button.
class GroupWaitingView extends StatelessWidget {
  const GroupWaitingView(this.group, {super.key});

  final GroupDeal group;

  String get _link => 'https://groupbuy.app/g/${group.id}';

  Future<void> _invite(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: _link));
    if (context.mounted) showMessage(context, 'Invite link copied. Send it to a friend.');
  }

  @override
  Widget build(BuildContext context) {
    final p = group.product;
    final missing = group.missing;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: TopBar(
                'Your group',
                trailing: CircleIconButton(
                  Icons.ios_share,
                  border: true,
                  tooltip: 'Share invite link',
                  onTap: () => _invite(context),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    GroupProgressRing(
                      progress: group.progress,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('${group.members.length} / ${p.groupSize}', style: AppText.priceL.copyWith(color: null)),
                          Text('joined', style: AppText.caption),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '${missing == 1 ? 'One more' : '$missing more'} to unlock ${money(p.groupPrice)}',
                      style: AppText.h2,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Invite friends. If the group is not full when time runs out, you are refunded.',
                      style: AppText.body.copyWith(color: AppText.caption.color),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    TimerPill(group.expiresAt),
                    const SizedBox(height: 20),
                    AvatarStack(group.members, seats: p.groupSize, size: 48),
                    const SizedBox(height: 20),
                    WhiteCard(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          ProductThumb(p),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(p.title, style: AppText.bodyStrong),
                                const SizedBox(height: 2),
                                PriceTag(p),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    AppButton(
                      'Demo: a friend joins',
                      style: AppButtonStyle.outline,
                      onPressed: () => store.simulateFriendJoin(group),
                    ),
                  ],
                ),
              ),
            ),
            BottomActionBar(
              children: [AppButton('Invite friends', icon: Icons.link, onPressed: () => _invite(context))],
            ),
          ],
        ),
      ),
    );
  }
}
