import 'package:cloud_firestore/cloud_firestore.dart';
import 'address.dart';
import 'product.dart';

class OrderItem {
  final Product product;
  final int     quantity;
  const OrderItem({required this.product, required this.quantity});
  double get subtotal => product.price * quantity;
}

class AppOrder {
  final String          id;
  final List<OrderItem> items;
  final Address         address;
  final String          paymentMethod;
  final DateTime        orderDate;
  final DateTime        estimatedDelivery;
  final double          deliveryFee;
  final String          customerId;
  String                status;

  AppOrder({
    required this.id, required this.items, required this.address,
    required this.paymentMethod, required this.orderDate,
    required this.estimatedDelivery, required this.deliveryFee,
    required this.customerId, this.status = 'Confirmed',
  });

  double get subtotal  => items.fold(0, (s, i) => s + i.subtotal);
  double get total     => subtotal + deliveryFee;
  int    get itemCount => items.fold(0, (s, i) => s + i.quantity);

  Map<String, dynamic> toFirestore() => {
        'customerId': customerId, 'paymentMethod': paymentMethod,
        'status': status, 'deliveryFee': deliveryFee,
        'orderDate': Timestamp.fromDate(orderDate),
        'estimatedDelivery': Timestamp.fromDate(estimatedDelivery),
        'address': {
          'id': address.id, 'label': address.label,
          'fullName': address.fullName, 'phone': address.phone,
          'line1': address.line1, 'city': address.city,
          'state': address.state, 'pincode': address.pincode,
        },
        'items': items.map((i) => {
          'productId':   i.product.id,
          'productName': i.product.name,
          'vendorName':  i.product.vendorName,
          'vendorId':    i.product.vendorId,
          'price':       i.product.price,
          'unit':        i.product.unit,
          'imageUrl':    i.product.imageUrl,
          'quantity':    i.quantity,
        }).toList(),
      };

  factory AppOrder.fromFirestore(String id, Map<String, dynamic> d) {
    final am = d['address'] as Map<String, dynamic>? ?? {};
    return AppOrder(
      id:                id,
      customerId:        d['customerId'] ?? '',
      paymentMethod:     d['paymentMethod'] ?? '',
      status:            d['status'] ?? 'Confirmed',
      deliveryFee:       (d['deliveryFee'] as num?)?.toDouble() ?? 49,
      orderDate:         (d['orderDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      estimatedDelivery: (d['estimatedDelivery'] as Timestamp?)?.toDate()
          ?? DateTime.now().add(const Duration(days: 3)),
      address: Address(
        id: am['id'] ?? '', label: am['label'] ?? 'Home',
        fullName: am['fullName'] ?? '', phone: am['phone'] ?? '',
        line1: am['line1'] ?? '', city: am['city'] ?? '',
        state: am['state'] ?? '', pincode: am['pincode'] ?? '',
      ),
      items: ((d['items'] as List?) ?? []).map((m) {
        final item = m as Map<String, dynamic>;
        return OrderItem(
          quantity: item['quantity'] ?? 1,
          product: Product(
            id:          item['productId'] ?? '',
            name:        item['productName'] ?? '',
            vendorName:  item['vendorName'] ?? '',
            vendorId:    item['vendorId'] ?? '',
            price:       (item['price'] as num).toDouble(),
            unit:        item['unit'] ?? 'kg',
            category: '', imageUrl: item['imageUrl'] ?? '',
            description: '', rating: 4.5, reviewCount: 0,
            isOrganic: false, isAvailable: true, stock: 0,
          ),
        );
      }).toList(),
    );
  }
}