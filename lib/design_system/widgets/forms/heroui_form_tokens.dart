part of 'heroui_forms.dart';

enum HeroUiInputVariant { primary, secondary }

enum HeroUiInputType { text, number, password }

enum HeroUiInputAffixTone { active, mute }

const List<BoxShadow> _kFieldShadow = [
  BoxShadow(color: Color(0x0F000000), blurRadius: 1, offset: Offset(0, 1)),
];

const Color _kFocusRingColor = Color(0xFF0485F7);
const Color _kDanger = Color(0xFFFF383C);

const Color _kFillPrimary = Color(0xFFFFFFFF);
const Color _kFillSecondary = Color(0xFFEBEBEC);
const Color _kDarkFillPrimary = Color(0xFF27272A);
const Color _kDarkFillSecondary = Color(0xFF3F3F46);

const Color _kMuted = Color(0xFF71717A);
const Color _kDarkMuted = Color(0xFFA1A1AA);
const Color _kForeground = Color(0xFF18181B);
const Color _kDarkForeground = Color(0xFFFCFCFC);

const TextStyle _kLabelStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w500,
  height: 1.43,
);

const TextStyle _kBodyXsStyle = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w400,
  height: 1.34,
);

const TextStyle _kInputTextStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w400,
  height: 1.43,
);

const TextStyle _kLinkSmStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w500,
  height: 1.286,
);

const TextStyle _kOtpValueStyle = TextStyle(
  fontSize: 13.5,
  fontWeight: FontWeight.w600,
  height: 1.333,
  letterSpacing: -0.27,
);

const TextStyle _kOtpValueErrorStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w600,
  height: 1.333,
  letterSpacing: -0.36,
);

const double _kOtpCellWidth = 38;

bool _isDark(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark;

Color _fillColor(BuildContext context, HeroUiInputVariant variant) =>
    _isDark(context)
    ? (variant == HeroUiInputVariant.primary
          ? _kDarkFillPrimary
          : _kDarkFillSecondary)
    : (variant == HeroUiInputVariant.primary ? _kFillPrimary : _kFillSecondary);

Color heroUiInputFillColor(BuildContext context, HeroUiInputVariant variant) =>
    _fillColor(context, variant);

Color _textColor(BuildContext context) =>
    _isDark(context) ? _kDarkForeground : _kForeground;

Color _mutedColor(BuildContext context) =>
    _isDark(context) ? _kDarkMuted : _kMuted;

Color _inputAffixDividerColor(BuildContext context) => _isDark(context)
    ? const Color.fromRGBO(161, 161, 170, 0.15)
    : const Color.fromRGBO(113, 113, 122, 0.15);

Color _inputAffixToneColor(BuildContext context, HeroUiInputAffixTone tone) {
  return switch (tone) {
    HeroUiInputAffixTone.active => _textColor(context),
    HeroUiInputAffixTone.mute => _mutedColor(context),
  };
}

BoxDecoration _inputDecoration({
  required BuildContext context,
  required HeroUiInputVariant variant,
  required bool isFocused,
  required bool hasError,
  required bool enabled,
}) {
  final dark = _isDark(context);
  final fill = _fillColor(context, variant);

  return BoxDecoration(
    color: fill,
    borderRadius: BorderRadius.circular(12),
    border: hasError
        ? Border.all(color: _kDanger)
        : Border.all(color: Colors.transparent),
    boxShadow:
        !isFocused && !dark && enabled && variant == HeroUiInputVariant.primary
        ? _kFieldShadow
        : const [],
  );
}

class _AnimatedFieldSurface extends StatelessWidget {
  const _AnimatedFieldSurface({
    required this.variant,
    required this.isFocused,
    required this.hasError,
    required this.enabled,
    required this.child,
  });

  final HeroUiInputVariant variant;
  final bool isFocused;
  final bool hasError;
  final bool enabled;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final decoration = _inputDecoration(
      context: context,
      variant: variant,
      isFocused: isFocused,
      hasError: hasError,
      enabled: enabled,
    );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: isFocused
            ? [
                BoxShadow(
                  color: hasError ? _kDanger : _kFocusRingColor,
                  spreadRadius: .2,
                  blurRadius: 0,
                ),
              ]
            : const [],
      ),
      child: Opacity(
        opacity: enabled ? 1 : 0.5,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          decoration: decoration,
          child: child,
        ),
      ),
    );
  }
}

TextInputType _keyboardType(HeroUiInputType type, int? maxLines) {
  return switch (type) {
    HeroUiInputType.number => TextInputType.number,
    HeroUiInputType.password => TextInputType.visiblePassword,
    HeroUiInputType.text =>
      maxLines == 1 ? TextInputType.text : TextInputType.multiline,
  };
}

List<Widget> _withVerticalSpacing(List<Widget> children, double spacing) {
  if (children.isEmpty) return const [];
  return [
    for (var i = 0; i < children.length; i++) ...[
      if (i > 0) SizedBox(height: spacing),
      children[i],
    ],
  ];
}

List<Widget> _withHorizontalSpacing(List<Widget> children, double spacing) {
  if (children.isEmpty) return const [];
  return [
    for (var i = 0; i < children.length; i++) ...[
      if (i > 0) SizedBox(width: spacing),
      children[i],
    ],
  ];
}
