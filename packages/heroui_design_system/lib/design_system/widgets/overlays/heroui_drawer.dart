part of 'heroui_overlays.dart';

enum HeroUiDrawerPosition { bottom, top, left, right }

enum HeroUiDrawerScrollShadowVariant { off, visible, blur }

/// Shows a drawer styled as a bottom-sheet modal by default.
///
/// Left/right layouts are applied only on large screens, otherwise the drawer
/// gracefully falls back to a bottom-sheet.
class HeroUiDrawer {
  static const double _kSideLayoutBreakpoint = 1024;
  static const double _kHandleHeight = 57;
  static const double _kScrollShadowSize = 56;
  static const Duration _kScrollShadowFadeDuration = Duration(
    milliseconds: 140,
  );
  static const double _kFooterHorizontalInset = 20;
  static const double _kFooterBottomInset = 16;
  static const double _kFooterEstimatedHeight = 48;
  static const double _kFooterToContentGap = 12;
  static const double _kDismissDragDistance = 94;
  static const double _kDismissDragVelocity = 500;

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget body,
    HeroUiDrawerPosition position = HeroUiDrawerPosition.bottom,
    HeroUiSurfaceVariant surfaceVariant = HeroUiSurfaceVariant.defaultVariant,
    String? title,
    String? subtitle,
    String? description,
    List<Widget>? footerActions,
    bool barrierDismissible = true,
    double? size,

    /// Max height of the panel as a fraction of the logical window height (0–1).
    /// When null, height follows content (subject to screen bounds).
    double? maxHeight,

