import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/farmer_auth_provider.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_colors.dart';

class FarmerProfileScreen extends StatefulWidget {
  const FarmerProfileScreen({super.key});

  @override
  State<FarmerProfileScreen> createState() =>
      _FarmerProfileScreenState();
}

class _FarmerProfileScreenState extends State<FarmerProfileScreen> {
  bool _uploading = false;

  Future<void> _pickPhoto() async {
    setState(() => _uploading = true);
    final url = await context
        .read<FarmerAuthProvider>()
        .uploadProfilePhoto();
    setState(() => _uploading = false);
    if (url != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Profile photo updated! ✅'),
          backgroundColor: AppTheme.primaryGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  Future<void> _deletePhoto() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Photo'),
        content: const Text('Remove your profile photo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete',
                style: TextStyle(color: AppTheme.error)),
          ),
        ],
      ),
    );
    if (confirm == true && mounted) {
      setState(() => _uploading = true);
      final uid = context.read<FarmerAuthProvider>().farmer!.id;
      await FirebaseFirestore.instance
          .collection('farmers')
          .doc(uid)
          .update({'photoUrl': FieldValue.delete()});
      setState(() => _uploading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Profile photo removed'),
            backgroundColor: AppTheme.primaryGreen,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  }

  Future<void> _signOut() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sign Out',
                style: TextStyle(color: AppTheme.error)),
          ),
        ],
      ),
    );
    if (confirm == true && mounted) {
      await context.read<FarmerAuthProvider>().logout();
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/', (_) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final farmerAuth = context.watch<FarmerAuthProvider>();
    final farmer     = farmerAuth.farmer;
    if (farmer == null) return const SizedBox.shrink();
    final c = context.col;

    final hasPhoto = farmer.photoUrl != null &&
        farmer.photoUrl!.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: c.surface,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          // ── Profile Photo ──────────────────────────────
          Center(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 110, height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: AppTheme.primaryGreen, width: 3),
                  ),
                  child: ClipOval(
                    child: _uploading
                        ? Container(
                            color: c.cardBg,
                            child: const Center(
                              child: CircularProgressIndicator(
                                  color: AppTheme.primaryGreen),
                            ),
                          )
                        : hasPhoto
                            ? CachedNetworkImage(
                                imageUrl: farmer.photoUrl!,
                                fit: BoxFit.cover,
                                placeholder: (_, __) =>
                                    Container(color: c.cardBg),
                                errorWidget: (_, __, ___) =>
                                    _DefaultAvatar(farmer.name),
                              )
                            : _DefaultAvatar(farmer.name),
                  ),
                ),

                // ── Camera (upload) button ─────────────
                Positioned(
                  bottom: 0, right: 0,
                  child: GestureDetector(
                    onTap: _uploading ? null : _pickPhoto,
                    child: Container(
                      width: 34, height: 34,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGreen,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: c.surface, width: 2),
                      ),
                      child: const Icon(
                          Icons.camera_alt_rounded,
                          color: Colors.white,
                          size: 16),
                    ),
                  ),
                ),

                // ── Delete button (only if photo exists) ─
                if (hasPhoto)
                  Positioned(
                    bottom: 0, left: 0,
                    child: GestureDetector(
                      onTap: _uploading ? null : _deletePhoto,
                      child: Container(
                        width: 34, height: 34,
                        decoration: BoxDecoration(
                          color: AppTheme.error,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: c.surface, width: 2),
                        ),
                        child: const Icon(
                            Icons.delete_rounded,
                            color: Colors.white,
                            size: 16),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Center(
            child: Text(farmer.name,
                style: TextStyle(
                  color: c.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                )),
          ),
          const SizedBox(height: 4),
          Center(
            child: Text(farmer.email,
                style: TextStyle(
                    color: c.textSecondary, fontSize: 14)),
          ),
          const SizedBox(height: 28),

          // ── Info Card ──────────────────────────────────
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: c.cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: c.divider),
            ),
            child: Column(children: [
              _InfoRow(Icons.store_rounded,
                  'Farm Name', farmer.farmName, c),
              _Divider(c),
              _InfoRow(Icons.location_on_outlined,
                  'Location', farmer.location, c),
              _Divider(c),
              _InfoRow(Icons.category_outlined,
                  'Category', farmer.category, c),
              _Divider(c),
              _InfoRow(Icons.phone_outlined,
                  'Phone', farmer.phone, c),
              if (farmer.bio.isNotEmpty) ...[
                _Divider(c),
                _InfoRow(Icons.info_outline_rounded,
                    'Bio', farmer.bio, c),
              ],
            ]),
          ),
          const SizedBox(height: 20),

          // ── Documents Card ─────────────────────────────
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: c.cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: c.divider),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Documents',
                    style: TextStyle(
                      color: c.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    )),
                const SizedBox(height: 12),
                _InfoRow(
                  Icons.credit_card_rounded,
                  'Aadhaar',
                  '****-****-${farmer.aadhaarNumber.length >= 4 ? farmer.aadhaarNumber.substring(farmer.aadhaarNumber.length - 4) : farmer.aadhaarNumber}',
                  c,
                ),
                _Divider(c),
                _InfoRow(Icons.book_outlined,
                    'Passbook', farmer.passbookNumber, c),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // ── Sign Out Button ────────────────────────────
          OutlinedButton.icon(
            onPressed: _signOut,
            icon: const Icon(Icons.logout_rounded,
                size: 18, color: AppTheme.error),
            label: const Text('Sign Out',
                style: TextStyle(color: AppTheme.error)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppTheme.error),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _DefaultAvatar extends StatelessWidget {
  final String name;
  const _DefaultAvatar(this.name);

  @override
  Widget build(BuildContext context) => Container(
        color: AppTheme.primaryGreen.withOpacity(0.15),
        child: Center(
          child: Text(
            name.isNotEmpty ? name[0].toUpperCase() : '?',
            style: const TextStyle(
              color: AppTheme.primaryGreen,
              fontSize: 44,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      );
}

class _InfoRow extends StatelessWidget {
  final IconData  icon;
  final String    label;
  final String    value;
  final AppColors c;
  const _InfoRow(this.icon, this.label, this.value, this.c);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(children: [
          Icon(icon, color: AppTheme.primaryGreen, size: 18),
          const SizedBox(width: 12),
          Text('$label: ',
              style: TextStyle(
                  color: c.textMuted,
                  fontSize: 13,
                  fontWeight: FontWeight.w500)),
          Expanded(
            child: Text(value,
                style: TextStyle(
                  color: c.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                )),
          ),
        ]),
      );
}

class _Divider extends StatelessWidget {
  final AppColors c;
  const _Divider(this.c);

  @override
  Widget build(BuildContext context) =>
      Divider(height: 1, color: c.divider);
}