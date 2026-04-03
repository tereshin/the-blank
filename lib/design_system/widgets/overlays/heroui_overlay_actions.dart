part of 'heroui_overlays.dart';

class _CloseIconButton extends StatefulWidget {
  const _CloseIconButton({required this.onTap});
  final VoidCallback onTap;

  @override
  State<_CloseIconButton> createState() => _CloseIconButtonState();
}

class _CloseIconButtonState extends State<_CloseIconButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF27272A) : const Color(0xFFEBEBEC);

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: _hover ? bg.withValues(alpha: 0.8) : bg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.close_rounded,
            size: 16,
            color: isDark ? const Color(0xFFA1A1AA) : const Color(0xFF71717A),
          ),
        ),
      ),
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: _hover ? hoverColor : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: borderColor),
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.43,
              color: textColor,
            ),
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: _hover ? bg.withValues(alpha: 0.85) : bg,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Text(
            widget.label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.43,
              color: Color(0xFFFFFFFF),
            ),
          ),
        ),
      ),
    );
  }
}