    /// Scroll shadow behavior for the scrollable viewport.
    /// - [off]: disabled
    /// - [visible]: gradient shadow only
    /// - [blur]: backdrop blur + gradient
    HeroUiDrawerScrollShadowVariant scrollShadow =
        HeroUiDrawerScrollShadowVariant.visible,
  }) {
    final maxHeightFraction = maxHeight?.clamp(0.0, 1.0);
    final scrollController = ScrollController();

    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 160),
      transitionBuilder: (_, _, _, child) => child,
      pageBuilder: (ctx, anim, _) {
        final media = MediaQuery.of(ctx);
        final supportsSideLayout = media.size.width >= _kSideLayoutBreakpoint;
        final requestedSide =
            position == HeroUiDrawerPosition.left ||
            position == HeroUiDrawerPosition.right;
        final resolvedPosition = requestedSide && !supportsSideLayout
            ? HeroUiDrawerPosition.bottom
            : position;
        final isVertical =
            resolvedPosition == HeroUiDrawerPosition.left ||
            resolvedPosition == HeroUiDrawerPosition.right;
        final defaultSize = isVertical ? 511.0 : 468.0;
        final resolvedSize = size ?? defaultSize;
        final resolvedDescription = description ?? subtitle;

        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        final titleColor = isDark
            ? const Color(0xFFFCFCFC)
            : const Color(0xFF18181B);
        final bodyMutedColor = isDark
            ? const Color(0xFFA1A1AA)
            : const Color(0xFF71717A);
        final scrollShadowBase = HeroUiSurface.fillColor(
          ctx,
          surfaceVariant == HeroUiSurfaceVariant.transparent
              ? HeroUiSurfaceVariant.defaultVariant
              : surfaceVariant,
        );

        final showHandle =
            resolvedPosition == HeroUiDrawerPosition.bottom ||
            resolvedPosition == HeroUiDrawerPosition.top;

        final slideAnim = Tween<Offset>(
          begin: switch (resolvedPosition) {
            HeroUiDrawerPosition.right => const Offset(1, 0),
            HeroUiDrawerPosition.left => const Offset(-1, 0),
            HeroUiDrawerPosition.bottom => const Offset(0, 1),
            HeroUiDrawerPosition.top => const Offset(0, -1),
          },
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut));

        final borderRadius = switch (resolvedPosition) {
          HeroUiDrawerPosition.right => const BorderRadius.horizontal(
            left: Radius.circular(36),
          ),
          HeroUiDrawerPosition.left => const BorderRadius.horizontal(
            right: Radius.circular(36),
          ),
          HeroUiDrawerPosition.bottom => const BorderRadius.vertical(
            top: Radius.circular(36),
          ),
          HeroUiDrawerPosition.top => const BorderRadius.vertical(
            bottom: Radius.circular(36),
          ),
        };

        var panelDragOffset = 0.0;
        var isPanelDragging = false;
        var isDragDismissInProgress = false;
        var isScrollEdgeDragging = false;
        var showTopShadow = false;
        var showBottomShadow = false;
        var lastScrollEdgeDragDelta = 0.0;
        var lastScrollEdgeDragAt = DateTime.fromMillisecondsSinceEpoch(0);

        final footerWidgets = footerActions;
        final hasFooter = footerWidgets != null && footerWidgets.isNotEmpty;

        void dismissFromDrag() {
          if (isDragDismissInProgress) return;
          isDragDismissInProgress = true;
          Navigator.of(ctx).maybePop();
        }

        double clampPanelDragOffset(double value) {
          return switch (resolvedPosition) {
            HeroUiDrawerPosition.bottom => math.max(value, 0),
            HeroUiDrawerPosition.top => math.min(value, 0),
            HeroUiDrawerPosition.left || HeroUiDrawerPosition.right => 0,
          };
        }

        void syncShadowsFromMetrics(
          ScrollMetrics metrics,
          StateSetter setPanelState,
        ) {
          if (metrics.axis != Axis.vertical) return;
          final canScroll = metrics.maxScrollExtent > 0;
          final nextTop = canScroll && metrics.pixels > 0.5;
          final nextBottom =
              canScroll && (metrics.maxScrollExtent - metrics.pixels > 0.5);
          if (nextTop == showTopShadow && nextBottom == showBottomShadow) {
            return;
          }
          setPanelState(() {
            showTopShadow = nextTop;
            showBottomShadow = nextBottom;
          });
        }

        double resolvedEdgeContentOffset(ScrollPosition position) {
          return switch (resolvedPosition) {
            HeroUiDrawerPosition.bottom => 0,
            HeroUiDrawerPosition.top => position.maxScrollExtent,
            HeroUiDrawerPosition.left || HeroUiDrawerPosition.right => 0,
          };
        }

        void stickContentToDismissEdge() {
          if (!scrollController.hasClients) return;
          final position = scrollController.position;
          final edgeOffset = resolvedEdgeContentOffset(position);
          if ((position.pixels - edgeOffset).abs() <= 0.5) {
            return;
          }
          scrollController.jumpTo(edgeOffset);
        }

        void rememberScrollEdgeDragSample(double delta) {
          if (delta == 0) return;
          lastScrollEdgeDragDelta = delta;
          lastScrollEdgeDragAt = DateTime.now();
        }

        double estimateScrollEdgeDragVelocity() {
          if (lastScrollEdgeDragDelta == 0) return 0;
          final elapsedMs = DateTime.now()
              .difference(lastScrollEdgeDragAt)
              .inMilliseconds;
          if (elapsedMs <= 0 || elapsedMs > 90) return 0;
          return (lastScrollEdgeDragDelta / elapsedMs) * 1000;
        }

        void startPanelDrag(StateSetter setPanelState) {
          if (!showHandle) return;
          setPanelState(() {
            isPanelDragging = true;
            isScrollEdgeDragging = false;
            panelDragOffset = 0;
            lastScrollEdgeDragDelta = 0;
          });
        }

        void updatePanelDrag(double delta, StateSetter setPanelState) {
          if (!showHandle || delta == 0) return;
          setPanelState(() {
            isPanelDragging = true;
            panelDragOffset = clampPanelDragOffset(panelDragOffset + delta);
          });
        }

        void finishPanelDrag(StateSetter setPanelState, {double velocity = 0}) {
          if (!showHandle) return;
          final passedDistanceThreshold =
              (resolvedPosition == HeroUiDrawerPosition.bottom &&
                  panelDragOffset >= _kDismissDragDistance) ||
              (resolvedPosition == HeroUiDrawerPosition.top &&
                  panelDragOffset <= -_kDismissDragDistance);
          final passedVelocityThreshold =
              (resolvedPosition == HeroUiDrawerPosition.bottom &&
                  velocity > _kDismissDragVelocity) ||
              (resolvedPosition == HeroUiDrawerPosition.top &&
                  velocity < -_kDismissDragVelocity);
          final shouldDismiss =
              passedDistanceThreshold || passedVelocityThreshold;

          setPanelState(() {
            isPanelDragging = false;
            isScrollEdgeDragging = false;
            lastScrollEdgeDragDelta = 0;
            if (!shouldDismiss) {
              panelDragOffset = 0;
            }
          });

          if (shouldDismiss) {
            dismissFromDrag();
          }
        }

        void cancelPanelDrag(StateSetter setPanelState) {
          if (!showHandle) return;
          setPanelState(() {
            isPanelDragging = false;
            isScrollEdgeDragging = false;
            panelDragOffset = 0;
            lastScrollEdgeDragDelta = 0;
          });
        }

        double? scrollEdgeDismissDelta(OverscrollNotification notification) {
          if (!showHandle || notification.metrics.axis != Axis.vertical) {
            return null;
          }

          final metrics = notification.metrics;
          final canScroll = metrics.maxScrollExtent > 0.5;
          final overscrollDelta = notification.overscroll.abs();
          if (overscrollDelta == 0) return null;
          return switch (resolvedPosition) {
            HeroUiDrawerPosition.bottom =>
              metrics.pixels <= 0.5 || !canScroll ? overscrollDelta : null,
            HeroUiDrawerPosition.top =>
              ((metrics.maxScrollExtent - metrics.pixels <= 0.5) ||
                          !canScroll) &&
                      overscrollDelta > 0
                  ? -overscrollDelta
                  : null,
            HeroUiDrawerPosition.left || HeroUiDrawerPosition.right => null,
          };
        }

        double? scrollUpdateDismissDelta(
          ScrollUpdateNotification notification,
        ) {
          if (!showHandle || notification.metrics.axis != Axis.vertical) {
            return null;
          }
          final dragDetails = notification.dragDetails;
          if (dragDetails == null) return null;

          final metrics = notification.metrics;
          final dy = dragDetails.delta.dy;
          final canScroll = metrics.maxScrollExtent > 0.5;
          final atTop = metrics.pixels <= 0.5;
          final atBottom = (metrics.maxScrollExtent - metrics.pixels) <= 0.5;

          if (isScrollEdgeDragging) {
            return dy;
          }

          return switch (resolvedPosition) {
            HeroUiDrawerPosition.bottom =>
              (atTop || !canScroll) && dy > 0 ? dy : null,
            HeroUiDrawerPosition.top =>
              (atBottom || !canScroll) && dy < 0 ? dy : null,
            HeroUiDrawerPosition.left || HeroUiDrawerPosition.right => null,
          };
        }

        Widget buildEdgeScrollShadow({required bool fromTop}) {
          final begin = fromTop ? Alignment.topCenter : Alignment.bottomCenter;
          final end = fromTop ? Alignment.bottomCenter : Alignment.topCenter;

          final gradient = Container(
            height: _kScrollShadowSize,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: begin,
                end: end,
                colors: switch (scrollShadow) {
                  HeroUiDrawerScrollShadowVariant.off => [
                    Colors.transparent,
                    Colors.transparent,
                  ],
                  HeroUiDrawerScrollShadowVariant.visible => [
                    scrollShadowBase,
                    scrollShadowBase.withValues(alpha: 0),
                  ],
                  HeroUiDrawerScrollShadowVariant.blur => [
                    scrollShadowBase.withValues(alpha: 0.76),
                    scrollShadowBase.withValues(alpha: 0),
                  ],
                },
              ),
            ),
          );

          if (scrollShadow != HeroUiDrawerScrollShadowVariant.blur) {
            return IgnorePointer(child: gradient);
          }

          return IgnorePointer(
            child: ClipRect(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: const SizedBox.expand(),
                    ),
                  ),
                  gradient,
                ],
              ),
            ),
          );
        }

        return StatefulBuilder(
          builder: (context, setPanelState) {
            final viewPadding = MediaQuery.viewPaddingOf(context);
            final footerBottomInset =
                _kFooterBottomInset +
                (resolvedPosition == HeroUiDrawerPosition.bottom
                    ? viewPadding.bottom
                    : 0.0);
            final scrollBottomPadding = hasFooter
                ? _kFooterEstimatedHeight +
                      _kFooterToContentGap +
                      footerBottomInset +
                      _kScrollShadowSize
                : (resolvedPosition == HeroUiDrawerPosition.bottom
                      ? viewPadding.bottom
                      : 0.0);
            final scrollPhysics = isScrollEdgeDragging
                ? const NeverScrollableScrollPhysics()
                : const AlwaysScrollableScrollPhysics();

            Widget buildHandle({required EdgeInsets margin}) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.of(ctx).pop(),
                onVerticalDragStart: (_) {
                  startPanelDrag(setPanelState);
                },
                onVerticalDragUpdate: (details) {
                  updatePanelDrag(details.primaryDelta ?? 0, setPanelState);
                },
                onVerticalDragEnd: (details) {
                  finishPanelDrag(
                    setPanelState,
                    velocity: details.primaryVelocity ?? 0,
                  );
                },
                onVerticalDragCancel: () {
                  cancelPanelDrag(setPanelState);
                },
                child: Container(
                  width: double.infinity,
                  height: _kHandleHeight,
                  margin: margin,
                  alignment: Alignment.center,
                  child: Container(
                    width: 52,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDEDEE0),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              );
            }

            final hasHeading = title != null || resolvedDescription != null;
            final headerSection = hasHeading || !showHandle
                ? Padding(
                    padding: EdgeInsets.fromLTRB(
                      16,
                      showHandle ? 8 : 16,
                      16,
                      16,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: hasHeading
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (title != null)
                                      Text(
                                        title,
                                        style: HeroUiTypography.heading4
                                            .copyWith(
                                              color: titleColor,
                                              decoration: TextDecoration.none,
                                              decorationColor:
                                                  Colors.transparent,
                                            ),
                                      ),
                                    if (resolvedDescription != null) ...[
                                      if (title != null)
                                        const SizedBox(height: 5),
                                      Text(
                                        resolvedDescription,
                                        style: HeroUiTypography.bodySm.copyWith(
                                          color: bodyMutedColor,
                                          decoration: TextDecoration.none,
                                          decorationColor: Colors.transparent,
                                        ),
                                      ),
                                    ],
                                  ],
                                )
                              : const SizedBox.shrink(),
                        ),
                        if (!showHandle)
                          _CloseIconButton(
                            onTap: () => Navigator.of(ctx).pop(),
                          ),
                      ],
                    ),
                  )
                : const SizedBox(height: 8);

            final scrollableContent =
                NotificationListener<ScrollMetricsNotification>(
                  onNotification: (notification) {
                    syncShadowsFromMetrics(notification.metrics, setPanelState);
                    return false;
                  },
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      syncShadowsFromMetrics(
                        notification.metrics,
                        setPanelState,
                      );

                      if (notification is ScrollUpdateNotification) {
                        final dragDelta = scrollUpdateDismissDelta(
                          notification,
                        );
                        if (dragDelta != null && dragDelta != 0) {
                          stickContentToDismissEdge();
                          setPanelState(() {
                            isScrollEdgeDragging = true;
                            isPanelDragging = true;
                            rememberScrollEdgeDragSample(dragDelta);
                            panelDragOffset = clampPanelDragOffset(
                              panelDragOffset + dragDelta,
                            );
                          });
                          return true;
                        }
                      }

                      if (notification is OverscrollNotification) {
                        final edgeDelta = scrollEdgeDismissDelta(notification);
                        if (edgeDelta != null && edgeDelta != 0) {
                          stickContentToDismissEdge();
                          setPanelState(() {
                            isScrollEdgeDragging = true;
                            isPanelDragging = true;
                            rememberScrollEdgeDragSample(edgeDelta);
                            panelDragOffset = clampPanelDragOffset(
                              panelDragOffset + edgeDelta,
                            );
                          });
                          return true;
                        }
                      }

                      if (isScrollEdgeDragging &&
                          notification is ScrollEndNotification) {
                        finishPanelDrag(
                          setPanelState,
                          velocity:
                              notification
                                  .dragDetails
                                  ?.velocity
                                  .pixelsPerSecond
                                  .dy ??
                              0,
                        );
                        return true;
                      }

                      return false;
                    },
                    child: Listener(
                      behavior: HitTestBehavior.translucent,
                      onPointerMove: (event) {
                        if (!isScrollEdgeDragging) return;
                        final delta = event.delta.dy;
                        if (delta == 0) return;
                        stickContentToDismissEdge();
                        setPanelState(() {
                          isPanelDragging = true;
                          rememberScrollEdgeDragSample(delta);
                          panelDragOffset = clampPanelDragOffset(
                            panelDragOffset + delta,
                          );
                        });
                      },
                      onPointerUp: (_) {
                        if (!isScrollEdgeDragging) return;
                        finishPanelDrag(
                          setPanelState,
                          velocity: estimateScrollEdgeDragVelocity(),
                        );
                      },
                      onPointerCancel: (_) {
                        if (!isScrollEdgeDragging) return;
                        cancelPanelDrag(setPanelState);
                      },
                      child: SingleChildScrollView(
                        controller: scrollController,
                        physics: scrollPhysics,
                        padding: EdgeInsets.only(bottom: scrollBottomPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [headerSection, body],
                        ),
                      ),
                    ),
                  ),
                );

            final scrollViewport = Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(child: scrollableContent),
                if (scrollShadow != HeroUiDrawerScrollShadowVariant.off)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: AnimatedOpacity(
                      opacity: showTopShadow ? 1 : 0,
                      duration: _kScrollShadowFadeDuration,
                      curve: Curves.easeOutCubic,
                      child: buildEdgeScrollShadow(fromTop: true),
                    ),
                  ),
                if (scrollShadow != HeroUiDrawerScrollShadowVariant.off)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: AnimatedOpacity(
                      opacity: showBottomShadow ? 1 : 0,
                      duration: _kScrollShadowFadeDuration,
                      curve: Curves.easeOutCubic,
                      child: buildEdgeScrollShadow(fromTop: false),
                    ),
                  ),
                if (hasFooter)
                  Positioned(
                    left: _kFooterHorizontalInset,
                    right: _kFooterHorizontalInset,
                    bottom: footerBottomInset,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (var i = 0; i < footerWidgets.length; i++) ...[
                          if (i > 0) const SizedBox(width: 10),
                          footerWidgets[i],
                        ],
                      ],
                    ),
                  ),
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
                        if (showHandle &&
                            resolvedPosition == HeroUiDrawerPosition.bottom)
                          buildHandle(margin: const EdgeInsets.only(top: 1)),
                        Flexible(fit: FlexFit.loose, child: scrollViewport),
                        if (showHandle &&
                            resolvedPosition == HeroUiDrawerPosition.top)
                          buildHandle(
                            margin: const EdgeInsets.only(bottom: 10),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );

            final mh = maxHeightFraction;
            if (mh != null) {
              final availableHeight = media.size.height;
              panel = ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: math.max(0, availableHeight) * mh,
                ),
                child: panel,
              );
            }

            panel = SlideTransition(position: slideAnim, child: panel);

            if (showHandle) {
              panel = AnimatedContainer(
                duration: isPanelDragging
                    ? Duration.zero
                    : const Duration(milliseconds: 180),
                curve: Curves.easeOutCubic,
                transform: Matrix4.translationValues(0, panelDragOffset, 0),
                child: panel,
              );
            }

            // showGeneralDialog does not insert Material; TextField and other
            // material widgets require a Material ancestor.
            return Material(
              type: MaterialType.transparency,
              child: Padding(
                padding: EdgeInsets.zero,
                child: Align(
                  alignment: switch (resolvedPosition) {
                    HeroUiDrawerPosition.right => Alignment.centerRight,
                    HeroUiDrawerPosition.left => Alignment.centerLeft,
                    HeroUiDrawerPosition.bottom => Alignment.bottomCenter,
                    HeroUiDrawerPosition.top => Alignment.topCenter,
                  },
                  child: SafeArea(
                    top: resolvedPosition != HeroUiDrawerPosition.top,
                    bottom: resolvedPosition != HeroUiDrawerPosition.bottom,
                    child: isVertical
                        ? SizedBox(width: resolvedSize, child: panel)
                        : SizedBox(width: double.infinity, child: panel),
                  ),
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(scrollController.dispose);
  }
}
