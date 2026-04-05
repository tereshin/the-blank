part of 'heroui_date_time.dart';

class _SingleDateCalendarPicker extends StatefulWidget {
  const _SingleDateCalendarPicker({
    required this.initialDate,
    required this.selectedDate,
    required this.minDate,
    required this.maxDate,
    required this.onDateSelected,
  });

  final DateTime initialDate;
  final DateTime? selectedDate;
  final DateTime minDate;
  final DateTime maxDate;
  final ValueChanged<DateTime> onDateSelected;

  @override
  State<_SingleDateCalendarPicker> createState() =>
      _SingleDateCalendarPickerState();
}

class _SingleDateCalendarPickerState extends State<_SingleDateCalendarPicker> {
  late DateTime _viewMonth;
  DateTime? _selectedDate;
  int _monthDirection = 1;

  @override
  void initState() {
    super.initState();
    final initial = widget.selectedDate ?? widget.initialDate;
    _selectedDate = widget.selectedDate;
    _viewMonth = DateTime(initial.year, initial.month);
  }

  bool _isInRange(DateTime date) {
    final normalized = _dateOnly(date);
    if (normalized.isBefore(widget.minDate)) return false;
    if (normalized.isAfter(widget.maxDate)) return false;
    return true;
  }

  bool get _canGoPrevMonth {
    final prev = DateTime(_viewMonth.year, _viewMonth.month - 1);
    final endOfPrev = DateTime(prev.year, prev.month + 1, 0);
    return !endOfPrev.isBefore(widget.minDate);
  }

  bool get _canGoNextMonth {
    final next = DateTime(_viewMonth.year, _viewMonth.month + 1, 1);
    return !next.isAfter(widget.maxDate);
  }

  void _changeMonth(int delta) {
    if (delta == 0) return;
    setState(() {
      _monthDirection = delta.sign;
      _viewMonth = DateTime(_viewMonth.year, _viewMonth.month + delta);
    });
  }

  void _selectDate(DateTime date) {
    if (!_isInRange(date)) return;
    final selected = _dateOnly(date);
    setState(() => _selectedDate = selected);
    widget.onDateSelected(selected);
  }

  @override
  Widget build(BuildContext context) {
    return _CalendarPopover(
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
      showFrame: false,
    );
  }
}
