part of 'heroui_pickers.dart';

/// An input field with tag chips and a filterable dropdown suggestion list.
///
/// Allows selecting multiple values, each shown as a removable chip in the
/// input field. The dropdown filters available options as the user types.
class HeroUiAutocomplete<T> extends StatefulWidget {
  const HeroUiAutocomplete({
    super.key,
    required this.items,
    this.values = const [],
    this.onChanged,
    this.label,
    this.placeholder = 'Type to search…',
    this.enabled = true,
    this.errorText,
    this.maxListHeight = 312.0,
  });

  final List<HeroUiPickerItem<T>> items;
  final List<T> values;
  final ValueChanged<List<T>>? onChanged;
  final String? label;
  final String placeholder;
  final bool enabled;
  final String? errorText;
  final double maxListHeight;

  @override
  State<HeroUiAutocomplete<T>> createState() => _HeroUiAutocompleteState<T>();
}

class _HeroUiAutocompleteState<T> extends State<HeroUiAutocomplete<T>> {
  final _ctrl = TextEditingController();
  final _focus = FocusNode();
  final _key = GlobalKey();
  OverlayEntry? _overlay;
  bool _isOverlayVisible = false;
  int _overlayToken = 0;
  List<HeroUiPickerItem<T>> _filtered = [];
  late List<T> _selected;
  bool _isOpen = false;
  bool _openAbove = false;
  Offset _triggerOffset = Offset.zero;
  Size _triggerSize = Size.zero;
  double _estimatedHeight = 0;

  @override
  void initState() {
    super.initState();
    _selected = List.from(widget.values);
    _refreshFiltered();
    _focus.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(covariant HeroUiAutocomplete<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.values != widget.values) {
      _selected = List.from(widget.values);
      _refreshFiltered();
      _overlay?.markNeedsBuild();
    }

    if (oldWidget.items != widget.items) {
      _refreshFiltered();
      _overlay?.markNeedsBuild();
    }

    if (!widget.enabled && _isOpen) {
      _closeDropdown(updateState: true);
    }
  }

