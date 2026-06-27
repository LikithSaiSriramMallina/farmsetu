import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/farmer_auth_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';

class FarmerOrdersScreen extends StatefulWidget {
  const FarmerOrdersScreen({super.key});
  @override
  State<FarmerOrdersScreen> createState() =>
      _FarmerOrdersScreenState();
}

class _FarmerOrdersScreenState extends State<FarmerOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final farmer = context.watch<FarmerAuthProvider>().farmer;
    if (farmer == null) return const SizedBox.shrink();
    final c = context.col;

    return SafeArea(
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Text('Incoming Orders',
              style: TextStyle(
                color: c.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              )),
        ),

        // Tabs
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: c.surfaceHigh,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TabBar(
            controller: _tab,
            indicator: BoxDecoration(
              color: AppTheme.primaryGreen,
              borderRadius: BorderRadius.circular(8),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Colors.white,
            unselectedLabelColor: c.textSecondary,
            labelStyle: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w600),
            tabs: const [
              Tab(text: 'New'),
              Tab(text: 'Active'),
              Tab(text: 'Done'),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Orders stream from Firestore
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('orders')
                .orderBy('orderDate', descending: true)
                .snapshots(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                        color: AppTheme.primaryGreen));
              }

              if (snap.hasError) {
                return Center(
                    child: Text('Error: ${snap.error}',
                        style: TextStyle(color: c.textSecondary)));
              }

              // Filter orders that contain this farmer's products
              final allDocs = snap.data?.docs ?? [];
              final farmerOrders = allDocs.where((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final items = data['items'] as List? ?? [];
                return items.any((item) {
                  final m = item as Map<String, dynamic>;
                  return m['vendorId'] == farmer.id ||
                         m['farmerId'] == farmer.id;
                });
              }).toList();

              final newOrders = farmerOrders.where((d) {
                final data = d.data() as Map<String, dynamic>;
                final status = data['status'] as String? ?? 'Confirmed';
                return status == 'Confirmed' || status == 'New';
              }).toList();

              final activeOrders = farmerOrders.where((d) {
                final data = d.data() as Map<String, dynamic>;
                final status = data['status'] as String? ?? '';
                return ['Processing', 'Accepted', 'Dispatched']
                    .contains(status);
              }).toList();

              final doneOrders = farmerOrders.where((d) {
                final data = d.data() as Map<String, dynamic>;
                final status = data['status'] as String? ?? '';
                return ['Delivered', 'Rejected', 'Cancelled']
                    .contains(status);
              }).toList();

              return TabBarView(
                controller: _tab,
                children: [
                  _OrderList(orders: newOrders, emptyText: 'No new orders'),
                  _OrderList(orders: activeOrders, emptyText: 'No active orders'),
                  _OrderList(orders: doneOrders, emptyText: 'No completed orders'),
                ],
              );
            },
          ),
        ),
      ]),
    );
  }
}

class _OrderList extends StatelessWidget {
  final List<QueryDocumentSnapshot> orders;
  final String emptyText;
  const _OrderList({required this.orders, required this.emptyText});

