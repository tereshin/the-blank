import 'package:flutter/material.dart';

import 'package:heroui_design_system/design_system.dart';
import '../features/component_catalog/presentation/screens/categories_screen.dart';

class TheBlankApp extends StatelessWidget {
  const TheBlankApp({super.key});

  static final ButtonStyle _noRippleButtonStyle = ButtonStyle(
    splashFactory: NoSplash.splashFactory,
    overlayColor: WidgetStateProperty.all(Colors.transparent),
  );

  @override
  Widget build(BuildContext context) {
    const lightBackground = Color(0xFFF5F5F5);
    const darkBackground = Color(0xFF060607);
    final lightScheme = ColorScheme.fromSeed(
      seedColor: Colors.indigo,
      brightness: Brightness.light,
    );
    final darkScheme = ColorScheme.fromSeed(
      seedColor: Colors.indigo,
      brightness: Brightness.dark,
    );
    final lightTextTheme = HeroUiTypography.materialTextTheme.apply(
      bodyColor: lightScheme.onSurface,
      displayColor: lightScheme.onSurface,
    );
    final darkTextTheme = HeroUiTypography.materialTextTheme.apply(
      bodyColor: darkScheme.onSurface,
      displayColor: darkScheme.onSurface,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The Blank',
      themeMode: ThemeMode.system,
      theme: ThemeData(
        colorScheme: lightScheme.copyWith(surface: lightBackground),
        fontFamily: 'Inter',
        textTheme: lightTextTheme,
        primaryTextTheme: lightTextTheme,
        splashFactory: NoSplash.splashFactory,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        elevatedButtonTheme: ElevatedButtonThemeData(style: _noRippleButtonStyle),
        outlinedButtonTheme: OutlinedButtonThemeData(style: _noRippleButtonStyle),
        textButtonTheme: TextButtonThemeData(style: _noRippleButtonStyle),
        iconButtonTheme: IconButtonThemeData(style: _noRippleButtonStyle),
        filledButtonTheme: FilledButtonThemeData(style: _noRippleButtonStyle),
        scaffoldBackgroundColor: lightBackground,
        canvasColor: lightBackground,
        appBarTheme: const AppBarTheme(
          backgroundColor: lightBackground,
          surfaceTintColor: Colors.transparent,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: darkScheme.copyWith(surface: darkBackground),
        fontFamily: 'Inter',
        textTheme: darkTextTheme,
        primaryTextTheme: darkTextTheme,
        splashFactory: NoSplash.splashFactory,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        elevatedButtonTheme: ElevatedButtonThemeData(style: _noRippleButtonStyle),
        outlinedButtonTheme: OutlinedButtonThemeData(style: _noRippleButtonStyle),
        textButtonTheme: TextButtonThemeData(style: _noRippleButtonStyle),
        iconButtonTheme: IconButtonThemeData(style: _noRippleButtonStyle),
        filledButtonTheme: FilledButtonThemeData(style: _noRippleButtonStyle),
        scaffoldBackgroundColor: darkBackground,
        canvasColor: darkBackground,
        appBarTheme: const AppBarTheme(
          backgroundColor: darkBackground,
          surfaceTintColor: Colors.transparent,
        ),
      ),
      home: const CategoriesScreen(),
    );
  }
}
