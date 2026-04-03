import 'package:flutter/material.dart';

import '../../typography/heroui_typography.dart';

// ─── Public enums ─────────────────────────────────────────────────────────────

enum HeroUiCheckboxVariant { primary, secondary }

/// The three possible values of a checkbox indicator.
enum HeroUiCheckboxValue { unselected, selected, indeterminate }

// ─── HeroUiCheckboxControl ────────────────────────────────────────────────────

/// Raw 16×16 animated checkbox indicator.
///
/// Manages hover, press and focus interaction states internally.
/// Use [HeroUiCheckbox] for the full component with label and description.
class HeroUiCheckboxControl extends StatefulWidget {
  const HeroUiCheckboxControl({
    super.key,
    this.value = HeroUiCheckboxValue.unselected,
    this.variant = HeroUiCheckboxVariant.primary,
    this.isDisabled = false,
    this.isInvalid = false,
    this.onToggle,
  });

  final HeroUiCheckboxValue value;
  final HeroUiCheckboxVariant variant;
  final bool isDisabled;
  final bool isInvalid;

  /// Called when the user taps. The parent is responsible for updating [value].
  final VoidCallback? onToggle;

  @override
  State<HeroUiCheckboxControl> createState() => _HeroUiCheckboxControlState();
}

class _HeroUiCheckboxControlState extends State<HeroUiCheckboxControl>
    with TickerProviderStateMixin {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  late final AnimationController _checkAnim;
  late final AnimationController _pressAnim;

  @override
  void initState() {
    super.initState();
    _checkAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
      value: _isChecked ? 1.0 : 0.0,
    );
    _pressAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
    );
  }

  @override
  void didUpdateWidget(HeroUiCheckboxControl old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value) {
      _isChecked ? _checkAnim.forward() : _checkAnim.reverse();
    }
  }

  @override
  void dispose() {
    _checkAnim.dispose();
    _pressAnim.dispose();
    super.dispose();
  }

  bool get _isChecked =>
      widget.value == HeroUiCheckboxValue.selected ||
      widget.value == HeroUiCheckboxValue.indeterminate;

  bool get _interactive => !widget.isDisabled;

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
            animation: Listenable.merge([_checkAnim, _pressAnim]),
            builder: (context, _) {
              final visualState = _effectiveVisualState();
              final tokens = _resolveTokens(
                variant: widget.variant,
                value: widget.value,
                state: visualState,
                isDark: isDark,
              );
              final scale = 1.0 - 0.02 * _pressAnim.value;
              final checkProgress = CurvedAnimation(
                parent: _checkAnim,
                curve: Curves.easeOut,
                reverseCurve: Curves.easeIn,
              ).value;

              return Opacity(
                opacity: tokens.opacity,
                child: Transform.scale(
                  scale: scale,
                  child: _CheckboxBox(
                    tokens: tokens,
                    checkProgress: checkProgress,
                    value: widget.value,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  _VisualState _effectiveVisualState() {
    if (widget.isDisabled) return _VisualState.disabled;
    if (widget.isInvalid) return _VisualState.error;
    if (_pressed) return _VisualState.pressed;
    if (_focused) return _VisualState.focus;
    if (_hovered) return _VisualState.hover;
    return _VisualState.defaultState;
  }
}

// ─── HeroUiCheckbox ───────────────────────────────────────────────────────────

/// Full checkbox: control + label + description + optional error message.
///
/// Set [value] to `null` for the indeterminate state.
/// Tapping the label area also triggers [onChanged].
class HeroUiCheckbox extends StatefulWidget {
  const HeroUiCheckbox({
    super.key,
    this.label,
    this.description,
    this.errorMessage,
    this.value = false,
    this.isDisabled = false,
    this.isInvalid = false,
    this.variant = HeroUiCheckboxVariant.primary,
    this.onChanged,
  });

  /// `null` → indeterminate, `true` → checked, `false` → unchecked.
  final bool? value;

  final String? label;
  final String? description;

  /// Shown below the description when [isInvalid] is `true`.
  final String? errorMessage;

  final bool isDisabled;
  final bool isInvalid;
  final HeroUiCheckboxVariant variant;

  /// Called with the next boolean value on user interaction.
  /// Indeterminate taps resolve to `true`; checked taps resolve to `false`.
  final ValueChanged<bool>? onChanged;

  @override
  State<HeroUiCheckbox> createState() => _HeroUiCheckboxState();
}

class _HeroUiCheckboxState extends State<HeroUiCheckbox> {
  HeroUiCheckboxValue get _controlValue {
    if (widget.value == null) return HeroUiCheckboxValue.indeterminate;
    return widget.value!
        ? HeroUiCheckboxValue.selected
        : HeroUiCheckboxValue.unselected;
  }

  void _handleToggle() {
    if (widget.onChanged == null || widget.isDisabled) return;
    // null/false → true; true → false
    widget.onChanged!(widget.value != true);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isInvalid = widget.isInvalid;

    final labelColor = isInvalid
        ? const Color(0xFFFF383C)
        : (isDark ? const Color(0xFFFCFCFC) : const Color(0xFF18181B));
    final descColor = isDark
        ? const Color(0xFFA1A1AA)
        : const Color(0xFF71717A);

    final hasLabel = widget.label != null;
    final hasDesc = widget.description != null;
    final hasError = isInvalid && widget.errorMessage != null;
    final hasText = hasLabel || hasDesc || hasError;

    final control = HeroUiCheckboxControl(
      value: _controlValue,
      variant: widget.variant,
      isDisabled: widget.isDisabled,
      isInvalid: isInvalid,
      onToggle: _handleToggle,
    );

    if (!hasText) return control;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(padding: const EdgeInsets.only(top: 2), child: control),
        const SizedBox(width: 8),
        Flexible(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _handleToggle,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 120),
              opacity: widget.isDisabled ? 0.5 : 1.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (hasLabel)
                    Text(
                      widget.label!,
                      style: HeroUiTypography.bodySmMedium.copyWith(
                        color: labelColor,
                      ),
                    ),
                  if (hasDesc) ...[
                    if (hasLabel) const SizedBox(height: 2),
                    Text(
                      widget.description!,
                      style: HeroUiTypography.bodySm.copyWith(color: descColor),
                    ),
                  ],
                  if (hasError) ...[
                    const SizedBox(height: 2),
                    Text(
                      widget.errorMessage!,
                      style: HeroUiTypography.bodySm.copyWith(
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

// ─── Private: visual box ─────────────────────────────────────────────────────

class _CheckboxBox extends StatelessWidget {
  const _CheckboxBox({
    required this.tokens,
    required this.checkProgress,
    required this.value,
  });

  final _BoxTokens tokens;
  final double checkProgress;
  final HeroUiCheckboxValue value;

  @override
  Widget build(BuildContext context) {
    final shadows = tokens.showFocusRing
        ? const <BoxShadow>[
            BoxShadow(color: Color(0xFF0485F7), blurRadius: 0, spreadRadius: 4),
            BoxShadow(color: Color(0xFFF5F5F5), blurRadius: 0, spreadRadius: 2),
          ]
        : const <BoxShadow>[
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.06),
              blurRadius: 1,
              offset: Offset(0, 1),
            ),
          ];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: tokens.bg,
        borderRadius: BorderRadius.circular(6),
        border: tokens.borderColor != Colors.transparent
            ? Border.all(color: tokens.borderColor, width: tokens.borderWidth)
            : null,
        boxShadow: shadows,
      ),
      child: checkProgress > 0
          ? ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: CustomPaint(
                painter: _IconPainter(value: value, progress: checkProgress),
              ),
            )
          : null,
    );
  }
}

// ─── Private: icon painter ───────────────────────────────────────────────────

class _IconPainter extends CustomPainter {
  const _IconPainter({required this.value, required this.progress});

  final HeroUiCheckboxValue value;

  /// 0.0 = invisible, 1.0 = fully drawn.
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFCFCFC)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    if (value == HeroUiCheckboxValue.indeterminate) {
      final x1 = 3.5 * w / 16;
      final x2 = 12.5 * w / 16;
      final y = 8.0 * h / 16;
      final xEnd = x1 + (x2 - x1) * progress;
      canvas.drawLine(Offset(x1, y), Offset(xEnd, y), paint);
    } else {
      // Checkmark path in 16×16 space:
      // left (3.9, 8.0) → bottom (6.5, 11.0) → top-right (12.1, 5.0)
      final path = Path()
        ..moveTo(3.9 * w / 16, 8.0 * h / 16)
        ..lineTo(6.5 * w / 16, 11.0 * h / 16)
        ..lineTo(12.1 * w / 16, 5.0 * h / 16);

      final metrics = path.computeMetrics().toList();
      if (metrics.isEmpty) return;
      final totalLen = metrics.fold(0.0, (sum, m) => sum + m.length);
      final drawn = totalLen * progress;
      var remaining = drawn;
      for (final metric in metrics) {
        final take = remaining.clamp(0.0, metric.length);
        if (take > 0) {
          canvas.drawPath(metric.extractPath(0, take), paint);
        }
        remaining -= take;
        if (remaining <= 0) break;
      }
    }
  }

  @override
  bool shouldRepaint(_IconPainter old) =>
      old.progress != progress || old.value != value;
}

// ─── Private: design tokens ──────────────────────────────────────────────────

enum _VisualState { defaultState, hover, pressed, focus, disabled, error }

class _BoxTokens {
  const _BoxTokens({
    required this.bg,
    required this.borderColor,
    required this.borderWidth,
    required this.opacity,
    required this.showFocusRing,
  });

  final Color bg;
  final Color borderColor;
  final double borderWidth;
  final double opacity;
  final bool showFocusRing;
}

_BoxTokens _resolveTokens({
  required HeroUiCheckboxVariant variant,
  required HeroUiCheckboxValue value,
  required _VisualState state,
  required bool isDark,
}) {
  final isChecked =
      value == HeroUiCheckboxValue.selected ||
      value == HeroUiCheckboxValue.indeterminate;

  // ── Disabled ──────────────────────────────────────────────────────────────
  if (state == _VisualState.disabled) {
    return _BoxTokens(
      bg: isChecked
          ? const Color(0xFF0485F7)
          : _unselectedDefaultBg(variant, isDark),
      borderColor: isChecked ? const Color(0xFF3592F9) : Colors.transparent,
      borderWidth: 1,
      opacity: 0.5,
      showFocusRing: false,
    );
  }

  // ── Error ─────────────────────────────────────────────────────────────────
  if (state == _VisualState.error) {
    return _BoxTokens(
      bg: isChecked
          ? const Color(0xFFFF383C)
          : _unselectedDefaultBg(variant, isDark),
      borderColor: const Color(0xFFFF383C),
      borderWidth: 1,
      opacity: 1,
      showFocusRing: false,
    );
  }

  // ── Checked states ────────────────────────────────────────────────────────
  if (isChecked) {
    return switch (state) {
      _VisualState.hover => const _BoxTokens(
        bg: Color(0xFF3592F9),
        borderColor: Color(0xFF3592F9),
        borderWidth: 1,
        opacity: 1,
        showFocusRing: false,
      ),
      _VisualState.pressed => const _BoxTokens(
        bg: Color(0xFF3592F9),
        borderColor: Color(0xFF3592F9),
        borderWidth: 1,
        opacity: 1,
        showFocusRing: false,
      ),
      _VisualState.focus => const _BoxTokens(
        bg: Color(0xFF0485F7),
        borderColor: Color(0xFF3592F9),
        borderWidth: 1,
        opacity: 1,
        showFocusRing: true,
      ),
      _ => const _BoxTokens(
        bg: Color(0xFF0485F7),
        borderColor: Color(0xFF3592F9),
        borderWidth: 1,
        opacity: 1,
        showFocusRing: false,
      ),
    };
  }

  // ── Unchecked states ──────────────────────────────────────────────────────
  return switch (state) {
    _VisualState.hover => _BoxTokens(
      bg: _unselectedHoverBg(variant, isDark),
      borderColor: Colors.transparent,
      borderWidth: 1,
      opacity: 1,
      showFocusRing: false,
    ),
    _VisualState.pressed => _BoxTokens(
      bg: _unselectedHoverBg(variant, isDark),
      borderColor: const Color(0xFF3592F9),
      borderWidth: 2,
      opacity: 1,
      showFocusRing: false,
    ),
    _VisualState.focus => _BoxTokens(
      bg: _unselectedHoverBg(variant, isDark),
      borderColor: Colors.transparent,
      borderWidth: 1,
      opacity: 1,
      showFocusRing: true,
    ),
    _ => _BoxTokens(
      bg: _unselectedDefaultBg(variant, isDark),
      borderColor: Colors.transparent,
      borderWidth: 1,
      opacity: 1,
      showFocusRing: false,
    ),
  };
}

Color _unselectedDefaultBg(HeroUiCheckboxVariant variant, bool isDark) {
  if (isDark) {
    return variant == HeroUiCheckboxVariant.primary
        ? const Color(0xFF27272A)
        : const Color(0xFF3F3F46);
  }
  return variant == HeroUiCheckboxVariant.primary
      ? const Color(0xFFFFFFFF)
      : const Color(0xFFEBEBEC);
}

Color _unselectedHoverBg(HeroUiCheckboxVariant variant, bool isDark) {
  if (isDark) {
    return variant == HeroUiCheckboxVariant.primary
        ? const Color(0xFF3F3F46)
        : const Color(0xFF52525B);
  }
  return variant == HeroUiCheckboxVariant.primary
      ? Color.fromRGBO(249, 249, 249, 0.92)
      : const Color(0xFFE1E1E2);
}

// ─── HeroUiCheckboxGroupItem ──────────────────────────────────────────────────

/// A single item descriptor for [HeroUiCheckboxGroup].
class HeroUiCheckboxGroupItem {
  const HeroUiCheckboxGroupItem({
    required this.value,
    this.label,
    this.description,
    this.isDisabled = false,
  });

  /// Unique string identifier used in [HeroUiCheckboxGroup.values].
  final String value;
  final String? label;
  final String? description;

  /// Overrides the group-level [HeroUiCheckboxGroup.isDisabled] for this item.
  final bool isDisabled;
}

// ─── HeroUiCheckboxGroup ──────────────────────────────────────────────────────

enum HeroUiCheckboxGroupOrientation { vertical, horizontal }

/// A labelled group of [HeroUiCheckbox] items with shared selection state.
///
/// Supports vertical and horizontal orientations, disabled, and invalid states.
/// The group label turns red when [isInvalid] is `true`, matching the Figma spec.
class HeroUiCheckboxGroup extends StatelessWidget {
  const HeroUiCheckboxGroup({
    super.key,
    required this.items,
    required this.values,
    required this.onChanged,
    this.label,
    this.description,
    this.errorMessage,
    this.isDisabled = false,
    this.isInvalid = false,
    this.orientation = HeroUiCheckboxGroupOrientation.vertical,
    this.variant = HeroUiCheckboxVariant.primary,
  });

  final List<HeroUiCheckboxGroupItem> items;

  /// The set of currently selected item values.
  final Set<String> values;

  /// Called with the full updated set every time a checkbox is toggled.
  final ValueChanged<Set<String>> onChanged;

  final String? label;

  /// Helper text shown below the group label.
  final String? description;

  /// Error message shown below the items when [isInvalid] is `true`.
  final String? errorMessage;

  final bool isDisabled;
  final bool isInvalid;
  final HeroUiCheckboxGroupOrientation orientation;
  final HeroUiCheckboxVariant variant;

  void _handleItemToggle(String itemValue, bool checked) {
    final next = Set<String>.from(values);
    if (checked) {
      next.add(itemValue);
    } else {
      next.remove(itemValue);
    }
    onChanged(next);
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
    final checkboxes = items.map((item) {
      final isItemDisabled = isDisabled || item.isDisabled;
      return HeroUiCheckbox(
        label: item.label,
        description: item.description,
        value: values.contains(item.value),
        isDisabled: isItemDisabled,
        isInvalid: isInvalid,
        variant: variant,
        onChanged: isItemDisabled
            ? null
            : (checked) => _handleItemToggle(item.value, checked),
      );
    }).toList();

    Widget itemsWidget;
    if (orientation == HeroUiCheckboxGroupOrientation.horizontal) {
      itemsWidget = Wrap(spacing: 16, runSpacing: 12, children: checkboxes);
    } else {
      itemsWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < checkboxes.length; i++) ...[
            if (i > 0) const SizedBox(height: 12),
            checkboxes[i],
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
      ?footer,
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
