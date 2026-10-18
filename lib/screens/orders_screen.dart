import 'package:flutter/material.dart';
import '../core/format.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text.dart';
import '../models/order.dart';
import '../state/store.dart';
import '../widgets/widgets.dart';
import 'group_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  static const _tabs = <(String, OrderStatus?)>[
    ('All', null),
    ('Waiting', OrderStatus.waitingForGroup),
    ('Complete', OrderStatus.groupComplete),
    ('Refunded', OrderStatus.refunded),
  ];

  OrderStatus? _filter;

  (Color, Color) _colors(OrderStatus s) => switch (s) {
        OrderStatus.waitingForGroup => (AppColors.accentSoft, AppColors.accent),
        OrderStatus.groupComplete || OrderStatus.preparing => (AppColors.successSoft, AppColors.success),
        OrderStatus.refunded => (AppColors.line, AppColors.ink2),
      };

  Widget _meta(Order o) {
    final g = o.group;
    switch (o.status) {
      case OrderStatus.waitingForGroup:
        return Row(
          children: [
            Text('${g!.members.length} of ${g.product.groupSize} joined · ', style: AppText.caption),
            Countdown(g.expiresAt, style: AppText.caption),
            Text(' left', style: AppText.caption),
          ],
        );
      case OrderStatus.groupComplete:
        return Text(
          'Arrives ${dateRange(o.at.add(const Duration(days: 6)), o.at.add(const Duration(days: 9)))}',
          style: AppText.caption,
        );
      case OrderStatus.refunded:
        return Text('Group did not fill · money returned', style: AppText.caption);
      case OrderStatus.preparing:
        return Text('Preparing shipment', style: AppText.caption);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          bottom: false,
          child: ListenableBuilder(
            listenable: store,
            builder: (context, _) {
              final orders = store.ordersWhere(_filter);
              return ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 130),
                children: [
                  Text('Orders', style: AppText.h1),
                  const SizedBox(height: 14),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (final t in _tabs) ...[
                          AppChip(t.$1, selected: _filter == t.$2, onTap: () => setState(() => _filter = t.$2)),
                          const SizedBox(width: 8),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  if (orders.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 60),
                      child: Center(child: Text('No orders here yet.', style: AppText.body.copyWith(color: AppColors.ink2))),
                    ),
                  for (final o in orders) ...[
                    WhiteCard(
                      onTap: o.group == null ? null : () => GroupScreen.open(context, o.group!),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ProductThumb(o.product, size: 72, radius: 14),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(o.product.title, style: AppText.bodyStrong),
                                    const SizedBox(height: 6),
                                    InfoPill(
                                      o.statusLabel,
                                      background: _colors(o.status).$1,
                                      foreground: _colors(o.status).$2,
                                    ),
                                  ],
                                ),
                              ),
                              Text(money(o.paid), style: AppText.h3),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _meta(o),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ],
              );
            },
          ),
        ),
      );
}
