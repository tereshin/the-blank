part of 'heroui_buttons.dart';

class _ButtonTokens {
  const _ButtonTokens(this.bg, this.fg, [this.border]);
  final Color bg;
  final Color fg;
  final Color? border;
}

class _Size {
  const _Size(
    this.height,
    this.radius,
    this.labelHeight,
    this.gap,
    this.padding,
    this.iconPadding,
    this.textStyle,
    this.divider,
  );
  final double height;
  final double radius;
  final double labelHeight;
  final double gap;
  final EdgeInsets padding;
  final EdgeInsets iconPadding;
  final TextStyle textStyle;
  final double divider;
}

_Size _size(HeroUiButtonSize s) => switch (s) {
  HeroUiButtonSize.sm => const _Size(
    32,
    16,
    20,
    5,
    EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    EdgeInsets.all(8),
    TextStyle(
      fontFamily: 'Inter',
      fontWeight: FontWeight.w500,
      fontSize: 13,
      height: 1,
    ),
    16,
  ),
  HeroUiButtonSize.md => const _Size(
    36,
    12,
    20,
    8,
    EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    EdgeInsets.all(10),
    TextStyle(
      fontFamily: 'Inter',
      fontWeight: FontWeight.w500,
      fontSize: 13,
      height: 1,
    ),
    18,
  ),
  HeroUiButtonSize.lg => const _Size(
    40,
    12,
    24,
    8,
    EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    EdgeInsets.all(12),
    TextStyle(
      fontFamily: 'Inter',
      fontWeight: FontWeight.w500,
      fontSize: 15,
      height: 1,
    ),
    20,
  ),
};

_ButtonTokens _tokens(
  HeroUiButtonVariant v,
  HeroUiButtonVisualState s, {
  required bool isDark,
}) {
  return isDark ? _tokensDark(v, s) : _tokensLight(v, s);
}

_ButtonTokens _tokensLight(HeroUiButtonVariant v, HeroUiButtonVisualState s) {
  final interactive =
      s == HeroUiButtonVisualState.hover ||
      s == HeroUiButtonVisualState.pressed ||
      s == HeroUiButtonVisualState.focus;
  final disabled = s == HeroUiButtonVisualState.disabled;
  final primaryBg = interactive
      ? const Color(0xFF3592F9)
      : const Color(0xFF0485F7);
  final dangerBg = interactive
      ? const Color(0xFFFF5551)
      : const Color(0xFFFF383C);
  final secondaryBg = interactive || disabled
      ? const Color(0xFFE1E1E2)
      : const Color(0xFFEBEBEC);
  final tertiaryBg = interactive
      ? const Color(0xFFE1E1E2)
      : const Color(0xFFEBEBEC);
  final dangerSoftBg = interactive
      ? const Color.fromRGBO(255, 85, 81, 0.2)
      : const Color.fromRGBO(255, 56, 60, 0.15);
  final toggleSelectedBg = interactive
      ? const Color.fromRGBO(4, 133, 247, 0.2)
      : const Color.fromRGBO(4, 133, 247, 0.15);
  return switch (v) {
    HeroUiButtonVariant.primary => _ButtonTokens(
      primaryBg,
      const Color(0xFFFCFCFC),
    ),
    HeroUiButtonVariant.secondary => _ButtonTokens(
      secondaryBg,
      const Color(0xFF0485F7),
    ),
    HeroUiButtonVariant.danger => _ButtonTokens(
      dangerBg,
      const Color(0xFFFCFCFC),
    ),
    HeroUiButtonVariant.ghost => _ButtonTokens(
      interactive ? const Color(0xFFEBEBEC) : Colors.transparent,
      const Color(0xFF18181B),
    ),
    HeroUiButtonVariant.outline => _ButtonTokens(
      interactive ? const Color(0xFFEBEBEC) : Colors.transparent,
      const Color(0xFF18181B),
      const Color(0xFFDEDEE0),
    ),
    HeroUiButtonVariant.tertiary => _ButtonTokens(
      tertiaryBg,
      const Color(0xFF18181B),
    ),
    HeroUiButtonVariant.dangerSoft => _ButtonTokens(
      dangerSoftBg,
      const Color(0xFFFF383C),
    ),
    HeroUiButtonVariant.toggleSelected => _ButtonTokens(
      toggleSelectedBg,
      const Color(0xFF0485F7),
    ),
  };
}

