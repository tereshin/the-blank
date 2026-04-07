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
    _filtered = widget.items;
    _focus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    _closeDropdown();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focus.hasFocus) {
      _openDropdown();
    } else {
      Future.delayed(const Duration(milliseconds: 150), _closeDropdown);
    }
  }

  void _onTextChanged(String text) {
    final lower = text.toLowerCase();
    setState(() {
      _filtered = widget.items
          .where(
            (i) =>
                !_selected.contains(i.value) &&
                i.label.toLowerCase().contains(lower),
          )
          .toList();
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
    if (_isOpen) return;
    _updateOverlayMetrics();

    _overlay = OverlayEntry(
      builder: (_) => _ComboBoxOverlay<T>(
        triggerOffset: _triggerOffset,
        triggerSize: _triggerSize,
        estimatedHeight: _estimatedHeight,
        openAbove: _openAbove,
        items: _filtered,
        selectedValue: null,
        maxListHeight: widget.maxListHeight,
        onSelected: (v) {
          setState(() {
            if (!_selected.contains(v)) _selected = [..._selected, v];
            _ctrl.clear();
            _filtered = widget.items
                .where((i) => !_selected.contains(i.value))
                .toList();
          });
          widget.onChanged?.call(List.unmodifiable(_selected));
          _updateOverlayMetrics();
          _overlay?.markNeedsBuild();
        },
      ),
    );

    Overlay.of(context, rootOverlay: true).insert(_overlay!);
    setState(() => _isOpen = true);
  }

  void _closeDropdown() {
    _overlay?.remove();
    _overlay = null;
    if (mounted) setState(() => _isOpen = false);
  }

  void _removeTag(T value) {
    setState(() {
      _selected = _selected.where((v) => v != value).toList();
      _filtered = widget.items
          .where((i) => !_selected.contains(i.value))
          .toList();
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.label != null) ...[
            Text(
              widget.label!,
              style: HeroUiTypography.bodySmMedium.copyWith(color: labelColor),
            ),
            const SizedBox(height: 5),
          ],
          Opacity(
            opacity: widget.enabled ? 1.0 : 0.5,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
                      onRemove: widget.enabled ? () => _removeTag(v) : null,
                    ),
                  IntrinsicWidth(
                    child: TextField(
                      controller: _ctrl,
                      focusNode: _focus,
                      enabled: widget.enabled,
                      onChanged: _onTextChanged,
                      style: HeroUiTypography.textFieldSm.copyWith(
                        color: isDark
                            ? const Color(0xFFFCFCFC)
                            : const Color(0xFF18181B),
                      ),
                      decoration: InputDecoration(
                        hintText: _selected.isEmpty ? widget.placeholder : '',
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
