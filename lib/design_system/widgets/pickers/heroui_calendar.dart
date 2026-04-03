import 'package:flutter/material.dart';

import '../../typography/heroui_typography.dart';

// ─── Design Tokens ────────────────────────────────────────────────────────────
const Color _kPrimary = Color(0xFF0485F7);
const Color _kForeground = Color(0xFF18181B);
const Color _kMuted = Color(0xFF71717A);
const Color _kSurface = Color(0xFFFFFFFF);
const Color _kRangeHighlight = Color(0x1A0485F7); // primary ~10% opacity

// ─── Calendar ─────────────────────────────────────────────────────────────────
// Figma Calendar: month/year navigation + week header + day grid
// Variants: single-select and multi-select (type=present/future/multi/years)
class HeroUiCalendar extends StatefulWidget {
  const HeroUiCalendar({
    super.key,
    this.initialDate,
    this.selectedDate,
    this.onDateSelected,
    this.minDate,
    this.maxDate,
    this.width = 252.0,
  });

  final DateTime? initialDate;
  final DateTime? selectedDate;
  final ValueChanged<DateTime>? onDateSelected;
  final DateTime? minDate;
  final DateTime? maxDate;
  final double width;

  @override
  State<HeroUiCalendar> createState() => _HeroUiCalendarState();
}

class _HeroUiCalendarState extends State<HeroUiCalendar> {
  late DateTime _viewMonth;
  DateTime? _selected;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _viewMonth = DateTime(
      (widget.initialDate ?? widget.selectedDate ?? now).year,
      (widget.initialDate ?? widget.selectedDate ?? now).month,
    );
    _selected = widget.selectedDate;
  }

  @override
  void didUpdateWidget(HeroUiCalendar old) {
    super.didUpdateWidget(old);
    if (widget.selectedDate != old.selectedDate) {
      _selected = widget.selectedDate;
    }
  }

  void _prevMonth() => setState(
    () => _viewMonth = DateTime(_viewMonth.year, _viewMonth.month - 1),
  );

  void _nextMonth() => setState(
    () => _viewMonth = DateTime(_viewMonth.year, _viewMonth.month + 1),
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _CalendarNav(
            month: _monthName(_viewMonth.month),
            year: _viewMonth.year.toString(),
            onPrev: _prevMonth,
            onNext: _nextMonth,
          ),
          const SizedBox(height: 4),
          _WeekHeader(),
          const SizedBox(height: 4),
          _DayGrid(
            viewMonth: _viewMonth,
            selected: _selected,
            minDate: widget.minDate,
            maxDate: widget.maxDate,
            onTap: (date) {
              setState(() => _selected = date);
              widget.onDateSelected?.call(date);
            },
          ),
        ],
      ),
    );
  }
}

// ─── RangeCalendar ────────────────────────────────────────────────────────────
// Figma RangeCalendar: same layout as Calendar but selects a date range
class HeroUiRangeCalendar extends StatefulWidget {
  const HeroUiRangeCalendar({
    super.key,
    this.initialDate,
    this.startDate,
    this.endDate,
    this.onRangeSelected,
    this.minDate,
    this.maxDate,
    this.width = 252.0,
  });

  final DateTime? initialDate;
  final DateTime? startDate;
  final DateTime? endDate;
  final void Function(DateTime start, DateTime? end)? onRangeSelected;
  final DateTime? minDate;
  final DateTime? maxDate;
  final double width;

  @override
  State<HeroUiRangeCalendar> createState() => _HeroUiRangeCalendarState();
}

class _HeroUiRangeCalendarState extends State<HeroUiRangeCalendar> {
  late DateTime _viewMonth;
  DateTime? _start;
  DateTime? _end;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _viewMonth = DateTime(
      (widget.initialDate ?? widget.startDate ?? now).year,
      (widget.initialDate ?? widget.startDate ?? now).month,
    );
    _start = widget.startDate;
    _end = widget.endDate;
  }

  void _prevMonth() => setState(
    () => _viewMonth = DateTime(_viewMonth.year, _viewMonth.month - 1),
  );

  void _nextMonth() => setState(
    () => _viewMonth = DateTime(_viewMonth.year, _viewMonth.month + 1),
  );

  void _onTap(DateTime date) {
    setState(() {
      if (_start == null || (_start != null && _end != null)) {
        _start = date;
        _end = null;
      } else {
        if (date.isBefore(_start!)) {
          _end = _start;
          _start = date;
        } else {
          _end = date;
        }
      }
    });
    widget.onRangeSelected?.call(_start!, _end);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _CalendarNav(
            month: _monthName(_viewMonth.month),
            year: _viewMonth.year.toString(),
            onPrev: _prevMonth,
            onNext: _nextMonth,
          ),
          const SizedBox(height: 4),
          _WeekHeader(),
          const SizedBox(height: 4),
          _RangeDayGrid(
            viewMonth: _viewMonth,
            start: _start,
            end: _end,
            minDate: widget.minDate,
            maxDate: widget.maxDate,
            onTap: _onTap,
          ),
        ],
      ),
    );
  }
}

