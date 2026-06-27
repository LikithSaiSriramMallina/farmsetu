import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/foundation.dart';

class AuthProvider extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;

  bool   _isLoggedIn = false;
  bool   _loading    = true;
  String _userName   = '';
  String _userEmail  = '';
  String _uid        = '';

  bool   get isLoggedIn => _isLoggedIn;
  bool   get isLoading  => _loading;
  String get userName   => _userName;
  String get userEmail  => _userEmail;
  String get uid        => _uid;

  /// Call once from main() before runApp, like FarmerAuthProvider does.
  Future<void> init() async {
    final user = _auth.currentUser;
    if (user != null && user.email != null) {
      _isLoggedIn = true;
      _uid        = user.uid;
      _userEmail  = user.email!;
      _userName   = _formatName(user.email!.split('@').first);
    }
    _loading = false;
    notifyListeners();
  }

  void login(String email, String password, {required String uid}) {
    _isLoggedIn = true;
    _userEmail  = email;
    _uid        = uid;
    _userName   = _formatName(email.split('@').first);
    notifyListeners();
  }

  void register(String name, String email, {required String uid}) {
    _isLoggedIn = true;
    _userName   = name;
    _userEmail  = email;
    _uid        = uid;
    notifyListeners();
  }

  Future<void> logout() async {
    await _auth.signOut();
    _isLoggedIn = false;
    _userName   = '';
    _userEmail  = '';
    _uid        = '';
    notifyListeners();
  }

  String _formatName(String raw) =>
      raw.replaceAll(RegExp(r'[._\-]'), ' ')
         .split(' ')
         .map((w) => w.isEmpty ? '' : w[0].toUpperCase() + w.substring(1))
         .join(' ');
}