_ButtonTokens _tokensDark(HeroUiButtonVariant v, HeroUiButtonVisualState s) {
  final interactive =
      s == HeroUiButtonVisualState.hover || s == HeroUiButtonVisualState.focus;
  final pressed = s == HeroUiButtonVisualState.pressed;
  final elevatedDarkSurface = pressed
      ? const Color(0xFF3F3F46)
      : interactive
      ? const Color(0xFF323238)
      : const Color(0xFF27272A);
  final primaryBg = pressed
      ? const Color(0xFF006FEE)
      : interactive
      ? const Color(0xFF3592F9)
      : const Color(0xFF0485F7);
  final dangerBg = pressed
      ? const Color(0xFFC93539)
      : interactive
      ? const Color(0xFFE24549)
      : const Color(0xFFDB3B3E);
  final dangerSoftBg = pressed
      ? const Color.fromRGBO(219, 59, 62, 0.26)
      : interactive
      ? const Color.fromRGBO(219, 59, 62, 0.2)
      : const Color.fromRGBO(219, 59, 62, 0.15);
  final toggleSelectedBg = pressed
      ? const Color.fromRGBO(4, 133, 247, 0.24)
      : interactive
      ? const Color.fromRGBO(4, 133, 247, 0.2)
      : const Color.fromRGBO(4, 133, 247, 0.15);

  return switch (v) {
    HeroUiButtonVariant.primary => _ButtonTokens(
      primaryBg,
      const Color(0xFFFCFCFC),
    ),
    HeroUiButtonVariant.secondary => _ButtonTokens(
      elevatedDarkSurface,
      const Color(0xFF0485F7),
    ),
    HeroUiButtonVariant.danger => _ButtonTokens(
      dangerBg,
      const Color(0xFFFCFCFC),
    ),
    HeroUiButtonVariant.ghost => _ButtonTokens(
      pressed
          ? const Color(0xFF27272A)
          : interactive
          ? const Color(0x2218181B)
          : Colors.transparent,
      const Color(0xFFFCFCFC),
    ),
    HeroUiButtonVariant.outline => _ButtonTokens(
      pressed
          ? const Color(0xFF27272A)
          : interactive
          ? const Color(0x1AFCFCFC)
          : Colors.transparent,
      const Color(0xFFFCFCFC),
      interactive ? const Color(0xFF3F3F46) : const Color(0xFF28282C),
    ),
    HeroUiButtonVariant.tertiary => _ButtonTokens(
      elevatedDarkSurface,
      const Color(0xFFFCFCFC),
    ),
    HeroUiButtonVariant.dangerSoft => _ButtonTokens(
      dangerSoftBg,
      const Color(0xFFDB3B3E),
    ),
    HeroUiButtonVariant.toggleSelected => _ButtonTokens(
      toggleSelectedBg,
      const Color(0xFF0485F7),
    ),
  };
}

Color _groupDivider(HeroUiButtonVariant v, {required bool isDark}) {
  if (!isDark) {
    return switch (v) {
      HeroUiButtonVariant.primary => const Color(0x66FFFFFF),
      HeroUiButtonVariant.danger => const Color(0x66FFFFFF),
      HeroUiButtonVariant.secondary => const Color(0x400485F7),
      HeroUiButtonVariant.ghost => const Color(0x4018181B),
      HeroUiButtonVariant.outline => const Color(0x40DEDEE0),
      HeroUiButtonVariant.tertiary => const Color(0x4018181B),
      HeroUiButtonVariant.dangerSoft => const Color(0x66FF383C),
      HeroUiButtonVariant.toggleSelected => const Color.fromRGBO(
        4,
        133,
        247,
        0.5,
      ),
    };
  }
  return switch (v) {
    HeroUiButtonVariant.primary => const Color(0x66FFFFFF),
    HeroUiButtonVariant.danger => const Color(0x66FFFFFF),
    HeroUiButtonVariant.secondary => const Color(0x400485F7),
    HeroUiButtonVariant.ghost => const Color(0x40FCFCFC),
    HeroUiButtonVariant.outline => const Color(0x6628282C),
    HeroUiButtonVariant.tertiary => const Color(0x40FCFCFC),
    HeroUiButtonVariant.dangerSoft => const Color.fromRGBO(219, 59, 62, 0.5),
    HeroUiButtonVariant.toggleSelected => const Color.fromRGBO(
      4,
      133,
      247,
      0.55,
    ),
  };
}

BorderRadius _segmentRadius(
  double r,
  HeroUiButtonGroupOrientation o,
  bool first,
  bool last,
) {
  if (o == HeroUiButtonGroupOrientation.horizontal) {
    return BorderRadius.only(
      topLeft: first ? Radius.circular(r) : Radius.zero,
      bottomLeft: first ? Radius.circular(r) : Radius.zero,
      topRight: last ? Radius.circular(r) : Radius.zero,
      bottomRight: last ? Radius.circular(r) : Radius.zero,
    );
  }
  return BorderRadius.only(
    topLeft: first ? Radius.circular(r) : Radius.zero,
    topRight: first ? Radius.circular(r) : Radius.zero,
    bottomLeft: last ? Radius.circular(r) : Radius.zero,
    bottomRight: last ? Radius.circular(r) : Radius.zero,
  );
}

class _ButtonGroupSegmentDivider extends StatelessWidget {
  const _ButtonGroupSegmentDivider({
    required this.child,
    required this.orientation,
    required this.color,
    required this.extent,
  });

  final Widget child;
  final HeroUiButtonGroupOrientation orientation;
  final Color color;
  final double extent;

  @override
  Widget build(BuildContext context) {
    final divider = orientation == HeroUiButtonGroupOrientation.horizontal
        ? Positioned(
            left: -0.5,
            top: 0,
            bottom: 0,
            child: IgnorePointer(
              child: Center(
                child: Container(width: 1, height: extent, color: color),
              ),
            ),
          )
        : Positioned(
            top: -0.5,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Center(
                child: Container(width: extent, height: 1, color: color),
              ),
            ),
          );

    return Stack(clipBehavior: Clip.none, children: [child, divider]);
  }
}

HeroUiButtonVariant _toggleBaseVariant(HeroUiToggleButtonVariant variant) {
  return variant == HeroUiToggleButtonVariant.ghost
      ? HeroUiButtonVariant.ghost
      : HeroUiButtonVariant.tertiary;
}

HeroUiButtonVariant _toggleVariant(
  bool selected,
  HeroUiToggleButtonVariant variant,
) {
  if (selected) return HeroUiButtonVariant.toggleSelected;
  return _toggleBaseVariant(variant);
}

List<Widget> _withHorizontalSpacing(List<Widget> children, double spacing) {
  final out = <Widget>[];
  for (var i = 0; i < children.length; i++) {
    if (i > 0) out.add(SizedBox(width: spacing));
    out.add(children[i]);
  }
  return out;
}

List<Widget> _withVerticalSpacing(List<Widget> children, double spacing) {
  final out = <Widget>[];
  for (var i = 0; i < children.length; i++) {
    if (i > 0) out.add(SizedBox(height: spacing));
    out.add(children[i]);
  }
  return out;
}
