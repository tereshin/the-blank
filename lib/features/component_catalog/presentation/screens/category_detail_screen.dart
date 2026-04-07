import 'package:flutter/material.dart';
import 'package:heroui_design_system/design_system.dart';

import '../../data/component_registry.dart';
import '../../domain/catalog_component.dart';
import '../../domain/component_category.dart';
import '../widgets/catalog_category_leading.dart';
import 'component_demo_screen.dart';

class CategoryDetailScreen extends StatelessWidget {
  const CategoryDetailScreen({required this.category, super.key});

  final ComponentCategory category;

  @override
  Widget build(BuildContext context) {
    final components = componentsFor(category);
    final implementedCount = components
        .where(
          (component) =>
              component.status == ComponentImplementationStatus.implemented,
        )
        .length;

    final menuItems = <HeroUiMenuItem>[
      for (final component in components)
        _componentMenuItem(context, category, component),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(category.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            components.isEmpty
                ? 'No components yet'
                : '$implementedCount/${components.length} implemented',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          if (components.isNotEmpty)
            HeroUiMenuCard(showShadow: false, items: menuItems),
        ],
      ),
    );
  }
}

HeroUiMenuItem _componentMenuItem(
  BuildContext context,
  ComponentCategory category,
  CatalogComponent component,
) {
  final mutedColor = Theme.of(context).colorScheme.onSurfaceVariant;

  return HeroUiMenuItem(
    title: component.name,
    subtitle: component.status.title,
    leading: CatalogComponentLeadingIcon(
      category: category,
      component: component,
    ),
    trailing: HeroUiIcon(
      component.hasDemo
          ? HeroUiIconManifest.chevronRight
          : HeroUiIconManifest.lock,
      size: 20,
      color: mutedColor,
    ),
    onTap: component.hasDemo
        ? () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => ComponentDemoScreen(component: component),
              ),
            );
          }
        : null,
  );
}
