part of 'heroui_pickers.dart';

/// A dropdown picker that shows a list of options to select from.
///
/// Uses a custom overlay positioned below the trigger field.
class HeroUiSelect<T> extends StatefulWidget {
  const HeroUiSelect({
    super.key,
    required this.items,
    this.value,
    this.onChanged,
    this.label,
    this.requiredField = false,
    this.description,
    this.placeholder = 'Select one',
    this.variant = HeroUiInputVariant.primary,
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
  final HeroUiInputVariant variant;
  final bool enabled;
  final String? errorText;
  final double maxListHeight;

  @override
  State<HeroUiSelect<T>> createState() => _HeroUiSelectState<T>();
}

class _HeroUiSelectState<T> extends State<HeroUiSelect<T>> {
  OverlayEntry? _overlay;
  final _triggerKey = GlobalKey();
  bool _isOverlayVisible = false;
  int _overlayToken = 0;
  bool _isOpen = false;
  bool _openAbove = false;
  Offset _triggerOffset = Offset.zero;
  Size _triggerSize = Size.zero;
  double _estimatedHeight = 0;

  @override
  void didUpdateWidget(covariant HeroUiSelect<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.enabled && _isOpen) {
      _closeDropdown();
    }
    if (_isOpen && oldWidget.items != widget.items) {
      _updateOverlayMetrics();
      _overlay?.markNeedsBuild();
    }
  }

  @override
  void dispose() {
    _closeDropdown(updateState: false, animate: false);
    super.dispose();
  }

  void _updateOverlayMetrics() {
    final renderObject = _triggerKey.currentContext?.findRenderObject();
    if (renderObject is! RenderBox) return;

    final offset = renderObject.localToGlobal(Offset.zero);
    final size = renderObject.size;
    final media = MediaQuery.of(context);
    final estimatedHeight = _estimateDropdownHeight(
      itemCount: widget.items.length,
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
      builder: (_) => _SelectOverlay(
        triggerOffset: _triggerOffset,
        triggerSize: _triggerSize,
        estimatedHeight: _estimatedHeight,
        openAbove: _openAbove,
        isVisible: _isOverlayVisible,
        items: widget.items,
        selectedValue: widget.value,
        maxListHeight: widget.maxListHeight,
        onSelected: (v) {
          widget.onChanged?.call(v);
          _closeDropdown();
        },
        onDismiss: _closeDropdown,
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

  String? get _selectedLabel {
    if (widget.value == null) return null;
    try {
      return widget.items.firstWhere((i) => i.value == widget.value).label;
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildTriggerField(
      context: context,
      value: _selectedLabel,
      placeholder: widget.placeholder,
      label: widget.label,
      requiredField: widget.requiredField,
      description: widget.description,
      isOpen: _isOpen,
      enabled: widget.enabled,
      hasError: widget.errorText?.trim().isNotEmpty == true,
      errorText: widget.errorText,
      triggerKey: _triggerKey,
      onTap: _isOpen ? _closeDropdown : _openDropdown,
      variant: widget.variant,
    );
  }
}

class _SelectOverlay<T> extends StatelessWidget {
  const _SelectOverlay({
    required this.triggerOffset,
    required this.triggerSize,
    required this.estimatedHeight,
    required this.openAbove,
    required this.isVisible,
    required this.items,
    required this.selectedValue,
    required this.onSelected,
    required this.onDismiss,
    required this.maxListHeight,
  });

  final Offset triggerOffset;
  final Size triggerSize;
  final double estimatedHeight;
  final bool openAbove;
  final bool isVisible;
  final List<HeroUiPickerItem<T>> items;
  final T? selectedValue;
  final ValueChanged<T> onSelected;
  final VoidCallback onDismiss;
  final double maxListHeight;

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

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onDismiss,
      child: Stack(
        children: [
          Positioned(
            left: triggerOffset.dx,
            top: top,
            width: triggerSize.width,
            child: GestureDetector(
              onTap: () {}, // prevent dismiss
              child: Material(
                color: Colors.transparent,
                child: _DropdownOpenAnimation(
                  openAbove: openAbove,
                  isVisible: isVisible,
                  child: _DropdownPanel(
                    children: [
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
            ),
          ),
        ],
      ),
    );
  }
}
