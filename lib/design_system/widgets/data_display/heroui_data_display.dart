import 'package:flutter/material.dart';

import '../../typography/heroui_typography.dart';

// ─── Shared color tokens ──────────────────────────────────────────────────────

enum HeroUiComponentType { defaultType, accent, success, warning, danger }

Color _typeColor(HeroUiComponentType type) => switch (type) {
  HeroUiComponentType.defaultType => const Color(0xFF18181B),
  HeroUiComponentType.accent => const Color(0xFF0485F7),
  HeroUiComponentType.success => const Color(0xFF17C964),
  HeroUiComponentType.warning => const Color(0xFFF5A524),
  HeroUiComponentType.danger => const Color(0xFFFF383C),
};

Color _typeSoftBg(HeroUiComponentType type) => switch (type) {
  HeroUiComponentType.defaultType => const Color(0x1E18181B),
  HeroUiComponentType.accent => const Color(0x260485F7),
  HeroUiComponentType.success => const Color(0x2617C964),
  HeroUiComponentType.warning => const Color(0x26F5A524),
  HeroUiComponentType.danger => const Color(0x26FF383C),
};

// ═══════════════════════════════════════════════════════════════════════════════
// SEPARATOR
// ═══════════════════════════════════════════════════════════════════════════════

enum HeroUiSeparatorVariant { primary, secondary, tertiary }

enum HeroUiSeparatorOrientation { horizontal, vertical }

/// A separator line, optionally with a centered text label.
///
/// Supports horizontal (default) and vertical orientations, plus three visual
/// weight variants (primary = most prominent, tertiary = lightest).
class HeroUiSeparator extends StatelessWidget {
  const HeroUiSeparator({
    super.key,
    this.label,
    this.variant = HeroUiSeparatorVariant.primary,
    this.orientation = HeroUiSeparatorOrientation.horizontal,
  });

  final String? label;
  final HeroUiSeparatorVariant variant;
  final HeroUiSeparatorOrientation orientation;

