import 'package:flutter/material.dart';

import '../../../../core/icons/heroui_icon.dart';
import '../../../../design_system/design_system.dart';
import '../../domain/catalog_component.dart';

class ComponentCatalogTile extends StatelessWidget {
  const ComponentCatalogTile({
    required this.component,
    required this.onTap,
    super.key,
  });

  final CatalogComponent component;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isImplemented =
        component.status == ComponentImplementationStatus.implemented;
    final statusColor = isImplemented
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.onSurfaceVariant;
    final trailingColor = Theme.of(context).colorScheme.onSurfaceVariant;
    final statusIcon = isImplemented
        ? HeroUiIconManifest.checkRegular
        : HeroUiIconManifest.clockRegular;
    final trailingIcon = onTap == null
        ? HeroUiIconManifest.lockRegular
        : HeroUiIconManifest.chevronRightRegular;

    return HeroUiCard(
      padding: EdgeInsets.zero,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              HeroUiIcon(statusIcon, size: 16, color: statusColor),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  component.name,
                  style: HeroUiTypography.bodySmMedium,
                ),
              ),
              HeroUiIcon(trailingIcon, size: 16, color: trailingColor),
            ],
          ),
        ),
      ),
    );
  }
}
