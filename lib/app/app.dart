import 'package:flutter/material.dart';

import '../design_system/typography/heroui_typography.dart';
import '../features/component_catalog/presentation/screens/categories_screen.dart';

class TheBlankApp extends StatelessWidget {
  const TheBlankApp({super.key});

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
