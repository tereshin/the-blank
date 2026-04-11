part of 'heroui_forms.dart';

const double _kOtpCellGap = 10;
const double _kOtpSeparatorWidth = 8;
const double _kOtpMinCellWidth = 32;

class HeroUiInputOtp extends StatefulWidget {
  const HeroUiInputOtp({
    super.key,
    this.length = 6,
    this.variant = HeroUiInputVariant.primary,
    this.onChanged,
    this.onCompleted,
    this.label,
    this.requiredField = false,
    this.description,
    this.helperText,
    this.linkText,
    this.onLinkTap,
    this.showSeparator = false,
    this.separatorIndex,
    this.errorText,
    this.enabled = true,
    this.autofocus = false,
  }) : assert(length > 1, 'OTP length must be greater than 1'),
       assert(
         separatorIndex == null ||
             (separatorIndex > 0 && separatorIndex < length),
         'separatorIndex must be between 1 and length-1',
       );

  final int length;
  final HeroUiInputVariant variant;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;
  final String? label;
  final bool requiredField;
  final String? description;
  final String? helperText;
  final String? linkText;
  final VoidCallback? onLinkTap;
  final bool showSeparator;
  final int? separatorIndex;
  final String? errorText;
  final bool enabled;
  final bool autofocus;

  @override
  State<HeroUiInputOtp> createState() => _HeroUiInputOtpState();
}

class _HeroUiInputOtpState extends State<HeroUiInputOtp> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  late List<VoidCallback> _focusListeners;
  late List<bool> _focused;

  @override
  void initState() {
    super.initState();
    _initFields();
  }

  @override
  void didUpdateWidget(covariant HeroUiInputOtp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.length != widget.length) {
      _disposeFields();
      _initFields();
    }
  }

  void _initFields() {
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
    _focused = List.filled(widget.length, false);
    _focusListeners = List.generate(widget.length, (index) {
      return () {
        if (!mounted) return;
        setState(() => _focused[index] = _focusNodes[index].hasFocus);
      };
    });

    for (var i = 0; i < widget.length; i++) {
      _focusNodes[i].addListener(_focusListeners[i]);
    }
  }

  void _disposeFields() {
    for (var i = 0; i < _focusNodes.length; i++) {
      _focusNodes[i].removeListener(_focusListeners[i]);
    }
    for (final c in _controllers) {
      c.dispose();
    }
    for (final n in _focusNodes) {
      n.dispose();
    }
  }

  @override
  void dispose() {
    _disposeFields();
    super.dispose();
  }

  void _emitValue() {
    final code = _controllers.map((c) => c.text).join();
    widget.onChanged?.call(code);
    if (_controllers.every((controller) => controller.text.isNotEmpty)) {
      widget.onCompleted?.call(code);
    }
  }

  void _setCellValue(int index, String value) {
    if (_controllers[index].text != value) {
      _controllers[index].text = value;
    }
    _controllers[index].selection = TextSelection.collapsed(
      offset: value.length,
    );
  }

  void _handleChanged(int index, String rawValue) {
    final digitsOnly = rawValue.replaceAll(RegExp(r'[^0-9]'), '');

    if (digitsOnly.isEmpty) {
      _setCellValue(index, '');
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
      _emitValue();
      return;
    }

    if (digitsOnly.length == 1) {
      _setCellValue(index, digitsOnly);
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
      _emitValue();
      return;
    }

    var writeIndex = index;
    for (final char in digitsOnly.split('')) {
      if (writeIndex >= widget.length) break;
      _setCellValue(writeIndex, char);
      writeIndex++;
    }

    if (writeIndex < widget.length) {
      _focusNodes[writeIndex].requestFocus();
    } else {
      _focusNodes.last.unfocus();
    }
    _emitValue();
  }

  KeyEventResult _handleKeyEvent(int index, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    if (event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _setCellValue(index - 1, '');
      _focusNodes[index - 1].requestFocus();
      _emitValue();
      return KeyEventResult.handled;
    }

    if (event.logicalKey == LogicalKeyboardKey.arrowLeft && index > 0) {
      _focusNodes[index - 1].requestFocus();
      return KeyEventResult.handled;
    }

    if (event.logicalKey == LogicalKeyboardKey.arrowRight &&
        index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  int get _effectiveSeparatorIndex =>
      widget.separatorIndex ?? (widget.length ~/ 2);

  bool get _shouldShowSeparator =>
      widget.showSeparator &&
      _effectiveSeparatorIndex > 0 &&
      _effectiveSeparatorIndex < widget.length;

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText?.trim().isNotEmpty == true;
    final hasTopDescription = widget.description?.trim().isNotEmpty == true;
    final helperText = hasError
        ? widget.errorText?.trim()
        : widget.helperText?.trim();
    final hasHelper = helperText?.isNotEmpty == true;
    final linkText = widget.linkText?.trim();
    final showLink = !hasError && linkText?.isNotEmpty == true;
    final muted = _mutedColor(context);
    final fg = _textColor(context);

    final items = <Widget>[
      if (widget.label != null || hasTopDescription)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.label != null)
              HeroUiLabel(widget.label!, requiredField: widget.requiredField),
            if (hasTopDescription)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
                child: Text(
                  widget.description!,
                  style: _kInputTextStyle.copyWith(color: muted),
                ),
              ),
          ],
        ),
      LayoutBuilder(
        builder: (context, constraints) {
          final gapCount = widget.length > 1 ? widget.length - 1 : 0;
          final separatorExtraWidth = _shouldShowSeparator
              ? (_kOtpSeparatorWidth + _kOtpCellGap)
              : 0.0;
          final fixedWidth = (gapCount * _kOtpCellGap) + separatorExtraWidth;
          final maxWidth = constraints.maxWidth;
          var cellWidth = _kOtpCellWidth;
          if (maxWidth.isFinite && maxWidth > 0) {
            final fittedWidth = ((maxWidth - fixedWidth) / widget.length)
                .floorToDouble();
            cellWidth = fittedWidth.clamp(_kOtpMinCellWidth, _kOtpCellWidth);
          }

          final rowWidth = (widget.length * cellWidth) + fixedWidth;
          final needsScroll = maxWidth.isFinite && rowWidth > maxWidth + 0.5;

          final cells = <Widget>[];
          for (var i = 0; i < widget.length; i++) {
            if (i > 0) {
              cells.add(const SizedBox(width: _kOtpCellGap));
            }
            if (_shouldShowSeparator && i == _effectiveSeparatorIndex) {
              cells.add(_OtpSeparator(color: muted));
              cells.add(const SizedBox(width: _kOtpCellGap));
            }
            cells.add(
              SizedBox(
                width: cellWidth,
                child: _OtpCell(
                  controller: _controllers[i],
                  focusNode: _focusNodes[i],
                  isFocused: _focused[i],
                  variant: widget.variant,
                  hasError: hasError,
                  enabled: widget.enabled,
                  autofocus: widget.autofocus && i == 0,
                  onChanged: (value) => _handleChanged(i, value),
                  onKeyEvent: (event) => _handleKeyEvent(i, event),
                ),
              ),
            );
          }

          final row = Row(mainAxisSize: MainAxisSize.min, children: cells);
          if (!needsScroll) {
            return Align(alignment: Alignment.centerLeft, child: row);
          }
          return Align(
            alignment: Alignment.centerLeft,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: row,
            ),
          );
        },
      ),
      if (hasHelper || showLink)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
          child: Wrap(
            spacing: 7,
            runSpacing: 5,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (hasHelper)
                Text(
                  helperText!,
                  style: _kInputTextStyle.copyWith(
                    color: hasError ? _kDanger : muted,
                  ),
                ),
              if (showLink)
                MouseRegion(
                  cursor: widget.onLinkTap != null
                      ? SystemMouseCursors.click
                      : MouseCursor.defer,
                  child: GestureDetector(
                    onTap: widget.onLinkTap,
                    behavior: HitTestBehavior.opaque,
                    child: Text(
                      linkText!,
                      style: _kLinkSmStyle.copyWith(color: fg),
                    ),
                  ),
                ),
            ],
          ),
        ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: _withVerticalSpacing(items, 5),
    );
  }
}

