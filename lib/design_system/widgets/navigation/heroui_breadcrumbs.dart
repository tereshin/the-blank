import 'package:flutter/material.dart';

import '../../../core/icons/heroui_icon.dart';
import 'heroui_link.dart';

class HeroUiBreadcrumbItem {
  const HeroUiBreadcrumbItem({required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;
}

class HeroUiBreadcrumbs extends StatelessWidget {
  const HeroUiBreadcrumbs({
    required this.items,
    super.key,
    this.separator = const HeroUiIcon(
      HeroUiIconManifest.chevronRightRegular,
      size: 16,
    ),
  });

  final List<HeroUiBreadcrumbItem> items;
  final Widget separator;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 6,
      children: [
        for (var index = 0; index < items.length; index++) ...[
          if (index > 0) separator,
          HeroUiLink(label: items[index].label, onTap: items[index].onTap),
        ],
      ],
    );
  }
}
