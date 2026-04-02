import 'package:flutter/material.dart';

import '../../../../design_system/design_system.dart';
import '../../domain/component_category.dart';

class CategoryTile extends StatelessWidget {
  const CategoryTile({
    required this.category,
    required this.totalComponents,
    required this.implementedComponents,
    required this.onTap,
    super.key,
  });

  final ComponentCategory category;
  final int totalComponents;
  final int implementedComponents;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return HeroUiCard(
      padding: EdgeInsets.zero,
      body: ListTile(
        onTap: onTap,
        title: Text(category.title),

        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
