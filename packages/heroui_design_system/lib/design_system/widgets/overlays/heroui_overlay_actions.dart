part of 'heroui_overlays.dart';

class _CloseIconButton extends StatelessWidget {
  const _CloseIconButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return HeroUiCloseButton(
      onPressed: onTap,
      state: HeroUiCloseButtonState.defaultState,
    );
  }
}

class _OutlineButton extends StatefulWidget {
  const _OutlineButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  State<_OutlineButton> createState() => _OutlineButtonState();
}

class _OutlineButtonState extends State<_OutlineButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? const Color(0xFFFCFCFC)
        : const Color(0xFF18181B);
    final borderColor = isDark
        ? const Color(0xFF3F3F46)
        : const Color(0xFFDEDEE0);
    final hoverColor = isDark
        ? const Color(0xFF27272A)
        : const Color(0xFFEFEFF0);

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 10),
          decoration: BoxDecoration(
            color: _hover ? hoverColor : Colors.transparent,
            borderRadius: BorderRadius.circular(31),
            border: Border.all(color: borderColor),
          ),
          child: Text(
            widget.label,
            style: HeroUiTypography.buttonBase.copyWith(color: textColor),
          ),
        ),
      ),
    );
  }
}

class _FilledButton extends StatefulWidget {
  const _FilledButton({
    required this.label,
    required this.onTap,
    this.isDanger = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool isDanger;

  @override
  State<_FilledButton> createState() => _FilledButtonState();
}

class _FilledButtonState extends State<_FilledButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final bg = widget.isDanger
        ? const Color(0xFFFF383C)
        : const Color(0xFF0485F7);

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 10),
          decoration: BoxDecoration(
            color: _hover ? bg.withValues(alpha: 0.85) : bg,
            borderRadius: BorderRadius.circular(31),
          ),
          child: Text(
            widget.label,
            style: HeroUiTypography.buttonBase.copyWith(
              color: const Color(0xFFFFFFFF),
            ),
          ),
        ),
      ),
    );
  }
}
