import 'package:flutter/material.dart';

// ─── Public enums & types ─────────────────────────────────────────────────────

/// Active-track colour variants (Figma: primary=blue, secondary=grey, danger=red).
enum HeroUiSliderColor { primary, secondary, danger }

/// Visual size of the track and thumb.
enum HeroUiSliderSize { sm, md, lg }

/// A single labelled mark rendered below the track.
class HeroUiSliderMark {
  const HeroUiSliderMark({required this.value, required this.label});

  /// The numeric value along [HeroUiSlider.min]…[HeroUiSlider.max].
  final double value;

  /// The string shown below the tick position.
  final String label;
}

// ─── Size tokens ──────────────────────────────────────────────────────────────

class _Tokens {
  const _Tokens({
    required this.trackH,
    required this.thumbW,
    required this.thumbH,
  });

  final double trackH;
  final double thumbW;
  final double thumbH;

  double get totalH => thumbH + 4;

  static _Tokens of(HeroUiSliderSize s) => switch (s) {
    HeroUiSliderSize.sm => const _Tokens(trackH: 2, thumbW: 20, thumbH: 12),
    HeroUiSliderSize.md => const _Tokens(trackH: 4, thumbW: 24, thumbH: 16),
    HeroUiSliderSize.lg => const _Tokens(trackH: 6, thumbW: 28, thumbH: 20),
  };
}

// ─── HeroUiSlider ─────────────────────────────────────────────────────────────

/// HeroUI slider – horizontal, single-value or range.
///
/// Figma node: Slider (2306:2324), light & dark theme.
///
/// Features:
/// - Three sizes: sm / md (default) / lg
/// - Three colour variants: primary (blue) / secondary (grey) / danger (red)
/// - Optional tooltip that appears above the active thumb while dragging
/// - Optional [marks] rendered below the track
/// - Animated thumb press state (thumb shrinks slightly)
/// - Disabled state (0.5 opacity, no interaction)
/// - Range mode: two draggable thumbs via [HeroUiSlider.range]
class HeroUiSlider extends StatefulWidget {
  const HeroUiSlider({
    super.key,
    this.value = 0.5,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.label,
    this.showValue = true,
    this.isDisabled = false,
    this.color = HeroUiSliderColor.primary,
    this.size = HeroUiSliderSize.md,
    this.showTooltip = false,
    this.marks,
    this.onChanged,
    this.formatValue,
  })  : startValue = null,
        endValue = null,
        onRangeChanged = null;

  const HeroUiSlider.range({
    super.key,
    this.startValue = 0.2,
    this.endValue = 0.8,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.label,
    this.showValue = true,
    this.isDisabled = false,
    this.color = HeroUiSliderColor.primary,
    this.size = HeroUiSliderSize.md,
    this.showTooltip = false,
    this.marks,
    this.onRangeChanged,
    this.formatValue,
  })  : value = null,
        onChanged = null;

  final double? value;
  final double? startValue;
  final double? endValue;

  final double min;
  final double max;

  /// Number of discrete steps. `null` = continuous.
  final int? divisions;

  final String? label;

  /// Show the current value label next to the header label.
  final bool showValue;

  final bool isDisabled;

  final HeroUiSliderColor color;
  final HeroUiSliderSize size;

  /// Show a tooltip above the active thumb while the user drags it.
  final bool showTooltip;

  /// Optional tick marks shown below the track.
  final List<HeroUiSliderMark>? marks;

  final ValueChanged<double>? onChanged;
  final ValueChanged<RangeValues>? onRangeChanged;

  /// Custom formatter for value labels. Defaults to 1 decimal (continuous) or
  /// integer (stepped).
  final String Function(double)? formatValue;

  bool get _isRange => startValue != null;

  @override
  State<HeroUiSlider> createState() => _HeroUiSliderState();
}

class _HeroUiSliderState extends State<HeroUiSlider> {
  String _format(double v) {
    if (widget.formatValue != null) return widget.formatValue!(v);
    if (widget.divisions != null) return v.toStringAsFixed(0);
    return v.toStringAsFixed(1);
  }

  double _clamp(double v) => v.clamp(widget.min, widget.max);

