import 'package:flutter/material.dart';

import '../../typography/heroui_typography.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// SURFACE
// ═══════════════════════════════════════════════════════════════════════════════

enum HeroUiSurfaceVariant { transparent, defaultVariant, secondary, tertiary }

/// A styled container surface — equivalent to a card background.
///
/// Variants:
/// - [transparent]: no background, no shadow.
/// - [defaultVariant]: white/dark background + subtle elevation shadow.
/// - [secondary]: slightly off-white `#EFEFF0` + shadow.
/// - [tertiary]: `#EAEAEB` (darker gray) + shadow.
class HeroUiSurface extends StatelessWidget {
  const HeroUiSurface({
    super.key,
    this.variant = HeroUiSurfaceVariant.defaultVariant,
    this.borderRadius = 24,
    this.padding,
    this.showShadow = true,
    this.backgroundColor,
    required this.child,
  });

  final HeroUiSurfaceVariant variant;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool showShadow;
  final Color? backgroundColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg = backgroundColor ??
        switch (variant) {
          HeroUiSurfaceVariant.transparent => Colors.transparent,
          HeroUiSurfaceVariant.defaultVariant =>
            isDark ? const Color(0xFF18181B) : const Color(0xFFFFFFFF),
          HeroUiSurfaceVariant.secondary =>
            isDark ? const Color(0xFF27272A) : const Color(0xFFEFEFF0),
          HeroUiSurfaceVariant.tertiary =>
            isDark ? const Color(0xFF3F3F46) : const Color(0xFFEAEAEB),
        };

    final List<BoxShadow> shadows =
        !showShadow || variant == HeroUiSurfaceVariant.transparent
        ? const []
        : const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.02),
              offset: Offset(0, 2),
              blurRadius: 2,
            ),
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.04),
              offset: Offset(0, 1),
              blurRadius: 2,
            ),
          ];

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: shadows,
      ),
      child: child,
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// DISCLOSURE
// ═══════════════════════════════════════════════════════════════════════════════

/// A collapsible section with an animated expand/collapse.
///
/// The [title] is shown in the trigger row alongside a chevron icon.
/// When open, [child] is revealed with a fade+slide animation.
class HeroUiDisclosure extends StatefulWidget {
  const HeroUiDisclosure({
    super.key,
    required this.title,
    required this.child,
    this.initiallyOpen = false,
    this.leading,
    this.onChanged,
  });

  final String title;
  final Widget child;
  final bool initiallyOpen;

  /// Optional leading widget (e.g. an icon) placed before the title.
  final Widget? leading;

  /// Called whenever the open/close state changes.
  final ValueChanged<bool>? onChanged;

  @override
  State<HeroUiDisclosure> createState() => _HeroUiDisclosureState();
}

class _HeroUiDisclosureState extends State<HeroUiDisclosure>
    with SingleTickerProviderStateMixin {
  late bool _isOpen;
  late final AnimationController _ctrl;
  late final Animation<double> _expandAnim;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _isOpen = widget.initiallyOpen;
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      value: widget.initiallyOpen ? 1.0 : 0.0,
    );
    _expandAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
    _fadeAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _isOpen = !_isOpen);
    _isOpen ? _ctrl.forward() : _ctrl.reverse();
    widget.onChanged?.call(_isOpen);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark
        ? const Color(0xFFFCFCFC)
        : const Color(0xFF18181B);
    final bgColor = isDark ? const Color(0xFF27272A) : const Color(0xFFEBEBEC);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Trigger row
        GestureDetector(
          onTap: _toggle,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                if (widget.leading != null) ...[
                  widget.leading!,
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    widget.title,
                    style: HeroUiTypography.bodySmMedium.copyWith(
                      color: titleColor,
                    ),
                  ),
                ),
                AnimatedBuilder(
                  animation: _ctrl,
                  builder: (_, __) => Transform.rotate(
                    angle: _ctrl.value * 3.14159,
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 18,
                      color: titleColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Content
        SizeTransition(
          sizeFactor: _expandAnim,
          axisAlignment: -1,
          child: FadeTransition(
            opacity: _fadeAnim,
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: widget.child,
            ),
          ),
        ),
      ],
    );
  }
}

/// A group of [HeroUiDisclosure] items separated by dividers.
///
/// Each [items] entry provides a [title], [child], and optional [leading].
class HeroUiDisclosureGroup extends StatelessWidget {
  const HeroUiDisclosureGroup({
    super.key,
    required this.items,
    this.initiallyOpenIndex,
  });

  final List<HeroUiDisclosureItem> items;

  /// Index of the item that should start open (or null for all closed).
  final int? initiallyOpenIndex;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dividerColor = isDark
        ? const Color(0xFF3F3F46)
        : const Color(0xFFE4E4E7);

