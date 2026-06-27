import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../providers/cart_provider.dart';
import '../../providers/language_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final VoidCallback onGoToCart;

  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.onGoToCart,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _qty = 1;

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final l10n = context.watch<LanguageProvider>().l10n;
    final c = context.col;
    final inCart = cart.isInCart(widget.product.id);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Hero image ───────────────────────────────────
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    size: 16, color: Colors.white),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: widget.product.imageUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(color: c.surfaceHigh),
                errorWidget: (_, __, ___) => Container(color: c.surfaceHigh),
              ),
            ),
          ),

          // ── Content ──────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + organic badge
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.product.name,
                          style: TextStyle(
                            color: c.textPrimary,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      if (widget.product.isOrganic)
                        Container(
                          margin: const EdgeInsets.only(left: 8, top: 4),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryGreen.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(l10n.organic,
                              style: const TextStyle(
                                color: AppTheme.primaryGreen,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              )),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Vendor
                  Text(widget.product.vendorName,
                      style: TextStyle(color: c.textSecondary, fontSize: 14)),
                  const SizedBox(height: 12),

                  // Rating
                  Row(children: [
                    const Icon(Icons.star_rounded,
                        color: AppTheme.starYellow, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.product.rating}  ·  '
                      '${widget.product.reviewCount} ${l10n.reviews}',
                      style: TextStyle(color: c.textSecondary, fontSize: 13),
                    ),
                  ]),
                  const SizedBox(height: 20),

                  // Price + Qty selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('₹${widget.product.price.toInt()}',
                              style: const TextStyle(
                                color: AppTheme.primaryGreen,
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                              )),
                          Text(widget.product.unit,
                              style:
                                  TextStyle(color: c.textMuted, fontSize: 13)),
                        ],
                      ),

                      // Qty selector
                      Container(
                        decoration: BoxDecoration(
                          color: c.surfaceHigh,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: c.divider),
                        ),
                        child: Row(children: [
                          _QtyBtn(
                            Icons.remove_rounded,
                            () =>
                                setState(() => _qty = (_qty - 1).clamp(1, 99)),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text('$_qty',
                                style: TextStyle(
                                  color: c.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                )),
                          ),
                          _QtyBtn(
                            Icons.add_rounded,
                            () =>
                                setState(() => _qty = (_qty + 1).clamp(1, 99)),
                          ),
                        ]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // About product
                  Text(l10n.aboutProduct,
                      style: TextStyle(
                        color: c.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      )),
                  const SizedBox(height: 8),
                  Text(widget.product.description,
                      style: TextStyle(
                          color: c.textSecondary, fontSize: 14, height: 1.6)),
                  const SizedBox(height: 24),

                  // From the farm
                  Text(l10n.fromTheFarm,
                      style: TextStyle(
                        color: c.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      )),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: c.cardBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: c.divider),
                    ),
                    child: Row(children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGreen.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.eco_rounded,
                            color: AppTheme.primaryGreen, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.product.vendorName,
                                style: TextStyle(
                                  color: c.textPrimary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                )),
                            Text(l10n.verified,
                                style: const TextStyle(
                                    color: AppTheme.primaryGreen,
                                    fontSize: 12)),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios_rounded,
                          size: 13, color: c.textMuted),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // ── Bottom bar ────────────────────────────────────────
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(
            20, 16, 20, MediaQuery.of(context).padding.bottom + 16),
        decoration: BoxDecoration(
          color: c.surface,
          border: Border(top: BorderSide(color: c.divider)),
        ),
        child: inCart
            ? ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  widget.onGoToCart();
                },
                icon: const Icon(Icons.shopping_bag_rounded, size: 18),
                label: Text(l10n.viewCart),
              )
            : ElevatedButton.icon(
                onPressed: () {
                  // Add _qty times since CartProvider.addItem adds 1 at a time
                  final cartProvider = context.read<CartProvider>();
                  for (int i = 0; i < _qty; i++) {
                    cartProvider.addItem(widget.product);
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.addedToCart(
                          widget.product.name, _qty)),
                      backgroundColor: AppTheme.primaryGreen,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(Icons.add_shopping_cart_rounded, size: 18),
                label: Text(
                    '${l10n.addToCartBtn}₹${(widget.product.price * _qty).toInt()}'),
              ),
      ),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyBtn(this.icon, this.onTap);

  @override
  Widget build(BuildContext context) {
    final c = context.col;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 18, color: c.textPrimary),
      ),
    );
  }
}