  @override
  void dispose() {
    _focus.removeListener(_onFocusChange);
    _closeDropdown(updateState: false, animate: false);
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focus.hasFocus) {
      _openDropdown();
    } else {
      Future.delayed(const Duration(milliseconds: 150), () {
        if (!mounted || _focus.hasFocus) return;
        _closeDropdown();
      });
    }
  }

  void _refreshFiltered() {
    final lower = _ctrl.text.toLowerCase();
    _filtered = widget.items
        .where(
          (i) =>
              !_selected.contains(i.value) &&
              i.label.toLowerCase().contains(lower),
        )
        .toList();
  }

  void _onTextChanged(String text) {
    setState(() {
      _refreshFiltered();
    });
    _updateOverlayMetrics();
    _overlay?.markNeedsBuild();
  }

  void _updateOverlayMetrics() {
    final renderObject = _key.currentContext?.findRenderObject();
    if (renderObject is! RenderBox) return;

    final offset = renderObject.localToGlobal(Offset.zero);
    final size = renderObject.size;
    final media = MediaQuery.of(context);
    final estimatedHeight = _estimateDropdownHeight(
      itemCount: _filtered.length,
      maxListHeight: widget.maxListHeight,
    );
    final availableBelow =
        media.size.height -
        media.viewInsets.bottom -
        media.padding.bottom -
        (offset.dy + size.height);
    final availableAbove = offset.dy - media.padding.top;
    final openAbove =
        availableBelow < estimatedHeight + 10 &&
        availableAbove > availableBelow;

    _triggerOffset = offset;
    _triggerSize = size;
    _estimatedHeight = estimatedHeight;
    _openAbove = openAbove;
  }

  void _openDropdown() {
    if (!widget.enabled || _isOpen) return;
    _updateOverlayMetrics();

    _overlayToken++;
    _overlay?.remove();
    _overlay = null;
    _isOverlayVisible = true;

    _overlay = OverlayEntry(
      builder: (_) => _ComboBoxOverlay<T>(
        triggerOffset: _triggerOffset,
        triggerSize: _triggerSize,
        estimatedHeight: _estimatedHeight,
        openAbove: _openAbove,
        isVisible: _isOverlayVisible,
        items: _filtered,
        selectedValue: null,
        maxListHeight: widget.maxListHeight,
        barrierDismissible: true,
        onDismiss: () {
          _focus.unfocus();
          _closeDropdown();
        },
        onSelected: (v) {
          setState(() {
            if (!_selected.contains(v)) _selected = [..._selected, v];
            _ctrl.clear();
            _refreshFiltered();
          });
          widget.onChanged?.call(List.unmodifiable(_selected));
          _focus.unfocus();
          _closeDropdown();
        },
      ),
    );

    Overlay.of(context, rootOverlay: true).insert(_overlay!);
    if (mounted) {
      setState(() => _isOpen = true);
    } else {
      _isOpen = true;
    }
  }

  void _closeDropdown({bool updateState = true, bool animate = true}) {
    final currentOverlay = _overlay;
    if (currentOverlay == null) {
      if (updateState) {
        if (mounted) {
          setState(() => _isOpen = false);
        } else {
          _isOpen = false;
        }
      } else {
        _isOpen = false;
      }
      return;
    }

    _overlayToken++;
    final closeToken = _overlayToken;

    if (updateState) {
      if (mounted) {
        setState(() => _isOpen = false);
      } else {
        _isOpen = false;
      }
    } else {
      _isOpen = false;
    }

    if (!animate) {
      _isOverlayVisible = false;
      currentOverlay.remove();
      if (identical(_overlay, currentOverlay)) {
        _overlay = null;
      }
      return;
    }

    _isOverlayVisible = false;
    currentOverlay.markNeedsBuild();

    Future.delayed(_kDropdownAnimationDuration, () {
      if (closeToken != _overlayToken) return;
      if (identical(_overlay, currentOverlay)) {
        currentOverlay.remove();
        _overlay = null;
      }
    });
  }

  void _removeTag(T value) {
    setState(() {
      _selected = _selected.where((v) => v != value).toList();
      _refreshFiltered();
    });
    widget.onChanged?.call(List.unmodifiable(_selected));
    _updateOverlayMetrics();
    _overlay?.markNeedsBuild();
  }

  String _labelFor(T value) {
    try {
      return widget.items.firstWhere((i) => i.value == value).label;
    } catch (_) {
      return value.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF18181B) : const Color(0xFFFFFFFF);
    final labelColor = isDark
        ? const Color(0xFFA1A1AA)
        : const Color(0xFF71717A);
    final chipBg = isDark ? const Color(0xFF3F3F46) : const Color(0xFFEFEFF0);
    final chipText = isDark ? const Color(0xFFFCFCFC) : const Color(0xFF18181B);
    final borderColor = widget.errorText != null
        ? const Color(0xFFFF383C)
        : _isOpen
        ? const Color(0xFF0485F7)
        : (isDark ? const Color(0xFF3F3F46) : const Color(0xFFDEDEE0));

    return KeyedSubtree(
      key: _key,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final shouldFillWidth = isMobile && constraints.maxWidth.isFinite;
          return SizedBox(
            width: shouldFillWidth ? double.infinity : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.label != null) ...[
                  Text(
                    widget.label!,
                    style: HeroUiTypography.bodySmMedium.copyWith(
                      color: labelColor,
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
                Opacity(
                  opacity: widget.enabled ? 1.0 : 0.5,
                  child: Container(
                    width: shouldFillWidth ? double.infinity : null,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: borderColor,
                        width: _isOpen ? 1.5 : 1.0,
                      ),
                      boxShadow: widget.enabled ? _kFieldShadow : const [],
                    ),
                    child: Wrap(
                      spacing: 5,
                      runSpacing: 5,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        for (final v in _selected)
                          _AutocompleteTag(
                            label: _labelFor(v),
                            bg: chipBg,
                            textColor: chipText,
                            onRemove: widget.enabled
                                ? () => _removeTag(v)
                                : null,
                          ),
                        IntrinsicWidth(
                          child: TextField(
                            controller: _ctrl,
                            focusNode: _focus,
                            enabled: widget.enabled,
                            onChanged: _onTextChanged,
                            onTapOutside: (_) {
                              _focus.unfocus();
                              _closeDropdown();
                            },
                            style: HeroUiTypography.textFieldSm.copyWith(
                              color: isDark
                                  ? const Color(0xFFFCFCFC)
                                  : const Color(0xFF18181B),
                            ),
                            decoration: InputDecoration(
                              hintText: _selected.isEmpty
                                  ? widget.placeholder
                                  : '',
                              hintStyle: HeroUiTypography.textFieldSm.copyWith(
                                color: isDark
                                    ? const Color(0xFF52525B)
                                    : const Color(0xFFA1A1AA),
                              ),
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 5,
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              constraints: const BoxConstraints(minWidth: 104),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (widget.errorText != null) ...[
                  const SizedBox(height: 5),
                  Text(
                    widget.errorText!,
                    style: HeroUiTypography.bodyXs.copyWith(
                      color: const Color(0xFFFF383C),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AutocompleteTag extends StatelessWidget {
  const _AutocompleteTag({
    required this.label,
    required this.bg,
    required this.textColor,
    this.onRemove,
  });

  final String label;
  final Color bg;
  final Color textColor;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: HeroUiTypography.bodyXsMedium.copyWith(color: textColor),
          ),
          if (onRemove != null) ...[
            const SizedBox(width: 5),
            GestureDetector(
              onTap: onRemove,
              child: Icon(
                Icons.close_rounded,
                size: 20,
                color: textColor.withValues(alpha: 0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
