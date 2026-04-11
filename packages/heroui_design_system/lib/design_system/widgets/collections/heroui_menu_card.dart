part of 'heroui_collections.dart';

/// One row inside [HeroUiMenuCard]: optional leading, title, optional subtitle,
/// optional trailing. [onTap] null → row is non-interactive.
class HeroUiMenuItem {
  const HeroUiMenuItem({
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
}

/// Grouped list in an [HeroUiCard], iOS Settings–style: rows and inset dividers.
class HeroUiMenuCard extends StatelessWidget {
  const HeroUiMenuCard({
    super.key,
    required this.items,
    this.borderRadius,
    this.showShadow = true,
    this.surfaceVariant = HeroUiSurfaceVariant.defaultVariant,
    this.backgroundColor,
    this.borderColor,
  });

  final List<HeroUiMenuItem> items;
  final double? borderRadius;
  final bool showShadow;
  final HeroUiSurfaceVariant surfaceVariant;
  final Color? backgroundColor;
  final Color? borderColor;

  static const double _horizontalPadding = 16;
  static const double _verticalPadding = 14;
  static const double _leadingSize = 32;
  static const double _leadingGap = 12;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    final useLeadingColumn = items.any((e) => e.leading != null);
    final dividerIndent =
        _horizontalPadding +
        (useLeadingColumn ? _leadingSize + _leadingGap : 0);

    final primaryText = Theme.of(context).colorScheme.onSurface;
    final secondaryText = Theme.of(context).colorScheme.onSurfaceVariant;

    return HeroUiCard(
      padding: EdgeInsets.zero,
      borderRadius: borderRadius ?? 24,
      showShadow: showShadow,
      surfaceVariant: surfaceVariant,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0)
              Padding(
                padding: EdgeInsets.only(
                  left: dividerIndent,
                  right: _horizontalPadding,
                ),
                child: const HeroUiSeparator(
                  variant: HeroUiSeparatorVariant.primary,
                ),
              ),
            _HeroUiMenuRow(
              item: items[i],
              useLeadingColumn: useLeadingColumn,
              primaryText: primaryText,
              secondaryText: secondaryText,
              cardBorderRadius: borderRadius ?? 24,
              rowIndex: i,
              rowCount: items.length,
            ),
          ],
        ],
      ),
    );
  }
}

class _HeroUiMenuRow extends StatelessWidget {
  const _HeroUiMenuRow({
    required this.item,
    required this.useLeadingColumn,
    required this.primaryText,
    required this.secondaryText,
    required this.cardBorderRadius,
    required this.rowIndex,
    required this.rowCount,
  });

  final HeroUiMenuItem item;
  final bool useLeadingColumn;
  final Color primaryText;
  final Color secondaryText;
  final double cardBorderRadius;
  final int rowIndex;
  final int rowCount;

  @override
  Widget build(BuildContext context) {
    final paddedRow = _HeroUiMenuRowContent(
      item: item,
      useLeadingColumn: useLeadingColumn,
      primaryText: primaryText,
      secondaryText: secondaryText,
    );

    if (item.onTap == null) {
      return MergeSemantics(
        child: Semantics(label: item.title, child: paddedRow),
      );
    }

    return _HeroUiMenuInteractiveRow(
      item: item,
      cardBorderRadius: cardBorderRadius,
      rowIndex: rowIndex,
      rowCount: rowCount,
      child: paddedRow,
    );
  }
}

class _HeroUiMenuRowContent extends StatelessWidget {
  const _HeroUiMenuRowContent({
    required this.item,
    required this.useLeadingColumn,
    required this.primaryText,
    required this.secondaryText,
  });

  final HeroUiMenuItem item;
  final bool useLeadingColumn;
  final Color primaryText;
  final Color secondaryText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: HeroUiMenuCard._horizontalPadding,
        vertical: HeroUiMenuCard._verticalPadding,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (useLeadingColumn) ...[
            SizedBox(
              width: HeroUiMenuCard._leadingSize,
              height: HeroUiMenuCard._leadingSize,
              child: Center(child: item.leading ?? const SizedBox.shrink()),
            ),
            const SizedBox(width: HeroUiMenuCard._leadingGap),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  item.title,
                  style: HeroUiTypography.bodyXs.copyWith(
                    height: 1,
                    color: primaryText,
                  ),
                ),
                if (item.subtitle != null && item.subtitle!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    item.subtitle!,
                    style: HeroUiTypography.bodyXxs.copyWith(
                      color: secondaryText,
                      height: 1,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (item.trailing != null) ...[
            const SizedBox(width: 8),
            item.trailing!,
          ],
        ],
      ),
    );
  }
}

class _HeroUiMenuInteractiveRow extends StatefulWidget {
  const _HeroUiMenuInteractiveRow({
    required this.item,
    required this.child,
    required this.cardBorderRadius,
    required this.rowIndex,
    required this.rowCount,
  });

  final HeroUiMenuItem item;
  final Widget child;
  final double cardBorderRadius;
  final int rowIndex;
  final int rowCount;

  @override
  State<_HeroUiMenuInteractiveRow> createState() =>
      _HeroUiMenuInteractiveRowState();
}

class _HeroUiMenuInteractiveRowState extends State<_HeroUiMenuInteractiveRow> {
  bool _hovering = false;
  bool _pressed = false;

  HeroUiSurfaceVariant get _backgroundVariant {
    if (_pressed) {
      return HeroUiSurfaceVariant.tertiary;
    }
    if (_hovering) {
      return HeroUiSurfaceVariant.secondary;
    }
    return HeroUiSurfaceVariant.transparent;
  }

  BorderRadius get _rowRadius {
    final r = widget.cardBorderRadius;
    final first = widget.rowIndex == 0;
    final last = widget.rowIndex == widget.rowCount - 1;
    if (first && last) {
      return BorderRadius.circular(r);
    }
    if (first) {
      return BorderRadius.only(
        topLeft: Radius.circular(r),
        topRight: Radius.circular(r),
      );
    }
    if (last) {
      return BorderRadius.only(
        bottomLeft: Radius.circular(r),
        bottomRight: Radius.circular(r),
      );
    }
    return BorderRadius.zero;
  }

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Semantics(
        button: true,
        label: widget.item.subtitle != null && widget.item.subtitle!.isNotEmpty
            ? '${widget.item.title}, ${widget.item.subtitle}'
            : widget.item.title,
        child: MouseRegion(
          onEnter: (_) => setState(() => _hovering = true),
          onExit: (_) => setState(() => _hovering = false),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: widget.item.onTap,
              onTapDown: (_) => setState(() => _pressed = true),
              onTapUp: (_) => setState(() => _pressed = false),
              onTapCancel: () => setState(() => _pressed = false),
              splashFactory: NoSplash.splashFactory,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              focusColor: Colors.transparent,
              customBorder: RoundedRectangleBorder(borderRadius: _rowRadius),
              child: ClipRRect(
                borderRadius: _rowRadius,
                child: HeroUiSurface(
                  variant: _backgroundVariant,
                  showShadow: false,
                  borderRadius: 0,
                  child: widget.child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