  Color _lineColor(bool isDark) {
    if (isDark) {
      return switch (variant) {
        HeroUiSeparatorVariant.primary => const Color(0xFF3F3F46),
        HeroUiSeparatorVariant.secondary => const Color(0xFF27272A),
        HeroUiSeparatorVariant.tertiary => const Color(0xFF18181B),
      };
    }
    return switch (variant) {
      HeroUiSeparatorVariant.primary => const Color(0xFFE4E4E7),
      HeroUiSeparatorVariant.secondary => const Color(0xFFD7D7D7),
      HeroUiSeparatorVariant.tertiary => const Color(0xFFCDCDCE),
    };
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = _lineColor(isDark);
    final textColor = isDark
        ? const Color(0xFFA1A1AA)
        : const Color(0xFF71717A);

    if (orientation == HeroUiSeparatorOrientation.vertical) {
      return IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            VerticalDivider(width: 1, thickness: 1, color: color),
            if (label != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: Text(
                  label!,
                  style: HeroUiTypography.bodyXsMedium.copyWith(
                    color: textColor,
                  ),
                ),
              ),
              VerticalDivider(width: 1, thickness: 1, color: color),
            ],
          ],
        ),
      );
    }

    if (label == null) {
      return Divider(height: 1, thickness: 1, color: color);
    }

    return Row(
      children: [
        Expanded(child: Divider(thickness: 1, color: color)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            label!,
            style: HeroUiTypography.bodyXsMedium.copyWith(color: textColor),
          ),
        ),
        Expanded(child: Divider(thickness: 1, color: color)),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// KBD
// ═══════════════════════════════════════════════════════════════════════════════

enum HeroUiKbdVariant { defaultVariant, light }

/// Keyboard shortcut badge, e.g. `HeroUiKbd(keys: ['⌘', 'K'])`.
class HeroUiKbd extends StatelessWidget {
  const HeroUiKbd({
    super.key,
    required this.keys,
    this.variant = HeroUiKbdVariant.defaultVariant,
  });

  /// List of key labels, e.g. `['⌘', 'K']` or `['⌃', 'Shift', 'P']`.
  final List<String> keys;
  final HeroUiKbdVariant variant;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg = variant == HeroUiKbdVariant.defaultVariant
        ? (isDark ? const Color(0xFF3F3F46) : const Color(0xFFEBEBEC))
        : Colors.transparent;

    final textColor = isDark
        ? const Color(0xFFA1A1AA)
        : const Color(0xFF71717A);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: variant == HeroUiKbdVariant.light
            ? Border.all(
                color: isDark
                    ? const Color(0xFF52525B)
                    : const Color(0xFFD4D4D8),
              )
            : null,
        boxShadow: [
          BoxShadow(color: const Color.fromRGBO(0, 0, 0, 0.06), blurRadius: 1),
          BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < keys.length; i++) ...[
            if (i > 0) const SizedBox(width: 2),
            Text(
              keys[i],
              style: HeroUiTypography.bodySmMedium.copyWith(color: textColor),
            ),
          ],
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// AVATAR
// ═══════════════════════════════════════════════════════════════════════════════

enum HeroUiAvatarVariant { letter, letterSoft, icon, iconSoft, img }

TextStyle _avatarLabelStyle(double size) {
  if (size <= 24) return HeroUiTypography.bodyXsMedium;
  if (size <= 36) return HeroUiTypography.bodySmMedium;
  return HeroUiTypography.bodyBaseMedium;
}

/// A circular avatar that can display initials, an icon, or an image.
class HeroUiAvatar extends StatelessWidget {
  const HeroUiAvatar({
    super.key,
    this.initials,
    this.imageUrl,
    this.imageProvider,
    this.icon,
    this.type = HeroUiComponentType.defaultType,
    this.variant = HeroUiAvatarVariant.letter,
    this.size = 36,
  });

  /// 1–2 character initials. Used for [HeroUiAvatarVariant.letter] /
  /// [HeroUiAvatarVariant.letterSoft].
  final String? initials;

  /// Network image URL. Used for [HeroUiAvatarVariant.img].
  final String? imageUrl;

  /// Custom image provider. Used for [HeroUiAvatarVariant.img].
  final ImageProvider? imageProvider;

  /// Custom icon widget. Falls back to a default person icon for
  /// [HeroUiAvatarVariant.icon] / [HeroUiAvatarVariant.iconSoft].
  final Widget? icon;

  final HeroUiComponentType type;
  final HeroUiAvatarVariant variant;

  /// Diameter in logical pixels. Default: 36.
  final double size;

  Color _bg() => switch (variant) {
    HeroUiAvatarVariant.letterSoft ||
    HeroUiAvatarVariant.iconSoft => _typeSoftBg(type),
    HeroUiAvatarVariant.img => Colors.transparent,
    _ =>
      type == HeroUiComponentType.defaultType
          ? const Color(0xFFEBEBEC)
          : const Color(0xFFEBEBEC),
  };

  Color _fg() => switch (type) {
    HeroUiComponentType.defaultType => const Color(0xFF18181B),
    _ => _typeColor(type),
  };

  @override
  Widget build(BuildContext context) {
    Widget content;

    switch (variant) {
      case HeroUiAvatarVariant.img:
        ImageProvider? provider;
        if (imageProvider != null) {
          provider = imageProvider;
        } else if (imageUrl != null) {
          provider = NetworkImage(imageUrl!);
        }
        content = provider != null
            ? CircleAvatar(
                radius: size / 2,
                backgroundImage: provider,
                backgroundColor: const Color(0xFFEBEBEC),
              )
            : _PlaceholderAvatar(size: size, bg: _bg(), fg: _fg());
        return content;

      case HeroUiAvatarVariant.icon:
      case HeroUiAvatarVariant.iconSoft:
        final iconSize = size * 0.44;
        content =
            icon ??
            Icon(Icons.person_outline_rounded, size: iconSize, color: _fg());
        break;

      case HeroUiAvatarVariant.letter:
      case HeroUiAvatarVariant.letterSoft:
        content = Text(
          (initials ?? 'AG').toUpperCase().substring(
            0,
            (initials?.length ?? 2).clamp(1, 2),
          ),
          style: _avatarLabelStyle(size).copyWith(color: _fg()),
        );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: _bg(), shape: BoxShape.circle),
      alignment: Alignment.center,
      child: content,
    );
  }
}

class _PlaceholderAvatar extends StatelessWidget {
  const _PlaceholderAvatar({
    required this.size,
    required this.bg,
    required this.fg,
  });

  final double size;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Icon(Icons.person_outline_rounded, size: size * 0.44, color: fg),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// BADGE
// ═══════════════════════════════════════════════════════════════════════════════

enum HeroUiBadgeVariant { primary, secondary, soft }

enum HeroUiBadgeSize { sm, md, lg }

/// A compact status/label indicator badge.
///
/// Variants:
/// - **primary** – solid filled background
/// - **secondary** – subtle bordered style
/// - **soft** – translucent tinted background
class HeroUiBadge extends StatelessWidget {
  const HeroUiBadge({
    super.key,
    required this.label,
    this.variant = HeroUiBadgeVariant.primary,
    this.type = HeroUiComponentType.defaultType,
    this.size = HeroUiBadgeSize.md,
    this.startIcon,
    this.endIcon,
  });

  final String label;
  final HeroUiBadgeVariant variant;
  final HeroUiComponentType type;
  final HeroUiBadgeSize size;
  final Widget? startIcon;
  final Widget? endIcon;

  _BadgeTokens _tokens(bool isDark) {
    final typeColor = _typeColor(type);

    return switch (variant) {
      HeroUiBadgeVariant.primary => _BadgeTokens(
        bg: typeColor,
        text: type == HeroUiComponentType.defaultType
            ? const Color(0xFFFFFFFF)
            : const Color(0xFFFFFFFF),
        border: null,
      ),
      HeroUiBadgeVariant.secondary => _BadgeTokens(
        bg: isDark ? const Color(0xFF27272A) : const Color(0xFFEBEBEC),
        text: typeColor == const Color(0xFF18181B)
            ? (isDark ? const Color(0xFFA1A1AA) : const Color(0xFF71717A))
            : typeColor,
        border: isDark ? const Color(0xFF3F3F46) : const Color(0xFFD4D4D8),
      ),
      HeroUiBadgeVariant.soft => _BadgeTokens(
        bg: _typeSoftBg(type),
        text: typeColor == const Color(0xFF18181B)
            ? (isDark ? const Color(0xFFA1A1AA) : const Color(0xFF71717A))
            : typeColor,
        border: null,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tokens = _tokens(isDark);

    final (textStyle, iconSize, padding, radius) = switch (size) {
      HeroUiBadgeSize.sm => (
        HeroUiTypography.bodyXsMedium,
        8.0,
        const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
        12.0,
      ),
      HeroUiBadgeSize.md => (
        HeroUiTypography.bodyXsMedium,
        10.0,
        const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        24.0,
      ),
      HeroUiBadgeSize.lg => (
        HeroUiTypography.bodySmMedium,
        12.0,
        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        16.0,
      ),
    };

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: tokens.bg,
        borderRadius: BorderRadius.circular(radius),
        border: tokens.border != null
            ? Border.all(color: tokens.border!, width: 1)
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (startIcon != null) ...[
            IconTheme(
              data: IconThemeData(size: iconSize, color: tokens.text),
              child: startIcon!,
            ),
            const SizedBox(width: 2),
          ],
          Text(label, style: textStyle.copyWith(color: tokens.text)),
          if (endIcon != null) ...[
            const SizedBox(width: 2),
            IconTheme(
              data: IconThemeData(size: iconSize, color: tokens.text),
              child: endIcon!,
            ),
          ],
        ],
      ),
    );
  }
}

class _BadgeTokens {
  const _BadgeTokens({required this.bg, required this.text, this.border});
  final Color bg;
  final Color text;
  final Color? border;
}

// ═══════════════════════════════════════════════════════════════════════════════
// CHIP
// ═══════════════════════════════════════════════════════════════════════════════

enum HeroUiChipVariant { primary, secondary, soft, tertiary }

enum HeroUiChipSize { sm, md, lg }

/// An interactive chip/tag with optional close button.
///
/// Similar to [HeroUiBadge] but interactive — tappable and optionally closeable.
class HeroUiChip extends StatefulWidget {
  const HeroUiChip({
    super.key,
    required this.label,
    this.variant = HeroUiChipVariant.primary,
    this.type = HeroUiComponentType.defaultType,
    this.size = HeroUiChipSize.md,
    this.startIcon,
    this.isCloseable = false,
    this.isDisabled = false,
    this.isSelected = false,
    this.onClose,
    this.onTap,
  });

  final String label;
  final HeroUiChipVariant variant;
  final HeroUiComponentType type;
  final HeroUiChipSize size;
  final Widget? startIcon;
  final bool isCloseable;
  final bool isDisabled;
  final bool isSelected;
  final VoidCallback? onClose;
  final VoidCallback? onTap;

  @override
  State<HeroUiChip> createState() => _HeroUiChipState();
}

class _HeroUiChipState extends State<HeroUiChip> {
  bool _hovered = false;
  bool _pressed = false;

  _ChipTokens _tokens(bool isDark) {
    final typeColor = _typeColor(widget.type);
    final isInteractive = widget.onTap != null && !widget.isDisabled;
    final highlight = isInteractive && (_hovered || _pressed);

    return switch (widget.variant) {
      HeroUiChipVariant.primary => _ChipTokens(
        bg: widget.isSelected
            ? (highlight ? const Color(0xFF3592F9) : const Color(0xFF0485F7))
            : (highlight
                  ? (isDark ? const Color(0xFF3F3F46) : const Color(0xFFD4D4D8))
                  : (isDark
                        ? const Color(0xFF27272A)
                        : const Color(0xFFEBEBEC))),
        text: widget.isSelected
            ? const Color(0xFFFFFFFF)
            : (isDark ? const Color(0xFFFCFCFC) : const Color(0xFF18181B)),
        border: null,
      ),
      HeroUiChipVariant.secondary => _ChipTokens(
        bg: highlight
            ? (isDark ? const Color(0xFF27272A) : const Color(0xFFE4E4E7))
            : (isDark ? const Color(0xFF18181B) : const Color(0xFFFFFFFF)),
        text: typeColor == const Color(0xFF18181B)
            ? (isDark ? const Color(0xFFFCFCFC) : const Color(0xFF18181B))
            : typeColor,
        border: isDark ? const Color(0xFF3F3F46) : const Color(0xFFD4D4D8),
      ),
      HeroUiChipVariant.soft => _ChipTokens(
        bg: _typeSoftBg(widget.type),
        text: typeColor == const Color(0xFF18181B)
            ? (isDark ? const Color(0xFFA1A1AA) : const Color(0xFF71717A))
            : typeColor,
        border: null,
      ),
      HeroUiChipVariant.tertiary => _ChipTokens(
        bg: Colors.transparent,
        text: typeColor == const Color(0xFF18181B)
            ? (isDark ? const Color(0xFFFCFCFC) : const Color(0xFF18181B))
            : typeColor,
        border: null,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tokens = _tokens(isDark);

    final (
      textStyle,
      iconSize,
      padding,
      radius,
      closeSize,
    ) = switch (widget.size) {
      HeroUiChipSize.sm => (
        HeroUiTypography.bodyXsMedium,
        8.0,
        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        10.0,
        12.0,
      ),
      HeroUiChipSize.md => (
        HeroUiTypography.bodyXsMedium,
        12.0,
        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        24.0,
        14.0,
      ),
      HeroUiChipSize.lg => (
        HeroUiTypography.bodySmMedium,
        14.0,
        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        16.0,
        16.0,
      ),
    };

    return Opacity(
      opacity: widget.isDisabled ? 0.5 : 1.0,
      child: MouseRegion(
        cursor: (widget.onTap != null && !widget.isDisabled)
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        onEnter: (_) {
          if (!widget.isDisabled) setState(() => _hovered = true);
        },
        onExit: (_) {
          if (!widget.isDisabled) setState(() => _hovered = false);
        },
        child: GestureDetector(
          onTapDown: (_) {
            if (!widget.isDisabled) setState(() => _pressed = true);
          },
          onTapUp: (_) {
            if (!widget.isDisabled) setState(() => _pressed = false);
          },
          onTapCancel: () {
            if (!widget.isDisabled) setState(() => _pressed = false);
          },
          onTap: widget.isDisabled ? null : widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            padding: padding,
            decoration: BoxDecoration(
              color: tokens.bg,
              borderRadius: BorderRadius.circular(radius),
              border: tokens.border != null
                  ? Border.all(color: tokens.border!, width: 1)
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.startIcon != null) ...[
                  IconTheme(
                    data: IconThemeData(size: iconSize, color: tokens.text),
                    child: widget.startIcon!,
                  ),
                  const SizedBox(width: 4),
                ],
                Text(
                  widget.label,
                  style: textStyle.copyWith(color: tokens.text),
                ),
                if (widget.isCloseable) ...[
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: widget.isDisabled ? null : widget.onClose,
                    child: Icon(
                      Icons.close_rounded,
                      size: closeSize,
                      color: tokens.text,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChipTokens {
  const _ChipTokens({required this.bg, required this.text, this.border});
  final Color bg;
  final Color text;
  final Color? border;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SKELETON
// ═══════════════════════════════════════════════════════════════════════════════

/// An animated shimmer placeholder for loading states.
class HeroUiSkeleton extends StatefulWidget {
  const HeroUiSkeleton({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius,
    this.isCircle = false,
  });

  const HeroUiSkeleton.circle({
    super.key,
    this.width = 40,
    this.height = 40,
    this.borderRadius,
  }) : isCircle = true;

  final double? width;
  final double height;
  final double? borderRadius;
  final bool isCircle;

  @override
  State<HeroUiSkeleton> createState() => _HeroUiSkeletonState();
}

class _HeroUiSkeletonState extends State<HeroUiSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = isDark ? const Color(0xFF27272A) : const Color(0xFFE4E4E7);
    final shine = isDark ? const Color(0xFF3F3F46) : const Color(0xFFF4F4F5);

    final br = widget.isCircle
        ? BorderRadius.circular(1000)
        : BorderRadius.circular(widget.borderRadius ?? 8);

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: br,
            gradient: LinearGradient(
              begin: Alignment(-2 + 4 * _ctrl.value, 0),
              end: Alignment(-1 + 4 * _ctrl.value, 0),
              colors: [base, shine, base],
              stops: const [0, 0.5, 1],
            ),
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// METER
// ═══════════════════════════════════════════════════════════════════════════════

/// A labeled measurement indicator (filled bar).
///
/// Unlike a progress bar, a meter visualises a static current value against
/// a min/max scale — e.g. storage used, battery level.
class HeroUiMeter extends StatelessWidget {
  const HeroUiMeter({
    super.key,
    required this.value,
    this.min = 0.0,
    this.max = 1.0,
    this.label,
    this.valueLabel,
    this.type = HeroUiComponentType.accent,
  });

  final double value;
  final double min;
  final double max;
  final String? label;
  final String? valueLabel;
  final HeroUiComponentType type;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fraction = ((value - min) / (max - min)).clamp(0.0, 1.0);
    final trackColor = isDark
        ? const Color(0xFF3F3F46)
        : const Color(0xFFE4E4E7);
    final fillColor = _typeColor(type);
    final labelColor = isDark
        ? const Color(0xFFFCFCFC)
        : const Color(0xFF18181B);
    final subColor = isDark ? const Color(0xFFA1A1AA) : const Color(0xFF71717A);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null || valueLabel != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (label != null)
                Text(
                  label!,
                  style: HeroUiTypography.bodySmMedium.copyWith(
                    color: labelColor,
                  ),
                ),
              if (valueLabel != null)
                Text(
                  valueLabel!,
                  style: HeroUiTypography.bodyXs.copyWith(color: subColor),
                ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: trackColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 8,
                  width: constraints.maxWidth * fraction,
                  decoration: BoxDecoration(
                    color: fillColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
