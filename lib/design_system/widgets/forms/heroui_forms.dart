import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/icons/heroui_icon.dart';

// ─── Enums ──────────────────────────────────────────────────────────────────
enum HeroUiInputVariant { primary, secondary }

enum HeroUiInputType { text, number, password }

enum HeroUiInputAffixTone { active, mute }

// ─── Design Tokens ──────────────────────────────────────────────────────────
// Figma "shadow-field" – light theme only; dark mode has no shadow
const List<BoxShadow> _kFieldShadow = [
  BoxShadow(color: Color(0x0F000000), blurRadius: 1, offset: Offset(0, 1)),
];

// Figma "focus-ring-field": 0px 0px 0px 2px rgba(4,133,247,1)
const Color _kFocusRingColor = Color(0xFF0485F7);

// Figma error #FF383C
const Color _kDanger = Color(0xFFFF383C);

// ── Light theme fills ────────────────────────────────────────────────────────
const Color _kFillPrimary = Color(0xFFFFFFFF);
const Color _kFillSecondary = Color(0xFFEBEBEC);

// ── Dark theme fills ─────────────────────────────────────────────────────────
const Color _kDarkFillPrimary = Color(0xFF27272A);
const Color _kDarkFillSecondary = Color(0xFF3F3F46);

// ── Text / icon colours ──────────────────────────────────────────────────────
// Figma placeholder / muted
const Color _kMuted = Color(0xFF71717A);
const Color _kDarkMuted = Color(0xFFA1A1AA);
// Figma foreground light
const Color _kForeground = Color(0xFF18181B);
// Figma foreground dark
const Color _kDarkForeground = Color(0xFFFCFCFC);

// ─── Text Styles ─────────────────────────────────────────────────────────────
// Figma "Body sm medium" – 14px / w500 / 1.43 lh
const TextStyle _kLabelStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w500,
  height: 1.43,
);

// Figma "Body xs" – 12px / w400 / 1.34 lh
const TextStyle _kBodyXsStyle = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w400,
  height: 1.34,
);

// Figma "Text field sm" – 14px / w400 / 1.43 lh (colour set at runtime)
const TextStyle _kInputTextStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w400,
  height: 1.43,
);

// Figma Link sm – 14px / w500 / 1.29 lh.
const TextStyle _kLinkSmStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w500,
  height: 1.286,
);

// Figma InputOTP value styles.
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

// ─── Runtime helpers ─────────────────────────────────────────────────────────
bool _isDark(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark;

Color _fillColor(BuildContext context, HeroUiInputVariant variant) =>
    _isDark(context)
    ? (variant == HeroUiInputVariant.primary
          ? _kDarkFillPrimary
          : _kDarkFillSecondary)
    : (variant == HeroUiInputVariant.primary ? _kFillPrimary : _kFillSecondary);

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

// Returns inner field decoration.
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
      // Keep space for an external focus ring in all states.
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

// ─── Form ─────────────────────────────────────────────────────────────────────
class HeroUiForm extends StatelessWidget {
  const HeroUiForm({
    required this.child,
    super.key,
    this.formKey,
    this.autovalidateMode = AutovalidateMode.disabled,
  });

  final Widget child;
  final GlobalKey<FormState>? formKey;
  final AutovalidateMode autovalidateMode;

  @override
  Widget build(BuildContext context) {
    return Form(key: formKey, autovalidateMode: autovalidateMode, child: child);
  }
}

// ─── Fieldset ─────────────────────────────────────────────────────────────────
class HeroUiFieldset extends StatelessWidget {
  const HeroUiFieldset({
    required this.children,
    super.key,
    this.legend,
    this.description,
    this.padding = const EdgeInsets.all(16),
  });

  final String? legend;
  final String? description;
  final List<Widget> children;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        border: Border.all(color: scheme.outlineVariant),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (legend != null) HeroUiLabel(legend!),
            if (description != null) ...[
              const SizedBox(height: 4),
              HeroUiDescription(description!),
            ],
            if (children.isNotEmpty) ...[
              if (legend != null || description != null)
                const SizedBox(height: 12),
              ..._withVerticalSpacing(children, 12),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Label ────────────────────────────────────────────────────────────────────
// Figma: row, gap 4px, Body sm medium (#18181B), asterisk (#FF383C)
class HeroUiLabel extends StatelessWidget {
  const HeroUiLabel(this.text, {super.key, this.requiredField = false});

  final String text;
  final bool requiredField;

  @override
  Widget build(BuildContext context) {
    final textColor = _textColor(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(text, style: _kLabelStyle.copyWith(color: textColor)),
        if (requiredField) ...[
          const SizedBox(width: 4),
          Text('*', style: _kLabelStyle.copyWith(color: _kDanger)),
        ],
      ],
    );
  }
}

// ─── Description ─────────────────────────────────────────────────────────────
// Figma: Body xs (#71717A)
class HeroUiDescription extends StatelessWidget {
  const HeroUiDescription(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: _kBodyXsStyle.copyWith(color: _kMuted));
  }
}

// ─── ErrorMessage ─────────────────────────────────────────────────────────────
// Figma: Body xs (#FF383C)
class HeroUiErrorMessage extends StatelessWidget {
  const HeroUiErrorMessage(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: _kBodyXsStyle.copyWith(color: _kDanger));
  }
}

// ─── FieldError ───────────────────────────────────────────────────────────────
class HeroUiFieldError extends StatelessWidget {
  const HeroUiFieldError({required this.child, super.key, this.errorText});

