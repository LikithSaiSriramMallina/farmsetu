import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/vendor.dart';
import '../theme/app_theme.dart';

class VendorCard extends StatelessWidget {
  final Vendor vendor;
  const VendorCard({super.key, required this.vendor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.divider),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Banner image
          CachedNetworkImage(
            imageUrl: vendor.bannerUrl,
            fit: BoxFit.cover,
            placeholder: (_, __) =>
                Container(color: AppTheme.surfaceHigh),
            errorWidget: (_, __, ___) =>
                Container(color: AppTheme.surfaceHigh),
          ),

          // Dark gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.88),
                ],
                stops: const [0.4, 1.0],
              ),
            ),
          ),

          // Text content
          Positioned(
            bottom: 12,
            left: 12,
            right: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        vendor.farmName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (vendor.isVerified)
                      const Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: Icon(Icons.verified_rounded,
                            color: AppTheme.primaryGreen, size: 14),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        color: AppTheme.starYellow, size: 12),
                    const SizedBox(width: 3),
                    Text(
                      '${vendor.rating} · ${vendor.location.split(',').first}',
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
