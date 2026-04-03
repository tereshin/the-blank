import 'package:flutter/material.dart';

import '../features/component_catalog/presentation/screens/categories_screen.dart';

class TheBlankApp extends StatelessWidget {
  const TheBlankApp({super.key});

  @override
  Widget build(BuildContext context) {
    final lightTextTheme = _withoutLetterSpacing(
      ThemeData.light().textTheme.apply(fontFamily: 'Inter'),
    );
    final darkTextTheme = _withoutLetterSpacing(
      ThemeData(
        brightness: Brightness.dark,
      ).textTheme.apply(fontFamily: 'Inter'),
    );
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

TextTheme _withoutLetterSpacing(TextTheme textTheme) {
  TextStyle? clearSpacing(TextStyle? style) {
    return style?.copyWith(letterSpacing: 0);
  }

  return textTheme.copyWith(
    displayLarge: clearSpacing(textTheme.displayLarge),
    displayMedium: clearSpacing(textTheme.displayMedium),
    displaySmall: clearSpacing(textTheme.displaySmall),
    headlineLarge: clearSpacing(textTheme.headlineLarge),
    headlineMedium: clearSpacing(textTheme.headlineMedium),
    headlineSmall: clearSpacing(textTheme.headlineSmall),
    titleLarge: clearSpacing(textTheme.titleLarge),
    titleMedium: clearSpacing(textTheme.titleMedium),
    titleSmall: clearSpacing(textTheme.titleSmall),
    bodyLarge: clearSpacing(textTheme.bodyLarge),
    bodyMedium: clearSpacing(textTheme.bodyMedium),
    bodySmall: clearSpacing(textTheme.bodySmall),
    labelLarge: clearSpacing(textTheme.labelLarge),
    labelMedium: clearSpacing(textTheme.labelMedium),
    labelSmall: clearSpacing(textTheme.labelSmall),
  );
}
