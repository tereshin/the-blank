part of 'heroui_date_time.dart';

class _CalendarMonthGrid extends StatelessWidget {
  const _CalendarMonthGrid({
    super.key,
    required this.month,
    required this.selectedDate,
    required this.mutedColor,
    required this.canSelectDate,
    required this.onDayTap,
  });

  final DateTime month;
  final DateTime? selectedDate;
  final Color mutedColor;
  final bool Function(DateTime date) canSelectDate;
  final ValueChanged<DateTime> onDayTap;

  @override
  Widget build(BuildContext context) {
    final firstOfMonth = DateTime(month.year, month.month, 1);
    final leadingDays = firstOfMonth.weekday % 7;
    final startDate = firstOfMonth.subtract(Duration(days: leadingDays));
    final today = _dateOnly(DateTime.now());

    final rows = <Widget>[];
    for (var row = 0; row < 6; row++) {
      final cells = <Widget>[];
      for (var col = 0; col < 7; col++) {
        final date = startDate.add(Duration(days: row * 7 + col));
        final isOutOfMonth = date.month != month.month;
        final isSelected =
            selectedDate != null && _isSameDay(date, selectedDate!);
        final isToday = _isSameDay(date, today);
        final enabled = canSelectDate(date);

        cells.add(
          Expanded(
            child: _CalendarDayCell(
              date: date,
              isOutOfMonth: isOutOfMonth,
              isSelected: isSelected,
              isToday: isToday,
              enabled: enabled,
              mutedColor: mutedColor,
              onTap: enabled ? () => onDayTap(date) : null,
            ),
          ),
        );
      }

      rows.add(Row(children: cells));
      if (row < 5) rows.add(const SizedBox(height: 3));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(mainAxisSize: MainAxisSize.min, children: rows),
    );
  }
}

class _RangeCalendarMonthGrid extends StatelessWidget {
  const _RangeCalendarMonthGrid({
    super.key,
    required this.month,
    required this.startDate,
    required this.endDate,
    required this.mutedColor,
    required this.canSelectDate,
    required this.onDayTap,
  });

  final DateTime month;
  final DateTime? startDate;
  final DateTime? endDate;
  final Color mutedColor;
  final bool Function(DateTime date) canSelectDate;
  final ValueChanged<DateTime> onDayTap;

  @override
  Widget build(BuildContext context) {
    final firstOfMonth = DateTime(month.year, month.month, 1);
    final leadingDays = firstOfMonth.weekday % 7;
    final startDateInGrid = firstOfMonth.subtract(Duration(days: leadingDays));
    final today = _dateOnly(DateTime.now());

    final rows = <Widget>[];
    for (var row = 0; row < 6; row++) {
      final cells = <Widget>[];
      for (var col = 0; col < 7; col++) {
        final date = startDateInGrid.add(Duration(days: row * 7 + col));
        final isOutOfMonth = date.month != month.month;
        final isToday = _isSameDay(date, today);
        final isRangeStart = startDate != null && _isSameDay(date, startDate!);
        final isRangeEnd = endDate != null && _isSameDay(date, endDate!);
        final isInRange =
            startDate != null &&
            endDate != null &&
            date.isAfter(startDate!) &&
            date.isBefore(endDate!);
        final enabled = canSelectDate(date);

        cells.add(
          Expanded(
            child: _RangeCalendarDayCell(
              date: date,
              isOutOfMonth: isOutOfMonth,
              isRangeStart: isRangeStart,
              isRangeEnd: isRangeEnd,
              isInRange: isInRange,
              isToday: isToday,
              enabled: enabled,
              mutedColor: mutedColor,
              onTap: enabled ? () => onDayTap(date) : null,
            ),
          ),
        );
      }
      rows.add(Row(children: cells));
      if (row < 5) rows.add(const SizedBox(height: 3));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(mainAxisSize: MainAxisSize.min, children: rows),
    );
  }
}

class _RangeCalendarDayCell extends StatelessWidget {
  const _RangeCalendarDayCell({
    required this.date,
    required this.isOutOfMonth,
    required this.isRangeStart,
    required this.isRangeEnd,
    required this.isInRange,
    required this.isToday,
    required this.enabled,
    required this.mutedColor,
    required this.onTap,
  });

  final DateTime date;
  final bool isOutOfMonth;
  final bool isRangeStart;
  final bool isRangeEnd;
  final bool isInRange;
  final bool isToday;
  final bool enabled;
  final Color mutedColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final dark = _isDark(context);
    final baseTextColor = dark ? _kTextDark : _kTextLight;
    final isEndpoint = isRangeStart || isRangeEnd;
    final textColor = isEndpoint
        ? _kTextDark
        : isOutOfMonth
        ? mutedColor
        : enabled
        ? baseTextColor
        : mutedColor;

    final opacity = !enabled
        ? 0.4
        : isOutOfMonth && !isEndpoint && !isInRange
        ? 0.5
        : 1.0;
    final indicator = !isEndpoint && !isInRange && isToday && !isOutOfMonth;
    final showRangeFill = isInRange || isRangeStart || isRangeEnd;
    final fillLeft = isInRange || isRangeEnd || (isRangeStart && isRangeEnd);
    final fillRight = isInRange || isRangeStart || (isRangeStart && isRangeEnd);

    return Opacity(
      opacity: opacity,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          height: 42,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (showRangeFill)
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: fillLeft
                              ? _kRangeHighlight
                              : Colors.transparent,
                          borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: fillRight
                              ? _kRangeHighlight
                              : Colors.transparent,
                          borderRadius: const BorderRadius.horizontal(
                            right: Radius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 120),
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: isEndpoint ? _kPrimary : Colors.transparent,
                    borderRadius: BorderRadius.circular(31),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        '${date.day}',
                        style: _kLabelStyle.copyWith(color: textColor),
                      ),
                      if (indicator)
                        Positioned(
                          bottom: 5,
                          child: Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: mutedColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
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
  }
}

class _CalendarDayCell extends StatelessWidget {
  const _CalendarDayCell({
    required this.date,
    required this.isOutOfMonth,
    required this.isSelected,
    required this.isToday,
    required this.enabled,
    required this.mutedColor,
    required this.onTap,
  });

  final DateTime date;
  final bool isOutOfMonth;
  final bool isSelected;
  final bool isToday;
  final bool enabled;
  final Color mutedColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final dark = _isDark(context);
    final baseTextColor = dark ? _kTextDark : _kTextLight;
    final textColor = isSelected
        ? _kTextDark
        : isOutOfMonth
        ? mutedColor
        : enabled
        ? baseTextColor
        : mutedColor;

    final opacity = !enabled
        ? 0.4
        : isOutOfMonth
        ? 0.5
        : 1.0;

    final indicator = !isSelected && isToday && !isOutOfMonth;

    return Opacity(
      opacity: opacity,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          height: 42,
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: isSelected ? _kPrimary : Colors.transparent,
                borderRadius: BorderRadius.circular(31),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    '${date.day}',
                    style: _kLabelStyle.copyWith(color: textColor),
                  ),
                  if (indicator)
                    Positioned(
                      bottom: 5,
                      child: Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: mutedColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.iconName,
    required this.enabled,
    required this.onTap,
  });

  final String iconName;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final iconColor = enabled
        ? _kPrimary
        : (_isDark(context) ? _kMutedDark : _kMutedLight);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: HeroUiIcon(iconName, size: 20, color: iconColor),
      ),
    );
  }
}
