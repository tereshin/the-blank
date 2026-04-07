import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../typography/heroui_typography.dart';

// ─── Design Tokens ────────────────────────────────────────────────────────────
const Color _kForeground = Color(0xFF18181B);
const Color _kMuted = Color(0xFF71717A);
const Color _kDivider = Color(0xFFE4E4E7);
const List<BoxShadow> _kOverlayShadow = [
  BoxShadow(color: Color(0x14000000), blurRadius: 36, offset: Offset(0, 18)),
  BoxShadow(color: Color(0x08000000), blurRadius: 16, offset: Offset(0, -8)),
  BoxShadow(color: Color(0x0F000000), blurRadius: 10, offset: Offset(0, 3)),
];

// ─── ColorSwatch ─────────────────────────────────────────────────────────────
// Figma ColorSwatch: circle or square colored dot
//   sizes: xs=21, sm=31, md=42, lg=47, xl=52
//   variants: circle (border-radius 9999), square (border-radius 8)
//   white container + inner shadow inset 0 0 1px rgba(0,0,0,0.3)
enum HeroUiColorSwatchVariant { circle, square }

enum HeroUiColorSwatchSize { xs, sm, md, lg, xl }

class HeroUiColorSwatch extends StatelessWidget {
  const HeroUiColorSwatch({
    required this.color,
    super.key,
    this.variant = HeroUiColorSwatchVariant.circle,
    this.size = HeroUiColorSwatchSize.md,
    this.selected = false,
    this.onTap,
  });

  final Color color;
  final HeroUiColorSwatchVariant variant;
  final HeroUiColorSwatchSize size;
  final bool selected;
  final VoidCallback? onTap;

  double get _dimension => switch (size) {
    HeroUiColorSwatchSize.xs => 21,
    HeroUiColorSwatchSize.sm => 31,
    HeroUiColorSwatchSize.md => 42,
    HeroUiColorSwatchSize.lg => 47,
    HeroUiColorSwatchSize.xl => 52,
  };

  @override
  Widget build(BuildContext context) {
    final d = _dimension;
    final isCircle = variant == HeroUiColorSwatchVariant.circle;
    final radius = isCircle ? d / 2 : 8.0;

    Widget swatch = Container(
      width: d,
      height: d,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: const [
          BoxShadow(
            color: Color(0x4D000000),
            blurRadius: 0,
            blurStyle: BlurStyle.inner,
            spreadRadius: -1,
          ),
        ],
      ),
    );

    if (selected) {
      swatch = Container(
        width: d + 5,
        height: d + 5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius + 3),
          border: Border.all(color: color, width: 2),
        ),
        child: Center(child: swatch),
      );
    }

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: swatch);
    }
    return swatch;
  }
}

// ─── ColorSwatchPicker ────────────────────────────────────────────────────────
// Figma ColorSwatchPicker: grid of ColorSwatch widgets with single selection
class HeroUiColorSwatchPicker extends StatefulWidget {
  const HeroUiColorSwatchPicker({
    required this.colors,
    super.key,
    this.initialColor,
    this.onColorSelected,
    this.swatchVariant = HeroUiColorSwatchVariant.circle,
    this.swatchSize = HeroUiColorSwatchSize.md,
    this.columns = 6,
    this.gap = 10.0,
    this.label,
  });

  final List<Color> colors;
  final Color? initialColor;
  final ValueChanged<Color>? onColorSelected;
  final HeroUiColorSwatchVariant swatchVariant;
  final HeroUiColorSwatchSize swatchSize;
  final int columns;
  final double gap;
  final String? label;

  @override
  State<HeroUiColorSwatchPicker> createState() =>
      _HeroUiColorSwatchPickerState();
}

class _HeroUiColorSwatchPickerState extends State<HeroUiColorSwatchPicker> {
  Color? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    final grid = Wrap(
      spacing: widget.gap,
      runSpacing: widget.gap,
      children: widget.colors.map((color) {
        return HeroUiColorSwatch(
          color: color,
          variant: widget.swatchVariant,
          size: widget.swatchSize,
          selected: _selected != null && _selected!.value == color.value,
          onTap: () {
            setState(() => _selected = color);
            widget.onColorSelected?.call(color);
          },
        );
      }).toList(),
    );

    if (widget.label != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.label!,
            style: HeroUiTypography.bodyXsMedium.copyWith(color: _kForeground),
          ),
          const SizedBox(height: 10),
          grid,
        ],
      );
    }
    return grid;
  }
}

