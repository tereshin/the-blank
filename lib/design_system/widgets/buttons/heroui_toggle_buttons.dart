part of 'heroui_buttons.dart';

class HeroUiToggleOption<T> {
  const HeroUiToggleOption({
    required this.value,
    required this.label,
    this.icon,
    this.trailing,
    this.iconOnly = false,
  });
  final T value;
  final String label;
  final Widget? icon;
  final Widget? trailing;
  final bool iconOnly;
}

class HeroUiToggleButton extends StatelessWidget {
  const HeroUiToggleButton({
    required this.label,
    required this.selected,
    required this.onChanged,
    super.key,
    this.size = HeroUiButtonSize.md,
    this.leading,
    this.trailing,
    this.iconOnly = false,
    this.variant = HeroUiToggleButtonVariant.defaultVariant,
  });
  final String label;
  final bool selected;
  final ValueChanged<bool>? onChanged;
  final HeroUiButtonSize size;
  final Widget? leading;
  final Widget? trailing;
  final bool iconOnly;
  final HeroUiToggleButtonVariant variant;

  @override
  Widget build(BuildContext context) => HeroUiButton(
    label: label,
    onPressed: onChanged == null ? null : () => onChanged!(!selected),
    size: size,
    leading: leading,
    trailing: trailing,
    iconOnly: iconOnly,
    variant: _toggleVariant(selected, variant),
  );
}

class HeroUiToggleButtonGroup<T> extends StatelessWidget {
  const HeroUiToggleButtonGroup({
    required this.options,
    required this.value,
    required this.onChanged,
    super.key,
    this.size = HeroUiButtonSize.md,
    this.variant = HeroUiToggleButtonVariant.defaultVariant,
    this.orientation = HeroUiButtonGroupOrientation.horizontal,
    this.width = HeroUiButtonGroupWidth.hug,
    this.isAttached = true,
    this.spacing = 4,
  });
  final List<HeroUiToggleOption<T>> options;
  final T? value;
  final ValueChanged<T>? onChanged;
  final HeroUiButtonSize size;
  final HeroUiToggleButtonVariant variant;
  final HeroUiButtonGroupOrientation orientation;
  final HeroUiButtonGroupWidth width;
  final bool isAttached;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final selectedIndex = options.indexWhere((option) => option.value == value);
    final hiddenDividerIndices = <int>{};
    if (selectedIndex != -1) {
      if (selectedIndex > 0) {
        hiddenDividerIndices.add(selectedIndex);
      }
      if (selectedIndex < options.length - 1) {
        hiddenDividerIndices.add(selectedIndex + 1);
      }
    }

    return HeroUiButtonGroup(
      size: size,
      variant: _toggleBaseVariant(variant),
      orientation: orientation,
      width: width,
      spacing: spacing,
      attached: isAttached,
      hiddenDividerIndices: hiddenDividerIndices,
      items: [
        for (final option in options)
          HeroUiButtonGroupItem(
            label: option.label,
            onPressed: onChanged == null
                ? null
                : () => onChanged!(option.value),
            leading: option.icon,
            trailing: option.trailing,
            iconOnly: option.iconOnly,
            variant: _toggleVariant(value == option.value, variant),
          ),
      ],
    );
  }
}
