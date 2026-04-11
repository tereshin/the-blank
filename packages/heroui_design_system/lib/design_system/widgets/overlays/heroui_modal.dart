part of 'heroui_overlays.dart';

enum HeroUiModalSize { sm, md, lg, full }

/// Shows a modal dialog.
///
/// Call [HeroUiModal.show] to display the dialog imperatively.
class HeroUiModal {
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget body,
    List<Widget>? actions,
    HeroUiModalSize size = HeroUiModalSize.md,
    bool barrierDismissible = true,
    bool blurBarrier = false,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: 'Dismiss',
      barrierColor: blurBarrier
          ? Colors.black.withValues(alpha: 0.3)
          : Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (ctx, anim, _) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        final bg = isDark ? const Color(0xFF18181B) : const Color(0xFFFFFFFF);
        final titleColor = isDark
            ? const Color(0xFFFCFCFC)
            : const Color(0xFF18181B);

        final maxW = switch (size) {
          HeroUiModalSize.sm => 520.0,
          HeroUiModalSize.md => 728.0,
          HeroUiModalSize.lg => 936.0,
          HeroUiModalSize.full => double.infinity,
        };

        return FadeTransition(
          opacity: anim,
          child: ScaleTransition(
            scale: Tween<double>(
              begin: 0.95,
              end: 1.0,
            ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
            child: Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: size == HeroUiModalSize.full
                  ? EdgeInsets.zero
                  : const EdgeInsets.symmetric(horizontal: 5, vertical: 31),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxW, minWidth: 0),
                child: Container(
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: size == HeroUiModalSize.full
                        ? BorderRadius.zero
                        : BorderRadius.circular(31),
                    boxShadow: _kOverlayShadow,
                  ),
                  child: Column(
                    mainAxisSize: size == HeroUiModalSize.full
                        ? MainAxisSize.max
                        : MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 26, 16, 0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                title,
                                style: HeroUiTypography.heading4.copyWith(
                                  color: titleColor,
                                ),
                              ),
                            ),
                            _CloseIconButton(
                              onTap: () => Navigator.of(ctx).pop(),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(20, 21, 20, 0),
                          child: body,
                        ),
                      ),
                      if (actions != null && actions.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 21, 20, 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              for (var i = 0; i < actions.length; i++) ...[
                                if (i > 0) const SizedBox(width: 10),
                                actions[i],
                              ],
                            ],
                          ),
                        ),
                      if (actions == null || actions.isEmpty)
                        const SizedBox(height: 26),
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
