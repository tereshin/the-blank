import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../../../core/icons/heroui_icon.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// SHARED OVERLAY STYLES
// ═══════════════════════════════════════════════════════════════════════════════

const _kOverlayShadow = [
  BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.08),
    blurRadius: 28,
    offset: Offset(0, 14),
  ),
  BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.03),
    blurRadius: 12,
    offset: Offset(0, -6),
  ),
  BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.06),
    blurRadius: 8,
    offset: Offset(0, 2),
  ),
];

// ═══════════════════════════════════════════════════════════════════════════════
// TOOLTIP
// ═══════════════════════════════════════════════════════════════════════════════

enum HeroUiTooltipPosition { top, bottom, left, right }

/// A small popup tooltip that appears relative to a [child] widget.
///
/// - [message]: the text shown in the tooltip.
/// - [position]: which side of the child the tooltip appears on.
/// - [inverse]: dark background tooltip (default is light).
class HeroUiTooltip extends StatefulWidget {
  const HeroUiTooltip({
    super.key,
    required this.message,
    required this.child,
    this.position = HeroUiTooltipPosition.top,
    this.inverse = false,
  });

  final String message;
  final Widget child;
  final HeroUiTooltipPosition position;
  final bool inverse;

  @override
  State<HeroUiTooltip> createState() => _HeroUiTooltipState();
}

class _HeroUiTooltipState extends State<HeroUiTooltip>
    with SingleTickerProviderStateMixin {
  OverlayEntry? _entry;
  final _key = GlobalKey();
  late final AnimationController _ctrl;
  late final Animation<double> _fade;

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
    _hide();
    _ctrl.dispose();
    super.dispose();
  }

  void _show() {
    if (_entry != null) return;
    final RenderBox box =
        _key.currentContext!.findRenderObject() as RenderBox;
    final offset = box.localToGlobal(Offset.zero);
    final size = box.size;

    _entry = OverlayEntry(
      builder: (_) => _TooltipOverlay(
        message: widget.message,
        position: widget.position,
        inverse: widget.inverse,
        triggerOffset: offset,
        triggerSize: size,
        fade: _fade,
      ),
    );

    Overlay.of(context).insert(_entry!);
    _ctrl.forward();
  }

  void _hide() {
    _ctrl.reverse().then((_) {
      _entry?.remove();
      _entry = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _show(),
      onExit: (_) => _hide(),
      child: GestureDetector(
        onTap: () => _entry == null ? _show() : _hide(),
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
    required this.triggerOffset,
    required this.triggerSize,
    required this.fade,
  });

  final String message;
  final HeroUiTooltipPosition position;
  final bool inverse;
  final Offset triggerOffset;
  final Size triggerSize;
  final Animation<double> fade;

  static const _gap = 6.0;
  static const _arrowH = 6.0;
  static const _padding = EdgeInsets.symmetric(horizontal: 12, vertical: 6);

  @override
  Widget build(BuildContext context) {
    final bg = inverse ? const Color(0xFF18181B) : const Color(0xFFFFFFFF);
    final textColor =
        inverse ? const Color(0xFFFCFCFC) : const Color(0xFF18181B);

    final content = Container(
      padding: _padding,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.12),
            blurRadius: 12,
            offset: Offset(0, 4),
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
      ),
    );

    return Positioned.fill(
      child: IgnorePointer(
        child: FadeTransition(
          opacity: fade,
          child: _TooltipPositioner(
            position: position,
            triggerOffset: triggerOffset,
            triggerSize: triggerSize,
            gap: _gap + _arrowH,
            arrowColor: bg,
            child: content,
          ),
        ),
      ),
    );
  }
}

class _TooltipPositioner extends StatelessWidget {
  const _TooltipPositioner({
    required this.position,
    required this.triggerOffset,
    required this.triggerSize,
    required this.gap,
    required this.child,
    required this.arrowColor,
  });

  final HeroUiTooltipPosition position;
  final Offset triggerOffset;
  final Size triggerSize;
  final double gap;
  final Widget child;
  final Color arrowColor;

