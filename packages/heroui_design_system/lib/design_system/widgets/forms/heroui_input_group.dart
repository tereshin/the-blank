part of 'heroui_forms.dart';

class HeroUiInputAffix extends StatelessWidget {
  const HeroUiInputAffix({
    super.key,
    this.iconName,
    this.content,
    this.showIcon = true,
    this.showContent = true,
    this.showArrow = false,
    this.showContainerGroup = false,
    this.tone = HeroUiInputAffixTone.active,
    this.child,
  });

  final String? iconName;
  final String? content;
  final bool showIcon;
  final bool showContent;
  final bool showArrow;
  final bool showContainerGroup;
  final HeroUiInputAffixTone tone;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final toneColor = _inputAffixToneColor(context, tone);
    final hasContent = showContent && content?.trim().isNotEmpty == true;
    final hasGroupContent = child != null || hasContent || showArrow;

    final groupChildren = <Widget>[
      if (child != null)
        child!
      else ...[
        if (hasContent)
          Text(content!, style: _kInputTextStyle.copyWith(color: toneColor)),
        if (showArrow)
          HeroUiIcon(
            HeroUiIconManifest.chevronDown,
            size: 12,
            color: toneColor,
          ),
      ],
    ];

    final affixChildren = <Widget>[
      if (showIcon && iconName != null)
        HeroUiIcon(iconName!, size: 16, color: toneColor),
      if (hasGroupContent)
        if (showContainerGroup && child == null)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: _withHorizontalSpacing(groupChildren, 4),
          )
        else
          ...groupChildren,
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _withHorizontalSpacing(affixChildren, 4),
      ),
    );
  }
}

class HeroUiInputGroup extends StatefulWidget {
  const HeroUiInputGroup({
    required this.placeholder,
    super.key,
    this.controller,
    this.prefixAffix,
    this.suffixAffix,
    this.showDividers = false,
    this.gapSpace,
    this.variant = HeroUiInputVariant.primary,
    this.label,
    this.requiredField = false,
    this.errorText,
    this.description,
    this.onChanged,
    this.enabled = true,
    this.type = HeroUiInputType.text,
  });

  final TextEditingController? controller;
  final String placeholder;
  final Widget? prefixAffix;
  final Widget? suffixAffix;
  final bool showDividers;
  final bool? gapSpace;
  final HeroUiInputVariant variant;
  final String? label;
  final bool requiredField;
  final String? errorText;
  final String? description;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final HeroUiInputType type;

  @override
  State<HeroUiInputGroup> createState() => _HeroUiInputGroupState();
}

class _HeroUiInputGroupState extends State<HeroUiInputGroup> {
  late final FocusNode _focusNode = FocusNode();
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
    super.dispose();
  }

  void _onFocusChange() => setState(() => _isFocused = _focusNode.hasFocus);

  Widget _divider(BuildContext context) =>
      Container(width: 1, height: 36, color: _inputAffixDividerColor(context));

  Widget _affixShell(Widget affix) {
    if (affix is HeroUiInputAffix) return affix;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: affix,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool hasError = widget.errorText?.trim().isNotEmpty == true;
    final bool hasDescription = widget.description?.trim().isNotEmpty == true;
    final Color fg = _textColor(context);
    final showDividers = widget.gapSpace ?? widget.showDividers;

    final double textStart = widget.prefixAffix == null
        ? 12
        : showDividers
        ? 12
        : 6;
    final double textEnd = widget.suffixAffix == null
        ? 12
        : showDividers
        ? 12
        : 6;

    final container = _AnimatedFieldSurface(
      variant: widget.variant,
      isFocused: _isFocused,
      hasError: hasError,
      enabled: widget.enabled,
      child: Row(
        children: [
          if (widget.prefixAffix != null) ...[
            _affixShell(widget.prefixAffix!),
            if (showDividers) _divider(context),
          ],
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              onChanged: widget.onChanged,
              enabled: widget.enabled,
              keyboardType: _keyboardType(widget.type, 1),
              obscureText: widget.type == HeroUiInputType.password,
              style: _kInputTextStyle.copyWith(color: fg),
              decoration: InputDecoration(
                hintText: widget.placeholder,
                hintStyle: _kInputTextStyle.copyWith(
                  color: _mutedColor(context),
                ),
                isDense: true,
                contentPadding: EdgeInsetsDirectional.fromSTEB(
                  textStart,
                  8,
                  textEnd,
                  8,
                ),
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
          if (widget.suffixAffix != null) ...[
            if (showDividers) _divider(context),
            _affixShell(widget.suffixAffix!),
          ],
        ],
      ),
    );

    final items = <Widget>[
      if (widget.label != null)
        HeroUiLabel(widget.label!, requiredField: widget.requiredField),
      container,
      if (hasError || hasDescription)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: hasError
              ? HeroUiErrorMessage(widget.errorText!)
              : HeroUiDescription(widget.description!),
        ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: _withVerticalSpacing(items, 4),
    );
  }
}
