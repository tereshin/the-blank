import 'package:flutter/material.dart';

/// Shared HeroUI typography tokens based on the design specification.
class HeroUiTypography {
  const HeroUiTypography._();

  static const String fontFamily = 'Inter';
  static const String packageName = 'heroui_design_system';

  static const TextStyle heading1 = TextStyle(
    fontFamily: fontFamily,
    package: packageName,
    fontSize: 46.8,
    fontWeight: FontWeight.w800,
    height: 1.12,
    letterSpacing: 0,
  );

  static const TextStyle heading2 = TextStyle(
    fontFamily: fontFamily,
    package: packageName,
    fontSize: 31.2,
    fontWeight: FontWeight.w700,
    height: 1.34,
    letterSpacing: 0,
  );

  static const TextStyle heading3 = TextStyle(
    fontFamily: fontFamily,
    package: packageName,
    fontSize: 26,
    fontWeight: FontWeight.w600,
    height: 1.6,
    letterSpacing: 0,
  );

  static const TextStyle heading4 = TextStyle(
    fontFamily: fontFamily,
    package: packageName,
    fontSize: 20.8,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: 0,
  );

  static const TextStyle bodyBase = TextStyle(
    fontFamily: fontFamily,
    package: packageName,
    fontSize: 20.8,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0,
  );

  static const TextStyle bodyBaseMedium = TextStyle(
    fontFamily: fontFamily,
    package: packageName,
    fontSize: 20.8,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: 0,
  );

  static const TextStyle bodySm = TextStyle(
    fontFamily: fontFamily,
    package: packageName,
    fontSize: 18.2,
    fontWeight: FontWeight.w400,
    height: 1.43,
    letterSpacing: 0,
  );

  static const TextStyle bodySmMedium = TextStyle(
    fontFamily: fontFamily,
    package: packageName,
    fontSize: 18.2,
    fontWeight: FontWeight.w500,
    height: 1.43,
    letterSpacing: 0,
  );

  static const TextStyle bodyXxs = TextStyle(
    fontFamily: fontFamily,
    package: packageName,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.34,
    letterSpacing: 0,
  );

  static const TextStyle bodyXxsMedium = TextStyle(
    fontFamily: fontFamily,
    package: packageName,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.34,
    letterSpacing: 0,
  );

  static const TextStyle bodyXs = TextStyle(
    fontFamily: fontFamily,
    package: packageName,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.34,
    letterSpacing: 0,
  );

  static const TextStyle bodyXsMedium = TextStyle(
    fontFamily: fontFamily,
    package: packageName,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.34,
    letterSpacing: 0,
  );

  static const TextStyle linkBase = TextStyle(
    fontFamily: fontFamily,
    package: packageName,
    fontSize: 20.8,
    fontWeight: FontWeight.w500,
    height: 1.25,
    letterSpacing: 0,
    decoration: TextDecoration.underline,
  );

  static const TextStyle linkSm = TextStyle(
    fontFamily: fontFamily,
    package: packageName,
    fontSize: 18.2,
    fontWeight: FontWeight.w500,
    height: 18 / 14,
    letterSpacing: 0,
    decoration: TextDecoration.underline,
  );

  static const TextStyle textFieldBase = TextStyle(
    fontFamily: fontFamily,
    package: packageName,
    fontSize: 20.8,
    fontWeight: FontWeight.w400,
    height: 1.25,
    letterSpacing: 0,
  );

  static const TextStyle textOTPFieldBase = TextStyle(
    fontFamily: fontFamily,
    package: packageName,
    fontSize: 20.8,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: 0,
  );

  static const TextStyle textFieldSm = TextStyle(
    fontFamily: fontFamily,
    package: packageName,
    fontSize: 18.2,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
    letterSpacing: 0,
  );

  static const TextStyle buttonBase = TextStyle(
    fontFamily: fontFamily,
    package: packageName,
    fontSize: 20.8,
    fontWeight: FontWeight.w500,
    height: 22 / 16,
    letterSpacing: 0,
  );

  static const TextStyle buttonSm = TextStyle(
    fontFamily: fontFamily,
    package: packageName,
    fontSize: 18.2,
    fontWeight: FontWeight.w500,
    height: 20 / 14,
    letterSpacing: 0,
  );

  static const TextTheme materialTextTheme = TextTheme(
    displayLarge: heading1,
    displayMedium: heading2,
    displaySmall: heading3,
    headlineLarge: heading2,
    headlineMedium: heading3,
    headlineSmall: heading4,
    titleLarge: heading4,
    titleMedium: bodyBaseMedium,
    titleSmall: bodySmMedium,
    bodyLarge: bodyBase,
    bodyMedium: bodySm,
    bodySmall: bodyXs,
    labelLarge: buttonBase,
    labelMedium: buttonSm,
    labelSmall: bodyXsMedium,
  );
}
