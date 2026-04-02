import 'package:flutter/material.dart';

import '../../../core/icons/heroui_icon.dart';

enum HeroUiButtonVariant {
  primary,
  secondary,
  danger,
  ghost,
  outline,
  tertiary,
  dangerSoft,
  toggleSelected,
}

enum HeroUiButtonSize { sm, md, lg }

enum HeroUiButtonVisualState { defaultState, hover, pressed, focus, disabled }

enum HeroUiButtonGroupOrientation { horizontal, vertical }

enum HeroUiButtonGroupWidth { hug, fill }

enum HeroUiCloseButtonState { defaultState, hover, pressed, focus, disabled }
enum HeroUiToggleButtonVariant { defaultVariant, ghost }

class HeroUiButton extends StatefulWidget {
  const HeroUiButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.variant = HeroUiButtonVariant.primary,
    this.size = HeroUiButtonSize.md,
    this.state = HeroUiButtonVisualState.defaultState,
    this.leading,
    this.trailing,
    this.iconOnly = false,
    this.borderRadiusOverride,
    this.expand = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final HeroUiButtonVariant variant;
  final HeroUiButtonSize size;
  final HeroUiButtonVisualState state;
  final Widget? leading;
  final Widget? trailing;
  final bool iconOnly;
  final BorderRadiusGeometry? borderRadiusOverride;
  final bool expand;

  @override
  State<HeroUiButton> createState() => _HeroUiButtonState();
}

class _HeroUiButtonState extends State<HeroUiButton> {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  bool get _autoStateEnabled =>
      widget.state == HeroUiButtonVisualState.defaultState;

  HeroUiButtonVisualState _autoState() {
    if (_pressed) return HeroUiButtonVisualState.pressed;
    if (_focused) return HeroUiButtonVisualState.focus;
    if (_hovered) return HeroUiButtonVisualState.hover;
    return HeroUiButtonVisualState.defaultState;
  }

