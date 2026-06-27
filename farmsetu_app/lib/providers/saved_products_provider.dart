import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

class SavedProductsProvider extends ChangeNotifier {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Set<String>    _saved   = {};
  String?        _uid;
  StreamSubscription<QuerySnapshot>? _sub;

  Set<String> get saved => _saved;
  bool isSaved(String id) => _saved.contains(id);

  /// Resolve the current user's UID — from loadForUser or FirebaseAuth.
  String? get _resolvedUid => _uid ?? _auth.currentUser?.uid;

  // ── Called on login ───────────────────────────────────
  Future<void> loadForUser(String uid) async {
    if (uid.isEmpty) return;
    if (_uid == uid) return;
    await _sub?.cancel();
    _uid   = uid;
    _saved = {};
    notifyListeners();

    _sub = _db
        .collection('users')
        .doc(uid)
        .collection('saved_products')
        .snapshots()
        .listen((snap) {
      _saved = snap.docs.map((d) => d.id).toSet();
      notifyListeners();
    }, onError: (e) {
      debugPrint('Saved products error: $e');
    });
  }

  // ── Called on logout ──────────────────────────────────
  Future<void> clear() async {
    await _sub?.cancel();
    _sub   = null;
    _uid   = null;
    _saved = {};
    notifyListeners();
  }

  // ── Toggle save/unsave ────────────────────────────────
  Future<void> toggle(String productId) async {
    final uid = _resolvedUid;
    if (uid == null || uid.isEmpty) return;

    // If loadForUser hasn't been called yet, start it now
    if (_uid == null) {
      _uid = uid;
      // kick off the listener in background (don't await)
      loadForUser(uid);
    }

    final wasSaved = _saved.contains(productId);

    // ── Optimistic update ──────────────────────────────
    if (wasSaved) {
      _saved.remove(productId);
    } else {
      _saved.add(productId);
    }
    notifyListeners();

    // ── Persist to Firestore ───────────────────────────
    final ref = _db
        .collection('users')
        .doc(uid)
        .collection('saved_products')
        .doc(productId);

    try {
      if (wasSaved) {
        await ref.delete();
      } else {
        await ref.set({
          'savedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      debugPrint('Saved products toggle error: $e');
      // ── Rollback on failure ────────────────────────────
      if (wasSaved) {
        _saved.add(productId);
      } else {
        _saved.remove(productId);
      }
      notifyListeners();
    }
  }

  // ── Keep old init() so main.dart doesn't break ────────
  Future<void> init() async {}

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}