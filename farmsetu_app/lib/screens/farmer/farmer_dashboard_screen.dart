import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/farmer_auth_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';

class FarmerDashboardScreen extends StatelessWidget {
  const FarmerDashboardScreen({super.key});

  static const _weeklyData = [
    {'day': 'Mon', 'amount': 1200.0},
    {'day': 'Tue', 'amount': 1850.0},
    {'day': 'Wed', 'amount': 980.0},
    {'day': 'Thu', 'amount': 2400.0},
    {'day': 'Fri', 'amount': 1700.0},
    {'day': 'Sat', 'amount': 3200.0},
    {'day': 'Sun', 'amount': 2100.0},
  ];

  static const _recentOrders = [
    {'id': 'ORD001', 'customer': 'Priya S.', 'items': 'Tomatoes ×3, Spinach ×2', 'amount': 185, 'status': 'New'},
    {'id': 'ORD002', 'customer': 'Rahul M.', 'items': 'Organic Carrots ×5',      'amount': 225, 'status': 'Processing'},
    {'id': 'ORD003', 'customer': 'Anjali K.', 'items': 'Fresh Milk ×2',           'amount': 120, 'status': 'Delivered'},
  ];

  @override
  Widget build(BuildContext context) {
    final farmer = context.watch<FarmerAuthProvider>().farmer;
    if (farmer == null) return const SizedBox.shrink();

    final c      = context.col;
    final maxAmt = _weeklyData
        .map((d) => d['amount'] as double)
        .reduce((a, b) => a > b ? a : b);

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // ── Header ──────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good morning 👋',
                          style: TextStyle(
                              color: c.textSecondary, fontSize: 13),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          farmer.farmName,
                          style: TextStyle(
                            color: c.textPrimary,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.agriculture_rounded,
                        color: AppTheme.primaryGreen, size: 24),
                  ),
                ],
              ),
            ),
          ),

          // ── Stats cards ──────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.6,
                children: const [
                  _StatCard(
                    label: 'This Month',
                    value: '₹12,450',
                    icon:  Icons.currency_rupee_rounded,
                    color: AppTheme.primaryGreen,
                    sub:   '+18% vs last month',
                  ),
                  _StatCard(
                    label: 'Pending Orders',
                    value: '3',
                    icon:  Icons.pending_actions_rounded,
                    color: Color(0xFFE88F3F),
                    sub:   '2 need response',
                  ),
                  _StatCard(
                    label: 'Products Listed',
                    value: '8',
                    icon:  Icons.inventory_2_outlined,
                    color: Color(0xFF5CB8E4),
                    sub:   '1 low stock',
                  ),
                  _StatCard(
                    label: 'Avg. Rating',
                    value: '4.7 ★',
                    icon:  Icons.star_outline_rounded,
                    color: AppTheme.starYellow,
                    sub:   'Based on 42 reviews',
                  ),
                ],
              ),
            ),
          ),

          // ── Weekly earnings chart ────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: c.cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: c.divider),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Weekly Earnings',
                            style: TextStyle(
                              color: c.textPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            )),
                        Text('This week',
                            style: TextStyle(
                                color: c.textMuted, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text('₹13,430 total',
                        style: TextStyle(
                          color: AppTheme.primaryGreen,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        )),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 100,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: _weeklyData.map((d) {
                          final frac =
                              (d['amount'] as double) / maxAmt;
                          final isMax =
                              d['amount'] == maxAmt;
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 3),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.end,
                                children: [
                                  if (isMax)
                                    Text(
                                      '₹${((d['amount'] as double) / 1000).toStringAsFixed(1)}k',
                                      style: const TextStyle(
                                        color:
                                            AppTheme.primaryGreen,
                                        fontSize: 8,
                                        fontWeight:
                                            FontWeight.w700,
                                      ),
                                    ),
                                  const SizedBox(height: 2),
                                  AnimatedContainer(
                                    duration: const Duration(
                                        milliseconds: 500),
                                    height: 80 * frac,
                                    decoration: BoxDecoration(
                                      color: isMax
                                          ? AppTheme.primaryGreen
                                          : AppTheme.primaryGreen
                                              .withOpacity(0.3),
                                      borderRadius:
                                          BorderRadius.circular(4),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(d['day'] as String,
                                      style: TextStyle(
                                          color: c.textMuted,
                                          fontSize: 10)),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Recent orders ────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Recent Orders',
                      style: TextStyle(
                        color: c.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      )),
                  const Text('See all',
                      style: TextStyle(
                          color: AppTheme.primaryGreen,
                          fontSize: 13,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, i) {
                final order = _recentOrders[i];
                final statusColor = switch (order['status']) {
                  'New'       => const Color(0xFF5CB8E4),
                  'Processing'=> const Color(0xFFE88F3F),
                  'Delivered' => AppTheme.primaryGreen,
                  _           => AppTheme.primaryGreen,
                };
                return Padding(
                  padding: EdgeInsets.fromLTRB(
                      20, i == 0 ? 12 : 8, 20, 0),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: c.cardBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: c.divider),
                    ),
                    child: Row(children: [
                      Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.receipt_outlined,
                            color: statusColor, size: 18),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Text(
                                order['id'] as String,
                                style: TextStyle(
                                  color: c.textPrimary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(order['customer'] as String,
                                  style: TextStyle(
                                      color: c.textMuted,
                                      fontSize: 12)),
                            ]),
                            const SizedBox(height: 3),
                            Text(order['items'] as String,
                                style: TextStyle(
                                    color: c.textSecondary,
                                    fontSize: 12),
                                overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '₹${order['amount']}',
                            style: const TextStyle(
                              color: AppTheme.primaryGreen,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color:
                                  statusColor.withOpacity(0.1),
                              borderRadius:
                                  BorderRadius.circular(4),
                            ),
                            child: Text(
                              order['status'] as String,
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ]),
                  ),
                );
              },
              childCount: _recentOrders.length,
            ),
          ),
          const SliverToBoxAdapter(
              child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String   label;
  final String   value;
  final IconData icon;
  final Color    color;
  final String   sub;
  const _StatCard({
    required this.label, required this.value,
    required this.icon,  required this.color, required this.sub,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.col;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: c.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: TextStyle(
                      color: c.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w500)),
              Icon(icon, color: color, size: 16),
            ],
          ),
          Text(value,
              style: TextStyle(
                color: c.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              )),
          Text(sub,
              style: TextStyle(color: c.textMuted, fontSize: 10),
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}