import 'package:flutter/material.dart';
import 'package:heroui_design_system/design_system.dart';

import '../../data/component_registry.dart';
import '../../domain/catalog_component.dart';
import '../../domain/component_category.dart';
import '../widgets/catalog_category_leading.dart';
import 'category_detail_screen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = ComponentCategory.values;
    final menuItems = <HeroUiMenuItem>[
      for (final category in categories) _categoryMenuItem(context, category),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Component Categories')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [HeroUiMenuCard(showShadow: false, items: menuItems)],
      ),
    );
  }
}

HeroUiMenuItem _categoryMenuItem(
  BuildContext context,
  ComponentCategory category,
) {
  final components = componentsFor(category);
  final totalComponents = components.length;
  final implementedComponents = components
      .where(
        (component) =>
            component.status == ComponentImplementationStatus.implemented,
      )
      .length;
  final mutedColor = Theme.of(context).colorScheme.onSurfaceVariant;

  return HeroUiMenuItem(
    title: category.title,
    subtitle: '$implementedComponents / $totalComponents implemented',
    leading: CatalogCategoryLeadingIcon(category: category),
    trailing: HeroUiIcon(
      HeroUiIconManifest.chevronRight,
      size: 20,
      color: mutedColor,
    ),
    onTap: () {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => CategoryDetailScreen(category: category),
        ),
      );
    },
  );
}