  double _snap(double v) {
    if (widget.divisions == null) return _clamp(v);
    final range = widget.max - widget.min;
    final stepSize = range / widget.divisions!;
    final snapped = ((v - widget.min) / stepSize).round() * stepSize + widget.min;
    return _clamp(snapped);
  }

  Color get _activeColor => switch (widget.color) {
    HeroUiSliderColor.primary   => const Color(0xFF0485F7),
    HeroUiSliderColor.secondary => const Color(0xFF71717A),
    HeroUiSliderColor.danger    => const Color(0xFFFF383C),
  };

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDark ? const Color(0xFFFCFCFC) : const Color(0xFF18181B);

    final valueLabel = widget._isRange
        ? '${_format(widget.startValue!)} – ${_format(widget.endValue!)}'
        : _format(widget.value!);

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 120),
      opacity: widget.isDisabled ? 0.5 : 1.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Header ──────────────────────────────────────────────────────────
          if (widget.label != null || widget.showValue) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.label != null)
                  Text(
                    widget.label!,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.43,
                      color: labelColor,
                    ),
                  ),
                if (widget.showValue)
                  Text(
                    valueLabel,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.43,
                      color: labelColor,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
          ],
          // ── Track ────────────────────────────────────────────────────────────
          _SliderTrack(
            value: widget.value,
            startValue: widget.startValue,
            endValue: widget.endValue,
            min: widget.min,
            max: widget.max,
            isDisabled: widget.isDisabled,
            isDark: isDark,
            activeColor: _activeColor,
            size: widget.size,
            showTooltip: widget.showTooltip,
            onChanged: widget.isDisabled ? null : widget.onChanged,
            onRangeChanged: widget.isDisabled ? null : widget.onRangeChanged,
            snap: _snap,
            format: _format,
          ),
          // ── Marks ────────────────────────────────────────────────────────────
          if (widget.marks != null && widget.marks!.isNotEmpty) ...[
            const SizedBox(height: 6),
            _MarksRow(
              marks: widget.marks!,
              min: widget.min,
              max: widget.max,
              isDark: isDark,
              tokens: _Tokens.of(widget.size),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Track ────────────────────────────────────────────────────────────────────

class _SliderTrack extends StatefulWidget {
  const _SliderTrack({
    required this.value,
    required this.startValue,
    required this.endValue,
    required this.min,
    required this.max,
    required this.isDisabled,
    required this.isDark,
    required this.activeColor,
    required this.size,
    required this.showTooltip,
    required this.onChanged,
    required this.onRangeChanged,
    required this.snap,
    required this.format,
  });

  final double? value;
  final double? startValue;
  final double? endValue;
  final double min;
  final double max;
  final bool isDisabled;
  final bool isDark;
  final Color activeColor;
  final HeroUiSliderSize size;
  final bool showTooltip;
  final ValueChanged<double>? onChanged;
  final ValueChanged<RangeValues>? onRangeChanged;
  final double Function(double) snap;
  final String Function(double) format;

  bool get isRange => startValue != null;

  @override
  State<_SliderTrack> createState() => _SliderTrackState();
}

class _SliderTrackState extends State<_SliderTrack> {
  int? _activeThumb;
  bool _isDragging = false;

  double _fraction(double v) =>
      ((v - widget.min) / (widget.max - widget.min)).clamp(0.0, 1.0);

  void _handleTapDown(Offset local, double trackWidth) {
    if (widget.isRange) {
      final raw = local.dx / trackWidth * (widget.max - widget.min) + widget.min;
      final ds = (raw - widget.startValue!).abs();
      final de = (raw - widget.endValue!).abs();
      _activeThumb = ds <= de ? 0 : 1;
    } else {
      _activeThumb = 0;
    }
    setState(() => _isDragging = true);
    _handleMove(local, trackWidth);
  }

  void _handleMove(Offset local, double trackWidth) {
    final raw = local.dx / trackWidth * (widget.max - widget.min) + widget.min;
    final snapped = widget.snap(raw);

    if (!widget.isRange) {
      widget.onChanged?.call(snapped);
      return;
    }
    if (_activeThumb == null) return;

    if (_activeThumb == 0) {
      final ns = snapped.clamp(widget.min, widget.endValue!);
      widget.onRangeChanged?.call(RangeValues(ns, widget.endValue!));
    } else {
      final ne = snapped.clamp(widget.startValue!, widget.max);
      widget.onRangeChanged?.call(RangeValues(widget.startValue!, ne));
    }
  }

  void _handleDragEnd() {
    setState(() {
      _activeThumb = null;
      _isDragging = false;
    });
  }

  Offset _normalise(Offset raw, double thumbW, double trackWidth) => Offset(
        (raw.dx - thumbW / 2).clamp(0.0, trackWidth),
        raw.dy,
      );

  String get _tooltipLabel {
    if (!widget.isRange) return widget.format(widget.value ?? 0);
    return _activeThumb == 1
        ? widget.format(widget.endValue ?? 0)
        : widget.format(widget.startValue ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    final t = _Tokens.of(widget.size);
    final inactive = widget.isDark
        ? const Color(0xFF3F3F46)
        : const Color(0xFFEBEBEC);

    // When tooltip is on, reserve 40 px of space above the track area.
    const tooltipAreaH = 40.0;
    final stackH = widget.showTooltip ? tooltipAreaH + t.totalH : t.totalH;

    return LayoutBuilder(builder: (ctx, constraints) {
      final trackWidth = constraints.maxWidth - t.thumbW;

      // Fraction at the active (or single) thumb.
      final activeFraction = !widget.isRange
          ? _fraction(widget.value ?? 0)
          : _activeThumb == 1
              ? _fraction(widget.endValue ?? 0)
              : _fraction(widget.startValue ?? 0);
      final tooltipThumbCx = t.thumbW / 2 + activeFraction * trackWidth;

      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: widget.isDisabled
            ? null
            : (d) => _handleTapDown(
                  _normalise(d.localPosition, t.thumbW, trackWidth),
                  trackWidth,
                ),
        onTapUp: widget.isDisabled ? null : (_) => _handleDragEnd(),
        onHorizontalDragStart: widget.isDisabled
            ? null
            : (d) {
                if (_activeThumb == null) {
                  _handleTapDown(
                    _normalise(d.localPosition, t.thumbW, trackWidth),
                    trackWidth,
                  );
                }
              },
        onHorizontalDragUpdate: widget.isDisabled
            ? null
            : (d) => _handleMove(
                  _normalise(d.localPosition, t.thumbW, trackWidth),
                  trackWidth,
                ),
        onHorizontalDragEnd:
            widget.isDisabled ? null : (_) => _handleDragEnd(),
        child: SizedBox(
          height: stackH,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // ── Tooltip ─────────────────────────────────────────────────────
              if (widget.showTooltip)
                Positioned(
                  top: 0,
                  left: tooltipThumbCx,
                  child: FractionalTranslation(
                    translation: const Offset(-0.5, 0),
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 120),
                      opacity: _isDragging ? 1.0 : 0.0,
                      child: _Tooltip(
                        label: _tooltipLabel,
                        isDark: widget.isDark,
                      ),
                    ),
                  ),
                ),

              // ── Track + thumbs ───────────────────────────────────────────
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: t.totalH,
                child: Stack(
                  alignment: Alignment.centerLeft,
                  clipBehavior: Clip.none,
                  children: [
                    // Inactive track
                    Positioned(
                      left: t.thumbW / 2,
                      right: t.thumbW / 2,
                      child: Container(
                        height: t.trackH,
                        decoration: BoxDecoration(
                          color: inactive,
                          borderRadius: BorderRadius.circular(t.trackH / 2),
                        ),
                      ),
                    ),

                    // Active track
                    if (!widget.isRange)
                      Positioned(
                        left: t.thumbW / 2,
                        width: _fraction(widget.value!) * trackWidth,
                        child: Container(
                          height: t.trackH,
                          decoration: BoxDecoration(
                            color: widget.activeColor,
                            borderRadius: BorderRadius.circular(t.trackH / 2),
                          ),
                        ),
                      )
                    else
                      Positioned(
                        left: t.thumbW / 2 +
                            _fraction(widget.startValue!) * trackWidth,
                        width: (_fraction(widget.endValue!) -
                                _fraction(widget.startValue!)) *
                            trackWidth,
                        child: Container(
                          height: t.trackH,
                          decoration: BoxDecoration(
                            color: widget.activeColor,
                            borderRadius: BorderRadius.circular(t.trackH / 2),
                          ),
                        ),
                      ),

                    // Thumb(s)
                    if (!widget.isRange)
                      Positioned(
                        left: _fraction(widget.value!) * trackWidth,
                        child: _Thumb(
                          width: t.thumbW,
                          height: t.thumbH,
                          isPressed: _isDragging,
                        ),
                      )
                    else ...[
                      Positioned(
                        left: _fraction(widget.startValue!) * trackWidth,
                        child: _Thumb(
                          width: t.thumbW,
                          height: t.thumbH,
                          isPressed: _isDragging && _activeThumb == 0,
                        ),
                      ),
                      Positioned(
                        left: _fraction(widget.endValue!) * trackWidth,
                        child: _Thumb(
                          width: t.thumbW,
                          height: t.thumbH,
                          isPressed: _isDragging && _activeThumb == 1,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

// ─── Thumb ────────────────────────────────────────────────────────────────────

class _Thumb extends StatelessWidget {
  const _Thumb({
    required this.width,
    required this.height,
    this.isPressed = false,
  });

  final double width;
  final double height;
  final bool isPressed;

  @override
  Widget build(BuildContext context) {
    // Pressed: shrink by 2 px on each axis (matches Figma state=pressed 22×14).
    final w = isPressed ? width - 2 : width;
    final h = isPressed ? height - 2 : height;

    return SizedBox(
      width: width,
      height: height,
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 80),
          width: w,
          height: h,
          decoration: BoxDecoration(
            color: const Color(0xFFFCFCFC),
            borderRadius: BorderRadius.circular(h / 2),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.06),
                blurRadius: 1,
              ),
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.06),
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.04),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Tooltip ─────────────────────────────────────────────────────────────────

/// Small bubble + arrow shown above the dragging thumb.
/// Figma: _TooltipContainer (padding 4×8, borderRadius 12, shadow-overlay).
class _Tooltip extends StatelessWidget {
  const _Tooltip({required this.label, required this.isDark});

  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? const Color(0xFF27272A) : const Color(0xFFFFFFFF);
    final fg = isDark ? const Color(0xFFFCFCFC) : const Color(0xFF18181B);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 28,
                offset: const Offset(0, 14),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.3),
                blurRadius: 0,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: fg,
              fontWeight: FontWeight.w400,
              height: 1.34,
            ),
          ),
        ),
        // Arrow (downward pointing)
        CustomPaint(
          size: const Size(10, 6),
          painter: _ArrowPainter(color: bg),
        ),
      ],
    );
  }
}

class _ArrowPainter extends CustomPainter {
  const _ArrowPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      Path()
        ..moveTo(0, 0)
        ..lineTo(size.width / 2, size.height)
        ..lineTo(size.width, 0)
        ..close(),
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(_ArrowPainter old) => old.color != color;
}

// ─── Marks ────────────────────────────────────────────────────────────────────

/// Row of labels positioned below the track at custom value fractions.
class _MarksRow extends StatelessWidget {
  const _MarksRow({
    required this.marks,
    required this.min,
    required this.max,
    required this.isDark,
    required this.tokens,
  });

  final List<HeroUiSliderMark> marks;
  final double min;
  final double max;
  final bool isDark;
  final _Tokens tokens;

  double _fraction(double v) => ((v - min) / (max - min)).clamp(0.0, 1.0);

  @override
  Widget build(BuildContext context) {
    final color = isDark ? const Color(0xFF71717A) : const Color(0xFF71717A);

    return LayoutBuilder(builder: (ctx, constraints) {
      final trackWidth = constraints.maxWidth - tokens.thumbW;

      return SizedBox(
        width: constraints.maxWidth,
        height: 18,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            for (final mark in marks)
              Positioned(
                left: tokens.thumbW / 2 + _fraction(mark.value) * trackWidth,
                top: 0,
                child: FractionalTranslation(
                  translation: const Offset(-0.5, 0),
                  child: Text(
                    mark.label,
                    style: TextStyle(
                      fontSize: 12,
                      color: color,
                      height: 1.33,
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}
