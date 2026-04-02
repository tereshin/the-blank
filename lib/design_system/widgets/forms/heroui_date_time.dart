import 'package:flutter/material.dart';

import '../../../core/icons/heroui_icon.dart';
import '../buttons/heroui_buttons.dart';
import 'heroui_forms.dart';

const Color _kPrimary = Color(0xFF0485F7);
const Color _kDanger = Color(0xFFFF383C);
const Color _kTextLight = Color(0xFF18181B);
const Color _kTextDark = Color(0xFFFCFCFC);
const Color _kMutedLight = Color(0xFF71717A);
const Color _kMutedDark = Color(0xFFA1A1AA);
const Color _kFieldLight = Color(0xFFFFFFFF);
const Color _kFieldDark = Color(0xFF27272A);
const Color _kPopoverLight = Color(0xFFFFFFFF);
const Color _kPopoverDark = Color(0xFF18181B);
const Color _kRangeHighlight = Color.fromRGBO(4, 133, 247, 0.15);
const String _kChevronLeftIcon = 'heroui-v3-icon__chevron-left__regular';
const String _kChevronRightIcon = 'heroui-v3-icon__chevron-right__regular';
const double _kCalendarModalBreakpoint = 720;

const List<BoxShadow> _kFieldShadow = [
  BoxShadow(color: Color(0x0F000000), blurRadius: 1, offset: Offset(0, 1)),
];

const List<BoxShadow> _kPopoverShadow = [
  BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.08),
    blurRadius: 28,
    offset: Offset(0, 14),
  ),
  BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.03),
    blurRadius: 12,
    offset: Offset(0, -6),
  ),
  BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.06),
    blurRadius: 8,
    offset: Offset(0, 2),
  ),
  BoxShadow(
    color: Color.fromRGBO(255, 255, 255, 0.3),
    blurRadius: 1,
    blurStyle: BlurStyle.inner,
  ),
];

const TextStyle _kLabelStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w500,
  height: 1.43,
);

const TextStyle _kFieldTextStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w400,
  height: 1.43,
);

const TextStyle _kWeekdayStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w500,
  height: 1.43,
);

bool _isDark(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark;

DateTime _dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);

bool _isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

String _twoDigits(int value) => value.toString().padLeft(2, '0');

String _formatDate(DateTime value) =>
    '${_twoDigits(value.month)}/${_twoDigits(value.day)}/${value.year}';

String _formatDateRange(DateTime start, DateTime end) =>
    '${_formatDate(start)} - ${_formatDate(end)}';

bool _useCalendarBottomSheet(BuildContext context) =>
    MediaQuery.sizeOf(context).width < _kCalendarModalBreakpoint;

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

String _formatTime(
  TimeOfDay value, {
  required bool show12hr,
  required bool showSeconds,
}) {
  if (show12hr) {
    final hour = value.hourOfPeriod == 0 ? 12 : value.hourOfPeriod;
    final minute = _twoDigits(value.minute);
    final suffix = value.period == DayPeriod.am ? 'AM' : 'PM';
    final seconds = showSeconds ? ':00' : '';
    return '$hour:$minute$seconds $suffix';
  }
  final hour = _twoDigits(value.hour);
  final minute = _twoDigits(value.minute);
  final seconds = showSeconds ? ':00' : '';
  return '$hour:$minute$seconds';
}

/// HeroUI DateField with optional time selection.
class HeroUiDateField extends StatefulWidget {
  const HeroUiDateField({
    super.key,
    this.label,
    this.description,
    this.errorText,
    this.placeholder = 'MM/DD/YYYY',
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
      enabled: widget.enabled,
      isFocused: _isPicking,
      valueText: valueText,
      placeholder: widget.placeholder,
      onTap: _pickValue,
      suffix: _FieldSuffix(isOpen: _isPicking),
    );
  }
}

/// HeroUI TimeField.
class HeroUiTimeField extends StatefulWidget {
  const HeroUiTimeField({
    super.key,
    this.label,
    this.description,
    this.errorText,
    this.placeholder = 'HH:MM',
    this.initialValue,
    this.enabled = true,
    this.show12hr = true,
    this.showSeconds = false,
    this.onChanged,
  });

  final String? label;
  final String? description;
  final String? errorText;
  final String placeholder;
  final TimeOfDay? initialValue;
  final bool enabled;
  final bool show12hr;
  final bool showSeconds;
  final ValueChanged<TimeOfDay>? onChanged;

