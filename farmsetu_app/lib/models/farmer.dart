import 'package:cloud_firestore/cloud_firestore.dart';

enum FarmerStatus { submitted, govtReview, adminReview, approved, rejected }

class FarmerProfile {
  final String       id;
  final String       name;
  final String       email;
  final String       phone;
  final String       farmName;
  final String       location;
  final String       bio;
  final String       aadhaarNumber;
  final String       passbookNumber;
  final String       category;
  final FarmerStatus status;
  final DateTime     registeredAt;
  final String?      photoUrl;

  const FarmerProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.farmName,
    required this.location,
    required this.bio,
    required this.aadhaarNumber,
    required this.passbookNumber,
    required this.category,
    this.status = FarmerStatus.submitted,
    required this.registeredAt,
    this.photoUrl,
  });

  String get maskedAadhaar =>
      '****-****-${aadhaarNumber.substring(aadhaarNumber.length - 4)}';

  FarmerProfile copyWith({
    FarmerStatus? status,
    String?       photoUrl,
  }) =>
      FarmerProfile(
        id:             id,
        name:           name,
        email:          email,
        phone:          phone,
        farmName:       farmName,
        location:       location,
        bio:            bio,
        aadhaarNumber:  aadhaarNumber,
        passbookNumber: passbookNumber,
        category:       category,
        registeredAt:   registeredAt,
        status:         status   ?? this.status,
        photoUrl:       photoUrl ?? this.photoUrl,
      );

  Map<String, dynamic> toFirestore() => {
        'id':             id,
        'name':           name,
        'email':          email,
        'phone':          phone,
        'farmName':       farmName,
        'location':       location,
        'bio':            bio,
        'aadhaarNumber':  aadhaarNumber,
        'passbookNumber': passbookNumber,
        'category':       category,
        'status':         status.index,
        'registeredAt':   Timestamp.fromDate(registeredAt),
        if (photoUrl != null) 'photoUrl': photoUrl,
      };

  factory FarmerProfile.fromFirestore(Map<String, dynamic> d) =>
      FarmerProfile(
        id:             d['id']             ?? '',
        name:           d['name']           ?? '',
        email:          d['email']          ?? '',
        phone:          d['phone']          ?? '',
        farmName:       d['farmName']       ?? '',
        location:       d['location']       ?? '',
        bio:            d['bio']            ?? '',
        aadhaarNumber:  d['aadhaarNumber']  ?? '',
        passbookNumber: d['passbookNumber'] ?? '',
        category:       d['category']       ?? '',
        status:         FarmerStatus.values[
            (d['status'] as int?) ?? 0],
        registeredAt:   d['registeredAt'] != null
            ? (d['registeredAt'] as Timestamp).toDate()
            : DateTime.now(),
        photoUrl:       d['photoUrl'],
      );
}

// ─────────────────────────────────────────────────────────────
class FarmerProduct {
  final String   id;
  final String   farmerId;
  final String   farmName;
  final String   name;
  final double   price;
  final String   unit;
  final String   category;
  final int      stock;
  final bool     isOrganic;
  final bool     isAvailable;
  final String   imageUrl;
  final DateTime createdAt;

  const FarmerProduct({
    required this.id,
    required this.farmerId,
    required this.farmName,
    required this.name,
    required this.price,
    required this.unit,
    required this.category,
    required this.stock,
    this.isOrganic   = false,
    this.isAvailable = true,
    this.imageUrl    = '',
    required this.createdAt,
  });

  Map<String, dynamic> toFirestore() => {
        'id':          id,
        'farmerId':    farmerId,
        'farmName':    farmName,
        'name':        name,
        'price':       price,
        'unit':        unit,
        'category':    category,
        'stock':       stock,
        'isOrganic':   isOrganic,
        'isAvailable': isAvailable,
        'imageUrl':    imageUrl,
        'createdAt':   Timestamp.fromDate(createdAt),
      };

  factory FarmerProduct.fromFirestore(Map<String, dynamic> d) =>
      FarmerProduct(
        id:          d['id']          ?? '',
        farmerId:    d['farmerId']    ?? '',
        farmName:    d['farmName']    ?? '',
        name:        d['name']        ?? '',
        price:       (d['price'] as num?)?.toDouble() ?? 0,
        unit:        d['unit']        ?? '',
        category:    d['category']    ?? '',
        stock:       (d['stock'] as int?) ?? 0,
        isOrganic:   d['isOrganic']   ?? false,
        isAvailable: d['isAvailable'] ?? true,
        imageUrl:    d['imageUrl']    ?? '',
        createdAt:   d['createdAt'] != null
            ? (d['createdAt'] as Timestamp).toDate()
            : DateTime.now(),
      );
}