import '../models/app_notification.dart';

List<AppNotification> seedNotifications([DateTime? now]) {
  final t = now ?? DateTime.now();
  return [
    AppNotification(
      id: 'n1',
      kind: NotificationKind.group,
      title: "Maya's group needs 1 more",
      body: 'Studio Headphones Pro · invite a friend to unlock \$89',
      at: t.subtract(const Duration(minutes: 2)),
    ),
    AppNotification(
      id: 'n2',
      kind: NotificationKind.shipping,
      title: 'Your order shipped',
      body: 'Smart Desk Clock arrives Oct 24 – 27',
      at: t.subtract(const Duration(hours: 3)),
    ),
    AppNotification(
      id: 'n3',
      kind: NotificationKind.deal,
      title: 'Flash deal ends in 2 hours',
      body: 'Pro Game Controller · 2 of 3 joined',
      at: t.subtract(const Duration(hours: 5)),
      read: true,
    ),
    AppNotification(
      id: 'n4',
      kind: NotificationKind.success,
      title: 'Group complete',
      body: 'Aura Lavender Headphones is confirmed',
      at: t.subtract(const Duration(days: 1)),
      read: true,
    ),
  ];
}
