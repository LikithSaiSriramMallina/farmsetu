import 'package:farmsetu/models/product.dart';
import 'package:farmsetu/models/vendor.dart';

class MockData {
  static const categories = [
    'All',
    'Vegetables',
    'Fruits',
    'Dairy',
    'Grains',
    'Honey'
  ];

  static final vendors = [
    const Vendor(
      id: 'v1',
      farmName: 'Green Valley Farm',
      ownerName: 'Ravi Kumar',
      location: 'Bangalore Rural, Karnataka',
      imageUrl:
          'https://images.unsplash.com/photo-1500076656116-558758c991c1?w=400',
      bannerUrl:
          'https://images.unsplash.com/photo-1500076656116-558758c991c1?w=800',
      bio: 'Family farm for 3 generations. Organic vegetables grown with love.',
      rating: 4.8,
      reviewCount: 124,
      yearsActive: 12,
      isVerified: true,
      productCategories: ['Vegetables', 'Fruits'],
    ),
    const Vendor(
      id: 'v2',
      farmName: 'Sunrise Dairy',
      ownerName: 'Meena Patel',
      location: 'Anand, Gujarat',
      imageUrl:
          'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=400',
      bannerUrl:
          'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=800',
      bio: 'Pure dairy products from happy, free-range cows.',
      rating: 4.6,
      reviewCount: 89,
      yearsActive: 8,
      isVerified: true,
      productCategories: ['Dairy'],
    ),
    const Vendor(
      id: 'v3',
      farmName: 'Forest Honey Co.',
      ownerName: 'Arjun Nair',
      location: 'Wayanad, Kerala',
      imageUrl:
          'https://images.unsplash.com/photo-1558642452-9d2a7deb7f62?w=400',
      bannerUrl:
          'https://images.unsplash.com/photo-1558642452-9d2a7deb7f62?w=800',
      bio: 'Wild honey harvested ethically from the forests of Wayanad.',
      rating: 4.9,
      reviewCount: 203,
      yearsActive: 5,
      isVerified: true,
      productCategories: ['Honey'],
    ),
    const Vendor(
      id: 'v4',
      farmName: 'Punjab Grains',
      ownerName: 'Harpreet Singh',
      location: 'Ludhiana, Punjab',
      imageUrl:
          'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=400',
      bannerUrl:
          'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=800',
      bio: 'Premium quality wheat and grains directly from our farms.',
      rating: 4.5,
      reviewCount: 67,
      yearsActive: 20,
      isVerified: true,
      productCategories: ['Grains'],
    ),
  ];

  static final products = [
    const Product(
      id: 'p1',
      name: 'Heirloom Tomatoes',
      vendorName: 'Green Valley Farm',
      vendorId: 'v1',
      price: 120,
      unit: 'per kg',
      category: 'Vegetables',
      imageUrl:
          'https://images.unsplash.com/photo-1546094096-0df4bcabd337?w=400',
      description:
          'Grown without pesticides. Rich in flavor, picked at peak ripeness.',
      rating: 4.8,
      reviewCount: 124,
      isOrganic: true,
      isAvailable: true,
      stock: 50,
    ),
    const Product(
      id: 'p2',
      name: 'Baby Spinach',
      vendorName: 'Green Valley Farm',
      vendorId: 'v1',
      price: 60,
      unit: 'per 250g',
      category: 'Vegetables',
      imageUrl:
          'https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=400',
      description:
          'Tender baby spinach leaves, freshly harvested every morning.',
      rating: 4.6,
      reviewCount: 89,
      isOrganic: true,
      isAvailable: true,
      stock: 30,
    ),
    const Product(
      id: 'p3',
      name: 'Organic Strawberries',
      vendorName: 'Green Valley Farm',
      vendorId: 'v1',
      price: 180,
      unit: 'per 500g',
      category: 'Fruits',
      imageUrl:
          'https://images.unsplash.com/photo-1464965911861-746a04b4bca6?w=400',
      description: 'Sweet and juicy strawberries, organically grown.',
      rating: 4.9,
      reviewCount: 203,
      isOrganic: true,
      isAvailable: true,
      stock: 20,
    ),
    const Product(
      id: 'p4',
      name: 'Free-Range Eggs',
      vendorName: 'Sunrise Dairy',
      vendorId: 'v2',
      price: 90,
      unit: 'per dozen',
      category: 'Dairy',
      imageUrl:
          'https://images.unsplash.com/photo-1582722872445-44dc5f7e3c8f?w=400',
      description: 'Eggs from free-range hens raised on natural feed.',
      rating: 4.7,
      reviewCount: 156,
      isOrganic: false,
      isAvailable: true,
      stock: 100,
    ),
    const Product(
      id: 'p5',
      name: 'Paneer',
      vendorName: 'Sunrise Dairy',
      vendorId: 'v2',
      price: 140,
      unit: 'per 200g',
      category: 'Dairy',
      imageUrl:
          'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?w=400',
      description: 'Fresh homemade paneer made from pure cow milk daily.',
      rating: 4.8,
      reviewCount: 98,
      isOrganic: false,
      isAvailable: true,
      stock: 40,
    ),
    const Product(
      id: 'p6',
      name: 'Raw Forest Honey',
      vendorName: 'Forest Honey Co.',
      vendorId: 'v3',
      price: 350,
      unit: 'per 500g',
      category: 'Honey',
      imageUrl:
          'https://images.unsplash.com/photo-1587049352846-4a222e784d38?w=400',
      description: 'Unprocessed wild honey harvested from forest beehives.',
      rating: 4.9,
      reviewCount: 312,
      isOrganic: true,
      isAvailable: true,
      stock: 15,
    ),
    const Product(
      id: 'p7',
      name: 'Fresh Carrots',
      vendorName: 'Green Valley Farm',
      vendorId: 'v1',
      price: 50,
      unit: 'per kg',
      category: 'Vegetables',
      imageUrl:
          'https://images.unsplash.com/photo-1598170845058-32b9d6a5da37?w=400',
      description: 'Crunchy farm-fresh carrots pulled straight from the soil.',
      rating: 4.5,
      reviewCount: 74,
      isOrganic: false,
      isAvailable: true,
      stock: 80,
    ),
    const Product(
      id: 'p8',
      name: 'Whole Wheat Atta',
      vendorName: 'Punjab Grains',
      vendorId: 'v4',
      price: 65,
      unit: 'per kg',
      category: 'Grains',
      imageUrl:
          'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=400',
      description:
          'Stone-ground whole wheat flour, rich in fiber and nutrients.',
      rating: 4.6,
      reviewCount: 145,
      isOrganic: false,
      isAvailable: true,
      stock: 200,
    ),
  ];

  static List<Product> getProductsByVendor(String vendorId) =>
      products.where((p) => p.vendorId == vendorId).toList();
}
