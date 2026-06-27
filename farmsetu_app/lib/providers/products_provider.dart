import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../models/farmer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

class ProductsProvider extends ChangeNotifier {
  final _db = FirebaseFirestore.instance;

  List<Product> _products = [];
  bool _loading = true;
  String? _error;

  List<Product> get products => _products;
  bool get isLoading => _loading;
  String? get error => _error;

  void startListening() {
    _db.collection('farmers').snapshots().listen((farmerSnap) {
      final approvedIds = farmerSnap.docs
          .where((d) {
            final status = d.data()['status'];
            return status == 3 || status == '3' || status == 'approved';
          })
          .map((d) => d.id)
          .toList();

      if (approvedIds.isEmpty) {
        _products = [];
        _loading = false;
        notifyListeners();
        return;
      }

      final ids = approvedIds.take(30).toList();

      _db
          .collection('products')
          .where('farmerId', whereIn: ids)
          .where('isAvailable', isEqualTo: true)
          .snapshots()
          .listen((productSnap) {
        _products = productSnap.docs.map((d) {
          final data = d.data();
          return Product(
            id: d.id,
            name: data['name'] ?? '',
            vendorName: data['farmName'] ?? '',
            vendorId: data['farmerId'] ?? '',
            price: (data['price'] ?? 0).toDouble(),
            unit: data['unit'] ?? '',
            category: data['category'] ?? '',
            imageUrl: data['imageUrl'] ?? '',
            description: data['description'] ?? data['name'] ?? '',
            rating: (data['rating'] ?? 4.5).toDouble(),
            reviewCount: data['reviewCount'] ?? 0,
            isOrganic: data['isOrganic'] ?? false,
            isAvailable: data['isAvailable'] ?? true,
            stock: data['stock'] ?? 0,
          );
        }).toList();
        _loading = false;
        notifyListeners();
      }, onError: (e) {
        _error = e.toString();
        _loading = false;
        notifyListeners();
      });
    }, onError: (e) {
      _error = e.toString();
      _loading = false;
      notifyListeners();
    });
  }

  // ── Filter helpers ───────────────────────────────────────────
  List<Product> byCategory(String cat) => cat == 'All'
      ? _products
      : _products.where((p) => p.category == cat).toList();

  List<Product> search(String query) {
    final q = query.toLowerCase();
    return _products
        .where((p) =>
            p.name.toLowerCase().contains(q) ||
            p.vendorName.toLowerCase().contains(q) ||
            p.category.toLowerCase().contains(q))
        .toList();
  }

  // ── Stream farmer's own products (for farmer portal) ─────────
  Stream<List<FarmerProduct>> farmerProductsStream(String farmerId) => _db
      .collection('products')
      .where('farmerId', isEqualTo: farmerId)
      .snapshots()
      .map((snap) =>
          snap.docs.map((d) => FarmerProduct.fromFirestore(d.data())).toList());

  // ── Add / Update / Delete products (farmer portal) ───────────
  Future<void> addProduct(FarmerProduct p) async {
    await _db.collection('products').doc(p.id).set(p.toFirestore());
  }

  Future<void> updateProduct(FarmerProduct p) async {
    await _db.collection('products').doc(p.id).update(p.toFirestore());
  }

  Future<void> deleteProduct(String id) async {
    await _db.collection('products').doc(id).delete();
  }

  // ── Upload product image via Cloudinary ──────────────────────
  Future<String?> uploadProductImage(String farmerId) async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      if (picked == null) return null;

      final fileName = DateTime.now().millisecondsSinceEpoch;

      final uri =
          Uri.parse('https://api.cloudinary.com/v1_1/djkftr3ft/image/upload');
      final request = http.MultipartRequest('POST', uri)
        ..fields['upload_preset'] = 'syrjfiud'
        ..fields['public_id'] = 'farmers/$farmerId/products/$fileName'
        ..files.add(await http.MultipartFile.fromPath('file', picked.path));

      final response = await request.send();
      final body = await response.stream.bytesToString();
      final json = jsonDecode(body);
      return json['secure_url'] as String;
    } catch (e) {
      debugPrint('uploadProductImage error: $e');
      return null;
    }
  }
}
