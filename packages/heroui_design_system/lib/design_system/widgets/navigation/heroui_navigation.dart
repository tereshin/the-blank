import 'package:flutter/material.dart';

import 'heroui_tabs.dart';

/// Vertical navigation variant extracted from [HeroUiTabs].
///
/// Uses vertical label layout and keeps active indicator drag behavior.
class HeroUiNavigation extends StatelessWidget {
  const HeroUiNavigation({
    required this.tabs,
    super.key,
    this.initialIndex = 0,
    this.variant = HeroUiTabsVariant.primary,
    this.behavior = HeroUiTabsBehavior.hug,
    this.showScrollShadow = true,
    this.showScrollButtons = false,
    this.showOptions,
    this.showPanel = true,
    this.panelHeight = 260,
    this.panelPadding = const EdgeInsets.all(3),
    this.enableSwipeSelection = true,
    this.onChanged,
  });

  final List<HeroUiTabItem> tabs;
  final int initialIndex;
  final HeroUiTabsVariant variant;
  final HeroUiTabsBehavior behavior;
  final bool showScrollShadow;
  final bool showScrollButtons;
  final List<bool>? showOptions;
  final bool showPanel;
  final double? panelHeight;
  final EdgeInsetsGeometry panelPadding;
  final bool enableSwipeSelection;
  final ValueChanged<int>? onChanged;

  @override
  Widget build(BuildContext context) {
    return HeroUiTabs(
      tabs: tabs,
      initialIndex: initialIndex,
      variant: variant,
      behavior: behavior,
      tabContentOrientation: HeroUiTabContentOrientation.vertical,
      showScrollShadow: showScrollShadow,
      showScrollButtons: showScrollButtons,
      showOptions: showOptions,
      showPanel: showPanel,
      panelHeight: panelHeight,
      panelPadding: panelPadding,
      enableSwipeSelection: enableSwipeSelection,
      onChanged: onChanged,
    );
  }
}
