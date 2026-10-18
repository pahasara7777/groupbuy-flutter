import 'package:flutter/material.dart';
import '../core/format.dart';
import '../core/navigation.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text.dart';
import '../models/coupon.dart';
import '../state/store.dart';
import '../widgets/widgets.dart';

class CouponsScreen extends StatelessWidget {
  const CouponsScreen({super.key});

  static String expiryText(Coupon c) {
    final days = c.expiresAt.difference(DateTime.now()).inDays;
    return days <= 0 ? 'Expires today' : 'Expires in $days days';
  }

  void _use(BuildContext context, Coupon c) {
    if (store.cartTotal == 0) {
      showMessage(context, 'Add something to your cart first.');
    } else if (store.applyCoupon(c)) {
      showMessage(context, '${c.title} applied to your cart.');
    } else {
      showMessage(context, 'Spend ${money(c.minSpend)} or more to use this coupon.');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: ListenableBuilder(
            listenable: store,
            builder: (context, _) => ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const TopBar('Coupons'),
                const SizedBox(height: 16),
                for (final c in store.coupons) ...[
                  _CouponTile(
                    c,
                    used: store.isCouponUsed(c),
                    applied: store.appliedCoupon?.code == c.code,
                    onUse: () => _use(context, c),
                  ),
                  const SizedBox(height: 12),
                ],
              ],
            ),
          ),
        ),
      );
}

class _CouponTile extends StatelessWidget {
  const _CouponTile(this.coupon, {required this.used, required this.applied, required this.onUse});

  final Coupon coupon;
  final bool used, applied;
  final VoidCallback onUse;

  @override
  Widget build(BuildContext context) {
    final on = !used;
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        color: AppColors.surface,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 96,
                alignment: Alignment.center,
                color: on ? AppColors.accent : AppColors.line,
                child: Text(coupon.badge, style: AppText.h2.copyWith(color: on ? Colors.white : AppColors.ink2)),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(coupon.title, style: AppText.bodyStrong.copyWith(color: on ? AppColors.ink : AppColors.ink2)),
                      const SizedBox(height: 4),
                      Text(
                        used
                            ? 'Used'
                            : '${coupon.minSpend > 0 ? 'Min. spend ${money(coupon.minSpend)} · ' : ''}${CouponsScreen.expiryText(coupon)}',
                        style: AppText.caption,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: GestureDetector(
                  onTap: used ? null : onUse,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: used ? AppColors.line : (applied ? AppColors.success : AppColors.ink),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      used ? 'Used' : (applied ? 'Applied' : 'Use'),
                      style: AppText.caption.copyWith(color: used ? AppColors.ink2 : Colors.white),
                    ),
                  ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