  @override
  State<HeroUiTimeField> createState() => _HeroUiTimeFieldState();
}

class _HeroUiTimeFieldState extends State<HeroUiTimeField> {
  TimeOfDay? _value;
  bool _isPicking = false;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  Future<void> _pickTime() async {
    if (!widget.enabled || _isPicking) return;
    setState(() => _isPicking = true);
    final value = await showTimePicker(
      context: context,
      initialTime: _value ?? TimeOfDay.now(),
      builder: (context, child) {
        if (widget.show12hr) return child ?? const SizedBox.shrink();
        final mediaQuery = MediaQuery.of(context);
        return MediaQuery(
          data: mediaQuery.copyWith(alwaysUse24HourFormat: true),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
    if (!mounted) return;
    if (value == null) {
      setState(() => _isPicking = false);
      return;
    }
    setState(() {
      _value = value;
      _isPicking = false;
    });
    widget.onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final valueText = _value == null
        ? null
        : _formatTime(
            _value!,
            show12hr: widget.show12hr,
            showSeconds: widget.showSeconds,
          );

    return _DateTimeFieldFrame(
      label: widget.label,
      description: widget.description,
      errorText: widget.errorText,
      enabled: widget.enabled,
      isFocused: _isPicking,
      valueText: valueText,
      placeholder: widget.placeholder,
      onTap: _pickTime,
      suffix: _FieldSuffix(isOpen: _isPicking),
    );
  }
}

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

class _DateTimeFieldFrame extends StatelessWidget {
  const _DateTimeFieldFrame({
    required this.enabled,
    required this.isFocused,
    required this.placeholder,
    required this.onTap,
    required this.suffix,
    this.label,
    this.description,
    this.errorText,
    this.valueText,
  });

  final String? label;
  final String? description;
  final String? errorText;
  final bool enabled;
  final bool isFocused;
  final String? valueText;
  final String placeholder;
  final VoidCallback onTap;
  final Widget suffix;

  @override
  Widget build(BuildContext context) {
    final dark = _isDark(context);
    final hasError = errorText?.trim().isNotEmpty == true;
    final hasDescription = description?.trim().isNotEmpty == true;
    final foreground = dark ? _kTextDark : _kTextLight;
    final muted = dark ? _kMutedDark : _kMutedLight;

    final fieldDecoration = BoxDecoration(
      color: dark ? _kFieldDark : _kFieldLight,
      borderRadius: BorderRadius.circular(12),
      border: hasError
          ? Border.all(color: _kDanger)
          : Border.all(color: Colors.transparent),
      boxShadow: !isFocused && !dark && enabled ? _kFieldShadow : const [],
    );

    final field = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeInOut,
      // Keep space for an external focus ring in all states to avoid clipping.
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: isFocused
            ? [
                BoxShadow(
                  color: hasError ? _kDanger : _kPrimary,
                  spreadRadius: .2,
                  blurRadius: 0,
                ),
              ]
            : const [],
      ),
      child: Opacity(
        opacity: enabled ? 1 : 0.5,
        child: GestureDetector(
          onTap: enabled ? onTap : null,
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeInOut,
            constraints: const BoxConstraints(minHeight: 36),
            decoration: fieldDecoration,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(start: 12),
                    child: Text(
                      valueText ?? placeholder,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: _kFieldTextStyle.copyWith(
                        color: valueText == null ? muted : foreground,
                      ),
                    ),
                  ),
                ),
                suffix,
              ],
            ),
          ),
        ),
      ),
    );

    final children = <Widget>[
      if (label != null) HeroUiLabel(label!),
      field,
      if (hasError || hasDescription)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: hasError
              ? HeroUiErrorMessage(errorText!)
              : HeroUiDescription(description!),
        ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) const SizedBox(height: 4),
          children[i],
        ],
      ],
    );
  }
}

class _FieldSuffix extends StatelessWidget {
  const _FieldSuffix({required this.isOpen});

  final bool isOpen;

  @override
  Widget build(BuildContext context) {
    final muted = _isDark(context) ? _kMutedDark : _kMutedLight;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          HeroUiIcon(
            HeroUiIconManifest.calendarRegular,
            size: 16,
            color: muted,
          ),
        ],
      ),
    );
  }
}

