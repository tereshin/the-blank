part of 'heroui_overlays.dart';

/// A small floating content panel anchored to a trigger widget.
///
/// Shows [content] in a rounded card below (or above) the trigger.
class HeroUiPopover extends StatefulWidget {
  const HeroUiPopover({
    super.key,
    required this.trigger,
    required this.content,
    this.preferBelow = true,
  });

  final Widget trigger;
  final Widget content;
  final bool preferBelow;

  @override
  State<HeroUiPopover> createState() => _HeroUiPopoverState();
}

class _HeroUiPopoverState extends State<HeroUiPopover>
    with SingleTickerProviderStateMixin {
  OverlayEntry? _entry;
  final _key = GlobalKey();
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, -0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _close(immediately: true);
    _ctrl.dispose();
    super.dispose();
  }

  void _open() {
    if (_entry != null) {
      _close();
      return;
    }
    final triggerContext = _key.currentContext;
    if (triggerContext == null) return;
    final renderObject = triggerContext.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) return;

    final triggerRect =
        renderObject.localToGlobal(Offset.zero) & renderObject.size;

    _entry = OverlayEntry(
      builder: (_) => _PopoverOverlay(
        triggerRect: triggerRect,
        preferBelow: widget.preferBelow,
        fade: _fade,
        slide: _slide,
        content: widget.content,
        onDismiss: _close,
      ),
    );

    Overlay.of(context, rootOverlay: true).insert(_entry!);
    _ctrl.forward(from: 0);
  }

  void _close({bool immediately = false}) {
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _open,
      child: KeyedSubtree(key: _key, child: widget.trigger),
    );
  }
}

class _PopoverOverlay extends StatelessWidget {
  const _PopoverOverlay({
    required this.triggerRect,
    required this.preferBelow,
    required this.fade,
    required this.slide,
    required this.content,
    required this.onDismiss,
  });

  final Rect triggerRect;
  final bool preferBelow;
  final Animation<double> fade;
  final Animation<Offset> slide;
  final Widget content;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF18181B) : const Color(0xFFFFFFFF);
    final textColor = isDark
        ? const Color(0xFFFCFCFC)
        : const Color(0xFF18181B);
    const viewportPadding = 12.0;
    final safeRect = Rect.fromLTRB(
      mediaQuery.padding.left + viewportPadding,
      mediaQuery.padding.top + viewportPadding,
      mediaQuery.size.width - mediaQuery.padding.right - viewportPadding,
      mediaQuery.size.height - mediaQuery.padding.bottom - viewportPadding,
    );
    final maxWidth = math.max(120.0, math.min(320.0, safeRect.width));
    final minWidth = math.min(200.0, maxWidth);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onDismiss,
      child: Stack(
        children: [
          CustomSingleChildLayout(
            delegate: _PopoverLayoutDelegate(
              triggerRect: triggerRect,
              safeRect: safeRect,
              preferBelow: preferBelow,
              gap: 8,
            ),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {},
              child: FadeTransition(
                opacity: fade,
                child: SlideTransition(
                  position: slide,
                  child: Material(
                    color: Colors.transparent,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: minWidth,
                        maxWidth: maxWidth,
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: bg,
                          borderRadius: BorderRadius.circular(24),
                          border: isDark
                              ? Border.all(color: const Color(0xFF28282C))
                              : null,
                          boxShadow: _kOverlayShadow,
                        ),
                        child: DefaultTextStyle.merge(
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: textColor,
                          ),
                          child: IconTheme.merge(
                            data: IconThemeData(color: textColor),
                            child: content,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PopoverLayoutDelegate extends SingleChildLayoutDelegate {
  const _PopoverLayoutDelegate({
    required this.triggerRect,
    required this.safeRect,
    required this.preferBelow,
    required this.gap,
  });

  final Rect triggerRect;
  final Rect safeRect;
  final bool preferBelow;
  final double gap;

  double _clamp(double value, double minValue, double maxValue) {
    if (maxValue < minValue) {
      return minValue;
    }
    return value.clamp(minValue, maxValue).toDouble();
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final minX = safeRect.left;
    final maxX = safeRect.right - childSize.width;
    final minY = safeRect.top;
    final maxY = safeRect.bottom - childSize.height;

    final x = _clamp(triggerRect.center.dx - (childSize.width / 2), minX, maxX);

    final belowY = triggerRect.bottom + gap;
    final aboveY = triggerRect.top - childSize.height - gap;
    final fitsBelow = belowY + childSize.height <= safeRect.bottom;
    final fitsAbove = aboveY >= safeRect.top;
    final availableBelow = safeRect.bottom - triggerRect.bottom - gap;
    final availableAbove = triggerRect.top - safeRect.top - gap;
    final openBelow = preferBelow
        ? (fitsBelow || (!fitsAbove && availableBelow >= availableAbove))
        : (!fitsAbove && (fitsBelow || availableBelow > availableAbove));

    final y = _clamp(openBelow ? belowY : aboveY, minY, maxY);
    return Offset(x, y);
  }

  @override
  bool shouldRelayout(_PopoverLayoutDelegate old) =>
      triggerRect != old.triggerRect ||
      safeRect != old.safeRect ||
      preferBelow != old.preferBelow ||
      gap != old.gap;
}
