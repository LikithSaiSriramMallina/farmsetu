import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import '../models/farmer.dart';
// ignore: unused_import
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

class FarmerAuthProvider extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  FarmerProfile? _farmer;
  bool _loading = true;
  String? _error;
  StreamSubscription<DocumentSnapshot>? _farmerSub;

  FarmerProfile? get farmer => _farmer;
  bool get isLoading => _loading;
  bool get isLoggedIn => _farmer != null;
  bool get isApproved => _farmer?.status == FarmerStatus.approved;
  String? get error => _error;

  // ── Called once from main() before runApp ──────────────────
  Future<void> init() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final snap = await _db.collection('farmers').doc(user.uid).get();
        if (snap.exists && snap.data() != null) {
          _farmer = FarmerProfile.fromFirestore(snap.data()!);
          listenToFarmer(user.uid);
        } else {
          await _auth.signOut();
        }
      }
    } catch (e) {
      debugPrint('FarmerAuthProvider init error: $e');
    }
    _loading = false;
    notifyListeners();
  }

  // ── Real-time listener — auto-updates pending screen ───────
  void listenToFarmer(String farmerId) {
    _farmerSub?.cancel();
    _farmerSub = _db.collection('farmers').doc(farmerId).snapshots().listen(
      (snap) {
        if (snap.exists && snap.data() != null) {
          _farmer = FarmerProfile.fromFirestore(snap.data()!);
          notifyListeners();
        }
      },
      onError: (e) => debugPrint('Farmer listen error: $e'),
    );
  }

  // ── Register ───────────────────────────────────────────────
  Future<String?> register({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String farmName,
    required String location,
    required String bio,
    required String aadhaarNumber,
    required String passbookNumber,
    required String category,
  }) async {
    try {
      _loading = true;
      _error = null;
      notifyListeners();

      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final profile = FarmerProfile(
        id: cred.user!.uid,
        name: name,
        email: email,
        phone: phone,
        farmName: farmName,
        location: location,
        bio: bio,
        aadhaarNumber: aadhaarNumber,
        passbookNumber: passbookNumber,
        category: category,
        status: FarmerStatus.submitted,
        registeredAt: DateTime.now(),
      );

      await _db
          .collection('farmers')
          .doc(cred.user!.uid)
          .set(profile.toFirestore());

      _farmer = profile;
      listenToFarmer(cred.user!.uid);

      _loading = false;
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      _loading = false;
      _error = e.message;
      notifyListeners();
      return e.message;
    } catch (e) {
      _loading = false;
      _error = e.toString();
      notifyListeners();
      return e.toString();
    }
  }

  // ── Login ──────────────────────────────────────────────────
  Future<String?> login(String email, String password) async {
    try {
      _loading = true;
      _error = null;
      notifyListeners();

      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final snap = await _db.collection('farmers').doc(cred.user!.uid).get();

      if (!snap.exists) {
        await _auth.signOut();
        _loading = false;
        notifyListeners();
        return 'No farmer account found. Please register.';
      }

      _farmer = FarmerProfile.fromFirestore(snap.data()!);
      listenToFarmer(cred.user!.uid);

      _loading = false;
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      _loading = false;
      _error = e.message;
      notifyListeners();
      return e.message;
    } catch (e) {
      _loading = false;
      _error = e.toString();
      notifyListeners();
      return e.toString();
    }
  }

  // ── Logout ─────────────────────────────────────────────────
  Future<void> logout() async {
    await _farmerSub?.cancel();   // ← stop listener FIRST to prevent resurrection
    _farmerSub = null;
    _farmer    = null;
    _loading   = false;
    notifyListeners();            // ← then notify so router redirects to login
    await _auth.signOut();
  }

  // ── Upload profile photo via Cloudinary ──────────────────────
  Future<String?> uploadProfilePhoto() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source:       ImageSource.gallery,
        maxWidth:     512,
        maxHeight:    512,
        imageQuality: 80,
      );
      if (picked == null) return null;

      final uid = _auth.currentUser!.uid;

      // Upload to Cloudinary
      final uri = Uri.parse(
          'https://api.cloudinary.com/v1_1/syrjfiud/image/upload');
      final request = http.MultipartRequest('POST', uri)
        ..fields['upload_preset'] = 'djkftr3ft'
        ..fields['public_id']     = 'farmers/$uid/profile'
        ..files.add(await http.MultipartFile.fromPath(
            'file', picked.path));

      final response = await request.send();
      final body     = await response.stream.bytesToString();
      final json     = jsonDecode(body);
      final url      = json['secure_url'] as String;

      // Save to Firestore
      await _db.collection('farmers').doc(uid)
          .update({'photoUrl': url});

      _farmer = FarmerProfile(
        id:             _farmer!.id,
        name:           _farmer!.name,
        email:          _farmer!.email,
        phone:          _farmer!.phone,
        farmName:       _farmer!.farmName,
        location:       _farmer!.location,
        bio:            _farmer!.bio,
        aadhaarNumber:  _farmer!.aadhaarNumber,
        passbookNumber: _farmer!.passbookNumber,
        category:       _farmer!.category,
        status:         _farmer!.status,
        registeredAt:   _farmer!.registeredAt,
        photoUrl:       url,
      );
      notifyListeners();
      return url;
    } catch (e) {
      debugPrint('uploadProfilePhoto error: $e');
      return null;
    }
  }
}
