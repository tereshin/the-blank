part of 'heroui_overlays.dart';

enum HeroUiTooltipPosition {
  topStart,
  topCenter,
  topEnd,
  rightStart,
  rightCenter,
  rightEnd,
  bottomStart,
  bottomCenter,
  bottomEnd,
  leftStart,
  leftCenter,
  leftEnd,
}

enum _TooltipSide { top, right, bottom, left }

enum _TooltipCrossAxisPosition { start, center, end }

extension _HeroUiTooltipPositionX on HeroUiTooltipPosition {
  _TooltipSide get side {
    switch (this) {
      case HeroUiTooltipPosition.topStart:
      case HeroUiTooltipPosition.topCenter:
      case HeroUiTooltipPosition.topEnd:
        return _TooltipSide.top;
      case HeroUiTooltipPosition.rightStart:
      case HeroUiTooltipPosition.rightCenter:
      case HeroUiTooltipPosition.rightEnd:
        return _TooltipSide.right;
      case HeroUiTooltipPosition.bottomStart:
      case HeroUiTooltipPosition.bottomCenter:
      case HeroUiTooltipPosition.bottomEnd:
        return _TooltipSide.bottom;
      case HeroUiTooltipPosition.leftStart:
      case HeroUiTooltipPosition.leftCenter:
      case HeroUiTooltipPosition.leftEnd:
        return _TooltipSide.left;
    }
  }

  _TooltipCrossAxisPosition get crossAxisPosition {
    switch (this) {
      case HeroUiTooltipPosition.topStart:
      case HeroUiTooltipPosition.rightStart:
      case HeroUiTooltipPosition.bottomStart:
      case HeroUiTooltipPosition.leftStart:
        return _TooltipCrossAxisPosition.start;
      case HeroUiTooltipPosition.topCenter:
      case HeroUiTooltipPosition.rightCenter:
      case HeroUiTooltipPosition.bottomCenter:
      case HeroUiTooltipPosition.leftCenter:
        return _TooltipCrossAxisPosition.center;
      case HeroUiTooltipPosition.topEnd:
      case HeroUiTooltipPosition.rightEnd:
      case HeroUiTooltipPosition.bottomEnd:
      case HeroUiTooltipPosition.leftEnd:
        return _TooltipCrossAxisPosition.end;
    }
  }
}

/// A small popup tooltip that appears relative to a [child] widget.
///
/// - [message]/[content]: text shown in the tooltip.
/// - [position]: tooltip side + arrow position.
/// - [inverse]: dark inverted tooltip style.
/// - [showArrow]: toggles directional arrow visibility.
class HeroUiTooltip extends StatefulWidget {
  const HeroUiTooltip({
    super.key,
    this.message,
    this.content,
    required this.child,
    this.position = HeroUiTooltipPosition.topCenter,
    this.inverse = false,
    this.showArrow = true,
  }) : assert(
         message != null || content != null,
         'Provide either "message" or "content" for HeroUiTooltip.',
       ),
       assert(
         message == null || content == null,
         'Provide only one of "message" or "content".',
       );

  final String? message;
  final String? content;
  final Widget child;
  final HeroUiTooltipPosition position;
  final bool inverse;
  final bool showArrow;

  String get resolvedMessage => message ?? content!;

  @override
  State<HeroUiTooltip> createState() => _HeroUiTooltipState();
}

class _HeroUiTooltipState extends State<HeroUiTooltip>
    with SingleTickerProviderStateMixin {
  OverlayEntry? _entry;
  final _key = GlobalKey();
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  Timer? _autoHideTimer;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _hide(immediately: true);
    _autoHideTimer?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  void _scheduleAutoHide() {
    _autoHideTimer?.cancel();
    _autoHideTimer = Timer(const Duration(milliseconds: 1800), () => _hide());
  }

  void _show() {
    if (_entry != null) return;
    final triggerContext = _key.currentContext;
    if (triggerContext == null) return;
    final renderObject = triggerContext.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) return;
    final overlay = Overlay.of(context, rootOverlay: true);
    final triggerRect =
        renderObject.localToGlobal(Offset.zero) & renderObject.size;

    _entry = OverlayEntry(
      builder: (_) => _TooltipOverlay(
        message: widget.resolvedMessage,
        position: widget.position,
        inverse: widget.inverse,
        showArrow: widget.showArrow,
        triggerRect: triggerRect,
        fade: _fade,
      ),
    );

    overlay.insert(_entry!);
    _ctrl.forward(from: 0);
  }

  void _hide({bool immediately = false}) {
    _autoHideTimer?.cancel();
    final entry = _entry;
    if (entry == null) return;

    if (immediately) {
      entry.remove();
      _entry = null;
      return;
    }

    _ctrl.reverse().then((_) {
      if (_entry == entry) {
        entry.remove();
        _entry = null;
      }
    });
  }

  bool _isTouchPointer(PointerDeviceKind kind) {
    return kind == PointerDeviceKind.touch ||
        kind == PointerDeviceKind.stylus ||
        kind == PointerDeviceKind.invertedStylus;
  }

  void _handleTouchToggle() {
    if (_entry == null) {
      _show();
      _scheduleAutoHide();
    } else {
      _hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _show(),
      onExit: (_) => _hide(),
      child: Listener(
        onPointerDown: (event) {
          if (_isTouchPointer(event.kind)) {
            _handleTouchToggle();
          }
        },
        child: KeyedSubtree(key: _key, child: widget.child),
      ),
    );
  }
}