// ─── ColorSlider ─────────────────────────────────────────────────────────────
// Figma ColorSlider: horizontal or vertical gradient slider with thumb
//   - bar: full hue spectrum gradient (or alpha, or saturation)
//   - thumb: 16px circle, white 3px border, shadow
//   - header: label (Body xs medium) + current value (right-aligned)
enum HeroUiColorSliderOrientation { horizontal, vertical }

enum HeroUiColorSliderType { hue, saturation, lightness, alpha }

class HeroUiColorSlider extends StatefulWidget {
  const HeroUiColorSlider({
    super.key,
    this.label,
    this.value = 0.0,
    this.onChanged,
    this.orientation = HeroUiColorSliderOrientation.horizontal,
    this.type = HeroUiColorSliderType.hue,
    this.baseColor = Colors.blue,
    this.enabled = true,
    this.showValue = true,
  });

  final String? label;
  final double value; // 0.0 to 1.0
  final ValueChanged<double>? onChanged;
  final HeroUiColorSliderOrientation orientation;
  final HeroUiColorSliderType type;
  final Color baseColor; // used for saturation/alpha sliders
  final bool enabled;
  final bool showValue;

  @override
  State<HeroUiColorSlider> createState() => _HeroUiColorSliderState();
}

class _HeroUiColorSliderState extends State<HeroUiColorSlider> {
  late double _value = widget.value.clamp(0.0, 1.0);

  @override
  void didUpdateWidget(HeroUiColorSlider old) {
    super.didUpdateWidget(old);
    if (widget.value != old.value) {
      _value = widget.value.clamp(0.0, 1.0);
    }
  }

  LinearGradient get _gradient {
    return switch (widget.type) {
      HeroUiColorSliderType.hue => const LinearGradient(
        colors: [
          Color(0xFFFF0000),
          Color(0xFFFF8A00),
          Color(0xFFFFE600),
          Color(0xFF14FF00),
          Color(0xFF00A3FF),
          Color(0xFF0500FF),
          Color(0xFFAD00FF),
          Color(0xFFFFC7FF),
          Color(0xFFFF0000),
        ],
      ),
      HeroUiColorSliderType.saturation => LinearGradient(
        colors: [Colors.grey, widget.baseColor],
      ),
      HeroUiColorSliderType.lightness => LinearGradient(
        colors: [Colors.black, widget.baseColor, Colors.white],
        stops: const [0, 0.5, 1],
      ),
      HeroUiColorSliderType.alpha => LinearGradient(
        colors: [widget.baseColor.withValues(alpha: 0), widget.baseColor],
      ),
    };
  }

  void _handleDrag(Offset localPos, Size trackSize) {
    final isHorizontal =
        widget.orientation == HeroUiColorSliderOrientation.horizontal;
    final fraction = isHorizontal
        ? (localPos.dx / trackSize.width).clamp(0.0, 1.0)
        : (localPos.dy / trackSize.height).clamp(0.0, 1.0);
    setState(() => _value = fraction);
    widget.onChanged?.call(fraction);
  }

  @override
  Widget build(BuildContext context) {
    final isHorizontal =
        widget.orientation == HeroUiColorSliderOrientation.horizontal;
    final trackWidth = isHorizontal ? double.infinity : 26.0;
    final trackHeight = isHorizontal ? 26.0 : double.infinity;
    final trackConstraints = isHorizontal
        ? const BoxConstraints(minWidth: 104, minHeight: 26, maxHeight: 26)
        : const BoxConstraints(minHeight: 104, minWidth: 26, maxWidth: 26);

    final track = LayoutBuilder(
      builder: (context, constraints) {
        final trackW = isHorizontal ? constraints.maxWidth : 26.0;
        final trackH = isHorizontal ? 26.0 : constraints.maxHeight;

        return GestureDetector(
          onTapDown: widget.enabled
              ? (d) => _handleDrag(d.localPosition, Size(trackW, trackH))
              : null,
          onPanUpdate: widget.enabled
              ? (d) => _handleDrag(d.localPosition, Size(trackW, trackH))
              : null,
          child: SizedBox(
            width: trackW,
            height: trackH,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Track with gradient
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: isHorizontal
                          ? _gradient
                          : LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: _gradient.colors,
                            ),
                      borderRadius: BorderRadius.circular(9999),
                    ),
                  ),
                ),
                // Thumb
                Positioned(
                  left: isHorizontal ? trackW * _value - 10 : 3,
                  top: isHorizontal ? 3 : trackH * _value - 10,
                  child: Container(
                    width: 21,
                    height: 21,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: _kOverlayShadow,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    final content = Opacity(
      opacity: widget.enabled ? 1.0 : 0.5,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null || widget.showValue) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.label != null)
                  Text(
                    widget.label!,
                    style: HeroUiTypography.bodyXsMedium.copyWith(
                      color: _kForeground,
                    ),
                  ),
                if (widget.showValue)
                  Text(
                    _formatValue(),
                    style: HeroUiTypography.bodyXs.copyWith(color: _kMuted),
                  ),
              ],
            ),
            const SizedBox(height: 5),
          ],
          ConstrainedBox(
            constraints: trackConstraints,
            child: SizedBox(
              width: trackWidth,
              height: trackHeight,
              child: track,
            ),
          ),
        ],
      ),
    );

    return content;
  }

  String _formatValue() {
    return switch (widget.type) {
      HeroUiColorSliderType.hue => '${(_value * 360).round()}°',
      HeroUiColorSliderType.alpha => '${(_value * 100).round()}%',
      _ => (_value * 100).round().toString(),
    };
  }
}

