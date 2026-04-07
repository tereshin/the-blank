part of 'heroui_collections.dart';

enum HeroUiListBoxSelectionMode { single, multiple }

enum HeroUiListBoxItemState { defaultState, hover, focus, selected, disabled }

enum HeroUiListBoxItemType { initial, danger }

class HeroUiListBoxItem<T> {
  const HeroUiListBoxItem({
    required this.value,
    required this.label,
    this.description,
    this.prefix,
    this.suffix,
    @Deprecated('Use prefix instead.') this.leading,
    @Deprecated('Use suffix instead.') this.trailing,
    @Deprecated('Use type: HeroUiListBoxItemType.danger instead.')
    this.isDanger = false,
    this.type = HeroUiListBoxItemType.initial,
    this.state,
    this.isDisabled = false,
  });

  final T value;
  final String label;
  final String? description;
  final Widget? prefix;
  final Widget? suffix;

  @Deprecated('Use prefix instead.')
  final Widget? leading;

  @Deprecated('Use suffix instead.')
  final Widget? trailing;

  @Deprecated('Use type: HeroUiListBoxItemType.danger instead.')
  final bool isDanger;
  final HeroUiListBoxItemType type;
  final HeroUiListBoxItemState? state;
  final bool isDisabled;

  bool get isDangerType => type == HeroUiListBoxItemType.danger || isDanger;

  bool get isDisabledState =>
      isDisabled || state == HeroUiListBoxItemState.disabled;

  Widget? get effectivePrefix => prefix ?? leading;
  Widget? get effectiveSuffix => suffix ?? trailing;
}

class HeroUiListBox<T> extends StatefulWidget {
  const HeroUiListBox({
    super.key,
    required this.items,
    this.selectionMode = HeroUiListBoxSelectionMode.single,
    this.selectedValues = const {},
    this.onSelectionChanged,
    this.label,
    this.description,
    this.padding = EdgeInsets.zero,
    this.itemSpacing = 0,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });

  final List<HeroUiListBoxItem<T>> items;
  final HeroUiListBoxSelectionMode selectionMode;
  final Set<T> selectedValues;
  final ValueChanged<Set<T>>? onSelectionChanged;
  final String? label;
  final String? description;
  final EdgeInsetsGeometry padding;
  final double itemSpacing;
  final BorderRadius borderRadius;

  @override
  State<HeroUiListBox<T>> createState() => _HeroUiListBoxState<T>();
}

class _HeroUiListBoxState<T> extends State<HeroUiListBox<T>> {
  late Set<T> _selected;

  @override
  void initState() {
    super.initState();
    _selected = Set<T>.from(widget.selectedValues);
  }

  @override
  void didUpdateWidget(HeroUiListBox<T> old) {
    super.didUpdateWidget(old);
    if (widget.selectedValues != old.selectedValues) {
      _selected = Set<T>.from(widget.selectedValues);
    }
  }

  void _toggleItem(HeroUiListBoxItem<T> item) {
    if (item.isDisabledState) return;
    setState(() {
      if (_selected.contains(item.value)) {
        _selected.remove(item.value);
      } else {
        if (widget.selectionMode == HeroUiListBoxSelectionMode.single) {
          _selected = {item.value};
        } else {
          _selected.add(item.value);
        }
      }
    });
    widget.onSelectionChanged?.call(Set<T>.from(_selected));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark
        ? const Color(0xFFFCFCFC)
        : const Color(0xFF18181B);
    final descriptionColor = isDark
        ? const Color(0xFFA1A1AA)
        : const Color(0xFF71717A);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: HeroUiTypography.bodySmMedium.copyWith(color: titleColor),
          ),
          const SizedBox(height: 6),
        ],
        Container(
          decoration: BoxDecoration(borderRadius: widget.borderRadius),
          child: Padding(
            padding: widget.padding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < widget.items.length; i++) ...[
                  _ListBoxItemTile<T>(
                    item: widget.items[i],
                    isSelected: _selected.contains(widget.items[i].value),
                    onTap: () => _toggleItem(widget.items[i]),
                  ),
                  if (i < widget.items.length - 1 && widget.itemSpacing > 0)
                    SizedBox(height: widget.itemSpacing),
                ],
              ],
            ),
          ),
        ),
        if (widget.description != null) ...[
          const SizedBox(height: 6),
          Text(
            widget.description!,
            style: HeroUiTypography.bodyXs.copyWith(color: descriptionColor),
          ),
        ],
      ],
    );
  }
}

