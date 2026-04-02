import 'dart:ui';
import 'package:flutter/material.dart';

// ─── ProgressiveBlur ──────────────────────────────────────────────────────────
// Figma ProgressiveBlur: gradient mask + backdrop blur
//   color=dark: semi-transparent dark overlay (rgba(6,6,7,0.2)) + blur 10px
//   color=light: semi-transparent light overlay (rgba(245,245,245,0.2)) + blur 10px
//   gradient: transparent at top → solid at 40% → solid at bottom (bottom-to-top fade)
enum HeroUiProgressiveBlurColor { dark, light }

enum HeroUiProgressiveBlurDirection { topToBottom, bottomToTop, leftToRight, rightToLeft }

class HeroUiProgressiveBlur extends StatelessWidget {
  const HeroUiProgressiveBlur({
    super.key,
    this.color = HeroUiProgressiveBlurColor.light,
    this.direction = HeroUiProgressiveBlurDirection.bottomToTop,
    this.blurSigma = 10.0,
    this.width = double.infinity,
    this.height = 80.0,
  });

  final HeroUiProgressiveBlurColor color;
  final HeroUiProgressiveBlurDirection direction;
  final double blurSigma;
  final double width;
  final double height;

  Color get _overlayColor => color == HeroUiProgressiveBlurColor.dark
      ? const Color(0x33060607) // rgba(6,6,7,0.2)
      : const Color(0x33F5F5F5); // rgba(245,245,245,0.2)

  (AlignmentGeometry, AlignmentGeometry) get _gradientAlignment {
    return switch (direction) {
      HeroUiProgressiveBlurDirection.bottomToTop => (Alignment.bottomCenter, Alignment.topCenter),
      HeroUiProgressiveBlurDirection.topToBottom => (Alignment.topCenter, Alignment.bottomCenter),
      HeroUiProgressiveBlurDirection.leftToRight => (Alignment.centerLeft, Alignment.centerRight),
      HeroUiProgressiveBlurDirection.rightToLeft => (Alignment.centerRight, Alignment.centerLeft),
    };
  }

  @override
  Widget build(BuildContext context) {
    final (begin, end) = _gradientAlignment;

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          // Backdrop blur layer
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
              child: const SizedBox.expand(),
            ),
          ),
          // Gradient overlay that fades the blur
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: begin,
                  end: end,
                  colors: [
                    Colors.transparent,
                    _overlayColor,
                  ],
                  stops: const [0.0, 0.4],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Resizable ────────────────────────────────────────────────────────────────
// Figma Resizable: drag handle for resizable panels
//   variant: primary (#E4E4E7), secondary (#D7D7D7), tertiary (#CDCDCE)
//   type: line (1px), pill (5px x 36px), drag (line + grip dots)
//   orientation: vertical (default) or horizontal
enum HeroUiResizableVariant { primary, secondary, tertiary }

enum HeroUiResizableType { line, pill, drag }

enum HeroUiResizableOrientation { vertical, horizontal }

class HeroUiResizable extends StatefulWidget {
  const HeroUiResizable({
    super.key,
    this.variant = HeroUiResizableVariant.primary,
    this.type = HeroUiResizableType.pill,
    this.orientation = HeroUiResizableOrientation.vertical,
    this.onDrag,
    this.length = 230.0,
  });

  final HeroUiResizableVariant variant;
  final HeroUiResizableType type;
  final HeroUiResizableOrientation orientation;
  final ValueChanged<double>? onDrag;
  final double length;

  @override
  State<HeroUiResizable> createState() => _HeroUiResizableState();
}

class _HeroUiResizableState extends State<HeroUiResizable> {
  bool _hovering = false;

  Color get _color => switch (widget.variant) {
        HeroUiResizableVariant.primary => const Color(0xFFE4E4E7),
        HeroUiResizableVariant.secondary => const Color(0xFFD7D7D7),
        HeroUiResizableVariant.tertiary => const Color(0xFFCDCDCE),
      };