  @override
  Widget build(BuildContext context) {
    final c = context.col;
    if (orders.isEmpty) {
      return Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 52, color: c.textMuted),
          const SizedBox(height: 12),
          Text(emptyText,
              style: TextStyle(color: c.textSecondary, fontSize: 15)),
        ],
      ));
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      itemCount: orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) => _OrderCard(doc: orders[i]),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final QueryDocumentSnapshot doc;
  const _OrderCard({required this.doc});

  @override
  Widget build(BuildContext context) {
    final c    = context.col;
    final data = doc.data() as Map<String, dynamic>;
    final items = (data['items'] as List? ?? []);
    final address = data['address'] as Map<String, dynamic>? ?? {};
    final status  = data['status'] as String? ?? 'Confirmed';
    final orderDate = data['orderDate'] != null
        ? (data['orderDate'] as Timestamp).toDate()
        : DateTime.now();

    final statusColor = switch (status) {
      'New' || 'Confirmed' => const Color(0xFF5CB8E4),
      'Processing' || 'Accepted' => const Color(0xFFE88F3F),
      'Dispatched' => const Color(0xFF9B7FE8),
      'Delivered'  => AppTheme.primaryGreen,
      _ => AppTheme.error,
    };

    final timeAgo = () {
      final diff = DateTime.now().difference(orderDate);
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      return '${diff.inDays}d ago';
    }();

    return Container(
      decoration: BoxDecoration(
        color: c.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: c.divider),
      ),
      child: Column(children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
          child: Row(children: [
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Order #${doc.id.substring(0, 8)}',
                    style: TextStyle(
                      color: c.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    )),
                const SizedBox(height: 2),
                Text(
                  '${address['fullName'] ?? 'Customer'}  ·  $timeAgo',
                  style: TextStyle(color: c.textMuted, fontSize: 11),
                ),
              ],
            )),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 9, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  )),
            ),
          ]),
        ),
        Divider(height: 1, color: c.divider),

        // Items
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 6),
          child: Column(
            children: items.map((item) {
              final m = item as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(children: [
                  const Icon(Icons.fiber_manual_record_rounded,
                      size: 6, color: AppTheme.primaryGreen),
                  const SizedBox(width: 8),
                  Expanded(child: Text(
                    '${m['productName'] ?? ''} ×${m['quantity'] ?? 1}',
                    style: TextStyle(
                        color: c.textSecondary, fontSize: 12),
                  )),
                  Text(
                    '₹${((m['price'] as num? ?? 0) * (m['quantity'] as num? ?? 1)).toInt()}',
                    style: TextStyle(
                        color: c.textPrimary, fontSize: 12)),
                ]),
              );
            }).toList(),
          ),
        ),

        // Address + Total
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 4, 14, 10),
          child: Row(children: [
            Icon(Icons.location_on_outlined,
                size: 12, color: c.textMuted),
            const SizedBox(width: 4),
            Expanded(child: Text(
              '${address['line1'] ?? ''}, ${address['city'] ?? ''}',
              style: TextStyle(color: c.textMuted, fontSize: 11),
              overflow: TextOverflow.ellipsis,
            )),
            Text(
              '₹${((data['deliveryFee'] as num? ?? 0) + items.fold<num>(0, (s, item) {
                final m = item as Map<String, dynamic>;
                return s + (m['price'] as num? ?? 0) * (m['quantity'] as num? ?? 1);
              })).toInt()}',
              style: const TextStyle(
                color: AppTheme.primaryGreen,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ]),
        ),

        // Update status button
        if (status != 'Delivered' && status != 'Rejected') ...[
          Divider(height: 1, color: c.divider),
          Padding(
            padding: const EdgeInsets.all(10),
            child: _buildActions(context, doc.id, status),
          ),
        ],
      ]),
    );
  }

  Widget _buildActions(BuildContext context, String orderId, String status) {
    final nextMap = {
      'Confirmed': ('Accept Order', 'Accepted'),
      'New':       ('Accept Order', 'Accepted'),
      'Accepted':  ('Mark Processing', 'Processing'),
      'Processing':('Mark Dispatched', 'Dispatched'),
      'Dispatched':('Mark Delivered', 'Delivered'),
    };

    final next = nextMap[status];
    if (next == null) return const SizedBox.shrink();

    return Row(children: [
      if (status == 'Confirmed' || status == 'New') ...[
        Expanded(
          child: OutlinedButton(
            onPressed: () => _updateStatus(orderId, 'Rejected'),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppTheme.error),
              minimumSize: const Size(0, 36),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Reject',
                style: TextStyle(color: AppTheme.error, fontSize: 12)),
          ),
        ),
        const SizedBox(width: 10),
      ],
      Expanded(
        flex: 2,
        child: ElevatedButton(
          onPressed: () => _updateStatus(orderId, next.$2),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(0, 36),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)),
          ),
          child: Text(next.$1,
              style: const TextStyle(fontSize: 12)),
        ),
      ),
    ]);
  }

  Future<void> _updateStatus(String orderId, String newStatus) async {
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(orderId)
        .update({'status': newStatus});
  }
}