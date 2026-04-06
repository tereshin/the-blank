import 'package:flutter/material.dart';

/// App shell similar to [Scaffold], but the app bar and bottom navigation
/// float above the body with margins and rounded corners (iOS-style chrome).
class HeroUiShell extends StatelessWidget {
  const HeroUiShell({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.backgroundColor,
    this.resizeToAvoidBottomInset = true,
    this.floatingMargin = 12,
    this.barBorderRadius = 20,
    this.barElevation = 3,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;
  final bool resizeToAvoidBottomInset;
  final double floatingMargin;
  final double barBorderRadius;
  final double barElevation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);
    final bg = backgroundColor ?? theme.scaffoldBackgroundColor;
    final keyboardBottom =
        resizeToAvoidBottomInset ? media.viewInsets.bottom : 0.0;
    final topSafe = media.padding.top;
    final bottomSafe = media.padding.bottom;
    final appBarHeight = appBar?.preferredSize.height ?? 0.0;

    return ColoredBox(
      color: bg,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: keyboardBottom > 0
                ? Padding(
                    padding: EdgeInsets.only(bottom: keyboardBottom),
                    child: body,
                  )
                : body,
          ),
          if (appBar != null)
            Positioned(
              top: topSafe + floatingMargin,
              left: floatingMargin,
              right: floatingMargin,
              child: Material(
                elevation: barElevation,
                shadowColor: Colors.black26,
                color:
                    theme.appBarTheme.backgroundColor ??
                    theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(barBorderRadius),
                clipBehavior: Clip.antiAlias,
                child: SizedBox(
                  height: appBarHeight,
                  width: double.infinity,
                  child: appBar,
                ),
              ),
            ),
          if (bottomNavigationBar != null)
            Positioned(
              left: floatingMargin,
              right: floatingMargin,
              bottom: bottomSafe + floatingMargin + keyboardBottom,
              child: Material(
                elevation: barElevation,
                shadowColor: Colors.black26,
                color:
                    theme.bottomNavigationBarTheme.backgroundColor ??
                    theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(barBorderRadius),
                clipBehavior: Clip.antiAlias,
                child: bottomNavigationBar,
              ),
            ),
        ],
      ),
    );
  }
}
