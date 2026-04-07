part of 'heroui_date_time.dart';

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
      insetPadding: const EdgeInsets.symmetric(horizontal: 31, vertical: 31),
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
          borderRadius: BorderRadius.circular(31),
          boxShadow: _kPopoverShadow,
        ),
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
          borderRadius: const BorderRadius.vertical(top: Radius.circular(31)),
          boxShadow: _kPopoverShadow,
        ),
        child: Padding(
          padding: EdgeInsets.only(bottom: mediaQuery.padding.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Container(
                  width: 47,
                  height: 5,
                  decoration: BoxDecoration(
                    color: muted.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              _CalendarModalHeader(title: title),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
      child: Row(
        children: [
          SizedBox(width: 36, height: 36, child: Center()),
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
            width: 36,
            height: 36,
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
