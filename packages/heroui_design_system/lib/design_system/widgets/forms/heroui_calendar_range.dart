part of 'heroui_date_time.dart';

class _RangeDateCalendarPicker extends StatefulWidget {
  const _RangeDateCalendarPicker({
    required this.minDate,
    required this.maxDate,
    required this.onCancel,
    required this.onApply,
    this.initialStart,
    this.initialEnd,
  });

  final DateTime? initialStart;
  final DateTime? initialEnd;
  final DateTime minDate;
  final DateTime maxDate;
  final VoidCallback onCancel;
  final ValueChanged<DateTimeRange> onApply;

  @override
  State<_RangeDateCalendarPicker> createState() =>
      _RangeDateCalendarPickerState();
}

class _RangeDateCalendarPickerState extends State<_RangeDateCalendarPicker> {
  late DateTime _viewMonth;
  DateTime? _start;
  DateTime? _end;
  int _monthDirection = 1;

  @override
  void initState() {
    super.initState();
    final anchor = widget.initialStart ?? widget.initialEnd ?? DateTime.now();
    _viewMonth = DateTime(anchor.year, anchor.month);
    _start = widget.initialStart;
    _end = widget.initialEnd;
  }

  bool _canSelectDate(DateTime date) {
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

  bool get _canApply => _start != null && _end != null;

  void _changeMonth(int delta) {
    if (delta == 0) return;
    setState(() {
      _monthDirection = delta.sign;
      _viewMonth = DateTime(_viewMonth.year, _viewMonth.month + delta);
    });
  }

  void _selectRangeDate(DateTime date) {
    if (!_canSelectDate(date)) return;
    final picked = _dateOnly(date);
    setState(() {
      if (_start == null || _end != null) {
        _start = picked;
        _end = null;
        return;
      }
      if (picked.isBefore(_start!)) {
        _end = _start;
        _start = picked;
      } else {
        _end = picked;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 364,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _RangeCalendarPopover(
            month: _viewMonth,
            startDate: _start,
            endDate: _end,
            isDark: _isDark(context),
            canGoPrev: _canGoPrevMonth,
            canGoNext: _canGoNextMonth,
            monthDirection: _monthDirection,
            canSelectDate: _canSelectDate,
            onPrevMonth: () => _changeMonth(-1),
            onNextMonth: () => _changeMonth(1),
            onDayTap: _selectRangeDate,
            showFrame: false,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _CalendarActionButton(
                  label: 'Cancel',
                  isPrimary: false,
                  onTap: widget.onCancel,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _CalendarActionButton(
                  label: 'Apply',
                  isPrimary: true,
                  enabled: _canApply,
                  onTap: _canApply
                      ? () => widget.onApply(
                          DateTimeRange(start: _start!, end: _end!),
                        )
                      : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CalendarActionButton extends StatelessWidget {
  const _CalendarActionButton({
    required this.label,
    required this.isPrimary,
    required this.onTap,
    this.enabled = true,
  });

  final String label;
  final bool isPrimary;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final dark = _isDark(context);
    final borderColor = dark
        ? const Color(0xFF3F3F46)
        : const Color(0xFFDEDEE0);
    final textColor = isPrimary
        ? const Color(0xFFFFFFFF)
        : (dark ? _kTextDark : _kTextLight);
    final background = isPrimary
        ? (enabled ? _kPrimary : _kPrimary.withValues(alpha: 0.45))
        : Colors.transparent;

    return Opacity(
      opacity: enabled ? 1 : 0.7,
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: 47,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(31),
            border: isPrimary ? null : Border.all(color: borderColor),
          ),
          alignment: Alignment.center,
          child: Text(label, style: _kLabelStyle.copyWith(color: textColor)),
        ),
      ),
    );
  }
}
