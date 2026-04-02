import 'dart:math' as math;

import 'package:flutter/material.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// SHARED INTERNAL HELPERS
// ═══════════════════════════════════════════════════════════════════════════════

const _kDropdownShadow = [
  BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.08),
    offset: Offset(0, 14),
    blurRadius: 28,
  ),
  BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.03),
    offset: Offset(0, -6),
    blurRadius: 12,
  ),
  BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.06),
    offset: Offset(0, 2),
    blurRadius: 8,
  ),
];

const _kFieldShadow = [
  BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.04),
    offset: Offset(0, 1),
    blurRadius: 2,
  ),
  BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.08),
    offset: Offset(0, 2),
    blurRadius: 4,
  ),
];

const Color _kFocusRingColor = Color(0xFF0485F7);
const Color _kDangerColor = Color(0xFFFF383C);

bool _isDark(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark;

Color _pickerFieldBg(BuildContext context) =>
    _isDark(context) ? const Color(0xFF18181B) : const Color(0xFFFFFFFF);

Color _pickerText(BuildContext context) =>
    _isDark(context) ? const Color(0xFFFCFCFC) : const Color(0xFF18181B);

Color _pickerMuted(BuildContext context) =>
    _isDark(context) ? const Color(0xFFA1A1AA) : const Color(0xFF71717A);

double _estimateDropdownHeight({
  required int itemCount,
  required double maxListHeight,
}) {
  final rows = itemCount <= 0 ? 1 : itemCount;
  final estimated = (rows * 40.0) + 8.0;
  return math.min(maxListHeight, estimated);
}

/// A single item in a picker dropdown.
class HeroUiPickerItem<T> {
  const HeroUiPickerItem({
    required this.value,
    required this.label,
    this.leading,
  });

  final T value;
  final String label;
  final Widget? leading;
}

/// Builds the dropdown list panel used by all pickers.
class _DropdownPanel extends StatelessWidget {
  const _DropdownPanel({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final bg = _pickerFieldBg(context);

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(24),
        boxShadow: _kDropdownShadow,
      ),
      padding: const EdgeInsets.all(4),
      child: Column(mainAxisSize: MainAxisSize.min, children: children),
    );
  }
}

/// A single item row in a dropdown panel.
class _DropdownItem extends StatefulWidget {
  const _DropdownItem({
    required this.label,
    required this.onTap,
    this.leading,
    this.isSelected = false,
  });

  final String label;
  final VoidCallback onTap;
  final Widget? leading;
  final bool isSelected;

  @override
  State<_DropdownItem> createState() => _DropdownItemState();
}

class _DropdownItemState extends State<_DropdownItem> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final textColor = _pickerText(context);
    final hoverColor = _isDark(context)
        ? const Color(0xFF3F3F46)
        : const Color(0xFFEFEFF0);
    final selectedColor = _isDark(context)
        ? const Color(0xFF3F3F46)
        : const Color(0xFFEFEFF0);

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? selectedColor
                : _hover
                ? hoverColor
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              if (widget.leading != null) ...[
                widget.leading!,
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: widget.isSelected
                        ? FontWeight.w500
                        : FontWeight.w400,
                    height: 1.43,
                    color: textColor,
                  ),
                ),
              ),
              if (widget.isSelected)
                Icon(Icons.check_rounded, size: 16, color: _kFocusRingColor),
            ],
          ),
        ),
      ),
    );
  }
}