class _OtpCell extends StatelessWidget {
  const _OtpCell({
    required this.controller,
    required this.focusNode,
    required this.isFocused,
    required this.variant,
    required this.hasError,
    required this.enabled,
    required this.autofocus,
    required this.onChanged,
    required this.onKeyEvent,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isFocused;
  final HeroUiInputVariant variant;
  final bool hasError;
  final bool enabled;
  final bool autofocus;
  final ValueChanged<String> onChanged;
  final KeyEventResult Function(KeyEvent event) onKeyEvent;

  @override
  Widget build(BuildContext context) {
    final Color fg = _textColor(context);
    final valueStyle = (hasError ? _kOtpValueErrorStyle : _kOtpValueStyle)
        .copyWith(color: fg);
    return _AnimatedFieldSurface(
      variant: variant,
      isFocused: isFocused,
      hasError: hasError,
      enabled: enabled,
      child: Focus(
        onKeyEvent: (_, event) => onKeyEvent(event),
        child: SizedBox(
          width: double.infinity,
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            enabled: enabled,
            autofocus: autofocus,
            textAlign: TextAlign.center,
            textAlignVertical: TextAlignVertical.center,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: valueStyle,
            decoration: const InputDecoration(
              counterText: '',
              isDense: true,
              contentPadding: EdgeInsets.fromLTRB(4, 10, 0, 10),
              filled: false,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
            ),
            onTap: () {
              controller.selection = TextSelection(
                baseOffset: 0,
                extentOffset: controller.text.length,
              );
            },
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}

class _OtpSeparator extends StatelessWidget {
  const _OtpSeparator({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
      child: const SizedBox(width: _kOtpSeparatorWidth, height: 3),
    );
  }
}