class _ListBoxItemTile<T> extends StatefulWidget {
  const _ListBoxItemTile({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final HeroUiListBoxItem<T> item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_ListBoxItemTile<T>> createState() => _ListBoxItemTileState<T>();
}

class _ListBoxItemTileState<T> extends State<_ListBoxItemTile<T>> {
  bool _hover = false;
  bool _focused = false;
  bool _pressed = false;

  HeroUiListBoxItemState _resolveVisualState(HeroUiListBoxItem<T> item) {
    if (item.isDisabledState) return HeroUiListBoxItemState.disabled;
    if (item.state != null) return item.state!;
    if (_pressed) return HeroUiListBoxItemState.hover;
    if (_focused) return HeroUiListBoxItemState.focus;
    if (_hover) return HeroUiListBoxItemState.hover;
    if (widget.isSelected) return HeroUiListBoxItemState.selected;
    return HeroUiListBoxItemState.defaultState;
  }

  Color _stateBackground({
    required HeroUiListBoxItemState state,
    required bool isDark,
    required bool isDanger,
    required bool isSelected,
  }) {
    final neutralHover = isDark
        ? const Color(0xFF27272A)
        : const Color(0xFFEBEBEC);

    if (state == HeroUiListBoxItemState.hover ||
        state == HeroUiListBoxItemState.focus) {
      return neutralHover;
    }
    if (state == HeroUiListBoxItemState.selected || isSelected) {
      return Colors.transparent;
    }
    return Colors.transparent;
  }

  List<BoxShadow>? _focusRing({
    required bool isDark,
    required HeroUiListBoxItemState state,
  }) {
    if (state != HeroUiListBoxItemState.focus) return null;
    return [
      const BoxShadow(color: Color(0xFF0485F7), spreadRadius: 4, blurRadius: 0),
      BoxShadow(
        color: isDark ? const Color(0xFF060607) : const Color(0xFFF5F5F5),
        spreadRadius: 2,
        blurRadius: 0,
      ),
    ];
  }

  Color? _stateBorder({
    required HeroUiListBoxItemState state,
    required bool isDark,
    required bool isDanger,
  }) {
    if (state == HeroUiListBoxItemState.focus && isDanger) {
      return isDark ? const Color(0xFFDB3B3E) : const Color(0xFFFF383C);
    }
    return null;
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
    final isDisabled = visualState == HeroUiListBoxItemState.disabled;
    final isDanger = item.isDangerType;
    final isSelected =
        widget.isSelected || visualState == HeroUiListBoxItemState.selected;
    final titleColor = isDisabled
        ? (isDark ? const Color(0xFF71717A) : const Color(0xFFA1A1AA))
        : (isDanger
              ? (isDark ? const Color(0xFFDB3B3E) : const Color(0xFFFF383C))
              : (isDark ? const Color(0xFFFCFCFC) : const Color(0xFF18181B)));
    final descriptionColor = isDisabled
        ? (isDark ? const Color(0xFF71717A) : const Color(0xFFA1A1AA))
        : (isDark ? const Color(0xFFA1A1AA) : const Color(0xFF71717A));
    final prefix = item.effectivePrefix == null
        ? null
        : _resolveSlotWidget(item.effectivePrefix!, titleColor);
    final fallbackSuffix = isSelected
        ? HeroUiIcon('check', size: 20, color: const Color(0xFF0485F7))
        : null;
    final suffix = item.effectiveSuffix == null
        ? fallbackSuffix
        : _resolveSlotWidget(item.effectiveSuffix!, descriptionColor);
    final stateBorderColor = _stateBorder(
      state: visualState,
      isDark: isDark,
      isDanger: isDanger,
    );

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
            curve: Curves.easeOut,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _stateBackground(
                state: visualState,
                isDark: isDark,
                isDanger: isDanger,
                isSelected: isSelected,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: _focusRing(isDark: isDark, state: visualState),
              border: stateBorderColor == null
                  ? null
                  : Border.all(color: stateBorderColor, width: 1),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (prefix != null) ...[prefix, const SizedBox(width: 12)],
                Expanded(
                  child: Column(
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
                            color: descriptionColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (suffix != null) ...[const SizedBox(width: 8), suffix],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