/// Builds a styled trigger field used by all pickers.
Widget _buildTriggerField({
  required BuildContext context,
  required String? value,
  required String placeholder,
  required String? label,
  required bool requiredField,
  required String? description,
  required bool isOpen,
  required bool enabled,
  required bool hasError,
  required String? errorText,
  required GlobalKey triggerKey,
  required VoidCallback onTap,
  Widget? prefix,
}) {
  final textColor = _pickerText(context);
  final mutedColor = _pickerMuted(context);
  final helperText = hasError ? errorText : description;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      if (label != null) ...[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.43,
                color: textColor,
              ),
            ),
            if (requiredField) ...[
              const SizedBox(width: 4),
              const Text(
                '*',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.43,
                  color: _kDangerColor,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 4),
      ],
      GestureDetector(
        onTap: enabled ? onTap : null,
        behavior: HitTestBehavior.opaque,
        child: Opacity(
          opacity: enabled ? 1.0 : 0.5,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              boxShadow: isOpen
                  ? const [
                      BoxShadow(
                        color: _kFocusRingColor,
                        spreadRadius: .2,
                        blurRadius: 0,
                      ),
                    ]
                  : const [],
            ),
            child: Container(
              key: triggerKey,
              decoration: BoxDecoration(
                color: _pickerFieldBg(context),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: hasError ? _kDangerColor : Colors.transparent,
                ),
                boxShadow: enabled && !_isDark(context)
                    ? _kFieldShadow
                    : const [],
              ),
              child: Row(
                children: [
                  if (prefix != null) ...[prefix, const SizedBox(width: 8)],
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Text(
                        value ?? placeholder,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.43,
                          color: value != null ? textColor : mutedColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: AnimatedRotation(
                      turns: isOpen ? 0.5 : 0,
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeInOut,
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 16,
                        color: mutedColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      if (helperText?.isNotEmpty == true) ...[
        const SizedBox(height: 4),
        Text(
          helperText!,
          style: TextStyle(
            fontSize: 12,
            height: 1.34,
            color: hasError ? _kDangerColor : mutedColor,
          ),
        ),
      ],
    ],
  );
}

class _DropdownOpenAnimation extends StatelessWidget {
  const _DropdownOpenAnimation({required this.openAbove, required this.child});

  final bool openAbove;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      builder: (context, value, animatedChild) {
        final translateY = (1 - value) * (openAbove ? 8 : -8);
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, translateY),
            child: Transform.scale(
              scale: 0.96 + (0.04 * value),
              alignment: openAbove
                  ? Alignment.bottomCenter
                  : Alignment.topCenter,
              child: animatedChild,
            ),
          ),
        );
      },
      child: child,
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SELECT
// ═══════════════════════════════════════════════════════════════════════════════

/// A dropdown picker that shows a list of options to select from.
///
/// Uses a custom overlay positioned below the trigger field.
class HeroUiSelect<T> extends StatefulWidget {
  const HeroUiSelect({
    super.key,
    required this.items,
    this.value,
    this.onChanged,
    this.label,
    this.requiredField = false,
    this.description,
    this.placeholder = 'Select one',
    this.enabled = true,
    this.errorText,
    this.maxListHeight = 240.0,
  });

  final List<HeroUiPickerItem<T>> items;
  final T? value;
  final ValueChanged<T>? onChanged;
  final String? label;
  final bool requiredField;
  final String? description;
  final String placeholder;
  final bool enabled;
  final String? errorText;
  final double maxListHeight;

  @override
  State<HeroUiSelect<T>> createState() => _HeroUiSelectState<T>();
}

class _HeroUiSelectState<T> extends State<HeroUiSelect<T>> {
  OverlayEntry? _overlay;
  final _triggerKey = GlobalKey();
  bool _isOpen = false;
  bool _openAbove = false;
  Offset _triggerOffset = Offset.zero;
  Size _triggerSize = Size.zero;
  double _estimatedHeight = 0;