// ─── ColorArea ────────────────────────────────────────────────────────────────
// Figma ColorArea: 2D saturation-lightness (HSL) or saturation-value (HSV) picker
// Shows a gradient square: horizontal = saturation (0→1), vertical = lightness (1→0)
class HeroUiColorArea extends StatefulWidget {
  const HeroUiColorArea({
    super.key,
    this.hue = 0.0, // 0..360
    this.saturation = 1.0, // 0..1
    this.lightness = 0.5, // 0..1
    this.onChanged,
    this.size = 260.0,
    this.enabled = true,
  });

  final double hue;
  final double saturation;
  final double lightness;
  final void Function(double saturation, double lightness)? onChanged;
  final double size;
  final bool enabled;

  @override
  State<HeroUiColorArea> createState() => _HeroUiColorAreaState();
}

class _HeroUiColorAreaState extends State<HeroUiColorArea> {
  late double _sat = widget.saturation;
  late double _lig = widget.lightness;

  @override
  void didUpdateWidget(HeroUiColorArea old) {
    super.didUpdateWidget(old);
    if (widget.saturation != old.saturation) _sat = widget.saturation;
    if (widget.lightness != old.lightness) _lig = widget.lightness;
  }

  void _handleDrag(Offset localPos) {
    final s = (localPos.dx / widget.size).clamp(0.0, 1.0);
    final l = 1 - (localPos.dy / widget.size).clamp(0.0, 1.0);
    setState(() {
      _sat = s;
      _lig = l;
    });
    widget.onChanged?.call(s, l);
  }