  final Widget child;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        child,
        if (errorText != null && errorText!.trim().isNotEmpty) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: HeroUiErrorMessage(errorText!),
          ),
        ],
      ],
    );
  }
}

// ─── Input ────────────────────────────────────────────────────────────────────
// Figma Input (base):
//   primary : white fill + shadow-field, transparent border
//   secondary: #EBEBEC fill, no shadow, transparent border
//   border-radius: 12px   padding: 8px 12px   gap: 6px
//   focus  → 0 0 0 2px rgba(4,133,247,1)
//   error  → 1px #FF383C border
//   disabled → opacity 0.5
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

    // Figma: 8px vertical / 12px horizontal.
    // When prefix/suffix icons are present their own padding supplies the gap,
    // so we zero the corresponding contentPadding side.
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
                // 12px from container edge + 6px gap to text = Figma spec
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
        // No fill / border in TextField — field shell handles everything.
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

// ─── TextField ───────────────────────────────────────────────────────────────
// Figma TextField: column gap 4px → Label + Input + description/error
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
      children: _withVerticalSpacing(items, 4),
    );
  }
}

// ─── TextArea ─────────────────────────────────────────────────────────────────
// Figma TextArea: same structure as TextField with multiline Input
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
      children: _withVerticalSpacing(items, 4),
    );
  }
}

// ─── InputGroup ───────────────────────────────────────────────────────────────
// Figma InputGroup: single input container with optional attached prefix/suffix
// affix panels (e.g. country code, dropdown trigger). The whole thing appears
// as one unified rounded container.
//   affix=none  → plain Input (no extra panels)
//   affix=prefix/suffix/both → side panel(s) merged with input
//   showDividers=true → vertical separator between panel and text area (gapSpace)
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
            HeroUiIconManifest.chevronDownRegular,
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
  // Backward compatible alias for Figma gapSpace variant.
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

    // Figma affix panel: padding 8px 12px, gap 6px.
    // Text area: 12px start when no prefix OR when dividers shown; 6px otherwise.
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

// ─── NumberField ──────────────────────────────────────────────────────────────
// Figma NumberField: Label + [−|value|+] container + description
// Uses InputGroup with affix=both, gapSpace=true (dividers shown)
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

// ─── SearchField ──────────────────────────────────────────────────────────────
// Figma SearchField: Label + Input(search icon prefix + clear button) + desc
// Has clear (×) button that appears when field has text (positioned at right)
class HeroUiSearchField extends StatefulWidget {
  const HeroUiSearchField({
    super.key,
    this.placeholder = 'Search...',
    this.label,
    this.description,
    this.variant = HeroUiInputVariant.primary,
    this.enabled = true,
    this.onChanged,
  });

  final String placeholder;
  final String? label;
  final String? description;
  final HeroUiInputVariant variant;
  final bool enabled;
  final ValueChanged<String>? onChanged;

  @override
  State<HeroUiSearchField> createState() => _HeroUiSearchFieldState();
}

class _HeroUiSearchFieldState extends State<HeroUiSearchField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChange);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChange);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onTextChange() =>
      setState(() => _hasText = _controller.text.isNotEmpty);

  void _clear() {
    _controller.clear();
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    final clearBtn = _hasText
        ? GestureDetector(
            onTap: _clear,
            child: const SizedBox(
              width: 20,
              height: 20,
              child: Icon(Icons.close_rounded, size: 14, color: _kMuted),
            ),
          )
        : null;

    final inputWidget = HeroUiInput(
      controller: _controller,
      focusNode: _focusNode,
      placeholder: widget.placeholder,
      variant: widget.variant,
      enabled: widget.enabled,
      description: widget.description,
      prefix: const Icon(Icons.search_rounded, size: 16, color: _kMuted),
      suffix: clearBtn,
      onChanged: (v) {
        widget.onChanged?.call(v);
      },
    );

    final items = <Widget>[
      if (widget.label != null) HeroUiLabel(widget.label!),
      inputWidget,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: _withVerticalSpacing(items, 4),
    );
  }
}

// ─── InputOTP ─────────────────────────────────────────────────────────────────
// Figma InputOTP supports:
// - label + optional top description
// - 4/6/.. digit cells (fixed width)
// - optional middle separator
// - helper text + optional resend link
// - error state (red border/text)
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

    final cells = <Widget>[];
    for (var i = 0; i < widget.length; i++) {
      if (i > 0) {
        cells.add(const SizedBox(width: 8));
      }
      if (_shouldShowSeparator && i == _effectiveSeparatorIndex) {
        cells.add(_OtpSeparator(color: muted));
        cells.add(const SizedBox(width: 8));
      }
      cells.add(
        SizedBox(
          width: _kOtpCellWidth,
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
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                child: Text(
                  widget.description!,
                  style: _kInputTextStyle.copyWith(color: muted),
                ),
              ),
          ],
        ),
      Align(
        alignment: Alignment.centerLeft,
        child: Row(mainAxisSize: MainAxisSize.min, children: cells),
      ),
      if (hasHelper || showLink)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
          child: Wrap(
            spacing: 5,
            runSpacing: 4,
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
      children: _withVerticalSpacing(items, 4),
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
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          enabled: enabled,
          autofocus: autofocus,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: valueStyle,
          decoration: const InputDecoration(
            counterText: '',
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
        borderRadius: BorderRadius.circular(4),
      ),
      child: const SizedBox(width: 6, height: 2),
    );
  }
}

// ─── Helpers ─────────────────────────────────────────────────────────────────
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
