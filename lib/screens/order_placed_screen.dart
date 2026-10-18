import 'package:flutter/material.dart';
import '../core/navigation.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text.dart';
import '../models/group_deal.dart';
import '../models/order.dart';
import '../widgets/widgets.dart';
import 'group_screen.dart';

enum _Step { done, active, pending }

class OrderPlacedScreen extends StatelessWidget {
  const OrderPlacedScreen(this.order, {super.key});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final g = order.group;
    final waiting = g != null && g.statusAt() == GroupStatus.open;
    final subtitle = g == null
        ? 'Order ${order.id} · We are getting your shipment ready.'
        : waiting
            ? 'Order ${order.id} · Waiting for ${g.missing} more '
                '${g.missing == 1 ? 'friend' : 'friends'} to join your group.'
            : 'Order ${order.id} · Your group is complete.';
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
                    Text('Order placed', style: AppText.h1),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: AppText.body.copyWith(color: AppColors.ink2),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 18),
                    WhiteCard(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const _TimelineRow('Order placed', 'Payment held securely', _Step.done),
                          const SizedBox(height: 18),
                          if (g != null)
                            _TimelineRow(
                              'Group filling',
                              '${g.members.length} of ${g.product.groupSize} joined',
                              waiting ? _Step.active : _Step.done,
                            )
                          else
                            const _TimelineRow('Packing', 'Usually 1–2 days', _Step.active),
                          const SizedBox(height: 18),
                          _TimelineRow(
                            'Shipped',
                            g == null ? 'You will get a tracking link' : 'Once the group is full',
                            _Step.pending,
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
                if (g != null)
                  AppButton('View my group', style: AppButtonStyle.dark, onPressed: () => GroupScreen.open(context, g))
                else
                  AppButton('Track order', style: AppButtonStyle.dark, onPressed: () => goToTab(context, tabOrders)),
                AppButton('Back to home', style: AppButtonStyle.soft, onPressed: () => goToTab(context, tabHome)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow(this.title, this.detail, this.step);

  final String title, detail;
  final _Step step;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: switch (step) {
                _Step.done => AppColors.success,
                _Step.active => AppColors.accent,
                _Step.pending => AppColors.line,
              },
            ),
            child: step == _Step.done ? const Icon(Icons.check_rounded, size: 16, color: Colors.white) : null,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppText.bodyStrong.copyWith(color: step == _Step.pending ? AppColors.ink2 : AppColors.ink)),
              const SizedBox(height: 2),
              Text(detail, style: AppText.caption),
            ],
          ),
        ],
      );
}
