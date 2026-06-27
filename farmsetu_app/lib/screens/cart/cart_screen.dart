import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/language_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../checkout/checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final l10n = context.watch<LanguageProvider>().l10n;
    final c    = context.col;

    return Scaffold(
      body: SafeArea(
        child: cart.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_bag_outlined,
                        size: 72, color: c.textMuted),
                    const SizedBox(height: 16),
                    Text('Your cart is empty',
                        style: TextStyle(
                            color: c.textPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Text('Add items from the Home or Farms tab',
                        style: TextStyle(
                            color: c.textSecondary, fontSize: 14)),
                  ],
                ),
              )
            : Column(
                children: [
                  // ── Header ──────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.navCart,
                            style: TextStyle(
                              color: c.textPrimary,
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                            )),
                        TextButton(
                          onPressed: cart.clearCart,
                          child: Text(l10n.clearAll,
                              style: const TextStyle(
                                  color: AppTheme.error)),
                        ),
                      ],
                    ),
                  ),
                  // ── Items list ───────────────────────────
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: cart.itemsList.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 10),
                      itemBuilder: (_, i) =>
                          _CartItemTile(item: cart.itemsList[i]),
                    ),
                  ),
                  // ── Summary + checkout ───────────────────
                  _OrderSummary(),
                ],
              ),
      ),
    );
  }
}

// ── Cart item tile ────────────────────────────────────────────
class _CartItemTile extends StatelessWidget {
  final CartItem item;
  const _CartItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartProvider>();
    final c    = context.col;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: c.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: c.divider),
      ),
      child: Row(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            item.product.imageUrl,
            width: 60, height: 60,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 60, height: 60,
              color: c.surfaceHigh,
              child: const Icon(Icons.eco_outlined,
                  color: AppTheme.primaryGreen),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.product.name,
                  style: TextStyle(
                    color: c.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  )),
              const SizedBox(height: 4),
              Text(item.product.vendorName,
                  style: TextStyle(color: c.textMuted, fontSize: 12)),
              const SizedBox(height: 6),
              Text(
                '₹${(item.product.price * item.quantity).toInt()}',
                style: const TextStyle(
                  color: AppTheme.primaryGreen,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
        // ── Qty controls ──
        Row(children: [
          _QtyBtn(
            icon:  Icons.remove_rounded,
            onTap: () => cart.decrementItem(item.product.id),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text('${item.quantity}',
                style: TextStyle(
                  color: c.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                )),
          ),
          _QtyBtn(
            icon:  Icons.add_rounded,
            onTap: () => cart.addItem(item.product),
          ),
        ]),
      ]),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData     icon;
  final VoidCallback onTap;
  const _QtyBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.col;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28, height: 28,
        decoration: BoxDecoration(
          color: c.surfaceHigh,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: c.divider),
        ),
        child: Icon(icon, size: 14, color: c.textPrimary),
      ),
    );
  }
}

// ── Order summary ─────────────────────────────────────────────
class _OrderSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart  = context.watch<CartProvider>();
    final l10n  = context.watch<LanguageProvider>().l10n;
    final c     = context.col;
    const deliveryFee = 49.0;
    final total = cart.totalAmount + deliveryFee;

    return Container(
      padding: EdgeInsets.fromLTRB(
          20, 16, 20, MediaQuery.of(context).padding.bottom + 16),
      decoration: BoxDecoration(
        color: c.surface,
        border: Border(top: BorderSide(color: c.divider)),
      ),
      child: Column(
        children: [
          _SummaryRow(
            l10n.subtotalWithCount(cart.itemCount),
            '₹${cart.totalAmount.toInt()}',
            c,
          ),
          const SizedBox(height: 4),
          _SummaryRow('Delivery fee', '₹${deliveryFee.toInt()}', c),
          const SizedBox(height: 10),
          Divider(color: c.divider),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.total,
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
          const SizedBox(height: 14),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CheckoutScreen(onOrderPlaced: () {}),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.payment_rounded, size: 18),
                SizedBox(width: 8),
                Text('Proceed to Checkout',
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String    label;
  final String    value;
  final AppColors c;
  const _SummaryRow(this.label, this.value, this.c);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(color: c.textSecondary, fontSize: 13)),
          Text(value,
              style: TextStyle(color: c.textPrimary, fontSize: 13)),
        ],
      );
}