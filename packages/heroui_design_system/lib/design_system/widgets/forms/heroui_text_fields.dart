part of 'heroui_forms.dart';

class HeroUiTextField extends StatelessWidget {
  const HeroUiTextField({
    super.key,
    this.controller,
    this.placeholder,
    this.label,
    this.requiredField = false,
    this.variant = HeroUiInputVariant.primary,
    this.errorText,
    this.description,
    this.prefix,
    this.suffix,
    this.onChanged,
    this.enabled = true,
  });

  final TextEditingController? controller;
  final String? placeholder;
  final String? label;
  final bool requiredField;
  final HeroUiInputVariant variant;
  final String? errorText;
  final String? description;
  final Widget? prefix;
  final Widget? suffix;
  final ValueChanged<String>? onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      if (label != null) HeroUiLabel(label!, requiredField: requiredField),
      HeroUiInput(
        controller: controller,
        placeholder: placeholder,
        variant: variant,
        errorText: errorText,
        description: description,
        prefix: prefix,
        suffix: suffix,
        onChanged: onChanged,
        enabled: enabled,
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: _withVerticalSpacing(items, 5),
    );
  }
}

class HeroUiTextArea extends StatelessWidget {
  const HeroUiTextArea({
    super.key,
    this.controller,
    this.placeholder,
    this.label,
    this.requiredField = false,
    this.variant = HeroUiInputVariant.primary,
    this.errorText,
    this.description,
    this.minLines = 4,
    this.maxLines = 6,
    this.enabled = true,
    this.onChanged,
  });

  final TextEditingController? controller;
  final String? placeholder;
  final String? label;
  final bool requiredField;
  final HeroUiInputVariant variant;
  final String? errorText;
  final String? description;
  final int minLines;
  final int maxLines;
  final bool enabled;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      if (label != null) HeroUiLabel(label!, requiredField: requiredField),
      HeroUiInput(
        controller: controller,
        placeholder: placeholder,
        variant: variant,
        type: HeroUiInputType.text,
        errorText: errorText,
        description: description,
        minLines: minLines,
        maxLines: maxLines,
        enabled: enabled,
        onChanged: onChanged,
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: _withVerticalSpacing(items, 5),
    );
  }
}
