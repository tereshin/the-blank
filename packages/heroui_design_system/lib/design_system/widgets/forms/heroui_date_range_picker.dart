part of 'heroui_date_time.dart';

/// HeroUI DateRangePicker.
class HeroUiDateRangePicker extends StatefulWidget {
  const HeroUiDateRangePicker({
    super.key,
    this.label,
    this.description,
    this.errorText,
    this.placeholder = 'Select range',
    this.initialStart,
    this.initialEnd,
    this.minDate,
    this.maxDate,
    this.enabled = true,
    this.onChanged,
  });

  final String? label;
  final String? description;
  final String? errorText;
  final String placeholder;
  final DateTime? initialStart;
  final DateTime? initialEnd;
  final DateTime? minDate;
  final DateTime? maxDate;
  final bool enabled;
  final void Function(DateTime? start, DateTime? end)? onChanged;

  @override
  State<HeroUiDateRangePicker> createState() => _HeroUiDateRangePickerState();
}

class _HeroUiDateRangePickerState extends State<HeroUiDateRangePicker> {
  DateTime? _start;
  DateTime? _end;
  bool _isPicking = false;

  @override
  void initState() {
    super.initState();
    _start = widget.initialStart;
    _end = widget.initialEnd;
  }

  Future<void> _pickRange() async {
    if (!widget.enabled || _isPicking) return;
    setState(() => _isPicking = true);
    final minDate = widget.minDate ?? DateTime(1900);
    final maxDate = widget.maxDate ?? DateTime(2100);
    final normalizedStart = _start == null ? null : _dateOnly(_start!);
    final normalizedEnd = _end == null ? null : _dateOnly(_end!);

    final range = await _showAdaptiveCalendarSurface<DateTimeRange>(
      context: context,
      title: 'Select date range',
      dialogWidth: 344,
      builder: (modalContext) => _RangeDateCalendarPicker(
        initialStart: normalizedStart,
        initialEnd: normalizedEnd,
        minDate: _dateOnly(minDate),
        maxDate: _dateOnly(maxDate),
        onCancel: () => Navigator.of(modalContext).pop(),
        onApply: (selectedRange) {
          Navigator.of(modalContext).pop(selectedRange);
        },
      ),
    );
    if (!mounted) return;
    if (range == null) {
      setState(() => _isPicking = false);
      return;
    }
    setState(() {
      _isPicking = false;
      _start = range.start;
      _end = range.end;
    });
    widget.onChanged?.call(_start, _end);
  }

  @override
  Widget build(BuildContext context) {
    final value = (_start != null && _end != null)
        ? _formatDateRange(_start!, _end!)
        : null;

    return _DateTimeFieldFrame(
      label: widget.label,
      description: widget.description,
      errorText: widget.errorText,
      enabled: widget.enabled,
      isFocused: _isPicking,
      valueText: value,
      placeholder: widget.placeholder,
      onTap: _pickRange,
      suffix: _FieldSuffix(isOpen: _isPicking),
    );
  }
}
