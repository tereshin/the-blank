part of 'heroui_date_time.dart';

const Color _kPrimary = Color(0xFF0485F7);
const Color _kDanger = Color(0xFFFF383C);
const Color _kTextLight = Color(0xFF18181B);
const Color _kTextDark = Color(0xFFFCFCFC);
const Color _kMutedLight = Color(0xFF71717A);
const Color _kMutedDark = Color(0xFFA1A1AA);
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