    final children = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      if (i > 0) {
        children.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Divider(height: 1, color: dividerColor),
          ),
        );
      }
      children.add(
        HeroUiDisclosure(
          title: items[i].title,
          leading: items[i].leading,
          initiallyOpen: i == initiallyOpenIndex,
          child: items[i].child,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}

/// Data model for a [HeroUiDisclosureGroup] item.
class HeroUiDisclosureItem {
  const HeroUiDisclosureItem({
    required this.title,
    required this.child,
    this.leading,
  });

  final String title;
  final Widget child;
  final Widget? leading;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SCROLL SHADOW
// ═══════════════════════════════════════════════════════════════════════════════

enum HeroUiScrollShadowType { opacity, blur }

/// Wraps a [child] scroll view and renders a gradient shadow at the
/// top/bottom edges as the user scrolls, indicating that more content is
/// available.
///
/// - [type]: [HeroUiScrollShadowType.opacity] fades content using a gradient mask;
///   [HeroUiScrollShadowType.blur] overlays a frosted-glass panel instead.
/// - [inSurface]: when true the gradient uses white/surface colors; when false
///   it uses the page background color.
/// - [shadowSize]: height (vertical) or width (horizontal) of the shadow area.
class HeroUiScrollShadow extends StatefulWidget {
  const HeroUiScrollShadow({
    super.key,
    required this.child,
    this.type = HeroUiScrollShadowType.opacity,
    this.inSurface = false,
    this.shadowSize = 60.0,
    this.scrollDirection = Axis.vertical,
    this.controller,
  });

  final Widget child;
  final HeroUiScrollShadowType type;
  final bool inSurface;
  final double shadowSize;
  final Axis scrollDirection;
  final ScrollController? controller;

  @override
  State<HeroUiScrollShadow> createState() => _HeroUiScrollShadowState();
}

class _HeroUiScrollShadowState extends State<HeroUiScrollShadow> {
  late final ScrollController _ctrl;
  bool _showTop = false;
  bool _showBottom = true;

  @override
  void initState() {
    super.initState();
    _ctrl = widget.controller ?? ScrollController();
    _ctrl.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _onScroll());
  }

  @override
  void dispose() {
    if (widget.controller == null) _ctrl.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_ctrl.hasClients) return;
    final pos = _ctrl.position;
    final atTop = pos.pixels <= 0;
    final atBottom = pos.pixels >= pos.maxScrollExtent;
    setState(() {
      _showTop = !atTop;
      _showBottom = !atBottom;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Surface color for gradient endpoint
    final surfaceColor = widget.inSurface
        ? (isDark ? const Color(0xFF18181B) : const Color(0xFFFFFFFF))
        : (isDark ? const Color(0xFF09090B) : const Color(0xFFFAFAFA));

    final isVertical = widget.scrollDirection == Axis.vertical;

    return Stack(
      children: [
        // Scrollable content
        widget.child,

        // Top/left shadow
        if (_showTop)
          Positioned(
            top: 0,
            left: 0,
            right: isVertical ? 0 : null,
            bottom: isVertical ? null : 0,
            child: _buildShadow(
              context,
              surfaceColor: surfaceColor,
              fromTop: true,
              isVertical: isVertical,
            ),
          ),

        // Bottom/right shadow
        if (_showBottom)
          Positioned(
            bottom: 0,
            right: 0,
            left: isVertical ? 0 : null,
            top: isVertical ? null : 0,
            child: _buildShadow(
              context,
              surfaceColor: surfaceColor,
              fromTop: false,
              isVertical: isVertical,
            ),
          ),
      ],
    );
  }

  Widget _buildShadow(
    BuildContext context, {
    required Color surfaceColor,
    required bool fromTop,
    required bool isVertical,
  }) {
    final size = widget.shadowSize;

    if (widget.type == HeroUiScrollShadowType.opacity) {
      // Gradient mask approach
      return IgnorePointer(
        child: Container(
          height: isVertical ? size : null,
          width: isVertical ? null : size,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: fromTop
                  ? (isVertical ? Alignment.topCenter : Alignment.centerLeft)
                  : (isVertical
                        ? Alignment.bottomCenter
                        : Alignment.centerRight),
              end: fromTop
                  ? (isVertical
                        ? Alignment.bottomCenter
                        : Alignment.centerRight)
                  : (isVertical ? Alignment.topCenter : Alignment.centerLeft),
              colors: [surfaceColor, surfaceColor.withValues(alpha: 0)],
              stops: const [0.0, 1.0],
            ),
          ),
        ),
      );
    } else {
      // Blur + gradient approach
      return IgnorePointer(
        child: ClipRect(
          child: Container(
            height: isVertical ? size : null,
            width: isVertical ? null : size,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: fromTop
                    ? (isVertical ? Alignment.topCenter : Alignment.centerLeft)
                    : (isVertical
                          ? Alignment.bottomCenter
                          : Alignment.centerRight),
                end: fromTop
                    ? (isVertical
                          ? Alignment.bottomCenter
                          : Alignment.centerRight)
                    : (isVertical ? Alignment.topCenter : Alignment.centerLeft),
                colors: [
                  surfaceColor.withValues(alpha: 0.7),
                  surfaceColor.withValues(alpha: 0),
                ],
                stops: const [0.0, 1.0],
              ),
            ),
          ),
        ),
      );
    }
  }
}