  @override
  Widget build(BuildContext context) {
    final s = _size(widget.size);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final current = widget.onPressed == null
        ? HeroUiButtonVisualState.disabled
        : (_autoStateEnabled ? _autoState() : widget.state);
    final t = _tokens(widget.variant, current, isDark: isDark);
    final radius =
        widget.borderRadiusOverride ?? BorderRadius.circular(s.radius);
    final iconTheme = IconThemeData(size: 16, color: t.fg);

    final content = widget.iconOnly
        ? IconTheme.merge(
            data: iconTheme,
            child:
                widget.leading ??
                widget.trailing ??
                const Icon(Icons.crop_square_rounded),
          )
        : DefaultTextStyle(
            style: s.textStyle.copyWith(color: t.fg),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            child: Row(
              mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.leading != null) ...[
                  IconTheme.merge(data: iconTheme, child: widget.leading!),
                  SizedBox(width: s.gap),
                ],
                Flexible(
                  child: SizedBox(
                    height: s.labelHeight,
                    child: Center(
                      child: Text(
                        widget.label,
                        textAlign: TextAlign.center,
                        textHeightBehavior: const TextHeightBehavior(
                          applyHeightToFirstAscent: false,
                          applyHeightToLastDescent: false,
                        ),
                      ),
                    ),
                  ),
                ),
                if (widget.trailing != null) ...[
                  SizedBox(width: s.gap),
                  IconTheme.merge(data: iconTheme, child: widget.trailing!),
                ],
              ],
            ),
          );

    return Opacity(
      opacity: current == HeroUiButtonVisualState.disabled ? 0.5 : 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: t.bg,
          borderRadius: radius,
          border: t.border == null ? null : Border.all(color: t.border!),
          boxShadow: current == HeroUiButtonVisualState.focus
              ? const [
                  BoxShadow(color: Color(0xFF0485F7), spreadRadius: 4),
                  BoxShadow(color: Color(0xFFF5F5F5), spreadRadius: 2),
                ]
              : null,
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            splashFactory: NoSplash.splashFactory,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            focusColor: Colors.transparent,
            onHover: (value) {
              if (!_autoStateEnabled || _hovered == value) return;
              setState(() => _hovered = value);
            },
            onHighlightChanged: (value) {
              if (!_autoStateEnabled || _pressed == value) return;
              setState(() => _pressed = value);
            },
            onFocusChange: (value) {
              if (!_autoStateEnabled || _focused == value) return;
              setState(() => _focused = value);
            },
            borderRadius: radius.resolve(Directionality.of(context)),
            onTap: current == HeroUiButtonVisualState.disabled
                ? null
                : widget.onPressed,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: s.height,
                minWidth: widget.iconOnly ? s.height : 0,
              ),
              child: Padding(
                padding: widget.iconOnly ? s.iconPadding : s.padding,
                child: Center(child: content),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HeroUiButtonGroupItem {
  const HeroUiButtonGroupItem({
    required this.label,
    this.onPressed,
    this.leading,
    this.trailing,
    this.iconOnly = false,
    this.variant,
    this.state,
  });
  final String label;
  final VoidCallback? onPressed;
  final Widget? leading;
  final Widget? trailing;
  final bool iconOnly;
  final HeroUiButtonVariant? variant;
  final HeroUiButtonVisualState? state;
}

class HeroUiButtonGroup extends StatelessWidget {
  const HeroUiButtonGroup({
    super.key,
    this.items,
    this.children,
    this.size = HeroUiButtonSize.md,
    this.variant = HeroUiButtonVariant.primary,
    this.state = HeroUiButtonVisualState.defaultState,
    this.orientation = HeroUiButtonGroupOrientation.horizontal,
    this.width = HeroUiButtonGroupWidth.hug,
    this.spacing = 8,
    this.attached = true,
  }) : assert(items != null || children != null);

  final List<HeroUiButtonGroupItem>? items;
  final List<Widget>? children;
  final HeroUiButtonSize size;
  final HeroUiButtonVariant variant;
  final HeroUiButtonVisualState state;
  final HeroUiButtonGroupOrientation orientation;
  final HeroUiButtonGroupWidth width;
  final double spacing;
  final bool attached;

  @override
  Widget build(BuildContext context) {
    if (items == null) {
      final legacy = children ?? const <Widget>[];
      if (orientation == HeroUiButtonGroupOrientation.horizontal) {
        return Wrap(spacing: spacing, runSpacing: spacing, children: legacy);
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _withVerticalSpacing(legacy, spacing),
      );
    }

    final list = items!;
    final s = _size(size);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (!attached) {
      final detached = <Widget>[];
      for (final item in list) {
        Widget node = HeroUiButton(
          label: item.label,
          onPressed: item.onPressed,
          leading: item.leading,
          trailing: item.trailing,
          iconOnly: item.iconOnly,
          variant: item.variant ?? variant,
          size: size,
          state: item.state ?? state,
          expand:
              width == HeroUiButtonGroupWidth.fill &&
              orientation == HeroUiButtonGroupOrientation.horizontal,
        );
        if (width == HeroUiButtonGroupWidth.fill &&
            orientation == HeroUiButtonGroupOrientation.horizontal) {
          node = Expanded(child: node);
        }
        detached.add(node);
      }
      final detachedGroup = orientation == HeroUiButtonGroupOrientation.horizontal
          ? Row(
              mainAxisSize: width == HeroUiButtonGroupWidth.hug
                  ? MainAxisSize.min
                  : MainAxisSize.max,
              children: _withHorizontalSpacing(detached, spacing),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _withVerticalSpacing(detached, spacing),
            );
      return width == HeroUiButtonGroupWidth.fill &&
              orientation == HeroUiButtonGroupOrientation.horizontal
          ? SizedBox(width: double.infinity, child: detachedGroup)
          : detachedGroup;
    }

    final dividerColor = _groupDivider(variant, isDark: isDark);
    final nodes = <Widget>[];
    for (var i = 0; i < list.length; i++) {
      final item = list[i];
      final first = i == 0;
      final last = i == list.length - 1;
      final itemVariant = item.variant ?? variant;
      final itemState = item.state ?? state;
      Widget node = HeroUiButton(
        label: item.label,
        onPressed: item.onPressed,
        leading: item.leading,
        trailing: item.trailing,
        iconOnly: item.iconOnly,
        variant: itemVariant,
        size: size,
        state: itemState,
        expand:
            width == HeroUiButtonGroupWidth.fill &&
            orientation == HeroUiButtonGroupOrientation.horizontal,
        borderRadiusOverride: _segmentRadius(
          s.radius,
          orientation,
          first,
          last,
        ),
      );
      if (!first) {
        node = _ButtonGroupSegmentDivider(
          orientation: orientation,
          color: dividerColor,
          extent: s.divider,
          child: node,
        );
      }
      if (width == HeroUiButtonGroupWidth.fill &&
          orientation == HeroUiButtonGroupOrientation.horizontal) {
        node = Expanded(child: node);
      }
      nodes.add(node);
    }

    final grouped = orientation == HeroUiButtonGroupOrientation.horizontal
        ? Row(
            mainAxisSize: width == HeroUiButtonGroupWidth.hug
                ? MainAxisSize.min
                : MainAxisSize.max,
            children: nodes,
          )
        : Column(crossAxisAlignment: CrossAxisAlignment.start, children: nodes);
    return width == HeroUiButtonGroupWidth.fill &&
            orientation == HeroUiButtonGroupOrientation.horizontal
        ? SizedBox(width: double.infinity, child: grouped)
        : grouped;
  }
}

class HeroUiCloseButton extends StatefulWidget {
  const HeroUiCloseButton({
    this.onPressed,
    super.key,
    this.state = HeroUiCloseButtonState.defaultState,
  });
  final VoidCallback? onPressed;
  final HeroUiCloseButtonState state;

  @override
  State<HeroUiCloseButton> createState() => _HeroUiCloseButtonState();
}

class _HeroUiCloseButtonState extends State<HeroUiCloseButton> {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  bool get _autoStateEnabled =>
      widget.state == HeroUiCloseButtonState.defaultState;

  HeroUiCloseButtonState _autoState() {
    if (_pressed) return HeroUiCloseButtonState.pressed;
    if (_focused) return HeroUiCloseButtonState.focus;
    if (_hovered) return HeroUiCloseButtonState.hover;
    return HeroUiCloseButtonState.defaultState;
  }

  @override
  Widget build(BuildContext context) {
    final current = widget.onPressed == null
        ? HeroUiCloseButtonState.disabled
        : (_autoStateEnabled ? _autoState() : widget.state);
    final bg = switch (current) {
      HeroUiCloseButtonState.defaultState => const Color(0xFFEBEBEC),
      HeroUiCloseButtonState.hover => const Color(0xFFE1E1E2),
      HeroUiCloseButtonState.pressed => const Color(0xFFD4D4D8),
      HeroUiCloseButtonState.focus => const Color(0xFFE1E1E2),
      HeroUiCloseButtonState.disabled => const Color(0xFFEBEBEC),
    };
    return Opacity(
      opacity: current == HeroUiCloseButtonState.disabled ? 0.5 : 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: bg,
          shape: BoxShape.circle,
          boxShadow: current == HeroUiCloseButtonState.focus
              ? const [
                  BoxShadow(
                    color: Color(0xFF0485F7),
                    spreadRadius: 4,
                    blurRadius: 0,
                  ),
                  BoxShadow(
                    color: Color(0xFFF5F5F5),
                    spreadRadius: 2,
                    blurRadius: 0,
                  ),
                ]
              : null,
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            splashFactory: NoSplash.splashFactory,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            focusColor: Colors.transparent,
            customBorder: const CircleBorder(),
            onHover: (value) {
              if (!_autoStateEnabled || _hovered == value) return;
              setState(() => _hovered = value);
            },
            onHighlightChanged: (value) {
              if (!_autoStateEnabled || _pressed == value) return;
              setState(() => _pressed = value);
            },
            onFocusChange: (value) {
              if (!_autoStateEnabled || _focused == value) return;
              setState(() => _focused = value);
            },
            onTap: current == HeroUiCloseButtonState.disabled
                ? null
                : widget.onPressed,
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: HeroUiIcon(
                HeroUiIconManifest.xmarkRegular,
                size: 16,
                color: Color(0xFF71717A),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HeroUiToggleOption<T> {
  const HeroUiToggleOption({
    required this.value,
    required this.label,
    this.icon,
    this.trailing,
    this.iconOnly = false,
  });
  final T value;
  final String label;
  final Widget? icon;
  final Widget? trailing;
  final bool iconOnly;
}

class HeroUiToggleButton extends StatelessWidget {
  const HeroUiToggleButton({
    required this.label,
    required this.selected,
    required this.onChanged,
    super.key,
    this.size = HeroUiButtonSize.md,
    this.leading,
    this.trailing,
    this.iconOnly = false,
    this.variant = HeroUiToggleButtonVariant.defaultVariant,
  });
  final String label;
  final bool selected;
  final ValueChanged<bool>? onChanged;
  final HeroUiButtonSize size;
  final Widget? leading;
  final Widget? trailing;
  final bool iconOnly;
  final HeroUiToggleButtonVariant variant;

  @override
  Widget build(BuildContext context) => HeroUiButton(
    label: label,
    onPressed: onChanged == null ? null : () => onChanged!(!selected),
    size: size,
    leading: leading,
    trailing: trailing,
    iconOnly: iconOnly,
    variant: _toggleVariant(selected, variant),
  );
}

class HeroUiToggleButtonGroup<T> extends StatelessWidget {
  const HeroUiToggleButtonGroup({
    required this.options,
    required this.value,
    required this.onChanged,
    super.key,
    this.size = HeroUiButtonSize.md,
    this.variant = HeroUiToggleButtonVariant.defaultVariant,
    this.orientation = HeroUiButtonGroupOrientation.horizontal,
    this.width = HeroUiButtonGroupWidth.hug,
    this.isAttached = true,
    this.spacing = 4,
  });
  final List<HeroUiToggleOption<T>> options;
  final T? value;
  final ValueChanged<T>? onChanged;
  final HeroUiButtonSize size;
  final HeroUiToggleButtonVariant variant;
  final HeroUiButtonGroupOrientation orientation;
  final HeroUiButtonGroupWidth width;
  final bool isAttached;
  final double spacing;

  @override
  Widget build(BuildContext context) => HeroUiButtonGroup(
    size: size,
    variant: _toggleBaseVariant(variant),
    orientation: orientation,
    width: width,
    spacing: spacing,
    attached: isAttached,
    items: [
      for (final option in options)
        HeroUiButtonGroupItem(
          label: option.label,
          onPressed: onChanged == null ? null : () => onChanged!(option.value),
          leading: option.icon,
          trailing: option.trailing,
          iconOnly: option.iconOnly,
          variant: _toggleVariant(value == option.value, variant),
        ),
    ],
  );
}

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
      fontSize: 14,
      height: 1,
    ),
    16,
  ),
  HeroUiButtonSize.md => const _Size(
    36,
    24,
    20,
    8,
    EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    EdgeInsets.all(10),
    TextStyle(
      fontFamily: 'Inter',
      fontWeight: FontWeight.w500,
      fontSize: 14,
      height: 1,
    ),
    18,
  ),
  HeroUiButtonSize.lg => const _Size(
    40,
    24,
    24,
    8,
    EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    EdgeInsets.all(12),
    TextStyle(
      fontFamily: 'Inter',
      fontWeight: FontWeight.w500,
      fontSize: 16,
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
      HeroUiButtonVariant.toggleSelected => const Color.fromRGBO(4, 133, 247, 0.5),
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
    HeroUiButtonVariant.toggleSelected => const Color.fromRGBO(4, 133, 247, 0.55),
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
