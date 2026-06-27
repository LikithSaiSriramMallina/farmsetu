import 'dart:convert';

class Address {
  final String id;
  final String label;
  final String fullName;
  final String phone;
  final String line1;
  final String city;
  final String state;
  final String pincode;

  const Address({
    required this.id,
    required this.label,
    required this.fullName,
    required this.phone,
    required this.line1,
    required this.city,
    required this.state,
    required this.pincode,
  });

  Map<String, dynamic> toJson() => {
    'id': id, 'label': label, 'fullName': fullName,
    'phone': phone, 'line1': line1, 'city': city,
    'state': state, 'pincode': pincode,
  };

  factory Address.fromJson(Map<String, dynamic> j) => Address(
    id: j['id'], label: j['label'], fullName: j['fullName'],
    phone: j['phone'], line1: j['line1'], city: j['city'],
    state: j['state'], pincode: j['pincode'],
  );

  static String encode(List<Address> list) =>
      jsonEncode(list.map((a) => a.toJson()).toList());

  static List<Address> decode(String s) =>
      (jsonDecode(s) as List)
          .map((j) => Address.fromJson(j as Map<String, dynamic>))
          .toList();
}