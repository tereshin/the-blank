import 'package:flutter/material.dart';

import '../../data/component_registry.dart';
import '../../domain/catalog_component.dart';
import '../../domain/component_category.dart';
import '../widgets/component_placeholder_tile.dart';
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

    return Scaffold(
      appBar: AppBar(title: Text(category.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              components.isEmpty
                  ? 'No components yet'
                  : '$implementedCount/${components.length} implemented',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: components.isEmpty
                  ? const Center(child: Text('No components yet'))
                  : ListView.separated(
                      itemCount: components.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final component = components[index];
                        return ComponentCatalogTile(
                          component: component,
                          onTap: component.hasDemo
                              ? () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                      builder: (_) =>
                                          ComponentDemoScreen(component: component),
                                    ),
                                  );
                                }
                              : null,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
