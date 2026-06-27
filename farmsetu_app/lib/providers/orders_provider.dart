import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import '../models/address.dart';
import '../models/order_model.dart';
import 'cart_provider.dart';

class OrdersProvider extends ChangeNotifier {
  final _db   = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  List<AppOrder> _orders  = [];
  bool                 _loading = false;
  String?              _currentCustomerId;
  StreamSubscription<QuerySnapshot>? _ordersSub;

  List<AppOrder> get orders    => List.unmodifiable(_orders);
  bool           get hasOrders => _orders.isNotEmpty;
  bool           get loading   => _loading;

  void startListening(String customerId) {
    if (_currentCustomerId == customerId) return;
    stopListening();
    _currentCustomerId = customerId;
    _loading = true;
    notifyListeners();

    _ordersSub = _db.collection('orders')
        .where('customerId', isEqualTo: customerId)
        .orderBy('orderDate', descending: true)
        .snapshots()
        .listen((snap) {
      _orders = snap.docs
          .map((d) => AppOrder.fromFirestore(d.id, d.data()))
          .toList();
      _loading = false;
      notifyListeners();
    }, onError: (e) {
      debugPrint('Orders listen error: $e');
      _loading = false;
      notifyListeners();
    });
  }

  void stopListening() {
    _ordersSub?.cancel();
    _ordersSub = null;
    _orders = [];
    _currentCustomerId = null;
    notifyListeners();
  }

  Future<AppOrder> placeOrder({
    required List<CartItem> cartItems,
    required Address        address,
    required String         paymentMethod,
    double deliveryFee = 49,
  }) async {
    final uid = _currentCustomerId ?? _auth.currentUser?.uid ?? 'guest';

    final order = AppOrder(
      id:                DateTime.now().millisecondsSinceEpoch.toString(),
      items:             cartItems.map((ci) =>
          OrderItem(product: ci.product, quantity: ci.quantity)).toList(),
      address:           address,
      paymentMethod:     paymentMethod,
      orderDate:         DateTime.now(),
      estimatedDelivery: DateTime.now().add(const Duration(days: 3)),
      deliveryFee:       deliveryFee,
      customerId:        uid,
    );

    // Optimistically add to local list so it shows immediately
    _orders.insert(0, order);
    notifyListeners();

    try {
      await _db.collection('orders').doc(order.id)
          .set(order.toFirestore());
    } catch (e) {
      debugPrint('Order save error: $e');
    }

    return order;
  }

  @override
  void dispose() {
    _ordersSub?.cancel();
    super.dispose();
  }
}