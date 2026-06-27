import 'package:cached_network_image/cached_network_image.dart';
import 'package:farmsetu/models/product.dart';
import 'package:farmsetu/providers/cart_provider.dart';
import 'package:farmsetu/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: unused_import
import '../models/product.dart';
// ignore: unused_import
import '../providers/cart_provider.dart';
// ignore: unused_import
import '../theme/app_theme.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final inCart = context.select<CartProvider, bool>(
        (c) => c.isInCart(product.id));

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.divider),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Image ────────────────────────────────────
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: product.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(color: AppTheme.surfaceHigh),
                  errorWidget: (_, __, ___) => Container(
                    color: AppTheme.surfaceHigh,
                    child: const Icon(Icons.image_not_supported_outlined,
                        color: AppTheme.textMuted),
                  ),
                ),
                if (product.isOrganic)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGreen,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Organic',
                        style: TextStyle(
                          color: AppTheme.background,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // ── Info ─────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(7),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 1),
                Text(
                  product.vendorName,
                  style: const TextStyle(
                      color: AppTheme.textMuted, fontSize: 10),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Price
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '₹${product.price.toInt()}',
                          style: const TextStyle(
                            color: AppTheme.primaryGreen,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          product.unit,
                          style: const TextStyle(
                              color: AppTheme.textMuted, fontSize: 9),
                        ),
                      ],
                    ),
                    // Add-to-cart button
                    GestureDetector(
                      onTap: () =>
                          context.read<CartProvider>().addItem(product),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          color: inCart
                              ? AppTheme.primaryGreen
                              : AppTheme.surfaceHigh,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: inCart
                                ? AppTheme.primaryGreen
                                : AppTheme.divider,
                          ),
                        ),
                        child: Icon(
                          inCart ? Icons.check_rounded : Icons.add_rounded,
                          size: 14,
                          color: inCart
                              ? AppTheme.background
                              : AppTheme.textSecondary,
                        ),
                      ),
                    ),
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
