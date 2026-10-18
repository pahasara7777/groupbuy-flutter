import 'package:flutter/material.dart';
import '../core/format.dart';
import '../core/navigation.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text.dart';
import '../models/coupon.dart';
import '../state/shell_tab.dart';
import '../state/store.dart';
import '../widgets/widgets.dart';
import 'checkout_screen.dart';
import 'coupons_screen.dart';
import 'product_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  void _checkout(BuildContext context) => pushScreen(
        context,
        CheckoutScreen(
          lines: [for (final l in store.cartLines) CheckoutLine(l.product, l.qty, l.product.price)],
          discount: store.cartDiscount,
          onPay: () => store.checkout().first,
        ),
      );

  void _pickCoupon(BuildContext context) {
    final options = store.usableCoupons(store.cartTotal);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (sheet) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Choose a coupon', style: AppText.h2),
              const SizedBox(height: 12),
              if (options.isEmpty)
                Text('No coupons fit this cart yet.', style: AppText.body.copyWith(color: AppColors.ink2)),
              for (final Coupon c in options)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const CircleIconButton(Icons.local_offer_outlined, size: 44, background: AppColors.accentSoft, iconColor: AppColors.accent),
                  title: Text(c.title, style: AppText.bodyStrong),
                  subtitle: Text(CouponsScreen.expiryText(c), style: AppText.caption),
                  trailing: Text(c.badge, style: AppText.h3.copyWith(color: AppColors.accent)),
                  onTap: () {
                    store.applyCoupon(c);
                    Navigator.of(sheet).pop();
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          bottom: false,
          child: ListenableBuilder(
            listenable: store,
            builder: (context, _) {
              final lines = store.cartLines;
              return ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 130),
                children: [
                  Text('Cart', style: AppText.h1),
                  const SizedBox(height: 16),
                  if (lines.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 60),
                      child: Column(
                        children: [
                          const Icon(Icons.shopping_bag_outlined, size: 56, color: AppColors.ink2),
                          const SizedBox(height: 12),
                          Text('Your cart is empty', style: AppText.h3),
                          const SizedBox(height: 4),
                          Text('Group prices are waiting for you.', style: AppText.body.copyWith(color: AppColors.ink2)),
                          const SizedBox(height: 20),
                          AppButton('Browse trending', onPressed: () => shellTab.value = tabHome),
                        ],
                      ),
                    )
                  else ...[
                    for (final l in lines) ...[
                      WhiteCard(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            ProductThumb(l.product, size: 80, radius: 14),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(l.product.title, style: AppText.bodyStrong),
                                  const SizedBox(height: 4),
                                  Text(money(l.product.price), style: AppText.priceM.copyWith(color: AppColors.ink)),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      CircleIconButton(
                                        Icons.remove,
                                        size: 28,
                                        background: AppColors.bg,
                                        tooltip: 'Remove one',
                                        onTap: () => store.removeFromCart(l.product),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        child: Text('${l.qty}', style: AppText.bodyStrong),
                                      ),
                                      CircleIconButton(
                                        Icons.add,
                                        size: 28,
                                        background: AppColors.ink,
                                        iconColor: Colors.white,
                                        tooltip: 'Add one',
                                        onTap: () => store.addToCart(l.product),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    WhiteCard(
                      color: AppColors.accentSoft,
                      padding: const EdgeInsets.all(14),
                      radius: 16,
                      onTap: () => ProductScreen.open(context, lines.first.product),
                      child: Row(
                        children: [
                          const Icon(Icons.people_outline, color: AppColors.accent),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Start a group on the ${lines.first.product.title} and save ${money(lines.first.product.saving)}.',
                              style: AppText.caption.copyWith(color: AppColors.accent),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    WhiteCard(
                      padding: const EdgeInsets.all(14),
                      radius: 16,
                      onTap: () => store.appliedCoupon != null ? store.applyCoupon(null) : _pickCoupon(context),
                      child: Row(
                        children: [
                          const Icon(Icons.local_offer_outlined, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              store.appliedCoupon == null ? 'Add a coupon' : '${store.appliedCoupon!.title} applied',
                              style: AppText.bodyStrong,
                            ),
                          ),
                          Text(
                            store.appliedCoupon == null ? 'Choose' : 'Remove',
                            style: AppText.caption.copyWith(color: AppColors.accent, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SummaryCard(
                      rows: [
                        SummaryRow('Subtotal', money(store.cartTotal)),
                        if (store.cartDiscount > 0)
                          SummaryRow('Coupon', '-${money(store.cartDiscount)}', valueColor: AppColors.success),
                        const SummaryRow('Shipping', 'Free'),
                        SummaryRow('Total', money(store.cartPayable), bold: true),
                      ],
                    ),
                    const SizedBox(height: 16),
                    AppButton('Checkout · ${money(store.cartPayable)}', onPressed: () => _checkout(context)),
                  ],
                ],
              );
            },
          ),
        ),
      );
}
