import 'package:flutter/material.dart';

import '../../typography/heroui_typography.dart';

// ─── Public enums ─────────────────────────────────────────────────────────────

enum HeroUiRadioGroupOrientation { vertical, horizontal }

// ─── HeroUiRadioControl ───────────────────────────────────────────────────────

/// Raw 16×16 animated radio-button indicator.
///
/// Manages hover, press and focus states internally.
/// Use [HeroUiRadio] for the full component with label and description.
class HeroUiRadioControl extends StatefulWidget {
  const HeroUiRadioControl({
    super.key,
    this.isSelected = false,
    this.isDisabled = false,
    this.isInvalid = false,
    this.onToggle,
  });

  final bool isSelected;
  final bool isDisabled;
  final bool isInvalid;

  /// Called when the user taps. The parent is responsible for updating state.
  final VoidCallback? onToggle;

  @override
  State<HeroUiRadioControl> createState() => _HeroUiRadioControlState();
}

class _HeroUiRadioControlState extends State<HeroUiRadioControl>
    with TickerProviderStateMixin {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  late final AnimationController _selectAnim;
  late final AnimationController _pressAnim;

  @override
  void initState() {
    super.initState();
    _selectAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
      value: widget.isSelected ? 1.0 : 0.0,
    );
    _pressAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
    );
  }

  @override
  void didUpdateWidget(HeroUiRadioControl old) {
    super.didUpdateWidget(old);
    if (old.isSelected != widget.isSelected) {
      widget.isSelected ? _selectAnim.forward() : _selectAnim.reverse();
    }
  }

  @override
  void dispose() {
    _selectAnim.dispose();
    _pressAnim.dispose();
    super.dispose();
  }

  bool get _interactive => !widget.isDisabled;

  _VisualState _effectiveState() {
    if (widget.isDisabled) return _VisualState.disabled;
    if (widget.isInvalid) return _VisualState.error;
    if (_pressed) return _VisualState.pressed;
    if (_focused) return _VisualState.focus;
    if (_hovered) return _VisualState.hover;
    return _VisualState.defaultState;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Focus(
      onFocusChange: (v) {
        if (_interactive) setState(() => _focused = v);
      },
      child: MouseRegion(
        cursor: _interactive && widget.onToggle != null
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        onEnter: (_) {
          if (_interactive) setState(() => _hovered = true);
        },
        onExit: (_) {
          if (_interactive) setState(() => _hovered = false);
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (_) {
            if (_interactive) {
              setState(() => _pressed = true);
              _pressAnim.forward();
            }
          },
          onTapUp: (_) {
            if (_interactive) {
              setState(() => _pressed = false);
              _pressAnim.reverse();
            }
          },
          onTapCancel: () {
            if (_interactive) {
              setState(() => _pressed = false);
              _pressAnim.reverse();
            }
          },
          onTap: _interactive ? widget.onToggle : null,
          child: AnimatedBuilder(
            animation: Listenable.merge([_selectAnim, _pressAnim]),
            builder: (context, _) {
              final state = _effectiveState();
              final tokens = _resolveTokens(
                isSelected: widget.isSelected,
                state: state,
                isDark: isDark,
              );
              final scale = 1.0 - 0.02 * _pressAnim.value;
              final dotProgress = CurvedAnimation(
                parent: _selectAnim,
                curve: Curves.easeOut,
                reverseCurve: Curves.easeIn,
              ).value;

              return Opacity(
                opacity: tokens.opacity,
                child: Transform.scale(
                  scale: scale,
                  child: _RadioDot(tokens: tokens, dotProgress: dotProgress),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// ─── HeroUiRadio ──────────────────────────────────────────────────────────────

/// Full radio: control + label + optional description + optional error message.
class HeroUiRadio extends StatelessWidget {
  const HeroUiRadio({
    super.key,
    this.label,
    this.description,
    this.errorMessage,
    this.isSelected = false,
    this.isDisabled = false,
    this.isInvalid = false,
    this.onChanged,
  });

  final String? label;
  final String? description;

  /// Shown below the description when [isInvalid] is `true`.
  final String? errorMessage;

  final bool isSelected;
  final bool isDisabled;
  final bool isInvalid;

  /// Called with `true` when the user selects this radio.
  final VoidCallback? onChanged;

  void _handleToggle() {
    if (onChanged == null || isDisabled || isSelected) return;
    onChanged!();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final labelColor = isInvalid
        ? const Color(0xFFFF383C)
        : (isDark ? const Color(0xFFFCFCFC) : const Color(0xFF18181B));
    final descColor = isDark
        ? const Color(0xFFA1A1AA)
        : const Color(0xFF71717A);

    final hasLabel = label != null;
    final hasDesc = description != null;
    final hasError = isInvalid && errorMessage != null;
    final hasText = hasLabel || hasDesc || hasError;

    final control = HeroUiRadioControl(
      isSelected: isSelected,
      isDisabled: isDisabled,
      isInvalid: isInvalid,
      onToggle: _handleToggle,
    );

    if (!hasText) return control;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(padding: const EdgeInsets.only(top: 1), child: control),
        const SizedBox(width: 12),
        Flexible(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _handleToggle,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 120),
              opacity: isDisabled ? 0.5 : 1.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (hasLabel)
                    Text(
                      label!,
                      style: HeroUiTypography.bodySmMedium.copyWith(
                        color: labelColor,
                      ),
                    ),
                  if (hasDesc) ...[
                    if (hasLabel) const SizedBox(height: 2),
                    Text(
                      description!,
                      style: HeroUiTypography.bodyXs.copyWith(color: descColor),
                    ),
                  ],
                  if (hasError) ...[
                    const SizedBox(height: 2),
                    Text(
                      errorMessage!,
                      style: HeroUiTypography.bodyXs.copyWith(
                        color: const Color(0xFFFF383C),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── HeroUiRadioGroupItem ─────────────────────────────────────────────────────

/// A single item descriptor for [HeroUiRadioGroup].
class HeroUiRadioGroupItem {
  const HeroUiRadioGroupItem({
    required this.value,
    this.label,
    this.description,
    this.isDisabled = false,
  });

  /// Unique string identifier used as the selected value.
  final String value;
  final String? label;
  final String? description;

  /// Overrides the group-level disabled flag for this item.
  final bool isDisabled;
}

// ─── HeroUiRadioGroup ─────────────────────────────────────────────────────────

/// A labelled group of [HeroUiRadio] items with single-selection state.
///
/// Supports vertical and horizontal orientations, disabled, and invalid states.
class HeroUiRadioGroup extends StatelessWidget {
  const HeroUiRadioGroup({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    this.label,
    this.description,
    this.errorMessage,
    this.isDisabled = false,
    this.isInvalid = false,
    this.orientation = HeroUiRadioGroupOrientation.vertical,
  });

  final List<HeroUiRadioGroupItem> items;

  /// The currently selected item value; `null` = nothing selected.
  final String? value;

  /// Called with the new value when the user selects an item.
  final ValueChanged<String> onChanged;

  final String? label;
  final String? description;

  /// Error message shown at the bottom when [isInvalid] is `true`.
  final String? errorMessage;

  final bool isDisabled;
  final bool isInvalid;
  final HeroUiRadioGroupOrientation orientation;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final labelColor = isInvalid
        ? const Color(0xFFFF383C)
        : (isDark ? const Color(0xFFFCFCFC) : const Color(0xFF18181B));
    final descColor = isDark
        ? const Color(0xFFA1A1AA)
        : const Color(0xFF71717A);

    // ── Header ────────────────────────────────────────────────────────────────
    final header = <Widget>[];

    if (label != null) {
      header.add(
        Text(
          label!,
          style: HeroUiTypography.bodySmMedium.copyWith(color: labelColor),
        ),
      );
    }

    if (description != null) {
      header.add(
        Text(
          description!,
          style: HeroUiTypography.bodyXs.copyWith(color: descColor),
        ),
      );
    }

    // ── Items ─────────────────────────────────────────────────────────────────
    final radios = items.map((item) {
      final isItemDisabled = isDisabled || item.isDisabled;
      return HeroUiRadio(
        label: item.label,
        description: item.description,
        isSelected: value == item.value,
        isDisabled: isItemDisabled,
        isInvalid: isInvalid,
        onChanged: isItemDisabled ? null : () => onChanged(item.value),
      );
    }).toList();

    Widget itemsWidget;
    if (orientation == HeroUiRadioGroupOrientation.horizontal) {
      itemsWidget = Wrap(spacing: 16, runSpacing: 12, children: radios);
    } else {
      itemsWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < radios.length; i++) ...[
            if (i > 0) const SizedBox(height: 12),
            radios[i],
          ],
        ],
      );
    }

    // ── Footer (error message) ────────────────────────────────────────────────
    Widget? footer;
    if (isInvalid && errorMessage != null) {
      footer = Text(
        errorMessage!,
        style: HeroUiTypography.bodyXs.copyWith(
          color: isDark ? const Color(0xFFFF6166) : const Color(0xFFFF383C),
        ),
      );
    }

    // ── Assemble ──────────────────────────────────────────────────────────────
    final sections = <Widget>[
      if (header.isNotEmpty)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: header,
        ),
      itemsWidget,
      if (footer != null) footer,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < sections.length; i++) ...[
          if (i > 0) const SizedBox(height: 16),
          sections[i],
        ],
      ],
    );
  }
}

// ─── Private: visual state / tokens ──────────────────────────────────────────

enum _VisualState { defaultState, hover, pressed, focus, disabled, error }

class _RadioTokens {
  const _RadioTokens({
    required this.trackColor,
    required this.borderColor,
    required this.borderWidth,
    required this.opacity,
    required this.showFocusRing,
    required this.showDot,
    required this.dotColor,
  });

  final Color trackColor;
  final Color borderColor;
  final double borderWidth;
  final double opacity;
  final bool showFocusRing;
  final bool showDot;
  final Color dotColor;
}

_RadioTokens _resolveTokens({
  required bool isSelected,
  required _VisualState state,
  required bool isDark,
}) {
  // ── Disabled ──────────────────────────────────────────────────────────────
  if (state == _VisualState.disabled) {
    return _RadioTokens(
      trackColor: isSelected ? const Color(0xFF0485F7) : _unselectedBg(isDark),
      borderColor: isSelected ? const Color(0xFF3592F9) : _borderColor(isDark),
      borderWidth: 1,
      opacity: 0.5,
      showFocusRing: false,
      showDot: isSelected,
      dotColor: const Color(0xFFFCFCFC),
    );
  }

  // ── Error ─────────────────────────────────────────────────────────────────
  if (state == _VisualState.error) {
    return _RadioTokens(
      trackColor: isSelected ? const Color(0xFFFF383C) : _unselectedBg(isDark),
      borderColor: const Color(0xFFFF383C),
      borderWidth: 1,
      opacity: 1,
      showFocusRing: false,
      showDot: isSelected,
      dotColor: const Color(0xFFFCFCFC),
    );
  }

  // ── Selected states ───────────────────────────────────────────────────────
  if (isSelected) {
    return switch (state) {
      _VisualState.hover || _VisualState.pressed => const _RadioTokens(
        trackColor: Color(0xFF3592F9),
        borderColor: Color(0xFF3592F9),
        borderWidth: 1,
        opacity: 1,
        showFocusRing: false,
        showDot: true,
        dotColor: Color(0xFFFCFCFC),
      ),
      _VisualState.focus => const _RadioTokens(
        trackColor: Color(0xFF0485F7),
        borderColor: Color(0xFF3592F9),
        borderWidth: 1,
        opacity: 1,
        showFocusRing: true,
        showDot: true,
        dotColor: Color(0xFFFCFCFC),
      ),
      _ => const _RadioTokens(
        trackColor: Color(0xFF0485F7),
        borderColor: Color(0xFF3592F9),
        borderWidth: 1,
        opacity: 1,
        showFocusRing: false,
        showDot: true,
        dotColor: Color(0xFFFCFCFC),
      ),
    };
  }

  // ── Unselected states ─────────────────────────────────────────────────────
  return switch (state) {
    _VisualState.hover => _RadioTokens(
      trackColor: _unselectedHoverBg(isDark),
      borderColor: _borderColor(isDark),
      borderWidth: 1,
      opacity: 1,
      showFocusRing: false,
      showDot: false,
      dotColor: Colors.transparent,
    ),
    _VisualState.pressed => _RadioTokens(
      trackColor: _unselectedHoverBg(isDark),
      borderColor: const Color(0xFF3592F9),
      borderWidth: 2,
      opacity: 1,
      showFocusRing: false,
      showDot: false,
      dotColor: Colors.transparent,
    ),
    _VisualState.focus => _RadioTokens(
      trackColor: _unselectedHoverBg(isDark),
      borderColor: _borderColor(isDark),
      borderWidth: 1,
      opacity: 1,
      showFocusRing: true,
      showDot: false,
      dotColor: Colors.transparent,
    ),
    _ => _RadioTokens(
      trackColor: _unselectedBg(isDark),
      borderColor: _borderColor(isDark),
      borderWidth: 1,
      opacity: 1,
      showFocusRing: false,
      showDot: false,
      dotColor: Colors.transparent,
    ),
  };
}

Color _unselectedBg(bool isDark) =>
    isDark ? const Color(0xFF27272A) : const Color(0xFFFFFFFF);

Color _unselectedHoverBg(bool isDark) =>
    isDark ? const Color(0xFF3F3F46) : const Color(0xFFF9F9F9);

Color _borderColor(bool isDark) =>
    isDark ? const Color(0xFF52525B) : const Color(0xFFD4D4D8);

// ─── Private: radio dot painter ──────────────────────────────────────────────

class _RadioDot extends StatelessWidget {
  const _RadioDot({required this.tokens, required this.dotProgress});

  final _RadioTokens tokens;
  final double dotProgress;

  @override
  Widget build(BuildContext context) {
    final shadows = tokens.showFocusRing
        ? const <BoxShadow>[
            BoxShadow(color: Color(0xFF0485F7), blurRadius: 0, spreadRadius: 4),
            BoxShadow(color: Color(0xFFF5F5F5), blurRadius: 0, spreadRadius: 2),
          ]
        : const <BoxShadow>[
            BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.06), blurRadius: 1),
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.06),
              offset: Offset(0, 1),
              blurRadius: 2,
            ),
          ];

    return Opacity(
      opacity: tokens.opacity,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: tokens.trackColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: tokens.borderColor,
            width: tokens.borderWidth,
          ),
          boxShadow: shadows,
        ),
        child: tokens.showDot && dotProgress > 0
            ? Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 120),
                  width: 7 * dotProgress,
                  height: 7 * dotProgress,
                  decoration: BoxDecoration(
                    color: tokens.dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
