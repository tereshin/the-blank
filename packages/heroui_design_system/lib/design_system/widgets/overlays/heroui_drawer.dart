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
    HeroUiSurfaceVariant surfaceVariant = HeroUiSurfaceVariant.defaultVariant,
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
      transitionDuration: const Duration(milliseconds: 160),
      transitionBuilder: (_, _, _, child) => child,
      pageBuilder: (ctx, anim, _) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
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
            left: Radius.circular(22),
          ),
          HeroUiDrawerPosition.left => const BorderRadius.horizontal(
            right: Radius.circular(22),
          ),
          HeroUiDrawerPosition.bottom => const BorderRadius.vertical(
            top: Radius.circular(22),
          ),
          HeroUiDrawerPosition.top => const BorderRadius.vertical(
            bottom: Radius.circular(22),
          ),
        };

        final showHandle =
            position == HeroUiDrawerPosition.bottom ||
            position == HeroUiDrawerPosition.top;
        final viewPadding = MediaQuery.viewPaddingOf(ctx);
        final double topInset =
            (showHandle && position == HeroUiDrawerPosition.bottom
                ? 0.0
                : 24.0) +
            (position == HeroUiDrawerPosition.top ? viewPadding.top : 0.0);
        final double bottomInset =
            (showHandle && position == HeroUiDrawerPosition.top
                ? 0.0
                : 24.0) +
            (position == HeroUiDrawerPosition.bottom
                ? viewPadding.bottom
                : 0.0);
        final headerPadding = EdgeInsets.fromLTRB(24, topInset, 24, 16);
        final footerPadding = EdgeInsets.fromLTRB(24, 20, 24, bottomInset);

        var panelDragOffset = 0.0;
        var isHandleDragging = false;
        var isHandleDismissInProgress = false;

        void dismissFromHandleDrag() {
          if (isHandleDismissInProgress) return;
          isHandleDismissInProgress = true;
          Navigator.of(ctx).maybePop();
        }

        return StatefulBuilder(
          builder: (context, setPanelState) {
            Widget buildHandle({required EdgeInsets margin}) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onVerticalDragStart: (_) {
                  setPanelState(() {
                    isHandleDragging = true;
                    panelDragOffset = 0;
                  });
                },
                onVerticalDragUpdate: (details) {
                  setPanelState(() {
                    panelDragOffset += details.primaryDelta ?? 0;
                    panelDragOffset = switch (position) {
                      HeroUiDrawerPosition.bottom => math.max(
                        panelDragOffset,
                        0,
                      ),
                      HeroUiDrawerPosition.top => math.min(panelDragOffset, 0),
                      HeroUiDrawerPosition.left ||
                      HeroUiDrawerPosition.right => 0,
                    };
                  });
                },
                onVerticalDragEnd: (details) {
                  final velocity = details.primaryVelocity ?? 0;
                  final passedDistanceThreshold =
                      (position == HeroUiDrawerPosition.bottom &&
                          panelDragOffset >= 72) ||
                      (position == HeroUiDrawerPosition.top &&
                          panelDragOffset <= -72);
                  final passedVelocityThreshold =
                      (position == HeroUiDrawerPosition.bottom &&
                          velocity > 500) ||
                      (position == HeroUiDrawerPosition.top && velocity < -500);
                  final shouldDismiss =
                      passedDistanceThreshold || passedVelocityThreshold;

                  setPanelState(() {
                    isHandleDragging = false;
                    if (!shouldDismiss) {
                      panelDragOffset = 0;
                    }
                  });

                  if (shouldDismiss) {
                    dismissFromHandleDrag();
                  }
                },
                onVerticalDragCancel: () {
                  setPanelState(() {
                    isHandleDragging = false;
                    panelDragOffset = 0;
                  });
                },
                child: Container(
                  width: double.infinity,
                  height: 44,
                  margin: margin,
                  alignment: Alignment.center,
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDEDEE0),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              );
            }

            final panelContent = Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (title != null)
                  Padding(
                    padding: headerPadding,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: HeroUiTypography.heading4.copyWith(
                                  color: titleColor,
                                  decoration: TextDecoration.none,
                                  decorationColor: Colors.transparent,
                                ),
                              ),
                              if (subtitle != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  subtitle,
                                  style: HeroUiTypography.bodySm.copyWith(
                                    color: const Color(0xFF71717A),
                                    decoration: TextDecoration.none,
                                    decorationColor: Colors.transparent,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        _CloseIconButton(onTap: () => Navigator.of(ctx).pop()),
                      ],
                    ),
                  )
                else if (topInset > 0)
                  SizedBox(height: topInset),
                Flexible(child: SingleChildScrollView(child: body)),
                if (footerActions != null && footerActions.isNotEmpty)
                  Padding(
                    padding: footerPadding,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        for (var i = 0; i < footerActions.length; i++) ...[
                          if (i > 0) const SizedBox(width: 8),
                          footerActions[i],
                        ],
                      ],
                    ),
                  )
                else if (bottomInset > 0)
                  SizedBox(height: bottomInset),
              ],
            );

            Widget panel = DefaultTextStyle.merge(
              style: const TextStyle(
                decoration: TextDecoration.none,
                decorationColor: Colors.transparent,
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  boxShadow: _kOverlayShadow,
                ),
                child: ClipRRect(
                  borderRadius: borderRadius,
                  child: HeroUiSurface(
                    variant: surfaceVariant,
                    borderRadius: 0,
                    showShadow: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (showHandle && position == HeroUiDrawerPosition.bottom)
                          buildHandle(margin: const EdgeInsets.only(top: 8)),
                        Flexible(fit: FlexFit.loose, child: panelContent),
                        if (showHandle && position == HeroUiDrawerPosition.top)
                          buildHandle(margin: const EdgeInsets.only(bottom: 8)),
                      ],
                    ),
                  ),
                ),
              ),
            );

            panel = SlideTransition(position: slideAnim, child: panel);

            if (showHandle) {
              panel = AnimatedContainer(
                duration: isHandleDragging
                    ? Duration.zero
                    : const Duration(milliseconds: 180),
                curve: Curves.easeOutCubic,
                transform: Matrix4.translationValues(0, panelDragOffset, 0),
                child: panel,
              );
            }

            return Align(
              alignment: switch (position) {
                HeroUiDrawerPosition.right => Alignment.centerRight,
                HeroUiDrawerPosition.left => Alignment.centerLeft,
                HeroUiDrawerPosition.bottom => Alignment.bottomCenter,
                HeroUiDrawerPosition.top => Alignment.topCenter,
              },
              child: SafeArea(
                top: position != HeroUiDrawerPosition.top,
                bottom: position != HeroUiDrawerPosition.bottom,
                child: isVertical
                    ? SizedBox(width: resolvedSize, child: panel)
                    : SizedBox(width: double.infinity, child: panel),
              ),
            );
          },
        );
      },
    );
  }
}
