import 'package:flutter/foundation.dart';
import '../models/app_notification.dart';

class NotificationsProvider extends ChangeNotifier {
  final List<AppNotification> _items = [
    AppNotification(
      id: 'n1', title: '🌿 Fresh arrivals this week!',
      body: 'New seasonal vegetables from Green Valley Farm are now available.',
      time: DateTime.now().subtract(const Duration(hours: 2)),
      type: 'product',
    ),
    AppNotification(
      id: 'n2', title: '🍯 Raw Forest Honey back in stock',
      body: 'Limited stock available. Order before it sells out!',
      time: DateTime.now().subtract(const Duration(days: 1)),
      type: 'product',
    ),
    AppNotification(
      id: 'n3', title: '🚚 Free delivery this weekend',
      body: 'Order above ₹300 and get free delivery. Limited time offer.',
      time: DateTime.now().subtract(const Duration(days: 2)),
      type: 'promo',
    ),
  ];

  List<AppNotification> get items       => List.unmodifiable(_items);
  int                   get unreadCount => _items.where((n) => !n.isRead).length;

  void addOrderNotification({
    required String   orderId,
    required String   paymentMethod,
    required DateTime deliveryDate,
  }) {
    final months = ['','Jan','Feb','Mar','Apr','May','Jun',
                    'Jul','Aug','Sep','Oct','Nov','Dec'];
    _items.insert(0, AppNotification(
      id:    'n_order_$orderId',
      title: '✅ Order Confirmed!',
      body:  'Order #${orderId.substring(orderId.length - 6)} placed via '
             '$paymentMethod. Estimated delivery: '
             '${deliveryDate.day} ${months[deliveryDate.month]}.',
      time:  DateTime.now(),
      type:  'order',
    ));
    notifyListeners();
  }

  void markAllRead() {
    for (final n in _items) { n.isRead = true; }
    notifyListeners();
  }

  void markRead(String id) {
    try {
      _items.firstWhere((n) => n.id == id).isRead = true;
      notifyListeners();
    } catch (_) {}
  }
}