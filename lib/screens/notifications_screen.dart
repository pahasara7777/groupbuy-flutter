import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text.dart';
import '../models/app_notification.dart';
import '../state/store.dart';
import '../widgets/widgets.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  static IconData _icon(NotificationKind k) => switch (k) {
        NotificationKind.group => Icons.people_outline,
        NotificationKind.shipping => Icons.local_shipping_outlined,
        NotificationKind.deal => Icons.bolt,
        NotificationKind.success => Icons.check_rounded,
      };

  static (Color, Color) _colors(NotificationKind k) => switch (k) {
        NotificationKind.group => (AppColors.accentSoft, AppColors.accent),
        NotificationKind.shipping || NotificationKind.success => (AppColors.successSoft, AppColors.success),
        NotificationKind.deal => (AppColors.bg, AppColors.ink),
      };

  static String ago(DateTime at) {
    final d = DateTime.now().difference(at);
    if (d.inMinutes < 1) return 'now';
    if (d.inMinutes < 60) return '${d.inMinutes}m';
    if (d.inHours < 24) return '${d.inHours}h';
    return '${d.inDays}d';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: ListenableBuilder(
            listenable: store,
            builder: (context, _) => ListView(
              padding: const EdgeInsets.all(20),
              children: [
                TopBar(
                  'Notifications',
                  trailing: GestureDetector(
                    onTap: store.markAllRead,
                    child: SizedBox(
                      width: 40,
                      child: Text('Read all', style: AppText.micro.copyWith(color: AppColors.accent)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                for (final n in store.notifications) ...[
                  WhiteCard(
                    onTap: () {
                      n.read = true;
                      store.notifyListeners();
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleIconButton(
                          _icon(n.kind),
                          size: 44,
                          background: _colors(n.kind).$1,
                          iconColor: _colors(n.kind).$2,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(n.title, style: AppText.bodyStrong),
                              const SizedBox(height: 4),
                              Text(n.body, style: AppText.caption),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(ago(n.at), style: AppText.micro.copyWith(color: AppColors.ink2)),
                            const SizedBox(height: 8),
                            if (!n.read)
                              const DecoratedBox(
                                decoration: BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                                child: SizedBox(width: 8, height: 8),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ],
            ),
          ),
        ),
      );
}
