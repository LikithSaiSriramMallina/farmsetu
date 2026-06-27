import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/app_notification.dart';
import '../../providers/language_provider.dart';
import '../../providers/notifications_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifP = context.watch<NotificationsProvider>();
    final l10n   = context.watch<LanguageProvider>().l10n;
    final c      = context.col;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notifications),
        leading: _BackBtn(),
        actions: [
          if (notifP.unreadCount > 0)
            TextButton(
              onPressed: notifP.markAllRead,
              child: const Text('Mark all read',
                  style: TextStyle(
                      color: AppTheme.primaryGreen,
                      fontWeight: FontWeight.w600)),
            ),
        ],
      ),
      body: notifP.items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_none_rounded,
                      size: 64, color: c.textMuted),
                  const SizedBox(height: 16),
                  Text('No notifications',
                      style: TextStyle(
                          color: c.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: notifP.items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) =>
                  _NotifCard(notif: notifP.items[i]),
            ),
    );
  }
}

class _NotifCard extends StatelessWidget {
  final AppNotification notif;
  const _NotifCard({required this.notif});

  Color _typeColor() => switch (notif.type) {
    'order'   => AppTheme.primaryGreen,
    'promo'   => const Color(0xFFE88F3F),
    _         => const Color(0xFF5CB8E4),
  };

  IconData _typeIcon() => switch (notif.type) {
    'order'   => Icons.shopping_bag_outlined,
    'promo'   => Icons.local_offer_outlined,
    _         => Icons.eco_outlined,
  };

  String _timeAgo() {
    final diff = DateTime.now().difference(notif.time);
    if (diff.inMinutes < 60)  return '${diff.inMinutes}m ago';
    if (diff.inHours   < 24)  return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final c  = context.col;
    final tc = _typeColor();

    return GestureDetector(
      onTap: () => context
          .read<NotificationsProvider>()
          .markRead(notif.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: notif.isRead ? c.cardBg : tc.withOpacity(0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: notif.isRead ? c.divider : tc.withOpacity(0.3),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: tc.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(_typeIcon(), color: tc, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(notif.title,
                            style: TextStyle(
                              color: c.textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            )),
                      ),
                      const SizedBox(width: 8),
                      Text(_timeAgo(),
                          style: TextStyle(
                              color: c.textMuted, fontSize: 11)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(notif.body,
                      style: TextStyle(
                          color: c.textSecondary,
                          fontSize: 13,
                          height: 1.4)),
                ],
              ),
            ),
            if (!notif.isRead) ...[
              const SizedBox(width: 8),
              Container(
                width: 8, height: 8,
                decoration: BoxDecoration(
                  color: tc,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _BackBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = context.col;
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: c.surfaceHigh,
            borderRadius: BorderRadius.circular(10)),
        child: Icon(Icons.arrow_back_ios_new_rounded,
            size: 16, color: c.textPrimary),
      ),
    );
  }
}