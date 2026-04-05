part of 'heroui_date_time.dart';

/// HeroUI DateField with optional time selection.
class HeroUiDateField extends StatefulWidget {
  const HeroUiDateField({
    super.key,
    this.label,
    this.description,
    this.errorText,
    this.placeholder = 'MM/DD/YYYY',
    this.variant = HeroUiInputVariant.primary,
    this.initialValue,
    this.minDate,
    this.maxDate,
    this.enabled = true,
    this.showTime = false,
    this.onChanged,
  });

  final String? label;
  final String? description;
  final String? errorText;
  final String placeholder;
  final HeroUiInputVariant variant;
  final DateTime? initialValue;
  final DateTime? minDate;
  final DateTime? maxDate;
  final bool enabled;
  final bool showTime;
  final ValueChanged<DateTime>? onChanged;

  @override
  State<HeroUiDateField> createState() => _HeroUiDateFieldState();
}

class _HeroUiDateFieldState extends State<HeroUiDateField> {
  DateTime? _value;
  bool _isPicking = false;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  Future<void> _pickValue() async {
    if (!widget.enabled || _isPicking) return;
    setState(() => _isPicking = true);

    final now = DateTime.now();
    final initial = _value ?? widget.initialValue ?? now;
    final minDate = widget.minDate ?? DateTime(1900);
    final maxDate = widget.maxDate ?? DateTime(2100);

    final initialDate = initial.isBefore(minDate)
        ? minDate
        : initial.isAfter(maxDate)
        ? maxDate
        : initial;

    final date = await _showAdaptiveCalendarSurface<DateTime>(
      context: context,
      title: 'Select date',
      dialogWidth: 312,
      builder: (modalContext) => _SingleDateCalendarPicker(
        initialDate: _dateOnly(initialDate),
        selectedDate: _value == null ? null : _dateOnly(_value!),
        minDate: _dateOnly(minDate),
        maxDate: _dateOnly(maxDate),
        onDateSelected: (picked) {
          Navigator.of(modalContext).pop(_dateOnly(picked));
        },
      ),
    );

    if (!mounted) return;
    if (date == null) {
      setState(() => _isPicking = false);
      return;
    }

    DateTime result = date;
    if (widget.showTime) {
      final initialTime = _value == null
          ? TimeOfDay.now()
          : TimeOfDay.fromDateTime(_value!);
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: initialTime,
      );
      if (!mounted) return;
      if (pickedTime != null) {
        result = DateTime(
          date.year,
          date.month,
          date.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      }
    }

    setState(() {
      _value = result;
      _isPicking = false;
    });
    widget.onChanged?.call(result);
  }

  @override
  Widget build(BuildContext context) {
    final valueText = _value == null
        ? null
        : widget.showTime
        ? '${_formatDate(_value!)} ${_formatTime(TimeOfDay.fromDateTime(_value!), show12hr: true, showSeconds: false)}'
        : _formatDate(_value!);

    return _DateTimeFieldFrame(
      label: widget.label,
      description: widget.description,
      errorText: widget.errorText,
      variant: widget.variant,
      enabled: widget.enabled,
      isFocused: _isPicking,
      valueText: valueText,
      placeholder: widget.placeholder,
      onTap: _pickValue,
      suffix: _FieldSuffix(isOpen: _isPicking),
    );
  }
}
