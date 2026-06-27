import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/address.dart';
import '../../models/order_model.dart';
import '../../providers/address_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/notifications_provider.dart';
import '../../providers/orders_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../profile/address_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final VoidCallback onOrderPlaced;
  const CheckoutScreen({super.key, required this.onOrderPlaced});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _payment = 'Cash on Delivery';

  static const _paymentOptions = [
    {
      'id': 'Cash on Delivery',
      'label': 'Cash on Delivery',
      'icon': Icons.money_rounded
    },
    {'id': 'UPI', 'label': 'UPI', 'icon': Icons.qr_code_rounded},
    {
      'id': 'Credit Card',
      'label': 'Credit / Debit Card',
      'icon': Icons.credit_card_rounded
    },
    {
      'id': 'Net Banking',
      'label': 'Net Banking',
      'icon': Icons.account_balance_outlined
    },
  ];

  Future<void> _placeOrder(BuildContext context) async {
    final addrP = context.read<AddressProvider>();
    final cart = context.read<CartProvider>();
    final orders = context.read<OrdersProvider>();
    final notif = context.read<NotificationsProvider>();

    if (addrP.selected == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add a delivery address first'),
          backgroundColor: AppTheme.error,
        ),
      );
      return;
    }

    final order = await orders.placeOrder(
      cartItems: cart.itemsList,
      address: addrP.selected!,
      paymentMethod: _payment,
    );

    notif.addOrderNotification(
      orderId: order.id,
      paymentMethod: _payment,
      deliveryDate: order.estimatedDelivery,
    );

    cart.clearCart();
    Navigator.pop(context);
    widget.onOrderPlaced();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _OrderSuccessDialog(order: order),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final addrP = context.watch<AddressProvider>();
    final c = context.col;
    const deliveryFee = 49.0;
    final total = cart.totalAmount + deliveryFee;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        leading: _BackBtn(),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
        children: [
          // ── Delivery Address ────────────────────────────
          const _SectionTitle('Delivery Address'),
          addrP.selected == null
              ? _AddAddressPrompt()
              : Column(
                  children: [
                    ...addrP.addresses.map((addr) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _AddressSelector(
                            address: addr,
                            selected: addrP.selectedId == addr.id,
                            onTap: () => addrP.selectAddress(addr.id),
                          ),
                        )),
                    if (addrP.canAdd)
                      TextButton.icon(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const AddressScreen())),
                        icon: const Icon(Icons.add_rounded,
                            color: AppTheme.primaryGreen, size: 16),
                        label: const Text('Add another address',
                            style: TextStyle(color: AppTheme.primaryGreen)),
                      ),
                  ],
                ),
          const SizedBox(height: 24),

          // ── Payment Method ──────────────────────────────
          const _SectionTitle('Payment Method'),
          ..._paymentOptions.map((opt) => _PaymentTile(
                icon: opt['icon'] as IconData,
                label: opt['label'] as String,
                selected: _payment == opt['id'],
                onTap: () => setState(() => _payment = opt['id'] as String),
              )),
          const SizedBox(height: 24),

          // ── Order Summary ───────────────────────────────
          const _SectionTitle('Order Summary'),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: c.cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: c.divider),
            ),
            child: Column(
              children: [
                ...cart.itemsList.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(children: [
                        Expanded(
                          child: Text(
                            item.product.name,
                            style:
                                TextStyle(color: c.textPrimary, fontSize: 13),
                          ),
                        ),
                        Text('×${item.quantity}',
                            style: TextStyle(color: c.textMuted, fontSize: 12)),
                        const SizedBox(width: 12),
                        Text('₹${item.subtotal.toInt()}',
                            style: const TextStyle(
                              color: AppTheme.primaryGreen,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            )),
                      ]),
                    )),
                Divider(color: c.divider),
                _Row('Subtotal', '₹${cart.totalAmount.toInt()}', c),
                const SizedBox(height: 4),
                _Row('Delivery', '₹${deliveryFee.toInt()}', c),
                const SizedBox(height: 8),
                Divider(color: c.divider),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total',
                        style: TextStyle(
                          color: c.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        )),
                    Text('₹${total.toInt()}',
                        style: const TextStyle(
                          color: AppTheme.primaryGreen,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        )),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),

      // ── Place Order button ──────────────────────────────
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(
            20, 16, 20, MediaQuery.of(context).padding.bottom + 16),
        decoration: BoxDecoration(
          color: c.surface,
          border: Border(top: BorderSide(color: c.divider)),
        ),
        child: ElevatedButton(
          onPressed: () => _placeOrder(context),
          child: Text(
            'Place Order  ·  ₹${total.toInt()}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(text,
            style: TextStyle(
              color: context.col.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            )),
      );
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final AppColors c;
  const _Row(this.label, this.value, this.c);
  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: c.textSecondary, fontSize: 13)),
          Text(value, style: TextStyle(color: c.textPrimary, fontSize: 13)),
        ],
      );
}

