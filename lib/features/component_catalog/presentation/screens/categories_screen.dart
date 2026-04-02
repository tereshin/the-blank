import 'package:flutter/material.dart';

import '../../data/component_registry.dart';
import '../../domain/catalog_component.dart';
import '../../domain/component_category.dart';
import '../widgets/category_tile.dart';
import 'category_detail_screen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = ComponentCategory.values;

    return Scaffold(
      appBar: AppBar(title: const Text('Component Categories')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final category = categories[index];
          final components = componentsFor(category);
          final totalComponents = components.length;
          final implementedComponents = components
              .where(
                (component) =>
                    component.status ==
                    ComponentImplementationStatus.implemented,
              )
              .length;

          return CategoryTile(
            category: category,
            totalComponents: totalComponents,
            implementedComponents: implementedComponents,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) =>
                      CategoryDetailScreen(category: category),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
