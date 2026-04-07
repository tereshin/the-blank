import 'dart:ui';

import 'package:flutter/material.dart';

enum HeroUiToolbarOrientation { horizontal, vertical }

/// HeroUI Toolbar component with Figma-aligned composition:
/// - Slot: [slot] or [children]
/// - Container variants: [isAttached] true/false
/// - Layout variants: [orientation] horizontal/vertical
class HeroUiToolbar extends StatelessWidget {
  const HeroUiToolbar({
    super.key,
    this.slot,
    this.children = const <Widget>[],
    this.isAttached = false,
    this.orientation = HeroUiToolbarOrientation.horizontal,
    this.spacing = 10,
    this.padding,
    this.borderRadius = 21,
  });

  final Widget? slot;
  final List<Widget> children;
  final bool isAttached;
  final HeroUiToolbarOrientation orientation;
  final double spacing;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;

  List<Widget> _slotChildren() => switch (slot) {
    final Widget slotWidget => <Widget>[slotWidget],
    null => children,
  };

  List<Widget> _withSpacing(List<Widget> source) {
    if (source.length <= 1) return source;
    final out = <Widget>[];
    for (var index = 0; index < source.length; index++) {
      if (index > 0) {
        out.add(switch (orientation) {
          HeroUiToolbarOrientation.horizontal => SizedBox(width: spacing),
          HeroUiToolbarOrientation.vertical => SizedBox(height: spacing),
        });
      }
      out.add(source[index]);
    }
    return out;
  }

  Widget _buildSlotContainer() {
    final items = _withSpacing(_slotChildren());
    return switch (orientation) {
      HeroUiToolbarOrientation.horizontal => Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: items,
      ),
      HeroUiToolbarOrientation.vertical => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: items,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    assert(
      slot == null || children.isEmpty,
      'Use either slot or children, not both.',
    );
    assert(
      slot != null || children.isNotEmpty,
      'Provide slot or children for toolbar content.',
    );

    final slotContainer = _buildSlotContainer();
    if (!isAttached) return slotContainer;

    final tokens = _toolbarTokens(
      isDark: Theme.of(context).brightness == Brightness.dark,
    );
    final radius = BorderRadius.circular(borderRadius);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.background,
        borderRadius: radius,
        boxShadow: tokens.shadow,
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 26, sigmaY: 26),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(5),
            child: slotContainer,
          ),
        ),
      ),
    );
  }
}

/// Divider tailored for toolbar action groups.
class HeroUiToolbarDivider extends StatelessWidget {
  const HeroUiToolbarDivider({
    super.key,
    this.toolbarOrientation = HeroUiToolbarOrientation.horizontal,
    this.length = 23,
    this.thickness = 1,
  });

  final HeroUiToolbarOrientation toolbarOrientation;
  final double length;
  final double thickness;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDark ? const Color(0xFF1A1A1D) : const Color(0xFFE4E4E7);
    final isHorizontalToolbar =
        toolbarOrientation == HeroUiToolbarOrientation.horizontal;

    return SizedBox(
      width: isHorizontalToolbar ? thickness : length,
      height: isHorizontalToolbar ? length : thickness,
      child: DecoratedBox(decoration: BoxDecoration(color: color)),
    );
  }
}

class _HeroUiToolbarTokens {
  const _HeroUiToolbarTokens({required this.background, required this.shadow});

  final Color background;
  final List<BoxShadow> shadow;
}

_HeroUiToolbarTokens _toolbarTokens({required bool isDark}) =>
    _HeroUiToolbarTokens(
      background: isDark ? const Color(0xFF18181B) : const Color(0xFFFFFFFF),
      shadow: const [
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.08),
          blurRadius: 36,
          offset: Offset(0, 18),
        ),
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.03),
          blurRadius: 16,
          offset: Offset(0, -8),
        ),
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.06),
          blurRadius: 10,
          offset: Offset(0, 3),
        ),
      ],
    );
