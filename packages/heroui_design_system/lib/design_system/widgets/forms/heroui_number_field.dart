part of 'heroui_forms.dart';

class HeroUiNumberField extends StatefulWidget {
  const HeroUiNumberField({
    super.key,
    this.initialValue = 0,
    this.variant = HeroUiInputVariant.primary,
    this.onChanged,
    this.min,
    this.max,
    this.step = 1,
    this.label,
    this.description,
    this.enabled = true,
  });

  final int initialValue;
  final HeroUiInputVariant variant;
  final ValueChanged<int>? onChanged;
  final int? min;
  final int? max;
  final int step;
  final String? label;
  final String? description;
  final bool enabled;

  @override
  State<HeroUiNumberField> createState() => _HeroUiNumberFieldState();
}

class _HeroUiNumberFieldState extends State<HeroUiNumberField> {
  late int _value = widget.initialValue;
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialValue.toString(),
  );
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onFocusChange() => setState(() => _isFocused = _focusNode.hasFocus);

  void _updateValue(int next) {
    var v = next;
    if (widget.min != null) v = v < widget.min! ? widget.min! : v;
    if (widget.max != null) v = v > widget.max! ? widget.max! : v;
    setState(() {
      _value = v;
      _controller.text = v.toString();
    });
    widget.onChanged?.call(v);
  }

  Widget _stepBtn(
    IconData icon,
    VoidCallback onTap, {
    required Color iconColor,
  }) {
    return GestureDetector(
      onTap: widget.enabled ? onTap : null,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 40,
        height: 36,
        child: Icon(icon, size: 16, color: iconColor),
      ),
    );
  }

  Widget _divider(BuildContext context) =>
      Container(width: 1, height: 36, color: _inputAffixDividerColor(context));

  @override
  Widget build(BuildContext context) {
    final Color fg = _textColor(context);

    final btnColor = widget.enabled ? fg : _mutedColor(context);
    final container = _AnimatedFieldSurface(
      variant: widget.variant,
      isFocused: _isFocused,
      hasError: false,
      enabled: widget.enabled,
      child: Row(
        children: [
          _stepBtn(
            Icons.remove_rounded,
            () => _updateValue(_value - widget.step),
            iconColor: btnColor,
          ),
          _divider(context),
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              enabled: widget.enabled,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: _kInputTextStyle.copyWith(color: fg),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
                hintStyle: _kInputTextStyle.copyWith(
                  color: _mutedColor(context),
                ),
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              onChanged: (value) {
                final parsed = int.tryParse(value);
                if (parsed != null) _updateValue(parsed);
              },
            ),
          ),
          _divider(context),
          _stepBtn(
            Icons.add_rounded,
            () => _updateValue(_value + widget.step),
            iconColor: btnColor,
          ),
        ],
      ),
    );

    final items = <Widget>[
      if (widget.label != null) HeroUiLabel(widget.label!),
      container,
      if (widget.description?.isNotEmpty == true)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: HeroUiDescription(widget.description!),
        ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: _withVerticalSpacing(items, 4),
    );
  }
}
