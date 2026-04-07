part of 'heroui_date_time.dart';

class _CalendarPopover extends StatelessWidget {
  const _CalendarPopover({
    required this.month,
    required this.selectedDate,
    required this.isDark,
    required this.canGoPrev,
    required this.canGoNext,
    required this.monthDirection,
    required this.canSelectDate,
    required this.onPrevMonth,
    required this.onNextMonth,
    required this.onDayTap,
    this.showFrame = true,
  });

  final DateTime month;
  final DateTime? selectedDate;
  final bool isDark;
  final bool canGoPrev;
  final bool canGoNext;
  final int monthDirection;
  final bool Function(DateTime date) canSelectDate;
  final VoidCallback onPrevMonth;
  final VoidCallback onNextMonth;
  final ValueChanged<DateTime> onDayTap;
  final bool showFrame;

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? _kTextDark : _kTextLight;
    final muted = isDark ? _kMutedDark : _kMutedLight;

    final content = SizedBox(
      width: 364,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(21, 0, 21, 21),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 21),
              child: Row(
                children: [
                  _NavButton(
                    iconName: _kChevronLeftIcon,
                    enabled: canGoPrev,
                    onTap: canGoPrev ? onPrevMonth : null,
                  ),
                  Expanded(
                    child: Text(
                      '${_monthName(month.month)} ${month.year}',
                      textAlign: TextAlign.center,
                      style: _kLabelStyle.copyWith(color: textColor),
                    ),
                  ),
                  _NavButton(
                    iconName: _kChevronRightIcon,
                    enabled: canGoNext,
                    onTap: canGoNext ? onNextMonth : null,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: const [
                  _WeekdayLabel('Sun'),
                  _WeekdayLabel('Mon'),
                  _WeekdayLabel('Tue'),
                  _WeekdayLabel('Wed'),
                  _WeekdayLabel('Thu'),
                  _WeekdayLabel('Fri'),
                  _WeekdayLabel('Sat'),
                ],
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, animation) {
                final begin = Offset(monthDirection * 0.1, 0);
                return ClipRect(
                  child: FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: begin,
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  ),
                );
              },
              child: _CalendarMonthGrid(
                key: ValueKey('${month.year}-${month.month}'),
                month: month,
                selectedDate: selectedDate,
                mutedColor: muted,
                canSelectDate: canSelectDate,
                onDayTap: onDayTap,
              ),
            ),
          ],
        ),
      ),
    );

    if (!showFrame) return content;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? _kPopoverDark : _kPopoverLight,
        borderRadius: BorderRadius.circular(31),
        boxShadow: _kPopoverShadow,
      ),
      child: content,
    );
  }
}

class _RangeCalendarPopover extends StatelessWidget {
  const _RangeCalendarPopover({
    required this.month,
    required this.startDate,
    required this.endDate,
    required this.isDark,
    required this.canGoPrev,
    required this.canGoNext,
    required this.monthDirection,
    required this.canSelectDate,
    required this.onPrevMonth,
    required this.onNextMonth,
    required this.onDayTap,
    this.showFrame = true,
  });

  final DateTime month;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isDark;
  final bool canGoPrev;
  final bool canGoNext;
  final int monthDirection;
  final bool Function(DateTime date) canSelectDate;
  final VoidCallback onPrevMonth;
  final VoidCallback onNextMonth;
  final ValueChanged<DateTime> onDayTap;
  final bool showFrame;

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? _kTextDark : _kTextLight;
    final muted = isDark ? _kMutedDark : _kMutedLight;

    final content = SizedBox(
      width: 364,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(21, 0, 21, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 21),
              child: Row(
                children: [
                  _NavButton(
                    iconName: _kChevronLeftIcon,
                    enabled: canGoPrev,
                    onTap: canGoPrev ? onPrevMonth : null,
                  ),
                  Expanded(
                    child: Text(
                      '${_monthName(month.month)} ${month.year}',
                      textAlign: TextAlign.center,
                      style: _kLabelStyle.copyWith(color: textColor),
                    ),
                  ),
                  _NavButton(
                    iconName: _kChevronRightIcon,
                    enabled: canGoNext,
                    onTap: canGoNext ? onNextMonth : null,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: const [
                  _WeekdayLabel('Sun'),
                  _WeekdayLabel('Mon'),
                  _WeekdayLabel('Tue'),
                  _WeekdayLabel('Wed'),
                  _WeekdayLabel('Thu'),
                  _WeekdayLabel('Fri'),
                  _WeekdayLabel('Sat'),
                ],
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, animation) {
                final begin = Offset(monthDirection * 0.1, 0);
                return ClipRect(
                  child: FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: begin,
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  ),
                );
              },
              child: _RangeCalendarMonthGrid(
                key: ValueKey(
                  '${month.year}-${month.month}-$startDate-$endDate',
                ),
                month: month,
                startDate: startDate,
                endDate: endDate,
                mutedColor: muted,
                canSelectDate: canSelectDate,
                onDayTap: onDayTap,
              ),
            ),
          ],
        ),
      ),
    );

    if (!showFrame) return content;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? _kPopoverDark : _kPopoverLight,
        borderRadius: BorderRadius.circular(31),
        boxShadow: _kPopoverShadow,
      ),
      padding: const EdgeInsets.only(bottom: 21),
      child: content,
    );
  }
}

class _WeekdayLabel extends StatelessWidget {
  const _WeekdayLabel(this.value);

  final String value;

  @override
  Widget build(BuildContext context) {
    final muted = _isDark(context) ? _kMutedDark : _kMutedLight;
    return Expanded(
      child: Center(
        child: Text(value, style: _kWeekdayStyle.copyWith(color: muted)),
      ),
    );
  }
}
