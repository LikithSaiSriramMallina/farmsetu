import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/order_model.dart';
import '../../providers/language_provider.dart';
import '../../providers/orders_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<OrdersProvider>().orders;
    final l10n = context.watch<LanguageProvider>().l10n;
    final c = context.col;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myOrders),
        leading: _BackBtn(),
      ),
      body: orders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_bag_outlined,
                      size: 64, color: c.textMuted),
                  const SizedBox(height: 16),
                  Text('No orders yet',
                      style: TextStyle(
                          color: c.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text('Your orders will appear here',
                      style: TextStyle(color: c.textSecondary, fontSize: 14)),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _OrderCard(order: orders[i]),
            ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final AppOrder order;
  const _OrderCard({required this.order});

  static const _months = [
    '',
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  String _fmt(DateTime d) => '${d.day} ${_months[d.month]} ${d.year}';

  Color _statusColor() => switch (order.status) {
        'Delivered' => AppTheme.primaryGreen,
        'Out for Delivery' => const Color(0xFF5CB8E4),
        'Processing' => const Color(0xFFE88F3F),
        _ => AppTheme.primaryGreen,
      };

  IconData _payIcon() => switch (order.paymentMethod) {
        'UPI' => Icons.qr_code_rounded,
        'Cash on Delivery' => Icons.money_rounded,
        _ => Icons.credit_card_rounded,
      };

  @override
  Widget build(BuildContext context) {
    final c = context.col;
    final sc = _statusColor();

    return Container(
      decoration: BoxDecoration(
        color: c.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: c.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Order #${order.id.substring(order.id.length - 6)}',
                      style: TextStyle(
                          color: c.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(_fmt(order.orderDate),
                      style: TextStyle(color: c.textMuted, fontSize: 12)),
                ]),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: sc.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(order.status,
                      style: TextStyle(
                          color: sc,
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: c.divider),

          // ── Items ──
          ...order.items.map((item) => Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                child: Row(children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.eco_outlined,
                        color: AppTheme.primaryGreen, size: 16),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(item.product.name,
                        style: TextStyle(color: c.textPrimary, fontSize: 13)),
                  ),
                  Text('×${item.quantity}',
                      style: TextStyle(color: c.textMuted, fontSize: 12)),
                  const SizedBox(width: 8),
                  Text('₹${item.subtotal.toInt()}',
                      style: const TextStyle(
                          color: AppTheme.primaryGreen,
                          fontSize: 13,
                          fontWeight: FontWeight.w600)),
                ]),
              )),
          const SizedBox(height: 12),
          Divider(height: 1, color: c.divider),

          // ── Footer ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Icon(Icons.local_shipping_outlined,
                      size: 13, color: c.textMuted),
                  const SizedBox(width: 6),
                  Text(
                    'Est. ${_fmt(order.estimatedDelivery)}',
                    style: TextStyle(color: c.textSecondary, fontSize: 12),
                  ),
                  const Spacer(),
                  Icon(_payIcon(), size: 13, color: c.textMuted),
                  const SizedBox(width: 4),
                  Text(order.paymentMethod,
                      style: TextStyle(color: c.textMuted, fontSize: 12)),
                ]),
                const SizedBox(height: 5),
                Row(children: [
                  Icon(Icons.location_on_outlined,
                      size: 13, color: c.textMuted),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '${order.address.line1}, ${order.address.city}',
                      style: TextStyle(color: c.textSecondary, fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ]),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total: ₹${order.total.toInt()}',
                        style: TextStyle(
                          color: c.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        )),
                    Row(children: [
                      Icon(Icons.storefront_outlined,
                          size: 13, color: c.textMuted),
                      const SizedBox(width: 4),
                      Text(order.items.first.product.vendorName,
                          style: TextStyle(color: c.textMuted, fontSize: 12)),
                    ]),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BackBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = context.col;
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: c.surfaceHigh, borderRadius: BorderRadius.circular(10)),
        child: Icon(Icons.arrow_back_ios_new_rounded,
            size: 16, color: c.textPrimary),
      ),
    );
  }
}