Future<T?> _showAdaptiveCalendarSurface<T>({
  required BuildContext context,
  required String title,
  required double dialogWidth,
  required WidgetBuilder builder,
}) {
  if (_useCalendarBottomSheet(context)) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      elevation: 0,
      isScrollControlled: true,
      useSafeArea: false,
      barrierColor: Colors.black.withValues(alpha: 0.48),
      builder: (sheetContext) =>
          _CalendarBottomSheetShell(title: title, child: builder(sheetContext)),
    );
  }

  return showDialog<T>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.48),
    builder: (dialogContext) => Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: _CalendarDialogShell(
        title: title,
        width: dialogWidth,
        child: builder(dialogContext),
      ),
    ),
  );
}

class _CalendarDialogShell extends StatelessWidget {
  const _CalendarDialogShell({
    required this.title,
    required this.width,
    required this.child,
  });

  final String title;
  final double width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final dark = _isDark(context);
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: width),
      child: Container(
        decoration: BoxDecoration(
          color: dark ? _kPopoverDark : _kPopoverLight,
          borderRadius: BorderRadius.circular(24),
          boxShadow: _kPopoverShadow,
        ),
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _CalendarModalHeader(title: title),
            Align(alignment: Alignment.center, child: child),
          ],
        ),
      ),
    );
  }
}

class _CalendarBottomSheetShell extends StatelessWidget {
  const _CalendarBottomSheetShell({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final dark = _isDark(context);
    final muted = dark ? _kMutedDark : _kMutedLight;
    final mediaQuery = MediaQuery.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: mediaQuery.viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: dark ? _kPopoverDark : _kPopoverLight,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: _kPopoverShadow,
        ),
        child: Padding(
          padding: EdgeInsets.only(bottom: mediaQuery.padding.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 4),
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: muted.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              _CalendarModalHeader(title: title),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: Align(alignment: Alignment.center, child: child),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CalendarModalHeader extends StatelessWidget {
  const _CalendarModalHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final dark = _isDark(context);
    final textColor = dark ? _kTextDark : _kTextLight;
    final titleStyle = Theme.of(context).textTheme.titleSmall;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      child: Row(
        children: [
          SizedBox(width: 28, height: 28, child: Center()),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style:
                  titleStyle?.copyWith(color: textColor) ??
                  _kLabelStyle.copyWith(color: textColor),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 28,
            height: 28,
            child: Center(
              child: HeroUiCloseButton(
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
      width: 280,
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
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _CalendarActionButton(
                  label: 'Cancel',
                  isPrimary: false,
                  onTap: widget.onCancel,
                ),
              ),
              const SizedBox(width: 8),
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
          height: 36,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(24),
            border: isPrimary ? null : Border.all(color: borderColor),
          ),
          alignment: Alignment.center,
          child: Text(label, style: _kLabelStyle.copyWith(color: textColor)),
        ),
      ),
    );
  }
}

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
      width: 280,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
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
              padding: const EdgeInsets.symmetric(vertical: 8),
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
        borderRadius: BorderRadius.circular(24),
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
      width: 280,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
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
              padding: const EdgeInsets.symmetric(vertical: 8),
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
        borderRadius: BorderRadius.circular(24),
        boxShadow: _kPopoverShadow,
      ),
      padding: const EdgeInsets.only(bottom: 16),
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
      if (row < 5) rows.add(const SizedBox(height: 2));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
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
      if (row < 5) rows.add(const SizedBox(height: 2));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
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
          height: 32,
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
                            left: Radius.circular(8),
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
                            right: Radius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 120),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isEndpoint ? _kPrimary : Colors.transparent,
                    borderRadius: BorderRadius.circular(24),
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
                          bottom: 4,
                          child: Container(
                            width: 3,
                            height: 3,
                            decoration: BoxDecoration(
                              color: mutedColor,
                              borderRadius: BorderRadius.circular(12),
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
          height: 32,
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isSelected ? _kPrimary : Colors.transparent,
                borderRadius: BorderRadius.circular(24),
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
                      bottom: 4,
                      child: Container(
                        width: 3,
                        height: 3,
                        decoration: BoxDecoration(
                          color: mutedColor,
                          borderRadius: BorderRadius.circular(12),
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
        padding: const EdgeInsets.all(4),
        child: HeroUiIcon(iconName, size: 12, color: iconColor),
      ),
    );
  }
}
