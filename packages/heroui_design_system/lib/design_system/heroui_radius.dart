import 'package:flutter/material.dart';

/// Border radius scale from HeroUI Figma Kit V3 (Radius / Tailwind base).
///
/// Source:
/// https://www.figma.com/design/K6gHtZsGORDD14SG2UGg5J/HeroUI-Figma-Kit-V3--Community-?node-id=17421-36561
abstract final class HeroUiRadius {
  HeroUiRadius._();

  static const double none = 0;
  static const double xs = 2;
  static const double sm = 4;
  static const double md = 6;
  static const double lg = 8;
  static const double xl = 12;

  /// Figma label: 2xl
  static const double twoXl = 16;

  /// Figma label: 2_5xl (Tailwind 2.5xl)
  static const double twoFiveXl = 20;

  /// Figma label: 3xl
  static const double threeXl = 24;

  /// Figma label: 4xl
  static const double fourXl = 32;

  /// Pill / fully rounded (Figma: 9999px).
  static const double full = 9999;

  static BorderRadius borderCircular(double radius) =>
      BorderRadius.circular(radius);

  static BorderRadius borderCircularScale(HeroUiRadiusScale scale) =>
      BorderRadius.circular(scale.value);
}

/// Named steps of the global radius scale (maps to [HeroUiRadius] values).
enum HeroUiRadiusScale {
  none,
  xs,
  sm,
  md,
  lg,
  xl,
  twoXl,
  twoFiveXl,
  threeXl,
  fourXl,
  full,
}

extension HeroUiRadiusScaleX on HeroUiRadiusScale {
  double get value => switch (this) {
    HeroUiRadiusScale.none => HeroUiRadius.none,
    HeroUiRadiusScale.xs => HeroUiRadius.xs,
    HeroUiRadiusScale.sm => HeroUiRadius.sm,
    HeroUiRadiusScale.md => HeroUiRadius.md,
    HeroUiRadiusScale.lg => HeroUiRadius.lg,
    HeroUiRadiusScale.xl => HeroUiRadius.xl,
    HeroUiRadiusScale.twoXl => HeroUiRadius.twoXl,
    HeroUiRadiusScale.twoFiveXl => HeroUiRadius.twoFiveXl,
    HeroUiRadiusScale.threeXl => HeroUiRadius.threeXl,
    HeroUiRadiusScale.fourXl => HeroUiRadius.fourXl,
    HeroUiRadiusScale.full => HeroUiRadius.full,
  };

  BorderRadius get borderRadius => BorderRadius.circular(value);
}
