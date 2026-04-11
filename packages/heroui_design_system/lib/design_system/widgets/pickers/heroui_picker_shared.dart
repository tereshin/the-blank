part of 'heroui_pickers.dart';

const _kDropdownShadow = [
  BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.08),
    offset: Offset(0, 18),
    blurRadius: 36,
  ),
  BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.03),
    offset: Offset(0, -8),
    blurRadius: 16,
  ),
  BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.06),
    offset: Offset(0, 3),
    blurRadius: 10,
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
const Duration _kDropdownAnimationDuration = Duration(milliseconds: 180);

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
  final estimated = (rows * 52.0) + 10.0;
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
        borderRadius: BorderRadius.circular(31),
        boxShadow: _kDropdownShadow,
      ),
      padding: const EdgeInsets.all(5),
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? selectedColor
                : _hover
                ? hoverColor
                : Colors.transparent,
            borderRadius: BorderRadius.circular(26),
          ),
          child: Row(
            children: [
              if (widget.leading != null) ...[
                widget.leading!,
                const SizedBox(width: 10),
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
                Icon(Icons.check_rounded, size: 21, color: _kFocusRingColor),
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
              const SizedBox(width: 5),
              Text(
                '*',
                style: HeroUiTypography.bodySmMedium.copyWith(
                  color: _kDangerColor,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 5),
      ],
      GestureDetector(
        onTap: enabled ? onTap : null,
        behavior: HitTestBehavior.opaque,
        child: Opacity(
          opacity: enabled ? 1.0 : 0.5,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
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
                borderRadius: BorderRadius.circular(16),
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
                  if (prefix != null) ...[prefix, const SizedBox(width: 10)],
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
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
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: AnimatedRotation(
                      turns: isOpen ? 0.5 : 0,
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeInOut,
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 21,
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
        const SizedBox(height: 5),
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

class _DropdownOpenAnimation extends StatefulWidget {
  const _DropdownOpenAnimation({
    required this.openAbove,
    this.isVisible = true,
    required this.child,
  });

  final bool openAbove;
  final bool isVisible;
  final Widget child;

  @override
  State<_DropdownOpenAnimation> createState() => _DropdownOpenAnimationState();
}

class _DropdownOpenAnimationState extends State<_DropdownOpenAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _kDropdownAnimationDuration,
      reverseDuration: _kDropdownAnimationDuration,
      value: 0,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    if (widget.isVisible) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant _DropdownOpenAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible == oldWidget.isVisible) return;
    if (widget.isVisible) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      child: widget.child,
      builder: (context, animatedChild) {
        final value = _animation.value;
        final translateY = (1 - value) * (widget.openAbove ? 10 : -10);
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, translateY),
            child: Transform.scale(
              scale: 0.96 + (0.04 * value),
              alignment: widget.openAbove
                  ? Alignment.bottomCenter
                  : Alignment.topCenter,
              child: animatedChild,
            ),
          ),
        );
      },
    );
  }
}
