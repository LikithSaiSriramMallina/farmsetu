import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/products_provider.dart';
import '../../providers/saved_products_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/product_card.dart';
import '../product/product_detail_screen.dart';

class SavedProductsScreen extends StatelessWidget {
  final VoidCallback onGoToCart;
  const SavedProductsScreen({super.key, required this.onGoToCart});

  @override
  Widget build(BuildContext context) {
    final savedP = context.watch<SavedProductsProvider>();
    final l10n   = context.watch<LanguageProvider>().l10n;
    final c      = context.col;
    final saved  = context.watch<ProductsProvider>().products
        .where((p) => savedP.isSaved(p.id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.savedProducts),
        leading: _BackBtn(),
      ),
      body: saved.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border_rounded,
                      size: 64, color: c.textMuted),
                  const SizedBox(height: 16),
                  Text('No saved products',
                      style: TextStyle(
                          color: c.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text('Tap the ♥ on any product to save it',
                      style: TextStyle(
                          color: c.textSecondary, fontSize: 14)),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, childAspectRatio: 0.72,
                crossAxisSpacing: 6, mainAxisSpacing: 6,
              ),
              itemCount: saved.length,
              itemBuilder: (ctx, i) => GestureDetector(
                onTap: () => Navigator.push(ctx,
                    MaterialPageRoute(
                        builder: (_) => ProductDetailScreen(
                              product:    saved[i],
                              onGoToCart: onGoToCart,
                            ))),
                child: ProductCard(product: saved[i]),
              ),
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
            color: c.surfaceHigh,
            borderRadius: BorderRadius.circular(10)),
        child: Icon(Icons.arrow_back_ios_new_rounded,
            size: 16, color: c.textPrimary),
      ),
    );
  }
}