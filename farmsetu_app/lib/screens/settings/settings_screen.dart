import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/language_provider.dart';
import '../../providers/theme_provider.dart';
import '../../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final langP  = context.watch<LanguageProvider>();
    final l10n   = langP.l10n;
    final themeP = context.watch<ThemeProvider>();
    final isDark = themeP.isDark;

    // Adapt colours to current theme
    // ignore: unused_local_variable
    final bg       = isDark ? AppTheme.background  : AppTheme.lBackground;
    final cardBg   = isDark ? AppTheme.cardBg       : AppTheme.lCardBg;
    final divColor = isDark ? AppTheme.divider      : AppTheme.lDivider;
    final txtPri   = isDark ? AppTheme.textPrimary  : AppTheme.lTextPrimary;
    final txtMuted = isDark ? AppTheme.textMuted    : AppTheme.lTextMuted;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.surfaceHigh : AppTheme.lSurfaceHigh,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.arrow_back_ios_new_rounded,
                size: 16, color: txtPri),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 0.5, color: divColor),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
        children: [

          // ── LANGUAGE ─────────────────────────────────────────
          _SectionHeader(icon: Icons.language_rounded,
              title: l10n.settingsLanguage,
              txtMuted: txtMuted),
          Container(
            margin: const EdgeInsets.only(bottom: 28),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: divColor),
            ),
            child: Column(
              children: AppLanguage.values.asMap().entries.map((entry) {
                final index    = entry.key;
                final lang     = entry.value;
                final selected = langP.language == lang;
                final isLast   = index == AppLanguage.values.length - 1;

                return Column(
                  children: [
                    InkWell(
                      onTap: () => langP.setLanguage(lang),
                      borderRadius: BorderRadius.vertical(
                        top:    index == 0 ? const Radius.circular(16) : Radius.zero,
                        bottom: isLast    ? const Radius.circular(16) : Radius.zero,
                      ),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: selected
                              ? AppTheme.primaryGreen.withOpacity(0.08)
                              : Colors.transparent,
                          borderRadius: BorderRadius.vertical(
                            top:    index == 0 ? const Radius.circular(16) : Radius.zero,
                            bottom: isLast    ? const Radius.circular(16) : Radius.zero,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40, height: 40,
                              decoration: BoxDecoration(
                                color: selected
                                    ? AppTheme.primaryGreen.withOpacity(0.15)
                                    : (isDark ? AppTheme.surfaceHigh : AppTheme.lSurfaceHigh),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(lang.flagEmoji,
                                    style: const TextStyle(fontSize: 20)),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(lang.displayName,
                                      style: TextStyle(
                                        color: selected
                                            ? AppTheme.primaryGreen
                                            : txtPri,
                                        fontSize: 15,
                                        fontWeight: selected
                                            ? FontWeight.w700
                                            : FontWeight.w500,
                                      )),
                                  Text(lang.code.toUpperCase(),
                                      style: TextStyle(
                                          color: txtMuted, fontSize: 11)),
                                ],
                              ),
                            ),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: selected
                                  ? Container(
                                      key: const ValueKey('check'),
                                      width: 26, height: 26,
                                      decoration: const BoxDecoration(
                                        color: AppTheme.primaryGreen,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.check_rounded,
                                          size: 16, color: Colors.white),
                                    )
                                  : Container(
                                      key: const ValueKey('empty'),
                                      width: 26, height: 26,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: divColor, width: 2),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (!isLast)
                      Divider(height: 1, indent: 70,
                          color: divColor.withOpacity(0.6)),
                  ],
                );
              }).toList(),
            ),
          ),

          // ── APPEARANCE ───────────────────────────────────────
          _SectionHeader(icon: Icons.palette_outlined,
              title: l10n.settingsAppearance,
              txtMuted: txtMuted),
          _SettingsCard(cardBg: cardBg, divColor: divColor, children: [
            // Dark Mode — actually works now
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(
                children: [
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFF9B7FE8).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                      color: const Color(0xFF9B7FE8), size: 18,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(l10n.settingsDarkMode,
                        style: TextStyle(
                            color: txtPri,
                            fontSize: 15,
                            fontWeight: FontWeight.w500)),
                  ),
                  Switch(
                    value: isDark,
                    onChanged: (v) => themeP.toggle(v),
                    activeThumbColor: AppTheme.primaryGreen,
                  ),
                ],
              ),
            ),
            _CardDivider(color: divColor),
            // Notifications toggle (UI-only)
            _NotifToggle(isDark: isDark, l10n: l10n,
                txtPri: txtPri, divColor: divColor),
          ]),
          const SizedBox(height: 28),

          // ── ACCOUNT ──────────────────────────────────────────
          _SectionHeader(icon: Icons.person_outline_rounded,
              title: l10n.settingsAccount,
              txtMuted: txtMuted),
          _SettingsCard(cardBg: cardBg, divColor: divColor, children: [
            _NavTile(icon: Icons.shopping_bag_outlined,
                iconColor: AppTheme.primaryGreen,
                title: l10n.myOrders,
                txtPri: txtPri),
            _CardDivider(color: divColor),
            _NavTile(icon: Icons.location_on_outlined,
                iconColor: const Color(0xFF5CB8E4),
                title: l10n.deliveryAddress,
                txtPri: txtPri),
            _CardDivider(color: divColor),
            _NavTile(icon: Icons.favorite_border_rounded,
                iconColor: const Color(0xFFE45C7A),
                title: l10n.savedProducts,
                txtPri: txtPri),
          ]),
          const SizedBox(height: 28),

          // ── ABOUT ────────────────────────────────────────────
          _SectionHeader(icon: Icons.info_outline_rounded,
              title: l10n.settingsAbout,
              txtMuted: txtMuted),
          _SettingsCard(cardBg: cardBg, divColor: divColor, children: [
            _NavTile(icon: Icons.shield_outlined,
                iconColor: const Color(0xFF5CB8E4),
                title: l10n.settingsPrivacyPolicy,
                txtPri: txtPri),
            _CardDivider(color: divColor),
            _NavTile(icon: Icons.description_outlined,
                iconColor: const Color(0xFFE88F3F),
                title: l10n.settingsTerms,
                txtPri: txtPri),
            _CardDivider(color: divColor),
            _NavTile(icon: Icons.help_outline_rounded,
                iconColor: const Color(0xFF9B7FE8),
                title: l10n.helpSupport,
                txtPri: txtPri),
            _CardDivider(color: divColor),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.eco_rounded,
                        color: AppTheme.primaryGreen, size: 20),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(l10n.appName,
                        style: TextStyle(color: txtPri,
                            fontSize: 15, fontWeight: FontWeight.w500)),
                  ),
                  Text(l10n.settingsVersion,
                      style: TextStyle(color: txtMuted, fontSize: 13)),
                ],
              ),
            ),
          ]),
        ],
      ),
    );
  }
}

