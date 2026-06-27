class Product {
  final String id;
  final String name;
  final String vendorName;
  final String vendorId;
  final double price;
  final String unit;
  final String category;
  final String imageUrl;
  final String description;
  final double rating;
  final int    reviewCount;
  final bool   isOrganic;
  final bool   isAvailable;
  final int    stock;

  const Product({
    required this.id,
    required this.name,
    required this.vendorName,
    required this.vendorId,
    required this.price,
    required this.unit,
    required this.category,
    required this.imageUrl,
    required this.description,
    required this.rating,
    required this.reviewCount,
    required this.isOrganic,
    required this.isAvailable,
    required this.stock,
  });
}