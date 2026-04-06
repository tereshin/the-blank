part of 'heroui_date_time.dart';

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
    this.variant = HeroUiInputVariant.primary,
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
  final HeroUiInputVariant variant;

  @override
  Widget build(BuildContext context) {
    final dark = _isDark(context);
    final hasError = errorText?.trim().isNotEmpty == true;
    final hasDescription = description?.trim().isNotEmpty == true;
    final foreground = dark ? _kTextDark : _kTextLight;
    final muted = dark ? _kMutedDark : _kMutedLight;

    final fieldDecoration = BoxDecoration(
      color: heroUiInputFillColor(context, variant),
      borderRadius: BorderRadius.circular(12),
      border: hasError
          ? Border.all(color: _kDanger)
          : Border.all(color: Colors.transparent),
      boxShadow:
          !isFocused &&
              !dark &&
              enabled &&
              variant == HeroUiInputVariant.primary
          ? _kFieldShadow
          : const [],
    );

    final field = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeInOut,
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
  const _FieldSuffix({
    required this.isOpen,
    this.iconName = HeroUiIconManifest.calendar,
  });

  final bool isOpen;
  final String iconName;

  @override
  Widget build(BuildContext context) {
    final muted = _isDark(context) ? _kMutedDark : _kMutedLight;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [HeroUiIcon(iconName, size: 16, color: muted)],
      ),
    );
  }
}