class _PaymentTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _PaymentTile({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.col;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primaryGreen.withOpacity(0.06) : c.cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                selected ? AppTheme.primaryGreen.withOpacity(0.4) : c.divider,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(children: [
          Icon(icon,
              color: selected ? AppTheme.primaryGreen : c.textMuted, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label,
                style: TextStyle(
                  color: selected ? AppTheme.primaryGreen : c.textPrimary,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 14,
                )),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? AppTheme.primaryGreen : c.divider,
                width: 2,
              ),
              color: selected ? AppTheme.primaryGreen : Colors.transparent,
            ),
            child: selected
                ? const Icon(Icons.check_rounded, size: 12, color: Colors.white)
                : null,
          ),
        ]),
      ),
    );
  }
}

class _AddressSelector extends StatelessWidget {
  final Address address;
  final bool selected;
  final VoidCallback onTap;
  const _AddressSelector({
    required this.address,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.col;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primaryGreen.withOpacity(0.06) : c.cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                selected ? AppTheme.primaryGreen.withOpacity(0.4) : c.divider,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? AppTheme.primaryGreen : c.divider,
                width: 2,
              ),
              color: selected ? AppTheme.primaryGreen : Colors.transparent,
            ),
            child: selected
                ? const Icon(Icons.check_rounded, size: 12, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${address.label} — ${address.fullName}',
                  style: TextStyle(
                    color: c.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${address.line1}, ${address.city}, '
                  '${address.state} - ${address.pincode}',
                  style: TextStyle(color: c.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

class _AddAddressPrompt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = context.col;
    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => const AddressScreen())),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: c.cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.3)),
        ),
        child: Row(children: [
          const Icon(Icons.add_location_alt_outlined,
              color: AppTheme.primaryGreen, size: 22),
          const SizedBox(width: 12),
          Text('Add delivery address',
              style: TextStyle(
                color: c.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              )),
          const Spacer(),
          Icon(Icons.arrow_forward_ios_rounded, size: 13, color: c.textMuted),
        ]),
      ),
    );
  }
}

class _OrderSuccessDialog extends StatelessWidget {
  final AppOrder order;
  const _OrderSuccessDialog({required this.order});

  @override
  Widget build(BuildContext context) {
    final c = context.col;
    return AlertDialog(
      backgroundColor: c.cardBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_circle_rounded,
                color: AppTheme.primaryGreen, size: 40),
          ),
          const SizedBox(height: 16),
          Text('Order Placed!',
              style: TextStyle(
                color: c.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              )),
          const SizedBox(height: 8),
          Text(
            'Order #${order.id.substring(order.id.length - 6)}\n'
            'via ${order.paymentMethod}',
            textAlign: TextAlign.center,
            style: TextStyle(color: c.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '🚚  Delivery in 3 days  ·  ₹${order.total.toInt()}',
              style: const TextStyle(
                  color: AppTheme.primaryGreen,
                  fontWeight: FontWeight.w600,
                  fontSize: 13),
            ),
          ),
        ],
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continue Shopping'),
          ),
        ),
      ],
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
