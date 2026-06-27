class AppNotification {
  final String   id;
  final String   title;
  final String   body;
  final DateTime time;
  final String   type; // 'order', 'product', 'promo'
  bool           isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    required this.type,
    this.isRead = false,
  });
}