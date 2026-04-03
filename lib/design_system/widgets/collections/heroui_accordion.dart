part of 'heroui_collections.dart';

enum HeroUiAccordionVariant {
  defaultVariant,
  secondary,
  @Deprecated('Use HeroUiAccordionVariant.secondary instead.')
  bordered,
}

enum HeroUiAccordionItemState { defaultState, hover, focus, disabled, expanded }

class HeroUiAccordionItem {
  const HeroUiAccordionItem({
    required this.title,
    this.description,
    this.content,
    @Deprecated('Use description instead.') this.subtitle,
    this.prefix,
    this.showPrefix,
    @Deprecated('Use prefix instead.') this.leading,
    this.initiallyExpanded = false,
    this.state,
    this.isDisabled = false,
  }) : assert(
         description != null || content != null,
         'Either description or content must be provided.',
       );

  final String title;

  /// Text content shown in expanded area when [content] is not provided.
  final String? description;

  /// Custom content shown in expanded area.
  ///
  /// If null, [description] will be rendered as plain text.
  final Widget? content;

  @Deprecated('Use description instead.')
  final String? subtitle;

  final Widget? prefix;

  /// Explicitly controls prefix visibility.
  ///
  /// - `true`: always show [prefix] (or deprecated [leading], if provided)
  /// - `false`: always hide prefix
  /// - `null`: auto show when a prefix widget is provided
  final bool? showPrefix;

  @Deprecated('Use prefix instead.')
  final Widget? leading;

  final bool initiallyExpanded;
  final HeroUiAccordionItemState? state;

  @Deprecated('Use state: HeroUiAccordionItemState.disabled instead.')
  final bool isDisabled;

  bool get isDisabledState =>
      isDisabled || state == HeroUiAccordionItemState.disabled;

  bool get isExpandedState => state == HeroUiAccordionItemState.expanded;

  bool get hasFixedState => state != null;

  bool get shouldShowPrefix =>
      showPrefix ?? (prefix != null || leading != null);

  Widget? get effectivePrefix => shouldShowPrefix ? (prefix ?? leading) : null;
}

class HeroUiAccordion extends StatefulWidget {
  const HeroUiAccordion({
    super.key,
    required this.items,
    this.variant = HeroUiAccordionVariant.defaultVariant,
    this.selectionMode = HeroUiAccordionSelectionMode.single,
  });

  final List<HeroUiAccordionItem> items;
  final HeroUiAccordionVariant variant;
  final HeroUiAccordionSelectionMode selectionMode;

  @override
  State<HeroUiAccordion> createState() => _HeroUiAccordionState();
}

enum HeroUiAccordionSelectionMode { single, multiple }

class _HeroUiAccordionState extends State<HeroUiAccordion> {
  late final Set<int> _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = _buildInitialExpandedSet(widget.items);
  }

  @override
  void didUpdateWidget(HeroUiAccordion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items.length != widget.items.length) {
      final nextExpanded = <int>{};
      for (int i = 0; i < widget.items.length; i++) {
        final item = widget.items[i];
        if (item.isExpandedState || item.initiallyExpanded) {
          nextExpanded.add(i);
          continue;
        }
        if (i < oldWidget.items.length && _expanded.contains(i)) {
          nextExpanded.add(i);
        }
      }
      _expanded
        ..clear()
        ..addAll(nextExpanded);
    } else {
      for (int i = 0; i < widget.items.length; i++) {
        final item = widget.items[i];
        if (item.isExpandedState) {
          _expanded.add(i);
        } else if (item.hasFixedState || item.isDisabledState) {
          _expanded.remove(i);
        }
      }
    }
  }

  Set<int> _buildInitialExpandedSet(List<HeroUiAccordionItem> items) {
    return {
      for (int i = 0; i < items.length; i++)
        if (items[i].initiallyExpanded || items[i].isExpandedState) i,
    };
  }

  bool _isExpanded(int index) {
    final item = widget.items[index];
    return item.isExpandedState || _expanded.contains(index);
  }

  bool _isInteractive(HeroUiAccordionItem item) {
    return !item.isDisabledState && !item.hasFixedState;
  }

  void _toggle(int index) {
    final item = widget.items[index];
    if (!_isInteractive(item)) return;

    setState(() {
      if (_isExpanded(index)) {
        _expanded.remove(index);
      } else {
        if (widget.selectionMode == HeroUiAccordionSelectionMode.single) {
          final fixedExpandedIndexes = {
            for (int i = 0; i < widget.items.length; i++)
              if (widget.items[i].isExpandedState) i,
          };
          _expanded
            ..clear()
            ..addAll(fixedExpandedIndexes);
        }
        _expanded.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSecondary =
        widget.variant == HeroUiAccordionVariant.secondary ||
        widget.variant == HeroUiAccordionVariant.bordered;

    Widget child = Column(
      children: [
        for (int i = 0; i < widget.items.length; i++) ...[
          _AccordionTile(
            item: widget.items[i],
            isExpanded: _isExpanded(i),
            isSecondary: isSecondary,
            isInteractive: _isInteractive(widget.items[i]),
            onTap: () => _toggle(i),
            showDivider: i < widget.items.length - 1,
          ),
        ],
      ],
    );

    if (isSecondary) {
      child = Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF18181B) : const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.02),
              offset: Offset(0, 1),
              blurRadius: 2,
            ),
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.04),
              offset: Offset(0, 1),
              blurRadius: 1,
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: child,
      );
    }

    return child;
  }
}

class _AccordionTile extends StatefulWidget {
  const _AccordionTile({
    required this.item,
    required this.isExpanded,
    required this.isSecondary,
    required this.isInteractive,
    required this.onTap,
    required this.showDivider,
  });