class _TooltipOverlay extends StatelessWidget {
  const _TooltipOverlay({
    required this.message,
    required this.position,
    required this.inverse,
    required this.showArrow,
    required this.triggerRect,
    required this.fade,
  });

  final String message;
  final HeroUiTooltipPosition position;
  final bool inverse;
  final bool showArrow;
  final Rect triggerRect;
  final Animation<double> fade;

  static const _gap = 8.0;
  static const _padding = EdgeInsets.symmetric(horizontal: 12, vertical: 8);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bg = inverse ? const Color(0xFF18181B) : const Color(0xFFFFFFFF);
    final textColor = inverse
        ? const Color(0xFFFCFCFC)
        : const Color(0xFF18181B);
    const viewportPadding = 8.0;
    final safeRect = Rect.fromLTRB(
      mediaQuery.padding.left + viewportPadding,
      mediaQuery.padding.top + viewportPadding,
      mediaQuery.size.width - mediaQuery.padding.right - viewportPadding,
      mediaQuery.size.height - mediaQuery.padding.bottom - viewportPadding,
    );
    final maxBubbleWidth = math.max(120.0, math.min(280.0, safeRect.width));

    final content = Container(
      padding: _padding,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.2),
            blurRadius: 8,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Text(
        message,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          height: 1.34,
          color: textColor,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );

    return Positioned.fill(
      child: IgnorePointer(
        child: FadeTransition(
          opacity: fade,
          child: _TooltipPositioner(
            position: position,
            triggerRect: triggerRect,
            safeRect: safeRect,
            gap: _gap,
            showArrow: showArrow,
            arrowColor: bg,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxBubbleWidth),
              child: content,
            ),
          ),
        ),
      ),
    );
  }
}

class _TooltipPositioner extends StatelessWidget {
  const _TooltipPositioner({
    required this.position,
    required this.triggerRect,
    required this.safeRect,
    required this.gap,
    required this.showArrow,
    required this.child,
    required this.arrowColor,
  });

  final HeroUiTooltipPosition position;
  final Rect triggerRect;
  final Rect safeRect;
  final double gap;
  final bool showArrow;
  final Widget child;
  final Color arrowColor;

  static const _arrowH = 6.0;
  static const _arrowAlignStart = -0.72;
  static const _arrowAlignCenter = 0.0;
  static const _arrowAlignEnd = 0.72;

  double _arrowAlignment(_TooltipCrossAxisPosition crossAxisPosition) {
    switch (crossAxisPosition) {
      case _TooltipCrossAxisPosition.start:
        return _arrowAlignStart;
      case _TooltipCrossAxisPosition.center:
        return _arrowAlignCenter;
      case _TooltipCrossAxisPosition.end:
        return _arrowAlignEnd;
    }
  }

  Widget _buildArrow(_TriDir direction) {
    switch (direction) {
      case _TriDir.up:
        return _ArrowUp(color: arrowColor);
      case _TriDir.down:
        return _ArrowDown(color: arrowColor);
      case _TriDir.left:
        return _ArrowLeft(color: arrowColor);
      case _TriDir.right:
        return _ArrowRight(color: arrowColor);
    }
  }

  Widget _wrapWithArrow({
    required _TooltipSide side,
    required _TooltipCrossAxisPosition crossAxisPosition,
  }) {
    if (!showArrow) {
      return child;
    }

    final alignment = _arrowAlignment(crossAxisPosition);
    switch (side) {
      case _TooltipSide.top:
        return Padding(
          padding: const EdgeInsets.only(bottom: _arrowH),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              child,
              Positioned(
                left: 0,
                right: 0,
                bottom: -_arrowH,
                child: Align(
                  alignment: Alignment(alignment, 0),
                  child: _buildArrow(_TriDir.down),
                ),
              ),
            ],
          ),
        );
      case _TooltipSide.bottom:
        return Padding(
          padding: const EdgeInsets.only(top: _arrowH),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              child,
              Positioned(
                left: 0,
                right: 0,
                top: -_arrowH,
                child: Align(
                  alignment: Alignment(alignment, 0),
                  child: _buildArrow(_TriDir.up),
                ),
              ),
            ],
          ),
        );
      case _TooltipSide.left:
        return Padding(
          padding: const EdgeInsets.only(right: _arrowH),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              child,
              Positioned(
                top: 0,
                bottom: 0,
                right: -_arrowH,
                child: Align(
                  alignment: Alignment(0, alignment),
                  child: _buildArrow(_TriDir.right),
                ),
              ),
            ],
          ),
        );
      case _TooltipSide.right:
        return Padding(
          padding: const EdgeInsets.only(left: _arrowH),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              child,
              Positioned(
                top: 0,
                bottom: 0,
                left: -_arrowH,
                child: Align(
                  alignment: Alignment(0, alignment),
                  child: _buildArrow(_TriDir.left),
                ),
              ),
            ],
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final wrappedChild = _wrapWithArrow(
      side: position.side,
      crossAxisPosition: position.crossAxisPosition,
    );

    return CustomSingleChildLayout(
      delegate: _TooltipLayoutDelegate(
        position: position,
        triggerRect: triggerRect,
        safeRect: safeRect,
        gap: gap,
      ),
      child: wrappedChild,
    );
  }
}

