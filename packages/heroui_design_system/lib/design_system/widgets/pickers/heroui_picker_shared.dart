part of 'heroui_pickers.dart';

const _kDropdownShadow = [
  BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.08),
    offset: Offset(0, 14),
    blurRadius: 28,
  ),
  BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.03),
    offset: Offset(0, -6),
    blurRadius: 12,
  ),
  BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.06),
    offset: Offset(0, 2),
    blurRadius: 8,
  ),
];

/// Matches [HeroUiTextField] / `_inputDecoration` primary variant (light theme).
const _kInputPrimaryFieldShadow = [
  BoxShadow(color: Color(0x0F000000), blurRadius: 1, offset: Offset(0, 1)),
];

const _kFieldShadow = [
  BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.04),
    offset: Offset(0, 1),
    blurRadius: 2,
  ),
  BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.08),
    offset: Offset(0, 2),
    blurRadius: 4,
  ),
];

const Color _kFocusRingColor = Color(0xFF0485F7);
const Color _kDangerColor = Color(0xFFFF383C);

bool _isDark(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark;

Color _pickerFieldBg(BuildContext context) =>
    _isDark(context) ? const Color(0xFF18181B) : const Color(0xFFFFFFFF);

Color _pickerText(BuildContext context) =>
    _isDark(context) ? const Color(0xFFFCFCFC) : const Color(0xFF18181B);

Color _pickerMuted(BuildContext context) =>
    _isDark(context) ? const Color(0xFFA1A1AA) : const Color(0xFF71717A);

double _estimateDropdownHeight({
  required int itemCount,
  required double maxListHeight,
}) {
  final rows = itemCount <= 0 ? 1 : itemCount;
  final estimated = (rows * 40.0) + 8.0;
  return math.min(maxListHeight, estimated);
}

/// A single item in a picker dropdown.
class HeroUiPickerItem<T> {
  const HeroUiPickerItem({
    required this.value,
    required this.label,
    this.leading,
  });

  final T value;
  final String label;
  final Widget? leading;
}

/// Builds the dropdown list panel used by all pickers.
class _DropdownPanel extends StatelessWidget {
  const _DropdownPanel({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final bg = _pickerFieldBg(context);

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(24),
        boxShadow: _kDropdownShadow,
      ),
      padding: const EdgeInsets.all(4),
      child: Column(mainAxisSize: MainAxisSize.min, children: children),
    );
  }
}

/// A single item row in a dropdown panel.
class _DropdownItem extends StatefulWidget {
  const _DropdownItem({
    required this.label,
    required this.onTap,
    this.leading,
    this.isSelected = false,
  });

  final String label;
  final VoidCallback onTap;
  final Widget? leading;
  final bool isSelected;

  @override
  State<_DropdownItem> createState() => _DropdownItemState();
}

class _DropdownItemState extends State<_DropdownItem> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final textColor = _pickerText(context);
    final hoverColor = _isDark(context)
        ? const Color(0xFF3F3F46)
        : const Color(0xFFEFEFF0);
    final selectedColor = _isDark(context)
        ? const Color(0xFF3F3F46)
        : const Color(0xFFEFEFF0);

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? selectedColor
                : _hover
                ? hoverColor
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              if (widget.leading != null) ...[
                widget.leading!,
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  widget.label,
                  style:
                      (widget.isSelected
                              ? HeroUiTypography.bodySmMedium
                              : HeroUiTypography.bodySm)
                          .copyWith(color: textColor),
                ),
              ),
              if (widget.isSelected)
                Icon(Icons.check_rounded, size: 16, color: _kFocusRingColor),
            ],
          ),
        ),
      ),
    );
  }
}

/// Builds a styled trigger field used by all pickers.
Widget _buildTriggerField({
  required BuildContext context,
  required String? value,
  required String placeholder,
  required String? label,
  required bool requiredField,
  required String? description,
  required bool isOpen,
  required bool enabled,
  required bool hasError,
  required String? errorText,
  required GlobalKey triggerKey,
  required VoidCallback onTap,
  HeroUiInputVariant variant = HeroUiInputVariant.primary,
  Widget? prefix,
}) {
  final textColor = _pickerText(context);
  final mutedColor = _pickerMuted(context);
  final helperText = hasError ? errorText : description;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      if (label != null) ...[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: HeroUiTypography.bodySmMedium.copyWith(color: textColor),
            ),
            if (requiredField) ...[
              const SizedBox(width: 4),
              Text(
                '*',
                style: HeroUiTypography.bodySmMedium.copyWith(
                  color: _kDangerColor,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 4),
      ],
      GestureDetector(
        onTap: enabled ? onTap : null,
        behavior: HitTestBehavior.opaque,
        child: Opacity(
          opacity: enabled ? 1.0 : 0.5,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              boxShadow: isOpen
                  ? const [
                      BoxShadow(
                        color: _kFocusRingColor,
                        spreadRadius: .2,
                        blurRadius: 0,
                      ),
                    ]
                  : const [],
            ),
            child: Container(
              key: triggerKey,
              decoration: BoxDecoration(
                color: heroUiInputFillColor(context, variant),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: hasError ? _kDangerColor : Colors.transparent,
                ),
                boxShadow:
                    !isOpen &&
                        enabled &&
                        !_isDark(context) &&
                        variant == HeroUiInputVariant.primary
                    ? _kInputPrimaryFieldShadow
                    : const [],
              ),
              child: Row(
                children: [
                  if (prefix != null) ...[prefix, const SizedBox(width: 8)],
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Text(
                        value ?? placeholder,
                        style: HeroUiTypography.textFieldSm.copyWith(
                          color: value != null ? textColor : mutedColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: AnimatedRotation(
                      turns: isOpen ? 0.5 : 0,
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeInOut,
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 16,
                        color: mutedColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      if (helperText?.isNotEmpty == true) ...[
        const SizedBox(height: 4),
        Text(
          helperText!,
          style: HeroUiTypography.bodyXs.copyWith(
            color: hasError ? _kDangerColor : mutedColor,
          ),
        ),
      ],
    ],
  );
}

class _DropdownOpenAnimation extends StatelessWidget {
  const _DropdownOpenAnimation({required this.openAbove, required this.child});

  final bool openAbove;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      builder: (context, value, animatedChild) {
        final translateY = (1 - value) * (openAbove ? 8 : -8);
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, translateY),
            child: Transform.scale(
              scale: 0.96 + (0.04 * value),
              alignment: openAbove
                  ? Alignment.bottomCenter
                  : Alignment.topCenter,
              child: animatedChild,
            ),
          ),
        );
      },
      child: child,
    );
  }
}
