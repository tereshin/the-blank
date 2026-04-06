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
  int _second = 0;
  bool _isPicking = false;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
    _second = 0;
  }

  Future<void> _pickTime() async {
    if (!widget.enabled || _isPicking) return;
    setState(() => _isPicking = true);

    final selection = await showModalBottomSheet<_TimeSelection>(
      context: context,
      backgroundColor: Colors.transparent,
      elevation: 0,
      isScrollControlled: true,
      useSafeArea: false,
      barrierColor: Colors.black.withValues(alpha: 0.48),
      builder: (sheetContext) => _CalendarBottomSheetShell(
        title: 'Select time',
        child: _TimePickerBottomSheet(
          initialTime: _value ?? widget.initialValue ?? TimeOfDay.now(),
          initialSecond: _second,
          show12hr: widget.show12hr,
          showSeconds: widget.showSeconds,
        ),
      ),
    );

    if (!mounted) return;
    if (selection == null) {
      setState(() => _isPicking = false);
      return;
    }
    setState(() {
      _value = selection.time;
      _second = selection.second;
      _isPicking = false;
    });
    widget.onChanged?.call(selection.time);
  }

  @override
  Widget build(BuildContext context) {
    final valueText = _value == null
        ? null
        : _formatTime(
            _value!,
            show12hr: widget.show12hr,
            showSeconds: widget.showSeconds,
            seconds: _second,
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
      suffix: _FieldSuffix(
        isOpen: _isPicking,
        iconName: HeroUiIconManifest.clock,
      ),
    );
  }
}

class _TimePickerBottomSheet extends StatefulWidget {
  const _TimePickerBottomSheet({
    required this.initialTime,
    required this.initialSecond,
    required this.show12hr,
    required this.showSeconds,
  });

  final TimeOfDay initialTime;
  final int initialSecond;
  final bool show12hr;
  final bool showSeconds;

  @override
  State<_TimePickerBottomSheet> createState() => _TimePickerBottomSheetState();
}

class _TimePickerBottomSheetState extends State<_TimePickerBottomSheet> {
  late int _hour;
  late int _minute;
  late int _second;
  late DayPeriod _period;
  late final TextEditingController _hourController;
  late final TextEditingController _minuteController;
  late final TextEditingController _secondController;

  @override
  void initState() {
    super.initState();
    _minute = widget.initialTime.minute;
    _second = _bound(widget.initialSecond, 0, 59);
    if (widget.show12hr) {
      _hour = widget.initialTime.hourOfPeriod == 0
          ? 12
          : widget.initialTime.hourOfPeriod;
      _period = widget.initialTime.period;
    } else {
      _hour = widget.initialTime.hour;
      _period = DayPeriod.am;
    }

    _hourController = TextEditingController(text: _hour.toString());
    _minuteController = TextEditingController(text: _minute.toString());
    _secondController = TextEditingController(text: _second.toString());
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    _secondController.dispose();
    super.dispose();
  }

  int _bound(int value, int min, int max) {
    if (value < min) return min;
    if (value > max) return max;
    return value;
  }

  String _digitsOnly(String value) => value.replaceAll(RegExp(r'[^0-9]'), '');

  void _replaceControllerValue(TextEditingController controller, String value) {
    controller.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }

  int _parseOrDefault(String value, int fallback) {
    final parsed = int.tryParse(_digitsOnly(value));
    return parsed ?? fallback;
  }

  void _onHourChanged(String value) {
    final digits = _digitsOnly(value);
    if (digits != value) {
      _replaceControllerValue(_hourController, digits);
    }
    if (digits.isEmpty) return;
    final parsed = int.tryParse(digits);
    if (parsed == null) return;
    setState(() => _hour = parsed);
  }

  void _onMinuteChanged(String value) {
    final digits = _digitsOnly(value);
    if (digits != value) {
      _replaceControllerValue(_minuteController, digits);
    }
    if (digits.isEmpty) return;
    final parsed = int.tryParse(digits);
    if (parsed == null) return;
    setState(() => _minute = parsed);
  }

  void _onSecondChanged(String value) {
    final digits = _digitsOnly(value);
    if (digits != value) {
      _replaceControllerValue(_secondController, digits);
    }
    if (digits.isEmpty) return;
    final parsed = int.tryParse(digits);
    if (parsed == null) return;
    setState(() => _second = parsed);
  }

  int _to24Hour(int hour, DayPeriod period) {
    final normalizedHour = _bound(hour, 1, 12);
    if (period == DayPeriod.am) {
      return normalizedHour == 12 ? 0 : normalizedHour;
    }
    return normalizedHour == 12 ? 12 : normalizedHour + 12;
  }

  _TimeSelection _buildSelection() {
    final typedHour = _parseOrDefault(_hourController.text, _hour);
    final typedMinute = _parseOrDefault(_minuteController.text, _minute);
    final typedSecond = _parseOrDefault(_secondController.text, _second);
    final hour = widget.show12hr
        ? _to24Hour(typedHour, _period)
        : _bound(typedHour, 0, 23);
    final minute = _bound(typedMinute, 0, 59);
    final second = _bound(typedSecond, 0, 59);
    return _TimeSelection(
      time: TimeOfDay(hour: hour, minute: minute),
      second: second,
    );
  }

  Widget _numericInput({
    required String label,
    required TextEditingController controller,
    required ValueChanged<String> onChanged,
    required String placeholder,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeroUiLabel(label),
        const SizedBox(height: 4),
        HeroUiInput(
          controller: controller,
          placeholder: placeholder,
          variant: HeroUiInputVariant.secondary,
          type: HeroUiInputType.number,
          onChanged: onChanged,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final hourLabel = widget.show12hr ? 'Hour (1-12)' : 'Hour (0-23)';
    final periodValue = widget.show12hr ? _period : null;

    return SizedBox(
      width: 360,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _numericInput(
                  label: hourLabel,
                  controller: _hourController,
                  onChanged: _onHourChanged,
                  placeholder: widget.show12hr ? '12' : '23',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _numericInput(
                  label: 'Minute',
                  controller: _minuteController,
                  onChanged: _onMinuteChanged,
                  placeholder: '59',
                ),
              ),
              if (widget.showSeconds) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: _numericInput(
                    label: 'Second',
                    controller: _secondController,
                    onChanged: _onSecondChanged,
                    placeholder: '59',
                  ),
                ),
              ],
            ],
          ),
          if (widget.show12hr) ...[
            const SizedBox(height: 12),
            HeroUiToggleButtonGroup<DayPeriod>(
              value: periodValue,
              options: const [
                HeroUiToggleOption(value: DayPeriod.am, label: 'AM'),
                HeroUiToggleOption(value: DayPeriod.pm, label: 'PM'),
              ],
              variant: HeroUiToggleButtonVariant.ghost,
              size: HeroUiButtonSize.sm,
              isAttached: false,
              onChanged: (value) => setState(() => _period = value),
            ),
          ],
          const SizedBox(height: 16),
          HeroUiButton(
            label: 'Apply',
            variant: HeroUiButtonVariant.primary,
            onPressed: () => Navigator.of(context).pop(_buildSelection()),
            size: HeroUiButtonSize.lg,
          ),
        ],
      ),
    );
  }
}

class _TimeSelection {
  const _TimeSelection({required this.time, required this.second});

  final TimeOfDay time;
  final int second;
}
