part of 'heroui_overlays.dart';

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
    final RenderBox box = _key.currentContext!.findRenderObject() as RenderBox;
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
    final sectionLabelColor = isDark
        ? const Color(0xFFA1A1AA)
        : const Color(0xFF71717A);
    final titleColor = isDark
        ? const Color(0xFFFCFCFC)
        : const Color(0xFF18181B);
    final dangerTitleColor = isDark
        ? const Color(0xFFDB3B3E)
        : const Color(0xFFFF383C);
    final dividerColor = isDark
        ? const Color(0xFF28282C)
        : const Color(0xFFE4E4E7);
    final hoverColor = isDark
        ? const Color(0xFF27272A)
        : const Color(0xFFEBEBEC);
    final dangerHoverColor = isDark
        ? const Color(0x26DB3B3E)
        : const Color(0x1AFF383C);
    const viewportPadding = 8.0;
    final viewportWidth = mediaQuery.size.width;
    final viewportHeight = mediaQuery.size.height;
    final baseWidth = matchTriggerWidth
        ? math.max(width, triggerRect.width)
        : width;
    final resolvedWidth = math.min(
      baseWidth,
      math.max(120.0, viewportWidth - (viewportPadding * 2)),
    );
    final safeTop = mediaQuery.padding.top + viewportPadding;
    final safeBottom =
        viewportHeight - mediaQuery.padding.bottom - viewportPadding;
    final anchorBelow = triggerRect.bottom + offset.dy;
    final anchorAbove = triggerRect.top - offset.dy;
    final availableBelow = safeBottom - anchorBelow;
    final availableAbove = anchorAbove - safeTop;
    final openBelow = availableBelow >= 160 || availableBelow >= availableAbove;

    final maxHeightBySide = openBelow ? availableBelow : availableAbove;
    final maxPossibleHeight = math.max(40.0, safeBottom - safeTop);
    final panelMaxHeight = math.min(
      maxPossibleHeight,
      math.max(80.0, math.min(menuMaxHeight, math.max(0.0, maxHeightBySide))),
    );
    final desiredTop = openBelow ? anchorBelow : anchorAbove - panelMaxHeight;
    final clampedTop = desiredTop
        .clamp(safeTop, safeBottom - panelMaxHeight)
        .toDouble();
    final clampedLeft = (triggerRect.left + offset.dx)
        .clamp(viewportPadding, viewportWidth - resolvedWidth - viewportPadding)
        .toDouble();
    final visibleSections = sections
        .where((section) => section.items.isNotEmpty)
        .toList();

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
                            for (
                              var i = 0;
                              i < visibleSections.length;
                              i++
                            ) ...[
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
                                    style: HeroUiTypography.bodyXsMedium
                                        .copyWith(color: sectionLabelColor),
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
      const BoxShadow(color: Color(0xFF0485F7), spreadRadius: 4, blurRadius: 0),
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
    final effectiveLeading =
        item.leading ??
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
      mouseCursor: isDisabled
          ? SystemMouseCursors.basic
          : SystemMouseCursors.click,
      onShowHoverHighlight: isDisabled
          ? null
          : (value) => setState(() => _hover = value),
      onShowFocusHighlight: isDisabled
          ? null
          : (value) => setState(() => _focused = value),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: isDisabled ? null : (_) => setState(() => _pressed = true),
        onTapUp: isDisabled ? null : (_) => setState(() => _pressed = false),
        onTapCancel: isDisabled ? null : () => setState(() => _pressed = false),
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
                    padding: EdgeInsets.only(
                      top: item.description == null ? 0 : 3,
                    ),
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
                        style: HeroUiTypography.bodySmMedium.copyWith(
                          color: titleColor,
                        ),
                      ),
                      if (item.description != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          item.description!,
                          style: HeroUiTypography.bodyXs.copyWith(
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
