import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/address.dart';

class AddressProvider extends ChangeNotifier {
  static const _key         = 'farmsetu_addresses';
  static const _selectedKey = 'farmsetu_selected_addr';
  static const maxAddresses = 5;

  List<Address> _addresses = [];
  String?       _selectedId;

  List<Address> get addresses  => _addresses;
  String?       get selectedId => _selectedId;
  bool          get canAdd     => _addresses.length < maxAddresses;

  Address? get selected {
    if (_addresses.isEmpty) return null;
    if (_selectedId == null) return _addresses.first;
    try {
      return _addresses.firstWhere((a) => a.id == _selectedId);
    } catch (_) {
      return _addresses.first;
    }
  }

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final raw   = prefs.getString(_key);
    if (raw != null) _addresses = Address.decode(raw);
    _selectedId = prefs.getString(_selectedKey) ??
        (_addresses.isEmpty ? null : _addresses.first.id);
    notifyListeners();
  }

  Future<void> addAddress(Address address) async {
    if (!canAdd) return;
    _addresses.add(address);
    _selectedId ??= address.id;
    notifyListeners();
    await _persist();
  }

  Future<void> removeAddress(String id) async {
    _addresses.removeWhere((a) => a.id == id);
    if (_selectedId == id) {
      _selectedId = _addresses.isEmpty ? null : _addresses.first.id;
    }
    notifyListeners();
    await _persist();
  }

  Future<void> selectAddress(String id) async {
    _selectedId = id;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedKey, id);
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, Address.encode(_addresses));
    if (_selectedId != null) {
      await prefs.setString(_selectedKey, _selectedId!);
    }
  }
}