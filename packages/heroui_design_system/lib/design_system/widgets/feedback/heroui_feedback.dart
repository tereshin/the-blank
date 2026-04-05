import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../typography/heroui_typography.dart';
import '../data_display/heroui_data_display.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// SPINNER
// ═══════════════════════════════════════════════════════════════════════════════

enum HeroUiSpinnerSize { sm, md, lg, xl }

/// An animated circular loading indicator.
///
/// A single circular ring with a transparent-to-solid gradient that rotates.
class HeroUiSpinner extends StatefulWidget {
  const HeroUiSpinner({
    super.key,
    this.size = HeroUiSpinnerSize.md,
    this.type = HeroUiComponentType.accent,
  });

  final HeroUiSpinnerSize size;
  final HeroUiComponentType type;

  @override
  State<HeroUiSpinner> createState() => _HeroUiSpinnerState();
}

class _HeroUiSpinnerState extends State<HeroUiSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final (diameter, strokeW) = switch (widget.size) {
      HeroUiSpinnerSize.sm => (16.0, 2.0),
      HeroUiSpinnerSize.md => (24.0, 3.0),
      HeroUiSpinnerSize.lg => (32.0, 4.0),
      HeroUiSpinnerSize.xl => (40.0, 5.0),
    };

    final activeColor = _typeColor(widget.type);

    return SizedBox(
      width: diameter,
      height: diameter,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) => Transform.rotate(
          angle: _ctrl.value * 2 * math.pi,
          child: CustomPaint(
            painter: _SpinnerPainter(
              activeColor: activeColor,
              strokeWidth: strokeW,
            ),
          ),
        ),
      ),
    );
  }
}

Color _typeColor(HeroUiComponentType type) => switch (type) {
  HeroUiComponentType.defaultType => const Color(0xFF18181B),
  HeroUiComponentType.accent => const Color(0xFF0485F7),
  HeroUiComponentType.success => const Color(0xFF17C964),
  HeroUiComponentType.warning => const Color(0xFFF5A524),
  HeroUiComponentType.danger => const Color(0xFFFF383C),
};

class _SpinnerPainter extends CustomPainter {
  const _SpinnerPainter({required this.activeColor, required this.strokeWidth});

  final Color activeColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final shortestSide = math.min(size.width, size.height);
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (shortestSide - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Single ring with a smooth tail: transparent -> solid color.
    // Draw as almost-full arc so the visible head can have a rounded cap.
    const startAngle = -math.pi / 2;
    const gapAngle = 0.08; // ~4.5°, keeps tail soft while enabling round head
    const sweepAngle = (2 * math.pi) - gapAngle;
    final ringGradient = SweepGradient(
      startAngle: startAngle,
      endAngle: startAngle + sweepAngle,
      colors: [
        activeColor.withValues(alpha: 0),
        activeColor.withValues(alpha: 0.24),
        activeColor.withValues(alpha: 0.62),
        activeColor,
      ],
      stops: const [0.0, 0.62, 0.84, 1.0],
    );

    final ringPaint = Paint()
      ..shader = ringGradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    canvas.drawArc(rect, startAngle, sweepAngle, false, ringPaint);

    // Round cap only on the opaque edge (arc end).
    final endAngle = startAngle + sweepAngle;
    final endPoint = Offset(
      center.dx + math.cos(endAngle) * radius,
      center.dy + math.sin(endAngle) * radius,
    );
    canvas.drawCircle(endPoint, strokeWidth / 2, Paint()..color = activeColor);
  }

  @override
  bool shouldRepaint(_SpinnerPainter old) =>
      old.activeColor != activeColor || old.strokeWidth != strokeWidth;
}

// ═══════════════════════════════════════════════════════════════════════════════
// PROGRESS BAR
// ═══════════════════════════════════════════════════════════════════════════════

enum HeroUiProgressBarSize { sm, md, lg }

/// A horizontal progress bar with an optional label and value text.
///
/// Track heights: sm = 4 px, md = 8 px, lg = 12 px.
class HeroUiProgressBar extends StatelessWidget {
  const HeroUiProgressBar({
    super.key,
    required this.value,
    this.label,
    this.valueLabel,
    this.size = HeroUiProgressBarSize.md,
    this.type = HeroUiComponentType.accent,
    this.isIndeterminate = false,
  });

  /// 0.0–1.0. Ignored when [isIndeterminate] is `true`.
  final double value;
  final String? label;
  final String? valueLabel;
  final HeroUiProgressBarSize size;
  final HeroUiComponentType type;

