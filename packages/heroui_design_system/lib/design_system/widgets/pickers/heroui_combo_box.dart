part of 'heroui_pickers.dart';

/// A text field that filters a list of options as the user types.
///
/// Matching items are shown in a dropdown overlay.
class HeroUiComboBox<T> extends StatefulWidget {
  const HeroUiComboBox({
    super.key,
    required this.items,
    this.value,
    this.onChanged,
    this.label,
    this.requiredField = false,
    this.description,
    this.placeholder = 'Type to search…',
    this.enabled = true,
    this.errorText,
    this.maxListHeight = 312.0,
  });

  final List<HeroUiPickerItem<T>> items;
  final T? value;
  final ValueChanged<T>? onChanged;
  final String? label;
  final bool requiredField;
  final String? description;
  final String placeholder;
  final bool enabled;
  final String? errorText;
  final double maxListHeight;

  @override
  State<HeroUiComboBox<T>> createState() => _HeroUiComboBoxState<T>();
}

class _HeroUiComboBoxState<T> extends State<HeroUiComboBox<T>> {
  final _ctrl = TextEditingController();
  final _focus = FocusNode();
  final _triggerKey = GlobalKey();
  OverlayEntry? _overlay;
  List<HeroUiPickerItem<T>> _filtered = [];
  bool _isOpen = false;
  bool _openAbove = false;
  Offset _triggerOffset = Offset.zero;
  Size _triggerSize = Size.zero;
  double _estimatedHeight = 0;

  @override
  void initState() {
    super.initState();
    _filtered = widget.items;
    _ctrl.text = _labelForValue(widget.value) ?? '';
    _focus.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(covariant HeroUiComboBox<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.value != oldWidget.value && !_focus.hasFocus) {
      _ctrl.text = _labelForValue(widget.value) ?? '';
    }

    if (widget.items != oldWidget.items) {
      _onTextChanged(_ctrl.text);
    }

    if (!widget.enabled && _isOpen) {
      _closeDropdown();
    }
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
          .where((i) => i.label.toLowerCase().contains(lower))
          .toList();
    });
    _updateOverlayMetrics();
    _overlay?.markNeedsBuild();
  }

  String? _labelForValue(T? value) {
    if (value == null) return null;
    try {
      return widget.items.firstWhere((item) => item.value == value).label;
    } catch (_) {
      return null;
    }
  }

  void _updateOverlayMetrics() {
    final renderObject = _triggerKey.currentContext?.findRenderObject();
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
        availableBelow < estimatedHeight + 10 && availableAbove > availableBelow;

    _triggerOffset = offset;
    _triggerSize = size;
    _estimatedHeight = estimatedHeight;
    _openAbove = openAbove;
  }

  void _openDropdown() {
    if (!widget.enabled || _isOpen) return;
    _updateOverlayMetrics();

    _overlay = OverlayEntry(
      builder: (_) => _ComboBoxOverlay(
        triggerOffset: _triggerOffset,
        triggerSize: _triggerSize,
        estimatedHeight: _estimatedHeight,
        openAbove: _openAbove,
        items: _filtered,
        selectedValue: widget.value,
        maxListHeight: widget.maxListHeight,
        onSelected: (v) {
          final item = widget.items.firstWhere((i) => i.value == v);
          _ctrl.text = item.label;
          widget.onChanged?.call(v);
          _focus.unfocus();
          _closeDropdown();
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

  @override
  Widget build(BuildContext context) {
    final textColor = _pickerText(context);
    final mutedColor = _pickerMuted(context);
    final hasError = widget.errorText?.trim().isNotEmpty == true;
    final helperText = hasError ? widget.errorText : widget.description;
    final isFocused = _isOpen || _focus.hasFocus;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label!,
                style: HeroUiTypography.bodySmMedium.copyWith(color: textColor),
              ),
              if (widget.requiredField) ...[
                const SizedBox(width: 5),
                Text(
                  '*',
                  style: HeroUiTypography.bodySmMedium.copyWith(
                    color: _kDangerColor,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 5),
        ],
        Opacity(
          opacity: widget.enabled ? 1.0 : 0.5,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              boxShadow: isFocused
                  ? const [
                      BoxShadow(
                        color: _kFocusRingColor,
                        spreadRadius: .2,
                        blurRadius: 0,
                      ),
                    ]
                  : const [],
            ),
            child: Container(
              key: _triggerKey,
              decoration: BoxDecoration(
                color: _pickerFieldBg(context),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: hasError ? _kDangerColor : Colors.transparent,
                ),
                boxShadow: widget.enabled && !_isDark(context)
                    ? _kFieldShadow
                    : const [],
              ),
              child: Row(
                children: [
                  Expanded(
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
                        color: textColor,
                      ),
                      decoration: InputDecoration(
                        hintText: widget.placeholder,
                        hintStyle: HeroUiTypography.textFieldSm.copyWith(
                          color: mutedColor,
                        ),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: AnimatedRotation(
                      turns: _isOpen ? 0.5 : 0,
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeInOut,
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 21,
                        color: mutedColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (helperText?.trim().isNotEmpty == true) ...[
          const SizedBox(height: 5),
          Text(
            helperText!,
            style: HeroUiTypography.bodyXs.copyWith(
              color: hasError ? _kDangerColor : mutedColor,
            ),
          ),
        ],
      ],
    );
  }
}

class _ComboBoxOverlay<T> extends StatelessWidget {
  const _ComboBoxOverlay({
    required this.triggerOffset,
    required this.triggerSize,
    required this.estimatedHeight,
    required this.openAbove,
    required this.items,
    required this.selectedValue,
    required this.onSelected,
    required this.maxListHeight,
    this.onDismiss,
    this.barrierDismissible = false,
  });

  final Offset triggerOffset;
  final Size triggerSize;
  final double estimatedHeight;
  final bool openAbove;
  final List<HeroUiPickerItem<T>> items;
  final T? selectedValue;
  final ValueChanged<T> onSelected;
  final double maxListHeight;
  final VoidCallback? onDismiss;
  final bool barrierDismissible;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final desiredTop = openAbove
        ? triggerOffset.dy - estimatedHeight - 10
        : triggerOffset.dy + triggerSize.height + 10;
    final minTop = media.padding.top + 10;
    final maxTop =
        media.size.height -
        media.viewInsets.bottom -
        media.padding.bottom -
        estimatedHeight -
        10;
    final top = maxTop > minTop
        ? desiredTop.clamp(minTop, maxTop).toDouble()
        : desiredTop;

    final panel = Positioned(
      left: triggerOffset.dx,
      top: top,
      width: triggerSize.width,
      child: Material(
        color: Colors.transparent,
        child: _DropdownOpenAnimation(
          openAbove: openAbove,
          child: _DropdownPanel(
            children: items.isEmpty
                ? [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'No results',
                        style: HeroUiTypography.bodySm.copyWith(
                          color: _pickerMuted(context),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ]
                : [
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: maxListHeight),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (final item in items)
                              _DropdownItem(
                                label: item.label,
                                leading: item.leading,
                                isSelected: item.value == selectedValue,
                                onTap: () => onSelected(item.value),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
          ),
        ),
      ),
    );

    if (!barrierDismissible) {
      return Stack(children: [panel]);
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onDismiss,
      child: Stack(children: [panel]),
    );
  }
}
