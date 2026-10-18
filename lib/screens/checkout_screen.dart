import 'package:flutter/material.dart';
import '../core/format.dart';
import '../core/navigation.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text.dart';
import '../data/demo_user.dart';
import '../models/order.dart';
import '../models/product.dart';
import '../state/store.dart';
import '../widgets/widgets.dart';
import 'order_placed_screen.dart';

/// One row on the checkout screen. [unitPrice] is what the shopper pays per unit.
class CheckoutLine {
  const CheckoutLine(this.product, this.qty, this.unitPrice, {this.tag});

  final Product product;
  final int qty;
  final double unitPrice;

  /// Small red label under the title, e.g. "Group price".
  final String? tag;
}

/// Address, payment method and total. [onPay] places the order(s) and returns the first one.
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key, required this.lines, required this.onPay, this.discount = 0});

  final List<CheckoutLine> lines;
  final double discount;
  final Order Function() onPay;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  static const _methods = [
    (Icons.credit_card, 'Visa •••• 4242', 'Expires 08/28'),
    (Icons.phone_iphone, 'Apple Pay', 'Fast checkout'),
    (Icons.payments_outlined, 'Cash on delivery', 'Pay when it arrives'),
  ];

  int _method = 0;
  bool _paying = false;

  double get _subtotal => widget.lines.fold<double>(0, (s, l) => s + l.unitPrice * l.qty);
  double get _total => _subtotal - widget.discount;

  void _pay() {
    setState(() => _paying = true);
    final order = widget.onPay();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => OrderPlacedScreen(order)));
  }

  @override
  Widget build(BuildContext context) {
    final user = store.user ?? demoUser;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const TopBar('Checkout'),
                  const SizedBox(height: 16),
                  WhiteCard(
                    padding: const EdgeInsets.all(16),
                    onTap: () => showMessage(context, 'Address book is coming soon.'),
                    child: Row(
                      children: [
                        const CircleIconButton(
                          Icons.location_on_outlined,
                          size: 44,
                          background: AppColors.accentSoft,
                          iconColor: AppColors.accent,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user.name, style: AppText.bodyStrong),
                              const SizedBox(height: 2),
                              Text(user.address, style: AppText.caption),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: AppColors.ink2),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  for (final l in widget.lines) ...[
                    WhiteCard(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          ProductThumb(l.product),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(l.product.title, style: AppText.bodyStrong),
                                if (l.qty > 1) Text('Qty ${l.qty}', style: AppText.caption),
                                if (l.tag != null) ...[
                                  const SizedBox(height: 4),
                                  InfoPill(l.tag!, icon: Icons.people_outline),
                                ],
                              ],
                            ),
                          ),
                          Text(money(l.unitPrice * l.qty), style: AppText.h3),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                  const SizedBox(height: 4),
                  Text('Payment method', style: AppText.h3),
                  const SizedBox(height: 12),
                  WhiteCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        for (var i = 0; i < _methods.length; i++)
                          GestureDetector(
                            key: ValueKey('method-$i'),
                            behavior: HitTestBehavior.opaque,
                            onTap: () => setState(() => _method = i),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Icon(_methods[i].$1, size: 22),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(_methods[i].$2, style: AppText.bodyStrong),
                                        Text(_methods[i].$3, style: AppText.caption),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 22,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _method == i ? AppColors.accent : null,
                                      border: _method == i ? null : Border.all(color: AppColors.line, width: 2),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  SummaryCard(
                    rows: [
                      SummaryRow('Subtotal', money(_subtotal)),
                      const SummaryRow('Shipping', 'Free'),
                      if (widget.discount > 0)
                        SummaryRow('Coupon', '-${money(widget.discount)}', valueColor: AppColors.success),
                      SummaryRow('Total', money(_total), bold: true),
                    ],
                  ),
                ],
              ),
            ),
            BottomActionBar(
              children: [AppButton('Pay ${money(_total)}', onPressed: _paying ? null : _pay)],
            ),
          ],
        ),
      ),
    );
  }
}