  @override
  Widget build(BuildContext context) {
    final cx = triggerOffset.dx + triggerSize.width / 2;
    final cy = triggerOffset.dy + triggerSize.height / 2;

    return CustomSingleChildLayout(
      delegate: _TooltipLayoutDelegate(
        position: position,
        triggerRect: triggerOffset & triggerSize,
        gap: gap,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (position == HeroUiTooltipPosition.bottom)
            _ArrowUp(color: arrowColor, cx: cx),
          if (position == HeroUiTooltipPosition.right)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ArrowLeft(color: arrowColor, cy: cy),
                Flexible(child: child),
              ],
            )
          else if (position == HeroUiTooltipPosition.left)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(child: child),
                _ArrowRight(color: arrowColor, cy: cy),
              ],
            )
          else
            child,
          if (position == HeroUiTooltipPosition.top)
            _ArrowDown(color: arrowColor, cx: cx),
        ],
      ),
    );
  }
}

class _TooltipLayoutDelegate extends SingleChildLayoutDelegate {
  const _TooltipLayoutDelegate({
    required this.position,
    required this.triggerRect,
    required this.gap,
  });

  final HeroUiTooltipPosition position;
  final Rect triggerRect;
  final double gap;

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    double x, y;
    switch (position) {
      case HeroUiTooltipPosition.top:
        x = triggerRect.center.dx - childSize.width / 2;
        y = triggerRect.top - childSize.height - gap;
      case HeroUiTooltipPosition.bottom:
        x = triggerRect.center.dx - childSize.width / 2;
        y = triggerRect.bottom + gap;
      case HeroUiTooltipPosition.left:
        x = triggerRect.left - childSize.width - gap;
        y = triggerRect.center.dy - childSize.height / 2;
      case HeroUiTooltipPosition.right:
        x = triggerRect.right + gap;
        y = triggerRect.center.dy - childSize.height / 2;
    }
    return Offset(
      x.clamp(8, size.width - childSize.width - 8),
      y.clamp(8, size.height - childSize.height - 8),
    );
  }

  @override
  bool shouldRelayout(_TooltipLayoutDelegate old) =>
      position != old.position || triggerRect != old.triggerRect;
}

class _ArrowUp extends StatelessWidget {
  const _ArrowUp({required this.color, required this.cx});
  final Color color;
  final double cx;

  @override
  Widget build(BuildContext context) => CustomPaint(
        size: const Size(12, 6),
        painter: _TrianglePainter(color: color, direction: _TriDir.up),
      );
}

class _ArrowDown extends StatelessWidget {
  const _ArrowDown({required this.color, required this.cx});
  final Color color;
  final double cx;

  @override
  Widget build(BuildContext context) => CustomPaint(
        size: const Size(12, 6),
        painter: _TrianglePainter(color: color, direction: _TriDir.down),
      );
}

class _ArrowLeft extends StatelessWidget {
  const _ArrowLeft({required this.color, required this.cy});
  final Color color;
  final double cy;

  @override
  Widget build(BuildContext context) => CustomPaint(
        size: const Size(6, 12),
        painter: _TrianglePainter(color: color, direction: _TriDir.left),
      );
}

