import 'package:flutter/material.dart';
import '../core/format.dart';
import '../core/navigation.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text.dart';
import '../data/demo_user.dart';
import '../state/store.dart';
import '../widgets/widgets.dart';
import 'coupons_screen.dart';
import 'notifications_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          bottom: false,
          child: ListenableBuilder(
            listenable: store,
            builder: (context, _) {
              final user = store.user ?? demoUser;
              final groups = store.orders.where((o) => o.group != null).length;
              void soon(String what) => showMessage(context, '$what is coming soon.');
              return ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 130),
                children: [
                  const SizedBox(height: 8),
                  Center(
                    child: Container(
                      width: 84,
                      height: 84,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(color: AppColors.ink, shape: BoxShape.circle),
                      child: Text(user.initials, style: AppText.h2.copyWith(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(child: Text(user.name, style: AppText.h2)),
                  const SizedBox(height: 2),
                  Center(child: Text(user.email, style: AppText.caption)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _Stat('${store.orders.length}', 'Orders'),
                      const SizedBox(width: 8),
                      _Stat('$groups', 'Groups'),
                      const SizedBox(width: 8),
                      _Stat(money(store.totalSaved), 'Saved', color: AppColors.success),
                    ],
                  ),
                  const SizedBox(height: 16),
                  WhiteCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        _MenuRow(Icons.local_offer_outlined, 'Coupons', onTap: () => pushScreen(context, const CouponsScreen())),
                        _MenuRow(
                          Icons.notifications_none,
                          'Notifications',
                          badge: store.unreadCount,
                          onTap: () => pushScreen(context, const NotificationsScreen()),
                        ),
                        _MenuRow(Icons.location_on_outlined, 'Addresses', onTap: () => soon('Address book')),
                        _MenuRow(Icons.credit_card, 'Payment methods', onTap: () => soon('Payment methods')),
                        _MenuRow(Icons.help_outline, 'Help & support', onTap: () => soon('Help centre')),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppButton('Sign out', style: AppButtonStyle.soft, onPressed: store.signOut),
                ],
              );
            },
          ),
        ),
      );
}

class _Stat extends StatelessWidget {
  const _Stat(this.value, this.label, {this.color = AppColors.ink});

  final String value, label;
  final Color color;

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              Text(value, style: AppText.priceM.copyWith(color: color)),
              const SizedBox(height: 2),
              Text(label, style: AppText.caption),
            ],
          ),
        ),
      );
}

class _MenuRow extends StatelessWidget {
  const _MenuRow(this.icon, this.label, {required this.onTap, this.badge = 0});

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final int badge;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleIconButton(icon, size: 38, background: AppColors.bg),
              const SizedBox(width: 12),
              Expanded(child: Text(label, style: AppText.bodyStrong)),
              if (badge > 0)
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(999)),
                  child: Text('$badge', style: AppText.micro.copyWith(color: Colors.white)),
                ),
              const Icon(Icons.chevron_right, size: 18, color: AppColors.ink2),
            ],
          ),
        ),
      );
}
