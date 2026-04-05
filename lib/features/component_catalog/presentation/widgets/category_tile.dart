import 'package:flutter/material.dart';

import 'package:heroui_design_system/design_system.dart';
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
    final mutedColor = Theme.of(context).colorScheme.onSurfaceVariant;

    return HeroUiCard(
      padding: EdgeInsets.zero,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  category.title,
                  style: HeroUiTypography.bodySmMedium,
                ),
              ),
              HeroUiIcon(
                HeroUiIconManifest.chevronRightRegular,
                size: 16,
                color: mutedColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
