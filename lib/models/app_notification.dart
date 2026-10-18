enum NotificationKind { group, shipping, deal, success }

class AppNotification {
  AppNotification({
    required this.id,
    required this.kind,
    required this.title,
    required this.body,
    required this.at,
    this.read = false,
  });

  final String id, title, body;
  final NotificationKind kind;
  final DateTime at;
  bool read;
}