class _TooltipLayoutDelegate extends SingleChildLayoutDelegate {
  const _TooltipLayoutDelegate({
    required this.position,
    required this.triggerRect,
    required this.safeRect,
    required this.gap,
  });

  final HeroUiTooltipPosition position;
  final Rect triggerRect;
  final Rect safeRect;
  final double gap;

  double _horizontalPositionFor(
    _TooltipCrossAxisPosition crossAxisPosition,
    double childWidth,
  ) {
    switch (crossAxisPosition) {
      case _TooltipCrossAxisPosition.start:
        return triggerRect.left;
      case _TooltipCrossAxisPosition.center:
        return triggerRect.center.dx - childWidth / 2;
      case _TooltipCrossAxisPosition.end:
        return triggerRect.right - childWidth;
    }
  }

  double _verticalPositionFor(
    _TooltipCrossAxisPosition crossAxisPosition,
    double childHeight,
  ) {
    switch (crossAxisPosition) {
      case _TooltipCrossAxisPosition.start:
        return triggerRect.top;
      case _TooltipCrossAxisPosition.center:
        return triggerRect.center.dy - childHeight / 2;
      case _TooltipCrossAxisPosition.end:
        return triggerRect.bottom - childHeight;
    }
  }

  double _clamp(double value, double minValue, double maxValue) {
    if (maxValue < minValue) {
      return minValue;
    }
    return value.clamp(minValue, maxValue).toDouble();
  }

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints.loose(constraints.biggest);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final side = position.side;
    final crossAxisPosition = position.crossAxisPosition;
    late final double x;
    late final double y;

    if (side == _TooltipSide.top) {
      x = _horizontalPositionFor(crossAxisPosition, childSize.width);
      y = triggerRect.top - childSize.height - gap;
    } else if (side == _TooltipSide.right) {
      x = triggerRect.right + gap;
      y = _verticalPositionFor(crossAxisPosition, childSize.height);
    } else if (side == _TooltipSide.bottom) {
      x = _horizontalPositionFor(crossAxisPosition, childSize.width);
      y = triggerRect.bottom + gap;
    } else {
      x = triggerRect.left - childSize.width - gap;
      y = _verticalPositionFor(crossAxisPosition, childSize.height);
    }

    final minX = safeRect.left;
    final maxX = safeRect.right - childSize.width;
    final minY = safeRect.top;
    final maxY = safeRect.bottom - childSize.height;

    return Offset(_clamp(x, minX, maxX), _clamp(y, minY, maxY));
  }

  @override
  bool shouldRelayout(_TooltipLayoutDelegate old) =>
      position != old.position ||
      triggerRect != old.triggerRect ||
      safeRect != old.safeRect ||
      gap != old.gap;
}

class _ArrowUp extends StatelessWidget {
  const _ArrowUp({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) => CustomPaint(
    size: const Size(12, 6),
    painter: _TrianglePainter(color: color, direction: _TriDir.up),
  );
}

class _ArrowDown extends StatelessWidget {
  const _ArrowDown({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) => CustomPaint(
    size: const Size(12, 6),
    painter: _TrianglePainter(color: color, direction: _TriDir.down),
  );
}

class _ArrowLeft extends StatelessWidget {
  const _ArrowLeft({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) => CustomPaint(
    size: const Size(6, 12),
    painter: _TrianglePainter(color: color, direction: _TriDir.left),
  );
}

class _ArrowRight extends StatelessWidget {
  const _ArrowRight({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) => CustomPaint(
    size: const Size(6, 12),
    painter: _TrianglePainter(color: color, direction: _TriDir.right),
  );
}

enum _TriDir { up, down, left, right }

class _TrianglePainter extends CustomPainter {
  const _TrianglePainter({required this.color, required this.direction});
  final Color color;
  final _TriDir direction;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();
    switch (direction) {
      case _TriDir.up:
        path
          ..moveTo(size.width / 2, 0)
          ..lineTo(size.width, size.height)
          ..lineTo(0, size.height)
          ..close();
      case _TriDir.down:
        path
          ..moveTo(0, 0)
          ..lineTo(size.width, 0)
          ..lineTo(size.width / 2, size.height)
          ..close();
      case _TriDir.left:
        path
          ..moveTo(0, size.height / 2)
          ..lineTo(size.width, 0)
          ..lineTo(size.width, size.height)
          ..close();
      case _TriDir.right:
        path
          ..moveTo(0, 0)
          ..lineTo(size.width, size.height / 2)
          ..lineTo(0, size.height)
          ..close();
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_TrianglePainter old) => old.color != color;
}
