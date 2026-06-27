import 'package:farmsetu/providers/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/farmer.dart';
import '../../providers/farmer_auth_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';

class FarmerProductsScreen extends StatelessWidget {
  const FarmerProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final farmer = context.watch<FarmerAuthProvider>().farmer;
    if (farmer == null) return const SizedBox.shrink();

    final prov = context.read<ProductsProvider>();
    final c    = context.col;

    return SafeArea(child: Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('My Products', style: TextStyle(color: c.textPrimary,
                fontSize: 24, fontWeight: FontWeight.w800)),
            ElevatedButton.icon(
              onPressed: () => _showSheet(context, farmer.id,
                  farmer.farmName, null, prov),
              icon: const Icon(Icons.add_rounded, size: 16),
              label: const Text('Add'),
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(0, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 16)),
            ),
          ],
        ),
      ),
      Expanded(child: StreamBuilder<List<FarmerProduct>>(
        stream: prov.farmerProductsStream(farmer.id),
        builder: (_, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final products = snap.data ?? [];
          if (products.isEmpty) {
            return Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inventory_2_outlined, size: 52, color: c.textMuted),
                const SizedBox(height: 12),
                Text('No products yet',
                    style: TextStyle(color: c.textSecondary, fontSize: 15)),
                const SizedBox(height: 8),
                Text('Tap + Add to list your first product',
                    style: TextStyle(color: c.textMuted, fontSize: 13)),
              ],
            ));
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
            itemCount: products.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) => _ProductTile(
              product:  products[i],
              onEdit:   () => _showSheet(context, farmer.id,
                  farmer.farmName, products[i], prov),
              onDelete: () => prov.deleteProduct(products[i].id),
              onToggle: () => prov.updateProduct(FarmerProduct(
                id:          products[i].id,
                farmerId:    products[i].farmerId,
                farmName:    products[i].farmName,
                name:        products[i].name,
                price:       products[i].price,
                unit:        products[i].unit,
                category:    products[i].category,
                stock:       products[i].stock,
                isOrganic:   products[i].isOrganic,
                isAvailable: !products[i].isAvailable,
                imageUrl:    products[i].imageUrl,
                createdAt:   products[i].createdAt,
              )),
            ),
          );
        },
      )),
    ]));
  }

  void _showSheet(BuildContext ctx, String farmerId, String farmName,
      FarmerProduct? product, ProductsProvider prov) {
    showModalBottomSheet(
      context: ctx, isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ProductSheet(
          farmerId: farmerId, farmName: farmName,
          product: product, prov: prov),
    );
  }
}

// ── Product Tile ──────────────────────────────────────────────
class _ProductTile extends StatelessWidget {
  final FarmerProduct product;
  final VoidCallback  onEdit, onDelete, onToggle;
  const _ProductTile({required this.product, required this.onEdit,
      required this.onDelete, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final c        = context.col;
    final lowStock = product.stock < 10;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.cardBg, borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: lowStock
                // ignore: deprecated_member_use
                ? AppTheme.error.withOpacity(0.3)
                : c.divider)),
      child: Row(children: [
        // ── Product image or icon ──────────────────────
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: product.imageUrl.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: product.imageUrl,
                  width: 48, height: 48,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                      width: 48, height: 48,
                      // ignore: deprecated_member_use
                      color: AppTheme.primaryGreen.withOpacity(0.1),
                      child: const Icon(Icons.eco_outlined,
                          color: AppTheme.primaryGreen, size: 24)),
                  errorWidget: (_, __, ___) => Container(
                      width: 48, height: 48,
                      // ignore: deprecated_member_use
                      color: AppTheme.primaryGreen.withOpacity(0.1),
                      child: const Icon(Icons.eco_outlined,
                          color: AppTheme.primaryGreen, size: 24)),
                )
              : Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: AppTheme.primaryGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.eco_outlined,
                      color: AppTheme.primaryGreen, size: 24)),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Expanded(child: Text(product.name, style: TextStyle(
                  color: c.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14))),
              if (product.isOrganic) Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                      color: AppTheme.primaryGreen,
                      borderRadius: BorderRadius.circular(4)),
                  child: const Text('Organic', style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w700))),
            ]),
            const SizedBox(height: 4),
            Row(children: [
              Text('₹${product.price.toInt()} ${product.unit}',
                  style: const TextStyle(
                      color: AppTheme.primaryGreen,
                      fontWeight: FontWeight.w700,
                      fontSize: 13)),
              const SizedBox(width: 10),
              Icon(lowStock
                  ? Icons.warning_amber_rounded
                  : Icons.inventory_2_outlined,
                  size: 12,
                  color: lowStock ? AppTheme.error : c.textMuted),
              const SizedBox(width: 3),
              Text('${product.stock}', style: TextStyle(
                  color: lowStock ? AppTheme.error : c.textMuted,
                  fontSize: 11)),
            ]),
          ],
        )),
        Column(children: [
          Transform.scale(scale: 0.75, child: Switch(
              value: product.isAvailable,
              onChanged: (_) => onToggle(),
              activeThumbColor: AppTheme.primaryGreen)),
          Row(children: [
            _btn(Icons.edit_outlined,
                const Color(0xFF5CB8E4), onEdit),
            const SizedBox(width: 6),
            _btn(Icons.delete_outline_rounded,
                AppTheme.error, onDelete),
          ]),
        ]),
      ]),
    );
  }

  Widget _btn(IconData icon, Color color, VoidCallback onTap) =>
      GestureDetector(onTap: onTap,
        child: Container(width: 28, height: 28,
            decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(7)),
            child: Icon(icon, size: 14, color: color)));
}

