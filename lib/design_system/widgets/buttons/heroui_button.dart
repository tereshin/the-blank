part of 'heroui_buttons.dart';

class HeroUiButton extends StatefulWidget {
  const HeroUiButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.variant = HeroUiButtonVariant.primary,
    this.size = HeroUiButtonSize.md,
    this.state = HeroUiButtonVisualState.defaultState,
    this.leading,
    this.trailing,
    this.iconOnly = false,
    this.borderRadiusOverride,
    this.expand = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final HeroUiButtonVariant variant;
  final HeroUiButtonSize size;
  final HeroUiButtonVisualState state;
  final Widget? leading;
  final Widget? trailing;
  final bool iconOnly;
  final BorderRadiusGeometry? borderRadiusOverride;
  final bool expand;

  @override
  State<HeroUiButton> createState() => _HeroUiButtonState();
}

class _HeroUiButtonState extends State<HeroUiButton> {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  bool get _autoStateEnabled =>
      widget.state == HeroUiButtonVisualState.defaultState;

  HeroUiButtonVisualState _autoState() {
    if (_pressed) return HeroUiButtonVisualState.pressed;
    if (_focused) return HeroUiButtonVisualState.focus;
    if (_hovered) return HeroUiButtonVisualState.hover;
    return HeroUiButtonVisualState.defaultState;
  }

  @override
  Widget build(BuildContext context) {
    final s = _size(widget.size);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final current = widget.onPressed == null
        ? HeroUiButtonVisualState.disabled
        : (_autoStateEnabled ? _autoState() : widget.state);
    final t = _tokens(widget.variant, current, isDark: isDark);
    final radius =
        widget.borderRadiusOverride ?? BorderRadius.circular(s.radius);
    final iconTheme = IconThemeData(size: 16, color: t.fg);

    final content = widget.iconOnly
        ? IconTheme.merge(
            data: iconTheme,
            child:
                widget.leading ??
                widget.trailing ??
                const Icon(Icons.crop_square_rounded),
          )
        : DefaultTextStyle(
            style: s.textStyle.copyWith(color: t.fg),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            child: Row(
              mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.leading != null) ...[
                  IconTheme.merge(data: iconTheme, child: widget.leading!),
                  SizedBox(width: s.gap),
                ],
                Flexible(
                  child: SizedBox(
                    height: s.labelHeight,
                    child: Center(
                      child: Text(
                        widget.label,
                        textAlign: TextAlign.center,
                        textHeightBehavior: const TextHeightBehavior(
                          applyHeightToFirstAscent: false,
                          applyHeightToLastDescent: false,
                        ),
                      ),
                    ),
                  ),
                ),
                if (widget.trailing != null) ...[
                  SizedBox(width: s.gap),
                  IconTheme.merge(data: iconTheme, child: widget.trailing!),
                ],
              ],
            ),
          );

    return Opacity(
      opacity: current == HeroUiButtonVisualState.disabled ? 0.5 : 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: t.bg,
          borderRadius: radius,
          border: t.border == null ? null : Border.all(color: t.border!),
          boxShadow: current == HeroUiButtonVisualState.focus
              ? const [
                  BoxShadow(color: Color(0xFF0485F7), spreadRadius: 4),
                  BoxShadow(color: Color(0xFFF5F5F5), spreadRadius: 2),
                ]
              : null,
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            splashFactory: NoSplash.splashFactory,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            focusColor: Colors.transparent,
            onHover: (value) {
              if (!_autoStateEnabled || _hovered == value) return;
              setState(() => _hovered = value);
            },
            onHighlightChanged: (value) {
              if (!_autoStateEnabled || _pressed == value) return;
              setState(() => _pressed = value);
            },
            onFocusChange: (value) {
              if (!_autoStateEnabled || _focused == value) return;
              setState(() => _focused = value);
            },
            borderRadius: radius.resolve(Directionality.of(context)),
            onTap: current == HeroUiButtonVisualState.disabled
                ? null
                : widget.onPressed,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: s.height,
                minWidth: widget.iconOnly ? s.height : 0,
              ),
              child: Padding(
                padding: widget.iconOnly ? s.iconPadding : s.padding,
                child: Center(child: content),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
