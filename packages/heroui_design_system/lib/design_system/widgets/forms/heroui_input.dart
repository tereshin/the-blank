part of 'heroui_forms.dart';

class HeroUiInput extends StatefulWidget {
  const HeroUiInput({
    super.key,
    this.controller,
    this.placeholder,
    this.variant = HeroUiInputVariant.primary,
    this.type = HeroUiInputType.text,
    this.enabled = true,
    this.errorText,
    this.description,
    this.prefix,
    this.suffix,
    this.focusNode,
    this.onChanged,
    this.maxLines = 1,
    this.minLines = 1,
  });

  final TextEditingController? controller;
  final String? placeholder;
  final HeroUiInputVariant variant;
  final HeroUiInputType type;
  final bool enabled;
  final String? errorText;
  final String? description;
  final Widget? prefix;
  final Widget? suffix;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final int? maxLines;
  final int? minLines;

  @override
  State<HeroUiInput> createState() => _HeroUiInputState();
}

class _HeroUiInputState extends State<HeroUiInput> {
  late final FocusNode _focusNode;
  bool _isFocused = false;
  bool _ownsNode = false;

  @override
  void initState() {
    super.initState();
    if (widget.focusNode != null) {
      _focusNode = widget.focusNode!;
    } else {
      _focusNode = FocusNode();
      _ownsNode = true;
    }
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    if (_ownsNode) _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() => setState(() => _isFocused = _focusNode.hasFocus);

  @override
  Widget build(BuildContext context) {
    final bool hasError = widget.errorText?.trim().isNotEmpty == true;
    final bool hasDescription = widget.description?.trim().isNotEmpty == true;
    final Color fg = _textColor(context);

    final contentPadding = EdgeInsetsDirectional.fromSTEB(
      widget.prefix == null ? 12.0 : 0.0,
      8.0,
      widget.suffix == null ? 12.0 : 0.0,
      8.0,
    );

    final Widget tf = TextField(
      controller: widget.controller,
      focusNode: _focusNode,
      onChanged: widget.onChanged,
      enabled: widget.enabled,
      keyboardType: _keyboardType(widget.type, widget.maxLines),
      textInputAction: widget.maxLines == 1
          ? TextInputAction.done
          : TextInputAction.newline,
      obscureText: widget.type == HeroUiInputType.password,
      maxLines: widget.type == HeroUiInputType.password ? 1 : widget.maxLines,
      minLines: widget.type == HeroUiInputType.password ? 1 : widget.minLines,
      style: _kInputTextStyle.copyWith(color: fg),
      decoration: InputDecoration(
        hintText: widget.placeholder,
        hintStyle: _kInputTextStyle.copyWith(color: _mutedColor(context)),
        isDense: true,
        prefixIcon: widget.prefix == null
            ? null
            : Padding(
                padding: const EdgeInsetsDirectional.only(start: 12, end: 6),
                child: widget.prefix,
              ),
        prefixIconConstraints: const BoxConstraints(
          minHeight: 20,
          minWidth: 20,
        ),
        suffixIcon: widget.suffix == null
            ? null
            : Padding(
                padding: const EdgeInsetsDirectional.only(start: 6, end: 12),
                child: widget.suffix,
              ),
        suffixIconConstraints: const BoxConstraints(
          minHeight: 20,
          minWidth: 20,
        ),
        contentPadding: contentPadding,
        filled: false,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
      ),
    );

    Widget inputWidget = _AnimatedFieldSurface(
      variant: widget.variant,
      isFocused: _isFocused,
      hasError: hasError,
      enabled: widget.enabled,
      child: tf,
    );

    if (hasError || hasDescription) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          inputWidget,
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: hasError
                ? HeroUiErrorMessage(widget.errorText!)
                : HeroUiDescription(widget.description!),
          ),
        ],
      );
    }
    return inputWidget;
  }
}