// ── Product Sheet ─────────────────────────────────────────────
class _ProductSheet extends StatefulWidget {
  final String         farmerId, farmName;
  final FarmerProduct? product;
  final ProductsProvider prov;
  const _ProductSheet({required this.farmerId, required this.farmName,
      this.product, required this.prov});
  @override
  State<_ProductSheet> createState() => _ProductSheetState();
}

class _ProductSheetState extends State<_ProductSheet> {
  late final TextEditingController _name, _price, _unit, _stock;
  late String _category;
  late bool   _organic;
  bool        _saving       = false;
  String?     _imageUrl;
  bool        _uploadingImg = false;

  @override
  void initState() {
    super.initState();
    _name     = TextEditingController(text: widget.product?.name ?? '');
    _price    = TextEditingController(
        text: widget.product?.price.toInt().toString() ?? '');
    _unit     = TextEditingController(text: widget.product?.unit ?? '');
    _stock    = TextEditingController(
        text: widget.product?.stock.toString() ?? '');
    _category = widget.product?.category ?? 'Vegetables';
    _organic  = widget.product?.isOrganic ?? false;
    _imageUrl = widget.product?.imageUrl;
  }

  @override
  void dispose() {
    _name.dispose(); _price.dispose();
    _unit.dispose(); _stock.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    setState(() => _uploadingImg = true);
    final url = await widget.prov
        .uploadProductImage(widget.farmerId);
    if (url != null) setState(() => _imageUrl = url as String?);
    setState(() => _uploadingImg = false);
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final p = FarmerProduct(
      id:        widget.product?.id ?? const Uuid().v4(),
      farmerId:  widget.farmerId,
      farmName:  widget.farmName,
      name:      _name.text.trim(),
      price:     double.tryParse(_price.text) ?? 0,
      unit:      _unit.text.trim(),
      category:  _category,
      stock:     int.tryParse(_stock.text) ?? 0,
      isOrganic: _organic,
      imageUrl:  _imageUrl ?? '',
      createdAt: widget.product?.createdAt ?? DateTime.now(),
    );
    widget.product == null
        ? await widget.prov.addProduct(p)
        : await widget.prov.updateProduct(p);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.col;
    return Container(
      decoration: BoxDecoration(
          color: c.surface,
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(20))),
      padding: EdgeInsets.fromLTRB(20, 16, 20,
          MediaQuery.of(context).viewInsets.bottom + 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Drag handle ───────────────────────────
            Center(child: Container(width: 40, height: 4,
                decoration: BoxDecoration(color: c.divider,
                    borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),

            Text(widget.product == null
                ? 'Add Product' : 'Edit Product',
                style: TextStyle(color: c.textPrimary,
                    fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),

            // ── Product Image ─────────────────────────
            GestureDetector(
              onTap: _uploadingImg ? null : _pickImage,
              child: Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: c.surfaceHigh,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      // ignore: deprecated_member_use
                      color: AppTheme.primaryGreen.withOpacity(0.4)),
                ),
                child: _uploadingImg
                    ? const Center(
                        child: CircularProgressIndicator(
                            color: AppTheme.primaryGreen))
                    : _imageUrl != null && _imageUrl!.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: _imageUrl!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          )
                        : const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_photo_alternate_outlined,
                                  color: AppTheme.primaryGreen,
                                  size: 36),
                              SizedBox(height: 8),
                              Text('Tap to add product photo',
                                  style: TextStyle(
                                    color: AppTheme.primaryGreen,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  )),
                            ],
                          ),
              ),
            ),
            const SizedBox(height: 10),

            // ── Fields ────────────────────────────────
            _tf('Product Name', _name, Icons.eco_outlined),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: _tf('Price (₹)', _price,
                  Icons.currency_rupee_rounded,
                  type: TextInputType.number)),
              const SizedBox(width: 10),
              Expanded(child: _tf('Unit', _unit,
                  Icons.scale_outlined)),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: DropdownButtonFormField<String>(
                initialValue: _category,
                dropdownColor: c.cardBg,
                style: TextStyle(color: c.textPrimary, fontSize: 14),
                decoration: InputDecoration(
                    hintText: 'Category', isDense: true,
                    prefixIcon: Icon(Icons.category_outlined,
                        size: 18, color: c.textSecondary)),
                items: ['Vegetables','Fruits','Dairy','Grains','Honey']
                    .map((cat) => DropdownMenuItem(
                        value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (v) => setState(() => _category = v!),
              )),
              const SizedBox(width: 10),
              Expanded(child: _tf('Stock qty', _stock,
                  Icons.inventory_2_outlined,
                  type: TextInputType.number)),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              Switch(
                  value: _organic,
                  onChanged: (v) => setState(() => _organic = v),
                  activeThumbColor: AppTheme.primaryGreen),
              const SizedBox(width: 8),
              Text('Organic Product',
                  style: TextStyle(
                      color: c.textPrimary, fontSize: 14)),
            ]),
            const SizedBox(height: 16),

            // ── Save button ───────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(width: 20, height: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : Text(widget.product == null
                        ? 'Add Product' : 'Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tf(String hint, TextEditingController ctrl, IconData icon,
      {TextInputType type = TextInputType.text}) {
    final c = context.col;
    return TextFormField(
        controller: ctrl,
        keyboardType: type,
        style: TextStyle(color: c.textPrimary),
        decoration: InputDecoration(
            hintText: hint, isDense: true,
            prefixIcon: Icon(icon, size: 18,
                color: c.textSecondary)));
  }
}