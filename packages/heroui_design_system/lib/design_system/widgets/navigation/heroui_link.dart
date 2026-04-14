import 'package:flutter/material.dart';

import '../../../icons/heroui_icon.dart';
import '../../typography/heroui_typography.dart';

enum HeroUiLinkState { defaultState, hover, pressed, focus, disabled }

class HeroUiLink extends StatefulWidget {
  const HeroUiLink({
    required this.label,
    super.key,
    this.onTap,
    this.state = HeroUiLinkState.defaultState,
    this.textStyle = HeroUiTypography.linkSm,
    this.showIcon = false,
    this.icon,
    this.leading,
    this.trailing,
  });

  final String label;
  final VoidCallback? onTap;
  final HeroUiLinkState state;
  /// Base typography for the label (color, underline, and decoration are overridden from state).
  final TextStyle textStyle;
  final bool showIcon;
  final Widget? icon;
  final Widget? leading;
  final Widget? trailing;

  @override
  State<HeroUiLink> createState() => _HeroUiLinkState();
}

class _HeroUiLinkState extends State<HeroUiLink> {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  bool get _autoStateEnabled => widget.state == HeroUiLinkState.defaultState;

  HeroUiLinkState _autoState() {
    if (_pressed) return HeroUiLinkState.pressed;
    if (_focused) return HeroUiLinkState.focus;
    if (_hovered) return HeroUiLinkState.hover;
    return HeroUiLinkState.defaultState;
  }

  HeroUiLinkState _resolveState() {
    if (widget.state == HeroUiLinkState.disabled) {
      return HeroUiLinkState.disabled;
    }
    if (!_autoStateEnabled) return widget.state;
    if (widget.onTap == null) return HeroUiLinkState.disabled;
    return _autoState();
  }

  Widget _resolveIconSlot(Widget child, Color fallbackColor) {
    if (child is HeroUiIcon) {
      return HeroUiIcon(
        child.name,
        key: child.key,
        size: child.size,
        color: child.color ?? fallbackColor,
        semanticLabel: child.semanticLabel,
      );
    }
    return IconTheme.merge(
      data: IconThemeData(color: fallbackColor, size: 18),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final current = _resolveState();
    final foreground = isDark
        ? const Color(0xFFFCFCFC)
        : const Color(0xFF18181B);
    final focusFill = isDark
        ? const Color(0xFF27272A)
        : const Color(0xFFF5F5F5);
    final focusRingInset = isDark
        ? const Color(0xFF060607)
        : const Color(0xFFF5F5F5);
    final surfaceOpacity = switch (current) {
      HeroUiLinkState.hover || HeroUiLinkState.pressed => 0.8,
      HeroUiLinkState.disabled => 0.5,
      _ => 1.0,
    };
    final iconOpacity = switch (current) {
      HeroUiLinkState.defaultState || HeroUiLinkState.disabled => 0.6,
      _ => 1.0,
    };
    final decoration = switch (current) {
      HeroUiLinkState.hover ||
      HeroUiLinkState.pressed ||
      HeroUiLinkState.focus => TextDecoration.underline,
      _ => TextDecoration.none,
    };

    final legacyLeading = !widget.showIcon ? widget.leading : null;
    final legacyTrailing = !widget.showIcon ? widget.trailing : null;
    final trailingIcon = widget.showIcon
        ? (widget.icon ??
              const HeroUiIcon(HeroUiIconManifest.external, size: 18))
        : legacyTrailing;
    final onTap = current == HeroUiLinkState.disabled ? null : widget.onTap;

    return Opacity(
      opacity: surfaceOpacity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: current == HeroUiLinkState.focus
              ? focusFill
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          boxShadow: current == HeroUiLinkState.focus
              ? [
                  const BoxShadow(
                    color: Color(0xFF0485F7),
                    blurRadius: 0,
                    spreadRadius: 5,
                  ),
                  BoxShadow(
                    color: focusRingInset,
                    blurRadius: 0,
                    spreadRadius: 3,
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
            borderRadius: BorderRadius.circular(16),
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
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: DefaultTextStyle(
                style: widget.textStyle.copyWith(
                  color: foreground,
                  decoration: decoration,
                  decorationColor: foreground,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (legacyLeading != null) ...[
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Opacity(
                          opacity: iconOpacity,
                          child: _resolveIconSlot(legacyLeading, foreground),
                        ),
                      ),
                      const SizedBox(width: 3),
                    ],
                    Text(
                      widget.label,
                      textHeightBehavior: const TextHeightBehavior(
                        applyHeightToFirstAscent: false,
                        applyHeightToLastDescent: false,
                      ),
                    ),
                    if (trailingIcon != null) ...[
                      const SizedBox(width: 3),
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Opacity(
                          opacity: iconOpacity,
                          child: _resolveIconSlot(trailingIcon, foreground),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