// ── Notifications toggle keeps its own state ──────────────────
class _NotifToggle extends StatefulWidget {
  final bool isDark;
  final dynamic l10n;
  final Color txtPri;
  final Color divColor;
  const _NotifToggle({
    required this.isDark,
    required this.l10n,
    required this.txtPri,
    required this.divColor,
  });
  @override
  State<_NotifToggle> createState() => _NotifToggleState();
}
class _NotifToggleState extends State<_NotifToggle> {
  bool _on = true;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    child: Row(
      children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFFE88F3F).withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.notifications_outlined,
              color: Color(0xFFE88F3F), size: 18),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(widget.l10n.settingsNotifications,
              style: TextStyle(
                  color: widget.txtPri,
                  fontSize: 15,
                  fontWeight: FontWeight.w500)),
        ),
        Switch(
          value: _on,
          onChanged: (v) => setState(() => _on = v),
          activeThumbColor: AppTheme.primaryGreen,
        ),
      ],
    ),
  );
}

// ── Sub-widgets ───────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String   title;
  final Color    txtMuted;
  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.txtMuted,
  });
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10, left: 2),
        child: Row(
          children: [
            Icon(icon, size: 15, color: txtMuted),
            const SizedBox(width: 6),
            Text(title.toUpperCase(),
                style: TextStyle(
                  color: txtMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                )),
          ],
        ),
      );
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  final Color cardBg;
  final Color divColor;
  const _SettingsCard({
    required this.children,
    required this.cardBg,
    required this.divColor,
  });
  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: divColor),
        ),
        child: Column(children: children),
      );
}

class _CardDivider extends StatelessWidget {
  final Color color;
  const _CardDivider({required this.color});
  @override
  Widget build(BuildContext context) =>
      Divider(height: 1, indent: 66, color: color.withOpacity(0.6));
}

class _NavTile extends StatelessWidget {
  final IconData icon;
  final Color    iconColor;
  final String   title;
  final Color    txtPri;
  const _NavTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.txtPri,
  });
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(title,
                    style: TextStyle(
                        color: txtPri,
                        fontSize: 15,
                        fontWeight: FontWeight.w500)),
              ),
              Icon(Icons.arrow_forward_ios_rounded,
                  size: 13,
                  color: context.watch<ThemeProvider>().isDark
                      ? AppTheme.textMuted
                      : AppTheme.lTextMuted),
            ],
          ),
        ),
      );
}