part of 'heroui_buttons.dart';

class HeroUiCloseButton extends StatefulWidget {
  const HeroUiCloseButton({
    this.onPressed,
    super.key,
    this.state = HeroUiCloseButtonState.defaultState,
  });
  final VoidCallback? onPressed;
  final HeroUiCloseButtonState state;

  @override
  State<HeroUiCloseButton> createState() => _HeroUiCloseButtonState();
}

class _HeroUiCloseButtonState extends State<HeroUiCloseButton> {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  bool get _autoStateEnabled =>
      widget.state == HeroUiCloseButtonState.defaultState;

  HeroUiCloseButtonState _autoState() {
    if (_pressed) return HeroUiCloseButtonState.pressed;
    if (_focused) return HeroUiCloseButtonState.focus;
    if (_hovered) return HeroUiCloseButtonState.hover;
    return HeroUiCloseButtonState.defaultState;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final current = widget.onPressed == null
        ? HeroUiCloseButtonState.disabled
        : (_autoStateEnabled ? _autoState() : widget.state);
    final bg = isDark
        ? switch (current) {
            HeroUiCloseButtonState.defaultState => const Color(0xFF3F3F46),
            HeroUiCloseButtonState.hover => const Color(0xFF52525B),
            HeroUiCloseButtonState.pressed => const Color(0xFF27272A),
            HeroUiCloseButtonState.focus => const Color(0xFF52525B),
            HeroUiCloseButtonState.disabled => const Color(0xFF3F3F46),
          }
        : switch (current) {
            HeroUiCloseButtonState.defaultState => const Color(0xFFEBEBEC),
            HeroUiCloseButtonState.hover => const Color(0xFFE1E1E2),
            HeroUiCloseButtonState.pressed => const Color(0xFFD4D4D8),
            HeroUiCloseButtonState.focus => const Color(0xFFE1E1E2),
            HeroUiCloseButtonState.disabled => const Color(0xFFEBEBEC),
          };
    final focusInnerRing =
        isDark ? const Color(0xFF27272A) : const Color(0xFFF5F5F5);
    final iconColor =
        isDark ? const Color(0xFFA1A1AA) : const Color(0xFF71717A);
    final pressScale = current == HeroUiCloseButtonState.disabled
        ? 1.0
        : (current == HeroUiCloseButtonState.pressed ? 0.97 : 1.0);

    return Opacity(
      opacity: current == HeroUiCloseButtonState.disabled ? 0.5 : 1,
      child: AnimatedScale(
        scale: pressScale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        alignment: Alignment.center,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: bg,
            shape: BoxShape.circle,
            boxShadow: current == HeroUiCloseButtonState.focus
                ? [
                    const BoxShadow(
                      color: Color(0xFF0485F7),
                      spreadRadius: 4,
                      blurRadius: 0,
                    ),
                    BoxShadow(
                      color: focusInnerRing,
                      spreadRadius: 2,
                      blurRadius: 0,
                    ),
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
              customBorder: const CircleBorder(),
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
              onTap: current == HeroUiCloseButtonState.disabled
                  ? null
                  : widget.onPressed,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: HeroUiIcon(
                  HeroUiIconManifest.xmark,
                  size: 21,
                  color: iconColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
