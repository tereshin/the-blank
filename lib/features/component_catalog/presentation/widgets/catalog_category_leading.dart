import 'package:flutter/material.dart';
import 'package:heroui_design_system/design_system.dart';

import '../../domain/catalog_component.dart';
import '../../domain/component_category.dart';

/// Gradient squircle + category glyph (catalog root list).
class CatalogCategoryLeadingIcon extends StatelessWidget {
  const CatalogCategoryLeadingIcon({required this.category, super.key});

  final ComponentCategory category;

  @override
  Widget build(BuildContext context) {
    return _CategoryLeadingSquircle(
      gradient: _categoryLeadingGradient(category),
      iconName: _categoryIconName(category),
    );
  }
}

/// Same gradient as the parent [category], icon reflects implementation status.
class CatalogComponentLeadingIcon extends StatelessWidget {
  const CatalogComponentLeadingIcon({
    required this.category,
    required this.component,
    super.key,
  });

  final ComponentCategory category;
  final CatalogComponent component;

  @override
  Widget build(BuildContext context) {
    final implemented =
        component.status == ComponentImplementationStatus.implemented;
    return _CategoryLeadingSquircle(
      gradient: _categoryLeadingGradient(category),
      iconName: implemented
          ? HeroUiIconManifest.check
          : HeroUiIconManifest.clock,
    );
  }
}

class _CategoryLeadingSquircle extends StatelessWidget {
  const _CategoryLeadingSquircle({
    required this.gradient,
    required this.iconName,
  });

  final LinearGradient gradient;
  final String iconName;

  static const double _size = 28;
  static const double _radius = 8;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(_radius),
      child: DecoratedBox(
        decoration: BoxDecoration(gradient: gradient),
        child: SizedBox(
          width: _size,
          height: _size,
          child: Center(
            child: HeroUiIcon(
              iconName,
              size: 20,
              color: const Color(0xFFFFFFFF),
            ),
          ),
        ),
      ),
    );
  }
}

String _categoryIconName(ComponentCategory category) => switch (category) {
  ComponentCategory.buttons => HeroUiIconManifest.squarePlus,
  ComponentCategory.collections => HeroUiIconManifest.boxes3,
  ComponentCategory.colors => HeroUiIconManifest.palette,
  ComponentCategory.controls => HeroUiIconManifest.sliders,
  ComponentCategory.dataDisplay => HeroUiIconManifest.squareChartColumn,
  ComponentCategory.dateAndTime => HeroUiIconManifest.calendar,
  ComponentCategory.feedback => HeroUiIconManifest.bell,
  ComponentCategory.forms => HeroUiIconManifest.squareBrackets,
  ComponentCategory.layout => HeroUiIconManifest.layoutColumns,
  ComponentCategory.media => HeroUiIconManifest.filmstrip,
  ComponentCategory.navigation => HeroUiIconManifest.branchesRight,
  ComponentCategory.overlays => HeroUiIconManifest.layers3Diagonal,
  ComponentCategory.pickers => HeroUiIconManifest.slidersVertical,
  ComponentCategory.typography => HeroUiIconManifest.text,
  ComponentCategory.utilities => HeroUiIconManifest.wrench,
};

LinearGradient _categoryLeadingGradient(ComponentCategory category) =>
    switch (category) {
      ComponentCategory.buttons => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF3A9DF5), Color(0xFF0360B8)],
      ),
      ComponentCategory.collections => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF7B79ED), Color(0xFF4846C2)],
      ),
      ComponentCategory.colors => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFFAB40), Color(0xFFE67E00)],
      ),
      ComponentCategory.controls => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF5EDD7A), Color(0xFF28A745)],
      ),
      ComponentCategory.dataDisplay => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF8B89F4), Color(0xFF4543C4)],
      ),
      ComponentCategory.dateAndTime => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFF6259), Color(0xFFE02820)],
      ),
      ComponentCategory.feedback => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFF5C8A), Color(0xFFE02050)],
      ),
      ComponentCategory.forms => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF8FE5FF), Color(0xFF3AB8E0)],
      ),
      ComponentCategory.layout => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF3D9FFF), Color(0xFF0066D6)],
      ),
      ComponentCategory.media => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFFD54F), Color(0xFFE6B000)],
      ),
      ComponentCategory.navigation => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF5BC8F0), Color(0xFF1E9FD4)],
      ),
      ComponentCategory.overlays => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFC4A882), Color(0xFF8B7355)],
      ),
      ComponentCategory.pickers => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF5EE67A), Color(0xFF24A844)],
      ),
      ComponentCategory.typography => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFAEAEB2), Color(0xFF636366)],
      ),
      ComponentCategory.utilities => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF5C5C5E), Color(0xFF2C2C2E)],
      ),
    };
