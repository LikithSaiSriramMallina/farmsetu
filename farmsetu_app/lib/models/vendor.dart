class Vendor {
  final String id;
  final String farmName;
  final String ownerName;
  final String bio;
  final String location;
  final String imageUrl;
  final String bannerUrl;
  final double rating;
  final int reviewCount;
  final List<String> productCategories;
  final int yearsActive;
  final bool isVerified;

  const Vendor({
    required this.id,
    required this.farmName,
    required this.ownerName,
    required this.bio,
    required this.location,
    required this.imageUrl,
    required this.bannerUrl,
    required this.rating,
    required this.reviewCount,
    required this.productCategories,
    required this.yearsActive,
    this.isVerified = false,
  });
}