  @override
  void didUpdateWidget(covariant HeroUiSelect<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.enabled && _isOpen) {
      _closeDropdown();
    }
    if (_isOpen && oldWidget.items != widget.items) {
      _updateOverlayMetrics();
      _overlay?.markNeedsBuild();
    }
  }

  @override
  void dispose() {
    _closeDropdown();
    super.dispose();
  }

  void _updateOverlayMetrics() {
    final renderObject = _triggerKey.currentContext?.findRenderObject();
    if (renderObject is! RenderBox) return;

    final offset = renderObject.localToGlobal(Offset.zero);
    final size = renderObject.size;
    final media = MediaQuery.of(context);
    final estimatedHeight = _estimateDropdownHeight(
      itemCount: widget.items.length,
      maxListHeight: widget.maxListHeight,
    );
    final availableBelow =
        media.size.height -
        media.viewInsets.bottom -
        media.padding.bottom -
        (offset.dy + size.height);
    final availableAbove = offset.dy - media.padding.top;
    final openAbove =
        availableBelow < estimatedHeight + 8 && availableAbove > availableBelow;

    _triggerOffset = offset;
    _triggerSize = size;
    _estimatedHeight = estimatedHeight;
    _openAbove = openAbove;
  }

  void _openDropdown() {
    if (!widget.enabled || _isOpen) return;
    _updateOverlayMetrics();

    _overlay = OverlayEntry(
      builder: (_) => _SelectOverlay(
        triggerOffset: _triggerOffset,
        triggerSize: _triggerSize,
        estimatedHeight: _estimatedHeight,
        openAbove: _openAbove,
        items: widget.items,
        selectedValue: widget.value,
        maxListHeight: widget.maxListHeight,
        onSelected: (v) {
          widget.onChanged?.call(v);
          _closeDropdown();
        },
        onDismiss: _closeDropdown,
      ),
    );

    Overlay.of(context, rootOverlay: true).insert(_overlay!);
    setState(() => _isOpen = true);
  }

  void _closeDropdown() {
    _overlay?.remove();
    _overlay = null;
    if (mounted) setState(() => _isOpen = false);
  }

  String? get _selectedLabel {
    if (widget.value == null) return null;
    try {
      return widget.items.firstWhere((i) => i.value == widget.value).label;
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildTriggerField(
      context: context,
      value: _selectedLabel,
      placeholder: widget.placeholder,
      label: widget.label,
      requiredField: widget.requiredField,
      description: widget.description,
      isOpen: _isOpen,
      enabled: widget.enabled,
      hasError: widget.errorText?.trim().isNotEmpty == true,
      errorText: widget.errorText,
      triggerKey: _triggerKey,
      onTap: _isOpen ? _closeDropdown : _openDropdown,
    );
  }
}

class _SelectOverlay<T> extends StatelessWidget {
  const _SelectOverlay({
    required this.triggerOffset,
    required this.triggerSize,
    required this.estimatedHeight,
    required this.openAbove,
    required this.items,
    required this.selectedValue,
    required this.onSelected,
    required this.onDismiss,
    required this.maxListHeight,
  });