  final HeroUiAccordionItem item;
  final bool isExpanded;
  final bool isSecondary;
  final bool isInteractive;
  final VoidCallback onTap;
  final bool showDivider;

  @override
  State<_AccordionTile> createState() => _AccordionTileState();
}

class _AccordionTileState extends State<_AccordionTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _expand;
  late Animation<double> _fade;
  late Animation<double> _rotateTurns;

  bool _isHover = false;
  bool _isFocus = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
      value: widget.isExpanded ? 1.0 : 0.0,
    );
    _expand = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
    _rotateTurns = Tween<double>(begin: 0, end: 0.5).animate(_expand);
  }

  @override
  void didUpdateWidget(_AccordionTile old) {
    super.didUpdateWidget(old);
    if (widget.isExpanded != old.isExpanded) {
      widget.isExpanded ? _ctrl.forward() : _ctrl.reverse();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  HeroUiAccordionItemState _resolveVisualState(HeroUiAccordionItem item) {
    if (item.isDisabledState) return HeroUiAccordionItemState.disabled;
    if (item.state != null) return item.state!;
    if (_isFocus) return HeroUiAccordionItemState.focus;
    if (_isHover || _isPressed) return HeroUiAccordionItemState.hover;
    if (widget.isExpanded) return HeroUiAccordionItemState.expanded;
    return HeroUiAccordionItemState.defaultState;
  }

  Color _headerBackground({
    required HeroUiAccordionItemState visualState,
    required bool isDark,
  }) {
    if (visualState == HeroUiAccordionItemState.hover ||
        visualState == HeroUiAccordionItemState.focus) {
      return isDark ? const Color(0xFF27272A) : const Color(0xFFEBEBEC);
    }
    return Colors.transparent;
  }

  List<BoxShadow>? _focusRing({
    required HeroUiAccordionItemState visualState,
    required bool isDark,
  }) {
    if (visualState != HeroUiAccordionItemState.focus) return null;
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
    final isDisabled = visualState == HeroUiAccordionItemState.disabled;
    final titleColor = isDisabled
        ? (isDark ? const Color(0xFF71717A) : const Color(0xFFA1A1AA))
        : (isDark ? const Color(0xFFFCFCFC) : const Color(0xFF18181B));
    final descriptionColor = isDisabled
        ? (isDark ? const Color(0xFF71717A) : const Color(0xFFA1A1AA))
        : (isDark ? const Color(0xFFA1A1AA) : const Color(0xFF71717A));
    final dividerColor = isDark
        ? const Color(0xFF27272A)
        : const Color(0xFFE4E4E7);

    final prefix = item.effectivePrefix == null
        ? null
        : _resolveSlotWidget(item.effectivePrefix!, titleColor);
    final resolvedContent =
        item.content ??
        Text(
          item.description!,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: descriptionColor, height: 1.4),
        );

    final bodyLeftPadding = 16.0 + (prefix != null ? 28.0 : 0.0);

    return Column(
      children: [
        Semantics(
          button: true,
          enabled: !isDisabled,
          expanded: widget.isExpanded,
          child: Opacity(
            opacity: isDisabled ? 0.6 : 1.0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              curve: Curves.easeOut,
              decoration: BoxDecoration(
                color: _headerBackground(
                  visualState: visualState,
                  isDark: isDark,
                ),
                borderRadius: widget.isSecondary
                    ? BorderRadius.circular(12)
                    : BorderRadius.zero,
                boxShadow: _focusRing(visualState: visualState, isDark: isDark),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: widget.isSecondary
                      ? BorderRadius.circular(12)
                      : BorderRadius.zero,
                  splashFactory: NoSplash.splashFactory,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  mouseCursor: widget.isInteractive
                      ? SystemMouseCursors.click
                      : SystemMouseCursors.basic,
                  onHover: widget.isInteractive
                      ? (value) => setState(() => _isHover = value)
                      : null,
                  onFocusChange: widget.isInteractive
                      ? (value) => setState(() => _isFocus = value)
                      : null,
                  onHighlightChanged: widget.isInteractive
                      ? (value) => setState(() => _isPressed = value)
                      : null,
                  onTap: widget.isInteractive ? widget.onTap : null,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    child: Row(
                      crossAxisAlignment: item.subtitle == null
                          ? CrossAxisAlignment.center
                          : CrossAxisAlignment.start,
                      children: [
                        if (prefix != null) ...[
                          Padding(
                            padding: EdgeInsets.only(
                              top: item.subtitle == null ? 0 : 1,
                            ),
                            child: prefix,
                          ),
                          const SizedBox(width: 12),
                        ],
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: HeroUiTypography.bodySmMedium.copyWith(
                                  color: titleColor,
                                ),
                              ),
                              if (item.subtitle != null) ...[
                                const SizedBox(height: 2),
                                Text(
                                  item.subtitle!,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: descriptionColor),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        RotationTransition(
                          turns: _rotateTurns,
                          child: HeroUiIcon(
                            HeroUiIconManifest.chevronDownRegular,
                            size: 16,
                            color: descriptionColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizeTransition(
          sizeFactor: _expand,
          axisAlignment: -1,
          child: FadeTransition(
            opacity: _fade,
            child: Padding(
              padding: EdgeInsets.fromLTRB(bodyLeftPadding, 0, 16, 14),
              child: Align(
                alignment: Alignment.topLeft,
                child: resolvedContent,
              ),
            ),
          ),
        ),
        if (widget.showDivider)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Divider(height: 1, color: dividerColor),
          ),
      ],
    );
  }
}
