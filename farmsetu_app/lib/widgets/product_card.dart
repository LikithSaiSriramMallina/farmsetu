import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/language_provider.dart';
import '../providers/saved_products_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final inCart = context.select<CartProvider, bool>(
        (c) => c.isInCart(product.id));
    final isSaved = context.select<SavedProductsProvider, bool>(
        (s) => s.isSaved(product.id));
    final l10n = context.watch<LanguageProvider>().l10n;
    final c    = context.col;

    return Container(
      decoration: BoxDecoration(
        color: c.cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: c.divider),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Expanded(
            flex: 5,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: product.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, __) =>
                      Container(color: c.surfaceHigh),
                  errorWidget: (_, __, ___) => Container(
                    color: c.surfaceHigh,
                    child: Icon(Icons.image_not_supported_outlined,
                        color: c.textMuted, size: 18),
                  ),
                ),
                if (product.isOrganic)
                  Positioned(
                    top: 5, left: 5,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGreen,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(l10n.organic,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                          )),
                    ),
                  ),
                // Heart button
                Positioned(
                  top: 4, right: 4,
                  child: GestureDetector(
                    onTap: () => context
                        .read<SavedProductsProvider>()
                        .toggle(product.id),
                    child: Container(
                      width: 22, height: 22,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        isSaved
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        size: 13,
                        color: isSaved
                            ? const Color(0xFFE45C7A)
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Info
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(6, 5, 6, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      color: c.textPrimary,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          '₹${product.price.toInt()}',
                          style: const TextStyle(
                            color: AppTheme.primaryGreen,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () =>
                            context.read<CartProvider>().addItem(product),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 22, height: 22,
                          decoration: BoxDecoration(
                            color: inCart
                                ? AppTheme.primaryGreen
                                : c.surfaceHigh,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: inCart
                                  ? AppTheme.primaryGreen
                                  : c.divider,
                            ),
                          ),
                          child: Icon(
                            inCart
                                ? Icons.check_rounded
                                : Icons.add_rounded,
                            size: 13,
                            color: inCart
                                ? Colors.white
                                : c.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}