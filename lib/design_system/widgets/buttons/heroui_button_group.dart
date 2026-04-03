part of 'heroui_buttons.dart';

class HeroUiButtonGroupItem {
  const HeroUiButtonGroupItem({
    required this.label,
    this.onPressed,
    this.leading,
    this.trailing,
    this.iconOnly = false,
    this.variant,
    this.state,
  });
  final String label;
  final VoidCallback? onPressed;
  final Widget? leading;
  final Widget? trailing;
  final bool iconOnly;
  final HeroUiButtonVariant? variant;
  final HeroUiButtonVisualState? state;
}

class HeroUiButtonGroup extends StatelessWidget {
  const HeroUiButtonGroup({
    super.key,
    this.items,
    this.children,
    this.size = HeroUiButtonSize.md,
    this.variant = HeroUiButtonVariant.primary,
    this.state = HeroUiButtonVisualState.defaultState,
    this.orientation = HeroUiButtonGroupOrientation.horizontal,
    this.width = HeroUiButtonGroupWidth.hug,
    this.spacing = 8,
    this.attached = true,
    this.hiddenDividerIndices = const <int>{},
  }) : assert(items != null || children != null);

  final List<HeroUiButtonGroupItem>? items;
  final List<Widget>? children;
  final HeroUiButtonSize size;
  final HeroUiButtonVariant variant;
  final HeroUiButtonVisualState state;
  final HeroUiButtonGroupOrientation orientation;
  final HeroUiButtonGroupWidth width;
  final double spacing;
  final bool attached;
  final Set<int> hiddenDividerIndices;

  @override
  Widget build(BuildContext context) {
    if (items == null) {
      final legacy = children ?? const <Widget>[];
      if (orientation == HeroUiButtonGroupOrientation.horizontal) {
        return Wrap(spacing: spacing, runSpacing: spacing, children: legacy);
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _withVerticalSpacing(legacy, spacing),
      );
    }

    final list = items!;
    final s = _size(size);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (!attached) {
      final detached = <Widget>[];
      for (final item in list) {
        Widget node = HeroUiButton(
          label: item.label,
          onPressed: item.onPressed,
          leading: item.leading,
          trailing: item.trailing,
          iconOnly: item.iconOnly,
          variant: item.variant ?? variant,
          size: size,
          state: item.state ?? state,
          expand:
              width == HeroUiButtonGroupWidth.fill &&
              orientation == HeroUiButtonGroupOrientation.horizontal,
        );
        if (width == HeroUiButtonGroupWidth.fill &&
            orientation == HeroUiButtonGroupOrientation.horizontal) {
          node = Expanded(child: node);
        }
        detached.add(node);
      }
      final detachedGroup =
          orientation == HeroUiButtonGroupOrientation.horizontal
          ? Row(
              mainAxisSize: width == HeroUiButtonGroupWidth.hug
                  ? MainAxisSize.min
                  : MainAxisSize.max,
              children: _withHorizontalSpacing(detached, spacing),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _withVerticalSpacing(detached, spacing),
            );
      return width == HeroUiButtonGroupWidth.fill &&
              orientation == HeroUiButtonGroupOrientation.horizontal
          ? SizedBox(width: double.infinity, child: detachedGroup)
          : detachedGroup;
    }

    final dividerColor = _groupDivider(variant, isDark: isDark);
    final nodes = <Widget>[];
    for (var i = 0; i < list.length; i++) {
      final item = list[i];
      final first = i == 0;
      final last = i == list.length - 1;
      final itemVariant = item.variant ?? variant;
      final itemState = item.state ?? state;
      Widget node = HeroUiButton(
        label: item.label,
        onPressed: item.onPressed,
        leading: item.leading,
        trailing: item.trailing,
        iconOnly: item.iconOnly,
        variant: itemVariant,
        size: size,
        state: itemState,
        expand:
            width == HeroUiButtonGroupWidth.fill &&
            orientation == HeroUiButtonGroupOrientation.horizontal,
        borderRadiusOverride: _segmentRadius(
          s.radius,
          orientation,
          first,
          last,
        ),
      );
      if (!first && !hiddenDividerIndices.contains(i)) {
        node = _ButtonGroupSegmentDivider(
          orientation: orientation,
          color: dividerColor,
          extent: s.divider,
          child: node,
        );
      }
      if (width == HeroUiButtonGroupWidth.fill &&
          orientation == HeroUiButtonGroupOrientation.horizontal) {
        node = Expanded(child: node);
      }
      nodes.add(node);
    }

    final grouped = orientation == HeroUiButtonGroupOrientation.horizontal
        ? Row(
            mainAxisSize: width == HeroUiButtonGroupWidth.hug
                ? MainAxisSize.min
                : MainAxisSize.max,
            children: nodes,
          )
        : Column(crossAxisAlignment: CrossAxisAlignment.start, children: nodes);
    return width == HeroUiButtonGroupWidth.fill &&
            orientation == HeroUiButtonGroupOrientation.horizontal
        ? SizedBox(width: double.infinity, child: grouped)
        : grouped;
  }
}