  bool get _isVertical => widget.orientation == HeroUiResizableOrientation.vertical;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: _isVertical
          ? SystemMouseCursors.resizeColumn
          : SystemMouseCursors.resizeRow,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onHorizontalDragUpdate: _isVertical
            ? (d) => widget.onDrag?.call(d.delta.dx)
            : null,
        onVerticalDragUpdate: !_isVertical
            ? (d) => widget.onDrag?.call(d.delta.dy)
            : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: _isVertical ? 20 : widget.length,
          height: _isVertical ? widget.length : 20,
          color: Colors.transparent,
          child: Center(child: _buildHandle()),
        ),
      ),
    );
  }

  Widget _buildHandle() {
    final hoverColor = _hovering
        ? _color.withValues(alpha: 1.0)
        : _color.withValues(alpha: 0.8);

    return switch (widget.type) {
      HeroUiResizableType.line => _buildLine(hoverColor),
      HeroUiResizableType.pill => _buildPill(hoverColor),
      HeroUiResizableType.drag => _buildDrag(hoverColor),
    };
  }

  Widget _buildLine(Color c) {
    return Container(
      width: _isVertical ? 1 : widget.length,
      height: _isVertical ? widget.length : 1,
      color: c,
    );
  }

  Widget _buildPill(Color c) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: _isVertical ? 1 : widget.length,
          height: _isVertical ? widget.length : 1,
          color: c,
        ),
        Container(
          width: _isVertical ? 5 : 36,
          height: _isVertical ? 36 : 5,
          decoration: BoxDecoration(
            color: c,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }

  Widget _buildDrag(Color c) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: _isVertical ? 1 : widget.length,
          height: _isVertical ? widget.length : 1,
          color: c,
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 3),
          child: _buildDots(c),
        ),
      ],
    );
  }

  Widget _buildDots(Color c) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _dot(c), const SizedBox(width: 3), _dot(c),
          ],
        ),
        const SizedBox(height: 3),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _dot(c), const SizedBox(width: 3), _dot(c),
          ],
        ),
        const SizedBox(height: 3),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _dot(c), const SizedBox(width: 3), _dot(c),
          ],
        ),
      ],
    );
  }

  Widget _dot(Color c) => Container(
        width: 2,
        height: 2,
        decoration: BoxDecoration(color: c, shape: BoxShape.circle),
      );
}

// ─── ResizablePanel ───────────────────────────────────────────────────────────
// A ready-to-use panel that can be resized by dragging its handle
class HeroUiResizablePanel extends StatefulWidget {
  const HeroUiResizablePanel({
    required this.child,
    super.key,
    this.initialSize = 200.0,
    this.minSize = 80.0,
    this.maxSize = double.infinity,
    this.direction = HeroUiResizableOrientation.vertical,
    this.handleVariant = HeroUiResizableVariant.primary,
    this.handleType = HeroUiResizableType.pill,
  });

  final Widget child;
  final double initialSize;
  final double minSize;
  final double maxSize;
  final HeroUiResizableOrientation direction;
  final HeroUiResizableVariant handleVariant;
  final HeroUiResizableType handleType;

  @override
  State<HeroUiResizablePanel> createState() => _HeroUiResizablePanelState();
}

class _HeroUiResizablePanelState extends State<HeroUiResizablePanel> {
  late double _size;

  @override
  void initState() {
    super.initState();
    _size = widget.initialSize;
  }

  void _onDrag(double delta) {
    setState(() {
      _size = (_size + delta).clamp(widget.minSize, widget.maxSize);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isVertical = widget.direction == HeroUiResizableOrientation.vertical;

    if (isVertical) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: _size, child: widget.child),
          HeroUiResizable(
            variant: widget.handleVariant,
            type: widget.handleType,
            orientation: HeroUiResizableOrientation.vertical,
            onDrag: _onDrag,
          ),
        ],
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: _size, child: widget.child),
          HeroUiResizable(
            variant: widget.handleVariant,
            type: widget.handleType,
            orientation: HeroUiResizableOrientation.horizontal,
            onDrag: _onDrag,
          ),
        ],
      );
    }
  }
}
