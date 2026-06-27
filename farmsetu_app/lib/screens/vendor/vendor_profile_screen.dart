import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/vendor.dart';
import '../../data/mock_data.dart';
import '../../providers/language_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/product_card.dart';
import '../product/product_detail_screen.dart';

class VendorProfileScreen extends StatelessWidget {
  final Vendor       vendor;
  final VoidCallback onGoToCart;

  const VendorProfileScreen({
    super.key,
    required this.vendor,
    required this.onGoToCart,
  });

  @override
  Widget build(BuildContext context) {
    final l10n     = context.watch<LanguageProvider>().l10n;
    final c        = context.col;
    final products = MockData.getProductsByVendor(vendor.id);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Banner / AppBar ──────────────────────────────
          SliverAppBar(
            expandedHeight: 220,
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
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: vendor.bannerUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, __) =>
                        Container(color: c.surfaceHigh),
                    errorWidget: (_, __, ___) =>
                        Container(color: c.surfaceHigh),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.6),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Vendor Info ──────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: CachedNetworkImage(
                          imageUrl: vendor.imageUrl,
                          width: 72, height: 72,
                          fit: BoxFit.cover,
                          placeholder: (_, __) =>
                              Container(color: c.surfaceHigh,
                                  width: 72, height: 72),
                          errorWidget: (_, __, ___) => Container(
                            width: 72, height: 72,
                            color: c.surfaceHigh,
                            child: const Icon(Icons.eco_rounded,
                                color: AppTheme.primaryGreen),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Expanded(
                                child: Text(vendor.farmName,
                                    style: TextStyle(
                                      color: c.textPrimary,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                    )),
                              ),
                              if (vendor.isVerified)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryGreen
                                        .withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(children: [
                                    const Icon(Icons.verified_rounded,
                                        color: AppTheme.primaryGreen,
                                        size: 12),
                                    const SizedBox(width: 4),
                                    Text(l10n.verified,
                                        style: const TextStyle(
                                          color: AppTheme.primaryGreen,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        )),
                                  ]),
                                ),
                            ]),
                            const SizedBox(height: 4),
                            Text('${l10n.byOwner} ${vendor.ownerName}',
                                style: TextStyle(
                                    color: c.textSecondary, fontSize: 13)),
                            const SizedBox(height: 6),
                            Row(children: [
                              const Icon(Icons.star_rounded,
                                  color: AppTheme.starYellow, size: 15),
                              const SizedBox(width: 4),
                              Text(
                                '${vendor.rating}  ·  ${vendor.reviewCount} ${l10n.reviewsLabel}',
                                style: TextStyle(
                                    color: c.textSecondary, fontSize: 13),
                              ),
                            ]),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Stats chips
                  Row(children: [
                    _StatChip(
                      icon: Icons.calendar_today_outlined,
                      label: '${vendor.yearsActive} ${l10n.active}',
                    ),
                    const SizedBox(width: 8),
                    _StatChip(
                      icon: Icons.location_on_outlined,
                      label: vendor.location,
                    ),
                  ]),
                  const SizedBox(height: 20),

                  // About
                  Text(l10n.aboutFarm,
                      style: TextStyle(
                        color: c.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      )),
                  const SizedBox(height: 8),
                  Text(vendor.bio,
                      style: TextStyle(
                          color: c.textSecondary,
                          fontSize: 14,
                          height: 1.5)),
                  const SizedBox(height: 20),

                  // Specialises in
                  Text(l10n.specialisesIn,
                      style: TextStyle(
                        color: c.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      )),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8, runSpacing: 8,
                    children: vendor.productCategories.map((cat) =>
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryGreen.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: AppTheme.primaryGreen
                                    .withOpacity(0.3)),
                          ),
                          child: Text(l10n.categoryName(cat),
                              style: const TextStyle(
                                color: AppTheme.primaryGreen,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              )),
                        )).toList(),
                  ),
                  const SizedBox(height: 28),

                  // Products header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.productsLabel,
                          style: TextStyle(
                            color: c.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          )),
                      Text(l10n.itemsCount(products.length),
                          style: TextStyle(
                              color: c.textSecondary, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 14),
                ],
              ),
            ),
          ),

          // ── Products Grid ────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (ctx, i) {
                  final product = products[i];
                  return GestureDetector(
                    onTap: () => Navigator.push(ctx,
                        MaterialPageRoute(
                            builder: (_) => ProductDetailScreen(
                                  product:    product,
                                  onGoToCart: onGoToCart,
                                ))),
                    child: ProductCard(product: product),
                  );
                },
                childCount: products.length,
              ),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:   4,
                childAspectRatio: 0.72,
                crossAxisSpacing: 6,
                mainAxisSpacing:  6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String   label;
  const _StatChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final c = context.col;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: c.surfaceHigh,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: c.divider),
      ),
      child: Row(children: [
        Icon(icon, size: 13, color: c.textMuted),
        const SizedBox(width: 5),
        Text(label,
            style: TextStyle(color: c.textSecondary, fontSize: 12)),
      ]),
    );
  }
}