  final Offset triggerOffset;
  final Size triggerSize;
  final double estimatedHeight;
  final bool openAbove;
  final List<HeroUiPickerItem<T>> items;
  final T? selectedValue;
  final ValueChanged<T> onSelected;
  final VoidCallback onDismiss;
  final double maxListHeight;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final desiredTop = openAbove
        ? triggerOffset.dy - estimatedHeight - 8
        : triggerOffset.dy + triggerSize.height + 8;
    final minTop = media.padding.top + 8;
    final maxTop =
        media.size.height -
        media.viewInsets.bottom -
        media.padding.bottom -
        estimatedHeight -
        8;
    final top = maxTop > minTop
        ? desiredTop.clamp(minTop, maxTop).toDouble()
        : desiredTop;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onDismiss,
      child: Stack(
        children: [
          Positioned(
            left: triggerOffset.dx,
            top: top,
            width: triggerSize.width,
            child: GestureDetector(
              onTap: () {}, // prevent dismiss
              child: Material(
                color: Colors.transparent,
                child: _DropdownOpenAnimation(
                  openAbove: openAbove,
                  child: _DropdownPanel(
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: maxListHeight),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              for (final item in items)
                                _DropdownItem(
                                  label: item.label,
                                  leading: item.leading,
                                  isSelected: item.value == selectedValue,
                                  onTap: () => onSelected(item.value),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// COMBOBOX
// ═══════════════════════════════════════════════════════════════════════════════

/// A text field that filters a list of options as the user types.
///
/// Matching items are shown in a dropdown overlay.
class HeroUiComboBox<T> extends StatefulWidget {
  const HeroUiComboBox({
    super.key,
    required this.items,
    this.value,
    this.onChanged,
    this.label,
    this.requiredField = false,
    this.description,
    this.placeholder = 'Type to search…',
    this.enabled = true,
    this.errorText,
    this.maxListHeight = 240.0,
  });

  final List<HeroUiPickerItem<T>> items;
  final T? value;
  final ValueChanged<T>? onChanged;
  final String? label;
  final bool requiredField;
  final String? description;
  final String placeholder;
  final bool enabled;
  final String? errorText;
  final double maxListHeight;

  @override
  State<HeroUiComboBox<T>> createState() => _HeroUiComboBoxState<T>();
}

class _HeroUiComboBoxState<T> extends State<HeroUiComboBox<T>> {
  final _ctrl = TextEditingController();
  final _focus = FocusNode();
  final _triggerKey = GlobalKey();
  OverlayEntry? _overlay;
  List<HeroUiPickerItem<T>> _filtered = [];
  bool _isOpen = false;
  bool _openAbove = false;
  Offset _triggerOffset = Offset.zero;
  Size _triggerSize = Size.zero;
  double _estimatedHeight = 0;

  @override
  void initState() {
    super.initState();
    _filtered = widget.items;
    _ctrl.text = _labelForValue(widget.value) ?? '';
    _focus.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(covariant HeroUiComboBox<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.value != oldWidget.value && !_focus.hasFocus) {
      _ctrl.text = _labelForValue(widget.value) ?? '';
    }

    if (widget.items != oldWidget.items) {
      _onTextChanged(_ctrl.text);
    }

    if (!widget.enabled && _isOpen) {
      _closeDropdown();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    _closeDropdown();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focus.hasFocus) {
      _openDropdown();
    } else {
      Future.delayed(const Duration(milliseconds: 150), _closeDropdown);
    }
  }

  void _onTextChanged(String text) {
    final lower = text.toLowerCase();
    setState(() {
      _filtered = widget.items
          .where((i) => i.label.toLowerCase().contains(lower))
          .toList();
    });
    _updateOverlayMetrics();
    _overlay?.markNeedsBuild();
  }

  String? _labelForValue(T? value) {
    if (value == null) return null;
    try {
      return widget.items.firstWhere((item) => item.value == value).label;
    } catch (_) {
      return null;
    }
  }

  void _updateOverlayMetrics() {
    final renderObject = _triggerKey.currentContext?.findRenderObject();
    if (renderObject is! RenderBox) return;

    final offset = renderObject.localToGlobal(Offset.zero);
    final size = renderObject.size;
    final media = MediaQuery.of(context);
    final estimatedHeight = _estimateDropdownHeight(
      itemCount: _filtered.length,
      maxListHeight: widget.maxListHeight,
    );
    final availableBelow =
        media.size.height -
        media.viewInsets.bottom -
        media.padding.bottom -
        (offset.dy + size.height);
    final availableAbove = offset.dy - media.padding.top;
    final openAbove =
        availableBelow < estimatedHeight + 8 && availableAbove > availableBelow;

    _triggerOffset = offset;
    _triggerSize = size;
    _estimatedHeight = estimatedHeight;
    _openAbove = openAbove;
  }

  void _openDropdown() {
    if (!widget.enabled || _isOpen) return;
    _updateOverlayMetrics();

    _overlay = OverlayEntry(
      builder: (_) => _ComboBoxOverlay(
        triggerOffset: _triggerOffset,
        triggerSize: _triggerSize,
        estimatedHeight: _estimatedHeight,
        openAbove: _openAbove,
        items: _filtered,
        selectedValue: widget.value,
        maxListHeight: widget.maxListHeight,
        onSelected: (v) {
          final item = widget.items.firstWhere((i) => i.value == v);
          _ctrl.text = item.label;
          widget.onChanged?.call(v);
          _focus.unfocus();
          _closeDropdown();
        },
      ),
    );

    Overlay.of(context, rootOverlay: true).insert(_overlay!);
    setState(() => _isOpen = true);
  }

  void _closeDropdown() {
    _overlay?.remove();
    _overlay = null;
    if (mounted) setState(() => _isOpen = false);
  }

  @override
  Widget build(BuildContext context) {
    final textColor = _pickerText(context);
    final mutedColor = _pickerMuted(context);
    final hasError = widget.errorText?.trim().isNotEmpty == true;
    final helperText = hasError ? widget.errorText : widget.description;
    final isFocused = _isOpen || _focus.hasFocus;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label!,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.43,
                  color: textColor,
                ),
              ),
              if (widget.requiredField) ...[
                const SizedBox(width: 4),
                const Text(
                  '*',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.43,
                    color: _kDangerColor,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
        ],
        Opacity(
          opacity: widget.enabled ? 1.0 : 0.5,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              boxShadow: isFocused
                  ? const [
                      BoxShadow(
                        color: _kFocusRingColor,
                        spreadRadius: .2,
                        blurRadius: 0,
                      ),
                    ]
                  : const [],
            ),
            child: Container(
              key: _triggerKey,
              decoration: BoxDecoration(
                color: _pickerFieldBg(context),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: hasError ? _kDangerColor : Colors.transparent,
                ),
                boxShadow: widget.enabled && !_isDark(context)
                    ? _kFieldShadow
                    : const [],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _ctrl,
                      focusNode: _focus,
                      enabled: widget.enabled,
                      onChanged: _onTextChanged,
                      onTapOutside: (_) {
                        _focus.unfocus();
                        _closeDropdown();
                      },
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.43,
                        color: textColor,
                      ),
                      decoration: InputDecoration(
                        hintText: widget.placeholder,
                        hintStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.43,
                          color: mutedColor,
                        ),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: AnimatedRotation(
                      turns: _isOpen ? 0.5 : 0,
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeInOut,
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 16,
                        color: mutedColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (helperText?.trim().isNotEmpty == true) ...[
          const SizedBox(height: 4),
          Text(
            helperText!,
            style: TextStyle(
              fontSize: 12,
              height: 1.34,
              color: hasError ? _kDangerColor : mutedColor,
            ),
          ),
        ],
      ],
    );
  }
}

class _ComboBoxOverlay<T> extends StatelessWidget {
  const _ComboBoxOverlay({
    required this.triggerOffset,
    required this.triggerSize,
    required this.estimatedHeight,
    required this.openAbove,
    required this.items,
    required this.selectedValue,
    required this.onSelected,
    required this.maxListHeight,
    this.onDismiss,
    this.barrierDismissible = false,
  });

  final Offset triggerOffset;
  final Size triggerSize;
  final double estimatedHeight;
  final bool openAbove;
  final List<HeroUiPickerItem<T>> items;
  final T? selectedValue;
  final ValueChanged<T> onSelected;
  final double maxListHeight;
  final VoidCallback? onDismiss;
  final bool barrierDismissible;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final desiredTop = openAbove
        ? triggerOffset.dy - estimatedHeight - 8
        : triggerOffset.dy + triggerSize.height + 8;
    final minTop = media.padding.top + 8;
    final maxTop =
        media.size.height -
        media.viewInsets.bottom -
        media.padding.bottom -
        estimatedHeight -
        8;
    final top = maxTop > minTop
        ? desiredTop.clamp(minTop, maxTop).toDouble()
        : desiredTop;

    final panel = Positioned(
      left: triggerOffset.dx,
      top: top,
      width: triggerSize.width,
      child: Material(
        color: Colors.transparent,
        child: _DropdownOpenAnimation(
          openAbove: openAbove,
          child: _DropdownPanel(
            children: items.isEmpty
                ? [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        'No results',
                        style: TextStyle(
                          fontSize: 14,
                          color: _pickerMuted(context),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ]
                : [
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: maxListHeight),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (final item in items)
                              _DropdownItem(
                                label: item.label,
                                leading: item.leading,
                                isSelected: item.value == selectedValue,
                                onTap: () => onSelected(item.value),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
          ),
        ),
      ),
    );

    if (!barrierDismissible) {
      return Stack(children: [panel]);
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onDismiss,
      child: Stack(children: [panel]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// AUTOCOMPLETE
// ═══════════════════════════════════════════════════════════════════════════════

/// An input field with tag chips and a filterable dropdown suggestion list.
///
/// Allows selecting multiple values, each shown as a removable chip in the
/// input field. The dropdown filters available options as the user types.
class HeroUiAutocomplete<T> extends StatefulWidget {
  const HeroUiAutocomplete({
    super.key,
    required this.items,
    this.values = const [],
    this.onChanged,
    this.label,
    this.placeholder = 'Type to search…',
    this.enabled = true,
    this.errorText,
    this.maxListHeight = 240.0,
  });

  final List<HeroUiPickerItem<T>> items;
  final List<T> values;
  final ValueChanged<List<T>>? onChanged;
  final String? label;
  final String placeholder;
  final bool enabled;
  final String? errorText;
  final double maxListHeight;

  @override
  State<HeroUiAutocomplete<T>> createState() => _HeroUiAutocompleteState<T>();
}

class _HeroUiAutocompleteState<T> extends State<HeroUiAutocomplete<T>> {
  final _ctrl = TextEditingController();
  final _focus = FocusNode();
  final _key = GlobalKey();
  OverlayEntry? _overlay;
  List<HeroUiPickerItem<T>> _filtered = [];
  late List<T> _selected;
  bool _isOpen = false;
  bool _openAbove = false;
  Offset _triggerOffset = Offset.zero;
  Size _triggerSize = Size.zero;
  double _estimatedHeight = 0;

  @override
  void initState() {
    super.initState();
    _selected = List.from(widget.values);
    _filtered = widget.items;
    _focus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    _closeDropdown();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focus.hasFocus) {
      _openDropdown();
    } else {
      Future.delayed(const Duration(milliseconds: 150), _closeDropdown);
    }
  }

  void _onTextChanged(String text) {
    final lower = text.toLowerCase();
    setState(() {
      _filtered = widget.items
          .where(
            (i) =>
                !_selected.contains(i.value) &&
                i.label.toLowerCase().contains(lower),
          )
          .toList();
    });
    _updateOverlayMetrics();
    _overlay?.markNeedsBuild();
  }

  void _updateOverlayMetrics() {
    final renderObject = _key.currentContext?.findRenderObject();
    if (renderObject is! RenderBox) return;

    final offset = renderObject.localToGlobal(Offset.zero);
    final size = renderObject.size;
    final media = MediaQuery.of(context);
    final estimatedHeight = _estimateDropdownHeight(
      itemCount: _filtered.length,
      maxListHeight: widget.maxListHeight,
    );
    final availableBelow =
        media.size.height -
        media.viewInsets.bottom -
        media.padding.bottom -
        (offset.dy + size.height);
    final availableAbove = offset.dy - media.padding.top;
    final openAbove =
        availableBelow < estimatedHeight + 8 && availableAbove > availableBelow;

    _triggerOffset = offset;
    _triggerSize = size;
    _estimatedHeight = estimatedHeight;
    _openAbove = openAbove;
  }

  void _openDropdown() {
    if (_isOpen) return;
    _updateOverlayMetrics();

    _overlay = OverlayEntry(
      builder: (_) => _ComboBoxOverlay<T>(
        triggerOffset: _triggerOffset,
        triggerSize: _triggerSize,
        estimatedHeight: _estimatedHeight,
        openAbove: _openAbove,
        items: _filtered,
        selectedValue: null,
        maxListHeight: widget.maxListHeight,
        onSelected: (v) {
          setState(() {
            if (!_selected.contains(v)) _selected = [..._selected, v];
            _ctrl.clear();
            _filtered = widget.items
                .where((i) => !_selected.contains(i.value))
                .toList();
          });
          widget.onChanged?.call(List.unmodifiable(_selected));
          _updateOverlayMetrics();
          _overlay?.markNeedsBuild();
        },
      ),
    );

    Overlay.of(context, rootOverlay: true).insert(_overlay!);
    setState(() => _isOpen = true);
  }

  void _closeDropdown() {
    _overlay?.remove();
    _overlay = null;
    if (mounted) setState(() => _isOpen = false);
  }

  void _removeTag(T value) {
    setState(() {
      _selected = _selected.where((v) => v != value).toList();
      _filtered = widget.items
          .where((i) => !_selected.contains(i.value))
          .toList();
    });
    widget.onChanged?.call(List.unmodifiable(_selected));
    _updateOverlayMetrics();
    _overlay?.markNeedsBuild();
  }

  String _labelFor(T value) {
    try {
      return widget.items.firstWhere((i) => i.value == value).label;
    } catch (_) {
      return value.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF18181B) : const Color(0xFFFFFFFF);
    final labelColor = isDark
        ? const Color(0xFFA1A1AA)
        : const Color(0xFF71717A);
    final chipBg = isDark ? const Color(0xFF3F3F46) : const Color(0xFFEFEFF0);
    final chipText = isDark ? const Color(0xFFFCFCFC) : const Color(0xFF18181B);
    final borderColor = widget.errorText != null
        ? const Color(0xFFFF383C)
        : _isOpen
        ? const Color(0xFF0485F7)
        : (isDark ? const Color(0xFF3F3F46) : const Color(0xFFDEDEE0));

    return KeyedSubtree(
      key: _key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.label != null) ...[
            Text(
              widget.label!,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.43,
                color: labelColor,
              ),
            ),
            const SizedBox(height: 4),
          ],
          Opacity(
            opacity: widget.enabled ? 1.0 : 0.5,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: borderColor,
                  width: _isOpen ? 1.5 : 1.0,
                ),
                boxShadow: widget.enabled ? _kFieldShadow : const [],
              ),
              child: Wrap(
                spacing: 4,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  // Tag chips
                  for (final v in _selected)
                    _AutocompleteTag(
                      label: _labelFor(v),
                      bg: chipBg,
                      textColor: chipText,
                      onRemove: widget.enabled ? () => _removeTag(v) : null,
                    ),
                  // Text input
                  IntrinsicWidth(
                    child: TextField(
                      controller: _ctrl,
                      focusNode: _focus,
                      enabled: widget.enabled,
                      onChanged: _onTextChanged,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark
                            ? const Color(0xFFFCFCFC)
                            : const Color(0xFF18181B),
                      ),
                      decoration: InputDecoration(
                        hintText: _selected.isEmpty ? widget.placeholder : '',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: isDark
                              ? const Color(0xFF52525B)
                              : const Color(0xFFA1A1AA),
                        ),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 4,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        constraints: const BoxConstraints(minWidth: 80),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (widget.errorText != null) ...[
            const SizedBox(height: 4),
            Text(
              widget.errorText!,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFFFF383C),
                height: 1.34,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AutocompleteTag extends StatelessWidget {
  const _AutocompleteTag({
    required this.label,
    required this.bg,
    required this.textColor,
    this.onRemove,
  });

  final String label;
  final Color bg;
  final Color textColor;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
          if (onRemove != null) ...[
            const SizedBox(width: 4),
            GestureDetector(
              onTap: onRemove,
              child: Icon(
                Icons.close_rounded,
                size: 12,
                color: textColor.withValues(alpha: 0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