class _ArrowRight extends StatelessWidget {
  const _ArrowRight({required this.color, required this.cy});
  final Color color;
  final double cy;

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

// ═══════════════════════════════════════════════════════════════════════════════
// POPOVER
// ═══════════════════════════════════════════════════════════════════════════════

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
    _close();
    _ctrl.dispose();
    super.dispose();
  }

  void _open() {
    if (_entry != null) {
      _close();
      return;
    }
    final RenderBox box =
        _key.currentContext!.findRenderObject() as RenderBox;
    final offset = box.localToGlobal(Offset.zero);
    final size = box.size;

    _entry = OverlayEntry(
      builder: (_) => _PopoverOverlay(
        triggerOffset: offset,
        triggerSize: size,
        preferBelow: widget.preferBelow,
        fade: _fade,
        slide: _slide,
        content: widget.content,
        onDismiss: _close,
      ),
    );

    Overlay.of(context).insert(_entry!);
    _ctrl.forward();
  }

  void _close() {
    _ctrl.reverse().then((_) {
      _entry?.remove();
      _entry = null;
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
    required this.triggerOffset,
    required this.triggerSize,
    required this.preferBelow,
    required this.fade,
    required this.slide,
    required this.content,
    required this.onDismiss,
  });

  final Offset triggerOffset;
  final Size triggerSize;
  final bool preferBelow;
  final Animation<double> fade;
  final Animation<Offset> slide;
  final Widget content;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF18181B) : const Color(0xFFFFFFFF);

    final top = preferBelow
        ? triggerOffset.dy + triggerSize.height + 8
        : null;
    final bottom = preferBelow
        ? null
        : MediaQuery.of(context).size.height -
            triggerOffset.dy +
            8;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onDismiss,
      child: Stack(
        children: [
          Positioned(
            left: triggerOffset.dx,
            top: top,
            bottom: bottom,
            child: GestureDetector(
              onTap: () {},
              child: FadeTransition(
                opacity: fade,
                child: SlideTransition(
                  position: slide,
                  child: Material(
                    color: Colors.transparent,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: 200,
                        maxWidth: 320,
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: bg,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: _kOverlayShadow,
                        ),
                        child: content,
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

// ═══════════════════════════════════════════════════════════════════════════════
// DROPDOWN
// ═══════════════════════════════════════════════════════════════════════════════

enum HeroUiDropdownItemState {
  defaultState,
  hover,
  focus,
  pressed,
  selected,
  disabled,
}

/// A model for items in a [HeroUiDropdown].
class HeroUiDropdownItem {
  const HeroUiDropdownItem({
    required this.label,
    this.description,
    this.leading,
    this.trailing,
    this.isDanger = false,
    this.isDisabled = false,
    this.isSelected = false,
    this.state,
    this.closeOnTap = true,
    this.onTap,
  });

  final String label;
  final String? description;
  final Widget? leading;
  final Widget? trailing;
  final bool isDanger;
  final bool isDisabled;
  final bool isSelected;
  final HeroUiDropdownItemState? state;
  final bool closeOnTap;
  final VoidCallback? onTap;
}

/// A model for item groups in a [HeroUiDropdown].
class HeroUiDropdownSection {
  const HeroUiDropdownSection({
    this.title,
    required this.items,
    this.showDivider = true,
  });

  final String? title;
  final List<HeroUiDropdownItem> items;
  final bool showDivider;
}

/// A button with an attached dropdown menu.
///
/// [sections] can be grouped item sections with optional titles.
class HeroUiDropdown extends StatefulWidget {
  const HeroUiDropdown({
    super.key,
    required this.trigger,
    required this.sections,
    this.width = 240.0,
    this.matchTriggerWidth = false,
    this.showGroups = true,
    this.showDividers = true,
    this.menuMaxHeight = 320.0,
    this.offset = const Offset(0, 8),
  });

  final Widget trigger;
  final List<HeroUiDropdownSection> sections;
  final double width;
  final bool matchTriggerWidth;
  final bool showGroups;
  final bool showDividers;
  final double menuMaxHeight;
  final Offset offset;

  @override
  State<HeroUiDropdown> createState() => _HeroUiDropdownState();
}

class _HeroUiDropdownState extends State<HeroUiDropdown>
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
      duration: const Duration(milliseconds: 180),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, -0.02),
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
    final RenderBox box =
        _key.currentContext!.findRenderObject() as RenderBox;
    final offset = box.localToGlobal(Offset.zero);
    final size = box.size;

    _entry = OverlayEntry(
      builder: (_) => _DropdownMenuOverlay(
        triggerRect: offset & size,
        sections: widget.sections,
        width: widget.width,
        matchTriggerWidth: widget.matchTriggerWidth,
        showGroups: widget.showGroups,
        showDividers: widget.showDividers,
        menuMaxHeight: widget.menuMaxHeight,
        offset: widget.offset,
        fade: _fade,
        slide: _slide,
        onDismiss: _close,
        onItemTap: (item) {
          if (item.isDisabled ||
              item.state == HeroUiDropdownItemState.disabled) {
            return;
          }
          if (item.closeOnTap) {
            _close();
          }
          item.onTap?.call();
        },
      ),
    );

    Overlay.of(context).insert(_entry!);
    _ctrl.forward();
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

class _DropdownMenuOverlay extends StatelessWidget {
  const _DropdownMenuOverlay({
    required this.triggerRect,
    required this.sections,
    required this.width,
    required this.matchTriggerWidth,
    required this.showGroups,
    required this.showDividers,
    required this.menuMaxHeight,
    required this.offset,
    required this.fade,
    required this.slide,
    required this.onDismiss,
    required this.onItemTap,
  });

  final Rect triggerRect;
  final List<HeroUiDropdownSection> sections;
  final double width;
  final bool matchTriggerWidth;
  final bool showGroups;
  final bool showDividers;
  final double menuMaxHeight;
  final Offset offset;
  final Animation<double> fade;
  final Animation<Offset> slide;
  final VoidCallback onDismiss;
  final ValueChanged<HeroUiDropdownItem> onItemTap;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF18181B) : const Color(0xFFFFFFFF);
    final sectionLabelColor =
        isDark ? const Color(0xFFA1A1AA) : const Color(0xFF71717A);
    final titleColor =
        isDark ? const Color(0xFFFCFCFC) : const Color(0xFF18181B);
    final dangerTitleColor =
        isDark ? const Color(0xFFDB3B3E) : const Color(0xFFFF383C);
    final dividerColor = isDark ? const Color(0xFF28282C) : const Color(0xFFE4E4E7);
    final hoverColor = isDark ? const Color(0xFF27272A) : const Color(0xFFEBEBEC);
    final dangerHoverColor =
        isDark ? const Color(0x26DB3B3E) : const Color(0x1AFF383C);
    const viewportPadding = 8.0;
    final viewportWidth = mediaQuery.size.width;
    final viewportHeight = mediaQuery.size.height;
    final baseWidth = matchTriggerWidth ? math.max(width, triggerRect.width) : width;
    final resolvedWidth = math.min(
      baseWidth,
      math.max(120.0, viewportWidth - (viewportPadding * 2)),
    );
    final safeTop = mediaQuery.padding.top + viewportPadding;
    final safeBottom = viewportHeight - mediaQuery.padding.bottom - viewportPadding;
    final anchorBelow = triggerRect.bottom + offset.dy;
    final anchorAbove = triggerRect.top - offset.dy;
    final availableBelow = safeBottom - anchorBelow;
    final availableAbove = anchorAbove - safeTop;
    final openBelow = availableBelow >= 160 || availableBelow >= availableAbove;

    final maxHeightBySide = openBelow ? availableBelow : availableAbove;
    final maxPossibleHeight = math.max(40.0, safeBottom - safeTop);
    final panelMaxHeight = math.min(
      maxPossibleHeight,
      math.max(
        80.0,
        math.min(menuMaxHeight, math.max(0.0, maxHeightBySide)),
      ),
    );
    final desiredTop = openBelow ? anchorBelow : anchorAbove - panelMaxHeight;
    final clampedTop = desiredTop
        .clamp(safeTop, safeBottom - panelMaxHeight)
        .toDouble();
    final clampedLeft = (triggerRect.left + offset.dx)
        .clamp(
          viewportPadding,
          viewportWidth - resolvedWidth - viewportPadding,
        )
        .toDouble();
    final visibleSections =
        sections.where((section) => section.items.isNotEmpty).toList();

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onDismiss,
      child: Stack(
        children: [
          Positioned(
            left: clampedLeft,
            top: clampedTop,
            width: resolvedWidth,
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
                        minWidth: resolvedWidth,
                        maxWidth: resolvedWidth,
                        maxHeight: panelMaxHeight,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: bg,
                          borderRadius: BorderRadius.circular(24),
                          border: isDark
                              ? Border.all(color: const Color(0xFF28282C))
                              : null,
                          boxShadow: _kOverlayShadow,
                        ),
                        child: ListView(
                          padding: const EdgeInsets.all(4),
                          shrinkWrap: true,
                          primary: false,
                          children: [
                            for (var i = 0; i < visibleSections.length; i++) ...[
                              if (i > 0 &&
                                  showDividers &&
                                  visibleSections[i - 1].showDivider)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 2,
                                  ),
                                  child: Container(
                                    height: 1,
                                    color: dividerColor,
                                  ),
                                ),
                              if (showGroups &&
                                  visibleSections[i].title != null &&
                                  visibleSections[i].title!.trim().isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    12,
                                    10,
                                    12,
                                    4,
                                  ),
                                  child: Text(
                                    visibleSections[i].title!,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      height: 1.34,
                                      color: sectionLabelColor,
                                    ),
                                  ),
                                ),
                              for (final item in visibleSections[i].items)
                                _DropdownMenuItemTile(
                                  item: item,
                                  titleColor: titleColor,
                                  descriptionColor: sectionLabelColor,
                                  dangerColor: dangerTitleColor,
                                  hoverColor: hoverColor,
                                  dangerHoverColor: dangerHoverColor,
                                  onTap: () => onItemTap(item),
                                ),
                            ],
                          ],
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

class _DropdownMenuItemTile extends StatefulWidget {
  const _DropdownMenuItemTile({
    required this.item,
    required this.titleColor,
    required this.descriptionColor,
    required this.dangerColor,
    required this.hoverColor,
    required this.dangerHoverColor,
    required this.onTap,
  });

  final HeroUiDropdownItem item;
  final Color titleColor;
  final Color descriptionColor;
  final Color dangerColor;
  final Color hoverColor;
  final Color dangerHoverColor;
  final VoidCallback onTap;

  @override
  State<_DropdownMenuItemTile> createState() => _DropdownMenuItemTileState();
}

class _DropdownMenuItemTileState extends State<_DropdownMenuItemTile> {
  bool _hover = false;
  bool _focused = false;
  bool _pressed = false;

  HeroUiDropdownItemState _resolveVisualState(HeroUiDropdownItem item) {
    if (item.state == HeroUiDropdownItemState.disabled || item.isDisabled) {
      return HeroUiDropdownItemState.disabled;
    }
    if (item.state != null) {
      return item.state!;
    }
    if (_pressed) return HeroUiDropdownItemState.pressed;
    if (_hover) return HeroUiDropdownItemState.hover;
    if (_focused) return HeroUiDropdownItemState.focus;
    if (item.isSelected) return HeroUiDropdownItemState.selected;
    return HeroUiDropdownItemState.defaultState;
  }

  Color _stateBackground({
    required HeroUiDropdownItemState state,
    required bool isDark,
    required bool isDanger,
  }) {
    if (state == HeroUiDropdownItemState.hover ||
        state == HeroUiDropdownItemState.focus) {
      return isDanger ? widget.dangerHoverColor : widget.hoverColor;
    }
    if (state == HeroUiDropdownItemState.pressed) {
      if (isDanger) {
        return isDark ? const Color(0x33DB3B3E) : const Color(0x2EFF383C);
      }
      return isDark ? const Color(0xFF3F3F46) : const Color(0xFFDEDEE0);
    }
    return Colors.transparent;
  }

  List<BoxShadow>? _focusRing(bool isDark, HeroUiDropdownItemState state) {
    if (state != HeroUiDropdownItemState.focus) return null;
    return [
      const BoxShadow(
        color: Color(0xFF0485F7),
        spreadRadius: 4,
        blurRadius: 0,
      ),
      BoxShadow(
        color: isDark ? const Color(0xFF060607) : const Color(0xFFF5F5F5),
        spreadRadius: 2,
        blurRadius: 0,
      ),
    ];
  }

  Widget _resolveSlotWidget(Widget child, Color fallbackColor) {
    if (child is HeroUiIcon) {
      return HeroUiIcon(
        child.name,
        key: child.key,
        size: child.size,
        color: child.color ?? fallbackColor,
        semanticLabel: child.semanticLabel,
      );
    }
    if (child is Icon) {
      return Icon(
        child.icon,
        key: child.key,
        size: child.size,
        color: child.color ?? fallbackColor,
        semanticLabel: child.semanticLabel,
      );
    }
    return child;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final item = widget.item;
    final visualState = _resolveVisualState(item);
    final isDisabled = visualState == HeroUiDropdownItemState.disabled;
    final titleColor = item.isDanger ? widget.dangerColor : widget.titleColor;
    final trailingColor = widget.descriptionColor;
    final effectiveLeading = item.leading ??
        (visualState == HeroUiDropdownItemState.selected
            ? HeroUiIcon(
                'heroui-v3-icon__check__regular',
                size: 16,
                color: titleColor,
              )
            : null);
    final leadingWidget = effectiveLeading == null
        ? null
        : _resolveSlotWidget(effectiveLeading, titleColor);
    final trailingWidget = item.trailing == null
        ? null
        : _resolveSlotWidget(item.trailing!, trailingColor);

    return FocusableActionDetector(
      enabled: !isDisabled,
      mouseCursor:
          isDisabled ? SystemMouseCursors.basic : SystemMouseCursors.click,
      onShowHoverHighlight: isDisabled
          ? null
          : (value) => setState(() => _hover = value),
      onShowFocusHighlight: isDisabled
          ? null
          : (value) => setState(() => _focused = value),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: isDisabled
            ? null
            : (_) => setState(() => _pressed = true),
        onTapUp: isDisabled
            ? null
            : (_) => setState(() => _pressed = false),
        onTapCancel: isDisabled
            ? null
            : () => setState(() => _pressed = false),
        onTap: isDisabled ? null : widget.onTap,
        child: Opacity(
          opacity: isDisabled ? 0.5 : 1.0,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _stateBackground(
                state: visualState,
                isDark: isDark,
                isDanger: item.isDanger,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: _focusRing(isDark, visualState),
            ),
            child: Row(
              crossAxisAlignment: item.description == null
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              children: [
                if (leadingWidget != null) ...[
                  Padding(
                    padding: EdgeInsets.only(top: item.description == null ? 0 : 3),
                    child: leadingWidget,
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 1.43,
                          color: titleColor,
                        ),
                      ),
                      if (item.description != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          item.description!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            height: 1.34,
                            color: widget.descriptionColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailingWidget != null) ...[
                  const SizedBox(width: 12),
                  trailingWidget,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// MODAL
// ═══════════════════════════════════════════════════════════════════════════════

enum HeroUiModalSize { sm, md, lg, full }

/// Shows a modal dialog.
///
/// Call [HeroUiModal.show] to display the dialog imperatively.
class HeroUiModal {
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget body,
    List<Widget>? actions,
    HeroUiModalSize size = HeroUiModalSize.md,
    bool barrierDismissible = true,
    bool blurBarrier = false,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: 'Dismiss',
      barrierColor: blurBarrier
          ? Colors.black.withValues(alpha: 0.3)
          : Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (ctx, anim, _) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        final bg = isDark ? const Color(0xFF18181B) : const Color(0xFFFFFFFF);
        final titleColor =
            isDark ? const Color(0xFFFCFCFC) : const Color(0xFF18181B);

        final maxW = switch (size) {
          HeroUiModalSize.sm => 400.0,
          HeroUiModalSize.md => 560.0,
          HeroUiModalSize.lg => 720.0,
          HeroUiModalSize.full => double.infinity,
        };

        return FadeTransition(
          opacity: anim,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1.0).animate(
              CurvedAnimation(parent: anim, curve: Curves.easeOut),
            ),
            child: Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: size == HeroUiModalSize.full
                  ? EdgeInsets.zero
                  : const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: maxW,
                  minWidth: 0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: size == HeroUiModalSize.full
                        ? BorderRadius.zero
                        : BorderRadius.circular(24),
                    boxShadow: _kOverlayShadow,
                  ),
                  child: Column(
                    mainAxisSize: size == HeroUiModalSize.full
                        ? MainAxisSize.max
                        : MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 20, 16, 0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  height: 1.4,
                                  color: titleColor,
                                ),
                              ),
                            ),
                            _CloseIconButton(
                              onTap: () => Navigator.of(ctx).pop(),
                            ),
                          ],
                        ),
                      ),
                      // Body
                      Flexible(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                          child: body,
                        ),
                      ),
                      // Footer
                      if (actions != null && actions.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              for (var i = 0; i < actions.length; i++) ...[
                                if (i > 0) const SizedBox(width: 8),
                                actions[i],
                              ],
                            ],
                          ),
                        ),
                      if (actions == null || actions.isEmpty)
                        const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// ALERT DIALOG
// ═══════════════════════════════════════════════════════════════════════════════

/// Shows a confirmation/alert dialog with title, body, and action buttons.
///
/// Call [HeroUiAlertDialog.show] to display it.
class HeroUiAlertDialog {
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    String? description,
    Widget? body,
    String cancelLabel = 'Cancel',
    String confirmLabel = 'Confirm',
    bool isDanger = false,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool barrierDismissible = true,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (ctx, anim, _) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        final bg = isDark ? const Color(0xFF18181B) : const Color(0xFFFFFFFF);
        final titleColor =
            isDark ? const Color(0xFFFCFCFC) : const Color(0xFF18181B);
        final descColor =
            isDark ? const Color(0xFFA1A1AA) : const Color(0xFF71717A);

        return FadeTransition(
          opacity: anim,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.96, end: 1.0).animate(
              CurvedAnimation(parent: anim, curve: Curves.easeOut),
            ),
            child: Dialog(
              backgroundColor: Colors.transparent,
              insetPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: _kOverlayShadow,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isDanger
                              ? const Color(0x1AFF383C)
                              : const Color(0x1A0485F7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          isDanger
                              ? Icons.warning_amber_rounded
                              : Icons.info_outline_rounded,
                          size: 20,
                          color: isDanger
                              ? const Color(0xFFFF383C)
                              : const Color(0xFF0485F7),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Title
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                          color: titleColor,
                        ),
                      ),
                      if (description != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                            color: descColor,
                          ),
                        ),
                      ],
                      if (body != null) ...[
                        const SizedBox(height: 12),
                        body,
                      ],
                      const SizedBox(height: 24),
                      // Actions
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _OutlineButton(
                            label: cancelLabel,
                            onTap: () {
                              Navigator.of(ctx).pop();
                              onCancel?.call();
                            },
                          ),
                          const SizedBox(width: 8),
                          _FilledButton(
                            label: confirmLabel,
                            isDanger: isDanger,
                            onTap: () {
                              Navigator.of(ctx).pop();
                              onConfirm?.call();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// DRAWER
// ═══════════════════════════════════════════════════════════════════════════════

enum HeroUiDrawerPosition { bottom, top, left, right }

/// Shows a side/bottom/top drawer panel.
///
/// Call [HeroUiDrawer.show] to display the drawer imperatively.
class HeroUiDrawer {
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget body,
    HeroUiDrawerPosition position = HeroUiDrawerPosition.right,
    String? title,
    String? subtitle,
    List<Widget>? footerActions,
    bool barrierDismissible = true,
    double? size,
  }) {
    final isVertical = position == HeroUiDrawerPosition.left ||
        position == HeroUiDrawerPosition.right;
    final defaultSize = isVertical ? 393.0 : 360.0;
    final resolvedSize = size ?? defaultSize;

    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (ctx, anim, _) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        final bg = isDark ? const Color(0xFF18181B) : const Color(0xFFFFFFFF);
        final titleColor =
            isDark ? const Color(0xFFFCFCFC) : const Color(0xFF18181B);

        final slideAnim = Tween<Offset>(
          begin: switch (position) {
            HeroUiDrawerPosition.right => const Offset(1, 0),
            HeroUiDrawerPosition.left => const Offset(-1, 0),
            HeroUiDrawerPosition.bottom => const Offset(0, 1),
            HeroUiDrawerPosition.top => const Offset(0, -1),
          },
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: anim, curve: Curves.easeOut),
        );

        final borderRadius = switch (position) {
          HeroUiDrawerPosition.right =>
            const BorderRadius.horizontal(left: Radius.circular(16)),
          HeroUiDrawerPosition.left =>
            const BorderRadius.horizontal(right: Radius.circular(16)),
          HeroUiDrawerPosition.bottom =>
            const BorderRadius.vertical(top: Radius.circular(16)),
          HeroUiDrawerPosition.top =>
            const BorderRadius.vertical(bottom: Radius.circular(16)),
        };

        final showHandle = position == HeroUiDrawerPosition.bottom ||
            position == HeroUiDrawerPosition.top;

        Widget panel = Container(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: borderRadius,
            boxShadow: _kOverlayShadow,
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Handle for bottom/top drawers
              if (showHandle && position == HeroUiDrawerPosition.bottom)
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDEDEE0),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              // Header
              if (title != null)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              height: 1.4,
                              color: titleColor,
                            ),
                          ),
                          if (subtitle != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              subtitle,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF71717A),
                                height: 1.43,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    _CloseIconButton(onTap: () => Navigator.of(ctx).pop()),
                  ],
                ),
              // Body
              if (title != null) const SizedBox(height: 16),
              Flexible(
                child: SingleChildScrollView(child: body),
              ),
              // Footer
              if (footerActions != null && footerActions.isNotEmpty) ...[
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    for (var i = 0; i < footerActions.length; i++) ...[
                      if (i > 0) const SizedBox(width: 8),
                      footerActions[i],
                    ],
                  ],
                ),
              ],
              // Handle for top drawers
              if (showHandle && position == HeroUiDrawerPosition.top)
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    margin: const EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDEDEE0),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
            ],
          ),
        );

        panel = SlideTransition(position: slideAnim, child: panel);

        return Align(
          alignment: switch (position) {
            HeroUiDrawerPosition.right => Alignment.centerRight,
            HeroUiDrawerPosition.left => Alignment.centerLeft,
            HeroUiDrawerPosition.bottom => Alignment.bottomCenter,
            HeroUiDrawerPosition.top => Alignment.topCenter,
          },
          child: SafeArea(
            child: isVertical
                ? SizedBox(width: resolvedSize, child: panel)
                : SizedBox(width: double.infinity, child: panel),
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// INTERNAL SHARED WIDGETS
// ═══════════════════════════════════════════════════════════════════════════════

class _CloseIconButton extends StatefulWidget {
  const _CloseIconButton({required this.onTap});
  final VoidCallback onTap;

  @override
  State<_CloseIconButton> createState() => _CloseIconButtonState();
}

class _CloseIconButtonState extends State<_CloseIconButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF27272A) : const Color(0xFFEBEBEC);

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: _hover
                ? bg.withValues(alpha: 0.8)
                : bg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.close_rounded,
            size: 16,
            color: isDark ? const Color(0xFFA1A1AA) : const Color(0xFF71717A),
          ),
        ),
      ),
    );
  }
}

class _OutlineButton extends StatefulWidget {
  const _OutlineButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  State<_OutlineButton> createState() => _OutlineButtonState();
}

class _OutlineButtonState extends State<_OutlineButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? const Color(0xFFFCFCFC) : const Color(0xFF18181B);
    final borderColor = isDark ? const Color(0xFF3F3F46) : const Color(0xFFDEDEE0);
    final hoverColor = isDark ? const Color(0xFF27272A) : const Color(0xFFEFEFF0);

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: _hover ? hoverColor : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: borderColor),
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.43,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _FilledButton extends StatefulWidget {
  const _FilledButton({
    required this.label,
    required this.onTap,
    this.isDanger = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool isDanger;

  @override
  State<_FilledButton> createState() => _FilledButtonState();
}

class _FilledButtonState extends State<_FilledButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final bg = widget.isDanger
        ? const Color(0xFFFF383C)
        : const Color(0xFF0485F7);

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: _hover ? bg.withValues(alpha: 0.85) : bg,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Text(
            widget.label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.43,
              color: Color(0xFFFFFFFF),
            ),
          ),
        ),
      ),
    );
  }
}