// ─── Internal: Navigation Header ─────────────────────────────────────────────
class _CalendarNav extends StatelessWidget {
  const _CalendarNav({
    required this.month,
    required this.year,
    required this.onPrev,
    required this.onNext,
  });

  final String month;
  final String year;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          _NavButton(icon: Icons.chevron_left_rounded, onTap: onPrev),
          Expanded(
            child: Text(
              '$month $year',
              textAlign: TextAlign.center,
              style: HeroUiTypography.bodySmMedium.copyWith(
                color: _kForeground,
              ),
            ),
          ),
          _NavButton(icon: Icons.chevron_right_rounded, onTap: onNext),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(icon, size: 16, color: _kPrimary),
      ),
    );
  }
}

// ─── Internal: Week Header ────────────────────────────────────────────────────
class _WeekHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const days = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];
    return Row(
      children: days
          .map(
            (d) => Expanded(
              child: SizedBox(
                height: 32,
                child: Center(
                  child: Text(
                    d,
                    style: HeroUiTypography.bodyXsMedium.copyWith(
                      color: _kMuted,
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

// ─── Internal: Day Grid (single select) ──────────────────────────────────────
class _DayGrid extends StatelessWidget {
  const _DayGrid({
    required this.viewMonth,
    required this.onTap,
    this.selected,
    this.minDate,
    this.maxDate,
  });

  final DateTime viewMonth;
  final DateTime? selected;
  final DateTime? minDate;
  final DateTime? maxDate;
  final ValueChanged<DateTime> onTap;

  @override
  Widget build(BuildContext context) {
    final cells = _buildCells();
    final rows = <Widget>[];
    for (var i = 0; i < cells.length; i += 7) {
      rows.add(
        Row(
          children: cells
              .sublist(i, i + 7)
              .map((c) => Expanded(child: c))
              .toList(),
        ),
      );
    }
    return Column(mainAxisSize: MainAxisSize.min, children: rows);
  }

  List<Widget> _buildCells() {
    final today = _today();
    final firstDay = DateTime(viewMonth.year, viewMonth.month, 1);
    final startOffset = firstDay.weekday % 7; // Sun=0..Sat=6
    final daysInMonth = _daysInMonth(viewMonth.year, viewMonth.month);

    final cells = <Widget>[];

    // Leading days from prev month
    final prevMonth = DateTime(viewMonth.year, viewMonth.month - 1);
    final daysInPrevMonth = _daysInMonth(prevMonth.year, prevMonth.month);
    for (var i = startOffset - 1; i >= 0; i--) {
      final date = DateTime(
        prevMonth.year,
        prevMonth.month,
        daysInPrevMonth - i,
      );
      cells.add(
        _DayCell(date: date, isOutOfMonth: true, onTap: () => onTap(date)),
      );
    }

    // Current month days
    for (var d = 1; d <= daysInMonth; d++) {
      final date = DateTime(viewMonth.year, viewMonth.month, d);
      final isSelected = selected != null && _isSameDay(date, selected!);
      final isDisabled =
          (minDate != null && date.isBefore(minDate!)) ||
          (maxDate != null && date.isAfter(maxDate!));
      cells.add(
        _DayCell(
          date: date,
          isSelected: isSelected,
          isToday: _isSameDay(date, today),
          isDisabled: isDisabled,
          onTap: isDisabled ? null : () => onTap(date),
        ),
      );
    }

    // Trailing days to complete last row
    final nextMonth = DateTime(viewMonth.year, viewMonth.month + 1);
    var trailing = 0;
    while ((cells.length) % 7 != 0) {
      trailing++;
      final date = DateTime(nextMonth.year, nextMonth.month, trailing);
      cells.add(
        _DayCell(date: date, isOutOfMonth: true, onTap: () => onTap(date)),
      );
    }

    return cells;
  }
}

// ─── Internal: Day Grid (range select) ───────────────────────────────────────
class _RangeDayGrid extends StatelessWidget {
  const _RangeDayGrid({
    required this.viewMonth,
    required this.onTap,
    this.start,
    this.end,
    this.minDate,
    this.maxDate,
  });

  final DateTime viewMonth;
  final DateTime? start;
  final DateTime? end;
  final DateTime? minDate;
  final DateTime? maxDate;
  final ValueChanged<DateTime> onTap;

  @override
  Widget build(BuildContext context) {
    final cells = _buildCells();
    final rows = <Widget>[];
    for (var i = 0; i < cells.length; i += 7) {
      rows.add(
        Row(
          children: cells
              .sublist(i, i + 7)
              .map((c) => Expanded(child: c))
              .toList(),
        ),
      );
    }
    return Column(mainAxisSize: MainAxisSize.min, children: rows);
  }

  List<Widget> _buildCells() {
    final today = _today();
    final firstDay = DateTime(viewMonth.year, viewMonth.month, 1);
    final startOffset = firstDay.weekday % 7;
    final daysInMonth = _daysInMonth(viewMonth.year, viewMonth.month);
    final cells = <Widget>[];

    final prevMonth = DateTime(viewMonth.year, viewMonth.month - 1);
    final daysInPrevMonth = _daysInMonth(prevMonth.year, prevMonth.month);
    for (var i = startOffset - 1; i >= 0; i--) {
      final date = DateTime(
        prevMonth.year,
        prevMonth.month,
        daysInPrevMonth - i,
      );
      cells.add(
        _RangeDayCell(date: date, isOutOfMonth: true, onTap: () => onTap(date)),
      );
    }

    for (var d = 1; d <= daysInMonth; d++) {
      final date = DateTime(viewMonth.year, viewMonth.month, d);
      final isStart = start != null && _isSameDay(date, start!);
      final isEnd = end != null && _isSameDay(date, end!);
      final inRange =
          start != null &&
          end != null &&
          date.isAfter(start!) &&
          date.isBefore(end!);
      cells.add(
        _RangeDayCell(
          date: date,
          isRangeStart: isStart,
          isRangeEnd: isEnd,
          isInRange: inRange,
          isToday: _isSameDay(date, today),
          onTap: () => onTap(date),
        ),
      );
    }

    final nextMonth = DateTime(viewMonth.year, viewMonth.month + 1);
    var trailing = 0;
    while ((cells.length) % 7 != 0) {
      trailing++;
      final date = DateTime(nextMonth.year, nextMonth.month, trailing);
      cells.add(
        _RangeDayCell(date: date, isOutOfMonth: true, onTap: () => onTap(date)),
      );
    }

    return cells;
  }
}

// ─── Internal: Single Day Cell ────────────────────────────────────────────────
class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.date,
    this.isSelected = false,
    this.isToday = false,
    this.isOutOfMonth = false,
    this.isDisabled = false,
    this.onTap,
  });

  final DateTime date;
  final bool isSelected;
  final bool isToday;
  final bool isOutOfMonth;
  final bool isDisabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Color textColor;
    if (isSelected) {
      textColor = _kSurface;
    } else if (isOutOfMonth || isDisabled) {
      textColor = _kMuted.withValues(alpha: isDisabled ? 0.4 : 1.0);
    } else if (isToday) {
      textColor = _kPrimary;
    } else {
      textColor = _kForeground;
    }

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 32,
        child: Center(
          child: Container(
            width: 28,
            height: 28,
            decoration: isSelected
                ? const BoxDecoration(color: _kPrimary, shape: BoxShape.circle)
                : isToday && !isSelected
                ? BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: _kPrimary, width: 1),
                  )
                : null,
            child: Center(
              child: Text(
                '${date.day}',
                style:
                    (isToday || isSelected
                            ? HeroUiTypography.bodyXsMedium
                            : HeroUiTypography.bodyXs)
                        .copyWith(color: textColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Internal: Range Day Cell ─────────────────────────────────────────────────
class _RangeDayCell extends StatelessWidget {
  const _RangeDayCell({
    required this.date,
    this.isRangeStart = false,
    this.isRangeEnd = false,
    this.isInRange = false,
    this.isToday = false,
    this.isOutOfMonth = false,
    this.onTap,
  });

  final DateTime date;
  final bool isRangeStart;
  final bool isRangeEnd;
  final bool isInRange;
  final bool isToday;
  final bool isOutOfMonth;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isEndpoint = isRangeStart || isRangeEnd;
    Color textColor;
    if (isEndpoint) {
      textColor = _kSurface;
    } else if (isOutOfMonth) {
      textColor = _kMuted;
    } else if (isToday) {
      textColor = _kPrimary;
    } else {
      textColor = _kForeground;
    }

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 32,
        child: Stack(
          children: [
            // Range highlight background (strip behind cell)
            if (isInRange || isRangeStart || isRangeEnd)
              Positioned.fill(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        color: (isRangeStart && !isRangeEnd)
                            ? Colors.transparent
                            : isInRange || isRangeEnd
                            ? _kRangeHighlight
                            : Colors.transparent,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: (isRangeEnd && !isRangeStart)
                            ? Colors.transparent
                            : isInRange || isRangeStart
                            ? _kRangeHighlight
                            : Colors.transparent,
                      ),
                    ),
                  ],
                ),
              ),
            Center(
              child: Container(
                width: 28,
                height: 28,
                decoration: isEndpoint
                    ? const BoxDecoration(
                        color: _kPrimary,
                        shape: BoxShape.circle,
                      )
                    : isInRange
                    ? const BoxDecoration(
                        color: _kRangeHighlight,
                        shape: BoxShape.circle,
                      )
                    : isToday
                    ? BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: _kPrimary),
                      )
                    : null,
                child: Center(
                  child: Text(
                    '${date.day}',
                    style:
                        (isEndpoint
                                ? HeroUiTypography.bodyXsMedium
                                : HeroUiTypography.bodyXs)
                            .copyWith(color: textColor),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Helpers ─────────────────────────────────────────────────────────────────
DateTime _today() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}

bool _isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

int _daysInMonth(int year, int month) => DateTime(year, month + 1, 0).day;

String _monthName(int month) {
  const names = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  return names[month - 1];
}
