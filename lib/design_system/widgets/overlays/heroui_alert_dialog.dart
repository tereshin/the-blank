part of 'heroui_overlays.dart';

/// Shows a confirmation/alert dialog with title, body, and action buttons.
///
/// Call [HeroUiAlertDialog.show] to display it.
class HeroUiAlertDialog {
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    String? description,
    Widget? body,
    String cancelLabel = 'Cancel',
    String confirmLabel = 'Confirm',
    bool isDanger = false,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool barrierDismissible = true,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (ctx, anim, _) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        final bg = isDark ? const Color(0xFF18181B) : const Color(0xFFFFFFFF);
        final titleColor = isDark
            ? const Color(0xFFFCFCFC)
            : const Color(0xFF18181B);
        final descColor = isDark
            ? const Color(0xFFA1A1AA)
            : const Color(0xFF71717A);

        return FadeTransition(
          opacity: anim,
          child: ScaleTransition(
            scale: Tween<double>(
              begin: 0.96,
              end: 1.0,
            ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
            child: Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 24,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: _kOverlayShadow,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isDanger
                              ? const Color(0x1AFF383C)
                              : const Color(0x1A0485F7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          isDanger
                              ? Icons.warning_amber_rounded
                              : Icons.info_outline_rounded,
                          size: 20,
                          color: isDanger
                              ? const Color(0xFFFF383C)
                              : const Color(0xFF0485F7),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        title,
                        style: HeroUiTypography.heading4.copyWith(
                          color: titleColor,
                        ),
                      ),
                      if (description != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          description,
                          style: HeroUiTypography.bodySm.copyWith(
                            color: descColor,
                          ),
                        ),
                      ],
                      if (body != null) ...[const SizedBox(height: 12), body],
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _OutlineButton(
                            label: cancelLabel,
                            onTap: () {
                              Navigator.of(ctx).pop();
                              onCancel?.call();
                            },
                          ),
                          const SizedBox(width: 8),
                          _FilledButton(
                            label: confirmLabel,
                            isDanger: isDanger,
                            onTap: () {
                              Navigator.of(ctx).pop();
                              onConfirm?.call();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
