part of 'heroui_overlays.dart';

enum HeroUiDrawerPosition { bottom, top, left, right }

/// Shows a side/bottom/top drawer panel.
///
/// Call [HeroUiDrawer.show] to display the drawer imperatively.
class HeroUiDrawer {
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget body,
    HeroUiDrawerPosition position = HeroUiDrawerPosition.right,
    String? title,
    String? subtitle,
    List<Widget>? footerActions,
    bool barrierDismissible = true,
    double? size,
  }) {
    final isVertical =
        position == HeroUiDrawerPosition.left ||
        position == HeroUiDrawerPosition.right;
    final defaultSize = isVertical ? 393.0 : 360.0;
    final resolvedSize = size ?? defaultSize;

    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (ctx, anim, _) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        final bg = isDark ? const Color(0xFF18181B) : const Color(0xFFFFFFFF);
        final titleColor = isDark
            ? const Color(0xFFFCFCFC)
            : const Color(0xFF18181B);

        final slideAnim = Tween<Offset>(
          begin: switch (position) {
            HeroUiDrawerPosition.right => const Offset(1, 0),
            HeroUiDrawerPosition.left => const Offset(-1, 0),
            HeroUiDrawerPosition.bottom => const Offset(0, 1),
            HeroUiDrawerPosition.top => const Offset(0, -1),
          },
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut));

        final borderRadius = switch (position) {
          HeroUiDrawerPosition.right => const BorderRadius.horizontal(
            left: Radius.circular(16),
          ),
          HeroUiDrawerPosition.left => const BorderRadius.horizontal(
            right: Radius.circular(16),
          ),
          HeroUiDrawerPosition.bottom => const BorderRadius.vertical(
            top: Radius.circular(16),
          ),
          HeroUiDrawerPosition.top => const BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        };

        final showHandle =
            position == HeroUiDrawerPosition.bottom ||
            position == HeroUiDrawerPosition.top;

        Widget panel = Container(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: borderRadius,
            boxShadow: _kOverlayShadow,
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (showHandle && position == HeroUiDrawerPosition.bottom)
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDEDEE0),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              if (title != null)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              height: 1.4,
                              color: titleColor,
                            ),
                          ),
                          if (subtitle != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              subtitle,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF71717A),
                                height: 1.43,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    _CloseIconButton(onTap: () => Navigator.of(ctx).pop()),
                  ],
                ),
              if (title != null) const SizedBox(height: 16),
              Flexible(child: SingleChildScrollView(child: body)),
              if (footerActions != null && footerActions.isNotEmpty) ...[
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    for (var i = 0; i < footerActions.length; i++) ...[
                      if (i > 0) const SizedBox(width: 8),
                      footerActions[i],
                    ],
                  ],
                ),
              ],
              if (showHandle && position == HeroUiDrawerPosition.top)
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    margin: const EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDEDEE0),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
            ],
          ),
        );

        panel = SlideTransition(position: slideAnim, child: panel);

        return Align(
          alignment: switch (position) {
            HeroUiDrawerPosition.right => Alignment.centerRight,
            HeroUiDrawerPosition.left => Alignment.centerLeft,
            HeroUiDrawerPosition.bottom => Alignment.bottomCenter,
            HeroUiDrawerPosition.top => Alignment.topCenter,
          },
          child: SafeArea(
            child: isVertical
                ? SizedBox(width: resolvedSize, child: panel)
                : SizedBox(width: double.infinity, child: panel),
          ),
        );
      },
    );
  }
}
