import 'package:flutter/material.dart';
import 'app_theme.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color background;
  final Color surface;
  final Color cardBg;
  final Color surfaceHigh;
  final Color divider;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;

  const AppColors({
    required this.background,
    required this.surface,
    required this.cardBg,
    required this.surfaceHigh,
    required this.divider,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
  });

  static const dark = AppColors(
    background:    AppTheme.background,
    surface:       AppTheme.surface,
    cardBg:        AppTheme.cardBg,
    surfaceHigh:   AppTheme.surfaceHigh,
    divider:       AppTheme.divider,
    textPrimary:   AppTheme.textPrimary,
    textSecondary: AppTheme.textSecondary,
    textMuted:     AppTheme.textMuted,
  );

  static const light = AppColors(
    background:    AppTheme.lBackground,
    surface:       AppTheme.lSurface,
    cardBg:        AppTheme.lCardBg,
    surfaceHigh:   AppTheme.lSurfaceHigh,
    divider:       AppTheme.lDivider,
    textPrimary:   AppTheme.lTextPrimary,
    textSecondary: AppTheme.lTextSecondary,
    textMuted:     AppTheme.lTextMuted,
  );

  @override
  AppColors copyWith({
    Color? background, Color? surface, Color? cardBg,
    Color? surfaceHigh, Color? divider,
    Color? textPrimary, Color? textSecondary, Color? textMuted,
  }) => AppColors(
    background:    background    ?? this.background,
    surface:       surface       ?? this.surface,
    cardBg:        cardBg        ?? this.cardBg,
    surfaceHigh:   surfaceHigh   ?? this.surfaceHigh,
    divider:       divider       ?? this.divider,
    textPrimary:   textPrimary   ?? this.textPrimary,
    textSecondary: textSecondary ?? this.textSecondary,
    textMuted:     textMuted     ?? this.textMuted,
  );

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;
    return AppColors(
      background:    Color.lerp(background,    other.background,    t)!,
      surface:       Color.lerp(surface,       other.surface,       t)!,
      cardBg:        Color.lerp(cardBg,        other.cardBg,        t)!,
      surfaceHigh:   Color.lerp(surfaceHigh,   other.surfaceHigh,   t)!,
      divider:       Color.lerp(divider,       other.divider,       t)!,
      textPrimary:   Color.lerp(textPrimary,   other.textPrimary,   t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted:     Color.lerp(textMuted,     other.textMuted,     t)!,
    );
  }
}

// One-liner access anywhere: context.col.textPrimary
extension AppColorsX on BuildContext {
  AppColors get col =>
      Theme.of(this).extension<AppColors>() ?? AppColors.dark;
}