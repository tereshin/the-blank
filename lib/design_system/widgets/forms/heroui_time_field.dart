part of 'heroui_date_time.dart';

/// HeroUI TimeField.
class HeroUiTimeField extends StatefulWidget {
  const HeroUiTimeField({
    super.key,
    this.label,
    this.description,
    this.errorText,
    this.placeholder = 'HH:MM',
    this.variant = HeroUiInputVariant.primary,
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
  final HeroUiInputVariant variant;
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
      variant: widget.variant,
      enabled: widget.enabled,
      isFocused: _isPicking,
      valueText: valueText,
      placeholder: widget.placeholder,
      onTap: _pickTime,
      suffix: _FieldSuffix(isOpen: _isPicking),
    );
  }
}