  @override
  Widget build(BuildContext context) {
    final hueColor = HSLColor.fromAHSL(1, widget.hue, 1, 0.5).toColor();

    return Opacity(
      opacity: widget.enabled ? 1.0 : 0.5,
      child: GestureDetector(
        onTapDown: widget.enabled ? (d) => _handleDrag(d.localPosition) : null,
        onPanUpdate: widget.enabled
            ? (d) => _handleDrag(d.localPosition)
            : null,
        child: SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            children: [
              // Base hue
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: hueColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              // Saturation overlay (white → transparent)
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.white, Colors.transparent],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              // Lightness overlay (transparent → black)
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              // Thumb
              Positioned(
                left: _sat * widget.size - 10,
                top: (1 - _lig) * widget.size - 10,
                child: Container(
                  width: 21,
                  height: 21,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: _kOverlayShadow,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── ColorField ───────────────────────────────────────────────────────────────
// Figma ColorField: text input for hex color value
// Structure: Label + Input(with swatch preview) + description/error
class HeroUiColorField extends StatefulWidget {
  const HeroUiColorField({
    super.key,
    this.initialColor,
    this.label,
    this.description,
    this.errorText,
    this.onColorChanged,
    this.enabled = true,
  });

  final Color? initialColor;
  final String? label;
  final String? description;
  final String? errorText;
  final ValueChanged<Color>? onColorChanged;
  final bool enabled;

  @override
  State<HeroUiColorField> createState() => _HeroUiColorFieldState();
}

class _HeroUiColorFieldState extends State<HeroUiColorField> {
  late final TextEditingController _controller;
  Color? _currentColor;
  String? _error;

  @override
  void initState() {
    super.initState();
    _currentColor = widget.initialColor;
    _controller = TextEditingController(
      text: widget.initialColor != null
          ? _colorToHex(widget.initialColor!)
          : '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
  }

  void _onChanged(String value) {
    final hex = value.replaceAll('#', '');
    if (hex.length == 6) {
      try {
        final color = Color(int.parse('FF$hex', radix: 16));
        setState(() {
          _currentColor = color;
          _error = null;
        });
        widget.onColorChanged?.call(color);
      } catch (_) {
        setState(() => _error = 'Invalid hex color');
      }
    } else if (hex.length > 6) {
      setState(() => _error = 'Invalid hex color');
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasError = (widget.errorText ?? _error) != null;
    final errorMsg = widget.errorText ?? _error;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: HeroUiTypography.bodyXsMedium.copyWith(color: _kForeground),
          ),
          const SizedBox(height: 5),
        ],
        DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: hasError
                ? Border.all(color: const Color(0xFFFF383C))
                : null,
            boxShadow: const [
              BoxShadow(color: Color(0x0F000000), blurRadius: 1),
              BoxShadow(
                color: Color(0x0F000000),
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              if (_currentColor != null) ...[
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: _currentColor,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: _kDivider),
                  ),
                ),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: TextField(
                  controller: _controller,
                  enabled: widget.enabled,
                  onChanged: _onChanged,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[#0-9a-fA-F]')),
                    LengthLimitingTextInputFormatter(7),
                  ],
                  style: HeroUiTypography.textFieldSm.copyWith(
                    color: _kForeground,
                  ),
                  decoration: InputDecoration(
                    hintText: '#000000',
                    hintStyle: HeroUiTypography.textFieldSm.copyWith(
                      color: const Color(0xFF71717A),
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
        if (errorMsg != null) ...[
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              errorMsg,
              style: HeroUiTypography.bodyXs.copyWith(
                color: const Color(0xFFFF383C),
              ),
            ),
          ),
        ],
        if (widget.description != null && errorMsg == null) ...[
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              widget.description!,
              style: HeroUiTypography.bodyXs.copyWith(
                color: const Color(0xFF71717A),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// ─── ColorPicker ─────────────────────────────────────────────────────────────
// Figma ColorPicker: compound of ColorArea + Hue/Alpha sliders + ColorField
// Full-featured HSL color picker
class HeroUiColorPicker extends StatefulWidget {
  const HeroUiColorPicker({
    super.key,
    this.initialColor = Colors.blue,
    this.onColorChanged,
    this.size = 260.0,
    this.showAlpha = true,
    this.showHexField = true,
  });

  final Color initialColor;
  final ValueChanged<Color>? onColorChanged;
  final double size;
  final bool showAlpha;
  final bool showHexField;

  @override
  State<HeroUiColorPicker> createState() => _HeroUiColorPickerState();
}

class _HeroUiColorPickerState extends State<HeroUiColorPicker> {
  late double _hue;
  late double _sat;
  late double _lig;
  late double _alpha;
  late final TextEditingController _hexController;

  @override
  void initState() {
    super.initState();
    final hsl = HSLColor.fromColor(widget.initialColor);
    _hue = hsl.hue;
    _sat = hsl.saturation;
    _lig = hsl.lightness;
    _alpha = widget.initialColor.alpha / 255.0;
    _hexController = TextEditingController(text: _colorToHex(_currentColor));
  }

  @override
  void dispose() {
    _hexController.dispose();
    super.dispose();
  }

  Color get _currentColor {
    final hsl = HSLColor.fromAHSL(_alpha, _hue, _sat, _lig);
    return hsl.toColor();
  }

  String _colorToHex(Color c) {
    return '#${c.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
  }

  void _notify() {
    final c = _currentColor;
    _hexController.text = _colorToHex(c);
    widget.onColorChanged?.call(c);
  }

  @override
  Widget build(BuildContext context) {
    final hueColor = HSLColor.fromAHSL(1, _hue, 1, 0.5).toColor();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        HeroUiColorArea(
          hue: _hue,
          saturation: _sat,
          lightness: _lig,
          size: widget.size,
          onChanged: (s, l) {
            setState(() {
              _sat = s;
              _lig = l;
            });
            _notify();
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: _currentColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _kDivider),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                children: [
                  HeroUiColorSlider(
                    label: 'Hue',
                    value: _hue / 360,
                    type: HeroUiColorSliderType.hue,
                    onChanged: (v) {
                      setState(() => _hue = v * 360);
                      _notify();
                    },
                  ),
                  if (widget.showAlpha) ...[
                    const SizedBox(height: 10),
                    HeroUiColorSlider(
                      label: 'Alpha',
                      value: _alpha,
                      type: HeroUiColorSliderType.alpha,
                      baseColor: hueColor,
                      onChanged: (v) {
                        setState(() => _alpha = v);
                        _notify();
                      },
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        if (widget.showHexField) ...[
          const SizedBox(height: 16),
          HeroUiColorField(
            initialColor: _currentColor,
            onColorChanged: (c) {
              final hsl = HSLColor.fromColor(c);
              setState(() {
                _hue = hsl.hue;
                _sat = hsl.saturation;
                _lig = hsl.lightness;
                _alpha = c.alpha / 255.0;
              });
              widget.onColorChanged?.call(c);
            },
          ),
        ],
      ],
    );
  }
}