  /// Shows an animated shimmer instead of a fixed fill.
  final bool isIndeterminate;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDark
        ? const Color(0xFFFCFCFC)
        : const Color(0xFF18181B);
    final trackH = switch (size) {
      HeroUiProgressBarSize.sm => 4.0,
      HeroUiProgressBarSize.md => 8.0,
      HeroUiProgressBarSize.lg => 12.0,
    };
    final fraction = value.clamp(0.0, 1.0);
    final fillColor = _typeColor(type);
    final trackColor = isDark
        ? const Color(0xFF3F3F46)
        : const Color(0xFFEBEBEC);

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
                  style: HeroUiTypography.bodySmMedium.copyWith(
                    color: labelColor,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
        ],
        isIndeterminate
            ? _IndeterminateBar(
                height: trackH,
                color: fillColor,
                trackColor: trackColor,
              )
            : LayoutBuilder(
                builder: (_, c) => Stack(
                  children: [
                    Container(
                      height: trackH,
                      decoration: BoxDecoration(
                        color: trackColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: trackH,
                      width: c.maxWidth * fraction,
                      decoration: BoxDecoration(
                        color: fillColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ],
                ),
              ),
      ],
    );
  }
}

class _IndeterminateBar extends StatefulWidget {
  const _IndeterminateBar({
    required this.height,
    required this.color,
    required this.trackColor,
  });

  final double height;
  final Color color;
  final Color trackColor;

  @override
  State<_IndeterminateBar> createState() => _IndeterminateBarState();
}

