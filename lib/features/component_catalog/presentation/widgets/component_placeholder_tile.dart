import 'package:flutter/material.dart';

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

    return HeroUiCard(
      padding: EdgeInsets.zero,
      body: ListTile(
        onTap: onTap,
        title: Text(component.name),

        leading: Icon(
          isImplemented ? Icons.check_circle_rounded : Icons.schedule_rounded,
          color: statusColor,
        ),
        trailing: Icon(
          onTap == null
              ? Icons.lock_outline_rounded
              : Icons.chevron_right_rounded,
        ),
      ),
    );
  }
}
