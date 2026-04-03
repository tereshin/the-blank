part of 'heroui_date_time.dart';

/// HeroUI DatePicker with animated popover calendar.
class HeroUiDatePicker extends StatefulWidget {
  const HeroUiDatePicker({
    super.key,
    this.label,
    this.description,
    this.errorText,
    this.placeholder = 'MM/DD/YYYY',
    this.initialValue,
    this.value,
    this.minDate,
    this.maxDate,
    this.enabled = true,
    this.onChanged,
  });

  final String? label;
  final String? description;
  final String? errorText;
  final String placeholder;
  final DateTime? initialValue;
  final DateTime? value;
  final DateTime? minDate;
  final DateTime? maxDate;
  final bool enabled;
  final ValueChanged<DateTime>? onChanged;

  @override
  State<HeroUiDatePicker> createState() => _HeroUiDatePickerState();
}

class _HeroUiDatePickerState extends State<HeroUiDatePicker>
    with SingleTickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  late final AnimationController _overlayController;
  late DateTime _viewMonth;
  DateTime? _selectedDate;
  bool _isOpen = false;
  int _monthDirection = 1;

  @override
  void initState() {
    super.initState();
    final initial = _dateOnly(
      widget.value ?? widget.initialValue ?? DateTime.now(),
    );
    _selectedDate = widget.value ?? widget.initialValue;
    _viewMonth = DateTime(initial.year, initial.month);
    _overlayController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void didUpdateWidget(HeroUiDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _selectedDate = widget.value;
      final current = _selectedDate ?? DateTime.now();
      _viewMonth = DateTime(current.year, current.month);
      _overlayEntry?.markNeedsBuild();
    }
    if (!widget.enabled && _isOpen) {
      _closePopover();
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _overlayController.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _openPopover() {
    if (_isOpen || !widget.enabled) return;
    _focusNode.requestFocus();
    _overlayEntry = OverlayEntry(builder: _buildOverlay);
    Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
    setState(() => _isOpen = true);
    _overlayController.forward(from: 0);
  }

  Future<void> _closePopover() async {
    if (!_isOpen) return;
    setState(() => _isOpen = false);
    await _overlayController.reverse();
    _removeOverlay();
    if (mounted) _focusNode.unfocus();
  }

  void _togglePopover() {
    if (_isOpen) {
      _closePopover();
    } else {
      _openPopover();
    }
  }

  void _setStateAndRefreshOverlay(VoidCallback fn) {
    setState(fn);
    _overlayEntry?.markNeedsBuild();
  }

  void _changeMonth(int delta) {
    if (delta == 0) return;
    _setStateAndRefreshOverlay(() {
      _monthDirection = delta.sign;
      _viewMonth = DateTime(_viewMonth.year, _viewMonth.month + delta);
    });
  }

  bool _isInRange(DateTime date) {
    final value = _dateOnly(date);
    final min = widget.minDate == null ? null : _dateOnly(widget.minDate!);
    final max = widget.maxDate == null ? null : _dateOnly(widget.maxDate!);
    if (min != null && value.isBefore(min)) return false;
    if (max != null && value.isAfter(max)) return false;
    return true;
  }

  bool get _canGoPrevMonth {
    if (widget.minDate == null) return true;
    final prev = DateTime(_viewMonth.year, _viewMonth.month - 1);
    final endOfPrev = DateTime(prev.year, prev.month + 1, 0);
    return !endOfPrev.isBefore(_dateOnly(widget.minDate!));
  }

  bool get _canGoNextMonth {
    if (widget.maxDate == null) return true;
    final next = DateTime(_viewMonth.year, _viewMonth.month + 1, 1);
    return !next.isAfter(_dateOnly(widget.maxDate!));
  }

  void _selectDate(DateTime date) {
    if (!_isInRange(date)) return;
    final picked = _dateOnly(date);
    _setStateAndRefreshOverlay(() {
      _selectedDate = picked;
    });
    widget.onChanged?.call(picked);
    _closePopover();
  }

  Widget _buildOverlay(BuildContext context) {
    final animation = CurvedAnimation(
      parent: _overlayController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );

    return Positioned.fill(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _closePopover,
        child: Stack(
          children: [
            CompositedTransformFollower(
              link: _layerLink,
              targetAnchor: Alignment.bottomLeft,
              followerAnchor: Alignment.topLeft,
              offset: const Offset(0, 8),
              showWhenUnlinked: false,
              child: Material(
                color: Colors.transparent,
                child: FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: Tween(begin: 0.94, end: 1.0).animate(animation),
                    alignment: Alignment.center,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {},
                      child: _CalendarPopover(
                        month: _viewMonth,
                        selectedDate: _selectedDate,
                        isDark: _isDark(context),
                        canGoPrev: _canGoPrevMonth,
                        canGoNext: _canGoNextMonth,
                        monthDirection: _monthDirection,
                        canSelectDate: _isInRange,
                        onPrevMonth: () => _changeMonth(-1),
                        onNextMonth: () => _changeMonth(1),
                        onDayTap: _selectDate,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: _DateTimeFieldFrame(
        label: widget.label,
        description: widget.description,
        errorText: widget.errorText,
        enabled: widget.enabled,
        isFocused: _isOpen,
        valueText: _selectedDate == null ? null : _formatDate(_selectedDate!),
        placeholder: widget.placeholder,
        onTap: _togglePopover,
        suffix: _FieldSuffix(isOpen: _isOpen),
      ),
    );
  }
}