class _IndeterminateBarState extends State<_IndeterminateBar>
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
    return LayoutBuilder(
      builder: (_, c) => AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) {
          final t = _ctrl.value;
          final barW = c.maxWidth * 0.4;
          final pos = (c.maxWidth + barW) * t - barW;
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                Container(height: widget.height, color: widget.trackColor),
                Positioned(
                  left: pos,
                  child: Container(
                    width: barW,
                    height: widget.height,
                    decoration: BoxDecoration(
                      color: widget.color,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// PROGRESS CIRCLE
// ═══════════════════════════════════════════════════════════════════════════════

enum HeroUiProgressCircleSize { sm, md, lg }

/// A circular progress indicator with optional label.
///
/// - sm: 20 × 20, 2 px stroke
/// - md: 28 × 28, 3 px stroke
/// - lg: 36 × 36, 4 px stroke
class HeroUiProgressCircle extends StatelessWidget {
  const HeroUiProgressCircle({
    super.key,
    required this.value,
    this.label,
    this.size = HeroUiProgressCircleSize.md,
    this.type = HeroUiComponentType.accent,
  });

  /// 0.0–1.0
  final double value;
  final String? label;
  final HeroUiProgressCircleSize size;
  final HeroUiComponentType type;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDark
        ? const Color(0xFFFCFCFC)
        : const Color(0xFF18181B);

    final (diameter, strokeW) = switch (size) {
      HeroUiProgressCircleSize.sm => (20.0, 2.0),
      HeroUiProgressCircleSize.md => (28.0, 3.0),
      HeroUiProgressCircleSize.lg => (36.0, 4.0),
    };

    final fraction = value.clamp(0.0, 1.0);
    final fillColor = _typeColor(type);
    final trackColor = isDark
        ? const Color(0xFF3F3F46)
        : const Color(0xFFEBEBEC);

    final circle = SizedBox(
      width: diameter,
      height: diameter,
      child: CustomPaint(
        painter: _ProgressCirclePainter(
          progress: fraction,
          trackColor: trackColor,
          fillColor: fillColor,
          strokeWidth: strokeW,
        ),
      ),
    );

    if (label == null) return circle;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        circle,
        const SizedBox(width: 12),
        Text(
          label!,
          style: HeroUiTypography.bodySmMedium.copyWith(color: labelColor),
        ),
      ],
    );
  }
}

class _ProgressCirclePainter extends CustomPainter {
  const _ProgressCirclePainter({
    required this.progress,
    required this.trackColor,
    required this.fillColor,
    required this.strokeWidth,
  });

  final double progress;
  final Color trackColor;
  final Color fillColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Track
    canvas.drawArc(
      rect,
      0,
      2 * math.pi,
      false,
      Paint()
        ..color = trackColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );

    // Fill arc
    if (progress > 0) {
      canvas.drawArc(
        rect,
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        Paint()
          ..color = fillColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(_ProgressCirclePainter old) =>
      old.progress != progress || old.fillColor != fillColor;
}

// ═══════════════════════════════════════════════════════════════════════════════
// ALERT
// ═══════════════════════════════════════════════════════════════════════════════

/// An inline alert banner with title, optional description, and action button.
///
/// Variants: default, accent, success, warning, danger.
class HeroUiAlert extends StatelessWidget {
  const HeroUiAlert({
    super.key,
    required this.title,
    this.description,
    this.type = HeroUiComponentType.defaultType,
    this.actionLabel,
    this.onAction,
    this.onClose,
  });

  final String title;
  final String? description;
  final HeroUiComponentType type;
  final String? actionLabel;
  final VoidCallback? onAction;
  final VoidCallback? onClose;

  IconData _icon() => switch (type) {
    HeroUiComponentType.defaultType => Icons.info_outline_rounded,
    HeroUiComponentType.accent => Icons.info_outline_rounded,
    HeroUiComponentType.success => Icons.check_circle_outline_rounded,
    HeroUiComponentType.warning => Icons.warning_amber_rounded,
    HeroUiComponentType.danger => Icons.error_outline_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final typeColor = _typeColor(type);

    final bg = isDark ? const Color(0xFF18181B) : const Color(0xFFFFFFFF);
    final titleColor = type == HeroUiComponentType.defaultType
        ? (isDark ? const Color(0xFFFCFCFC) : const Color(0xFF18181B))
        : typeColor;
    final descColor = isDark
        ? const Color(0xFFA1A1AA)
        : const Color(0xFF71717A);
    final borderColor = isDark
        ? const Color(0xFF27272A)
        : const Color(0xFFF4F4F5);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Padding(
            padding: const EdgeInsets.only(top: 14),
            child: Icon(_icon(), size: 20, color: typeColor),
          ),
          const SizedBox(width: 8),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: HeroUiTypography.bodySmMedium.copyWith(
                      color: titleColor,
                    ),
                  ),
                  if (description != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      description!,
                      style: HeroUiTypography.bodySm.copyWith(color: descColor),
                    ),
                  ],
                ],
              ),
            ),
          ),
          // Action + close
          if (actionLabel != null || onClose != null) ...[
            const SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (actionLabel != null)
                    GestureDetector(
                      onTap: onAction,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: type == HeroUiComponentType.defaultType
                              ? (isDark
                                    ? const Color(0xFF27272A)
                                    : const Color(0xFFEBEBEC))
                              : typeColor,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Text(
                          actionLabel!,
                          style: HeroUiTypography.buttonSm.copyWith(
                            color: type == HeroUiComponentType.defaultType
                                ? (isDark
                                      ? const Color(0xFFFCFCFC)
                                      : const Color(0xFF18181B))
                                : const Color(0xFFFFFFFF),
                          ),
                        ),
                      ),
                    ),
                  if (onClose != null) ...[
                    if (actionLabel != null) const SizedBox(width: 8),
                    GestureDetector(
                      onTap: onClose,
                      child: Icon(
                        Icons.close_rounded,
                        size: 16,
                        color: descColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// TOAST
// ═══════════════════════════════════════════════════════════════════════════════

/// A transient notification message (toast / snackbar).
///
/// Use [HeroUiToastService] to show toasts imperatively via the overlay.
class HeroUiToast extends StatelessWidget {
  const HeroUiToast({
    super.key,
    required this.message,
    this.description,
    this.type = HeroUiComponentType.defaultType,
    this.actionLabel,
    this.onAction,
    this.onClose,
  });

  final String message;
  final String? description;
  final HeroUiComponentType type;
  final String? actionLabel;
  final VoidCallback? onAction;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final typeColor = _typeColor(type);

    final bg = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFFFFFFF);
    final titleColor = isDark
        ? const Color(0xFFFCFCFC)
        : const Color(0xFF18181B);
    final descColor = isDark
        ? const Color(0xFFA1A1AA)
        : const Color(0xFF71717A);

    return Container(
      constraints: const BoxConstraints(maxWidth: 360),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.08),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.04),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Icon(
              switch (type) {
                HeroUiComponentType.success =>
                  Icons.check_circle_outline_rounded,
                HeroUiComponentType.warning => Icons.warning_amber_rounded,
                HeroUiComponentType.danger => Icons.error_outline_rounded,
                _ => Icons.info_outline_rounded,
              },
              size: 18,
              color: type == HeroUiComponentType.defaultType
                  ? descColor
                  : typeColor,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message,
                    style: HeroUiTypography.bodySmMedium.copyWith(
                      color: titleColor,
                    ),
                  ),
                  if (description != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      description!,
                      style: HeroUiTypography.bodyXs.copyWith(color: descColor),
                    ),
                  ],
                  if (actionLabel != null) ...[
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: onAction,
                      child: Text(
                        actionLabel!,
                        style: HeroUiTypography.bodyXsMedium.copyWith(
                          color: typeColor == const Color(0xFF18181B)
                              ? const Color(0xFF0485F7)
                              : typeColor,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (onClose != null) ...[
            const SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: GestureDetector(
                onTap: onClose,
                child: Icon(Icons.close_rounded, size: 16, color: descColor),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Helper to show a [HeroUiToast] using an [OverlayEntry].
class HeroUiToastService {
  static OverlayEntry? _entry;

  static void show(
    BuildContext context, {
    required String message,
    String? description,
    HeroUiComponentType type = HeroUiComponentType.defaultType,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 3),
  }) {
    _entry?.remove();

    _entry = OverlayEntry(
      builder: (_) => Positioned(
        bottom: 24,
        left: 0,
        right: 0,
        child: Center(
          child: _AnimatedToastWrapper(
            child: HeroUiToast(
              message: message,
              description: description,
              type: type,
              actionLabel: actionLabel,
              onAction: onAction,
              onClose: dismiss,
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_entry!);

    Future.delayed(duration, dismiss);
  }

  static void dismiss() {
    _entry?.remove();
    _entry = null;
  }
}

class _AnimatedToastWrapper extends StatefulWidget {
  const _AnimatedToastWrapper({required this.child});
  final Widget child;

  @override
  State<_AnimatedToastWrapper> createState() => _AnimatedToastWrapperState();
}

class _AnimatedToastWrapperState extends State<_AnimatedToastWrapper>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _opacity = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}
