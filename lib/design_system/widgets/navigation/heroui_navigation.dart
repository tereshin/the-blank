import 'package:flutter/material.dart';

import '../buttons/heroui_buttons.dart';

class HeroUiLink extends StatelessWidget {
  const HeroUiLink({
    required this.label,
    super.key,
    this.onTap,
    this.leading,
    this.trailing,
  });

  final String label;
  final VoidCallback? onTap;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    final disabledColor = Theme.of(context).colorScheme.onSurfaceVariant;
    final resolvedColor = onTap == null ? disabledColor : color;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leading != null) ...[
              IconTheme.merge(
                data: IconThemeData(size: 16, color: resolvedColor),
                child: leading!,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: resolvedColor,
                decoration: TextDecoration.underline,
                decorationColor: resolvedColor,
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 6),
              IconTheme.merge(
                data: IconThemeData(size: 16, color: resolvedColor),
                child: trailing!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class HeroUiBreadcrumbItem {
  const HeroUiBreadcrumbItem({required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;
}

class HeroUiBreadcrumbs extends StatelessWidget {
  const HeroUiBreadcrumbs({
    required this.items,
    super.key,
    this.separator = const Icon(Icons.chevron_right_rounded, size: 16),
  });

  final List<HeroUiBreadcrumbItem> items;
  final Widget separator;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 6,
      children: [
        for (var index = 0; index < items.length; index++) ...[
          if (index > 0) separator,
          HeroUiLink(label: items[index].label, onTap: items[index].onTap),
        ],
      ],
    );
  }
}

class HeroUiPagination extends StatelessWidget {
  const HeroUiPagination({
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
    super.key,
    this.windowSize = 5,
  }) : assert(totalPages > 0, 'totalPages must be greater than zero');

  final int currentPage;
  final int totalPages;
  final ValueChanged<int>? onPageChanged;
  final int windowSize;

  @override
  Widget build(BuildContext context) {
    final start = (currentPage - (windowSize ~/ 2)).clamp(1, totalPages);
    final end = (start + windowSize - 1).clamp(1, totalPages);
    final adjustedStart = (end - windowSize + 1).clamp(1, totalPages);
    final pages = [for (var page = adjustedStart; page <= end; page++) page];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        HeroUiButton(
          label: 'Previous',
          variant: HeroUiButtonVariant.secondary,
          size: HeroUiButtonSize.sm,
          leading: const Icon(Icons.chevron_left_rounded),
          onPressed: onPageChanged == null || currentPage <= 1
              ? null
              : () => onPageChanged!(currentPage - 1),
        ),
        for (final page in pages)
          HeroUiButton(
            label: '$page',
            iconOnly: false,
            size: HeroUiButtonSize.sm,
            variant: page == currentPage
                ? HeroUiButtonVariant.primary
                : HeroUiButtonVariant.secondary,
            onPressed: onPageChanged == null
                ? null
                : () => onPageChanged!(page),
          ),
        HeroUiButton(
          label: 'Next',
          variant: HeroUiButtonVariant.secondary,
          size: HeroUiButtonSize.sm,
          trailing: const Icon(Icons.chevron_right_rounded),
          onPressed: onPageChanged == null || currentPage >= totalPages
              ? null
              : () => onPageChanged!(currentPage + 1),
        ),
      ],
    );
  }
}

class HeroUiTabItem {
  const HeroUiTabItem({
    required this.label,
    required this.child,
    this.icon,
    this.leading,
    this.trailing,
    this.isDisabled = false,
  });

  final String label;
  final Widget child;
  final IconData? icon;
  final Widget? leading;
  final Widget? trailing;
  final bool isDisabled;
}

enum HeroUiTabsVariant { primary, secondary }

enum HeroUiTabsBehavior { hug, fill }

enum HeroUiTabContentOrientation { horizontal, vertical }

class HeroUiTabs extends StatefulWidget {
  const HeroUiTabs({
    required this.tabs,
    super.key,
    this.initialIndex = 0,
    this.variant = HeroUiTabsVariant.primary,
    this.behavior = HeroUiTabsBehavior.hug,
    this.tabContentOrientation = HeroUiTabContentOrientation.horizontal,
    this.showScrollShadow = true,
    this.showScrollButtons,
    this.showOptions,
    this.showPanel = true,
    this.panelHeight = 200,
    this.panelPadding = const EdgeInsets.all(12),
    this.onChanged,
  }) : assert(tabs.length > 0, 'tabs cannot be empty');

  final List<HeroUiTabItem> tabs;
  final int initialIndex;
  final HeroUiTabsVariant variant;
  final HeroUiTabsBehavior behavior;
  final HeroUiTabContentOrientation tabContentOrientation;
  final bool showScrollShadow;
  final bool? showScrollButtons;
  final List<bool>? showOptions;
  final bool showPanel;
  final double? panelHeight;
  final EdgeInsetsGeometry panelPadding;
  final ValueChanged<int>? onChanged;

  @override
  State<HeroUiTabs> createState() => _HeroUiTabsState();
}

class _HeroUiTabsState extends State<HeroUiTabs> {
  static const Duration _kAnimationDuration = Duration(milliseconds: 180);

  late int _selectedIndex;
  late final ScrollController _scrollController;
  late List<GlobalKey> _tabKeys;
  bool _canScrollBack = false;
  bool _canScrollForward = false;

  @override
  void initState() {
    super.initState();
    _selectedIndex = _resolveInitialIndex(widget.initialIndex);
    _scrollController = ScrollController()..addListener(_syncScrollState);
    _tabKeys = _buildTabKeys(widget.tabs.length);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _syncScrollState();
      _ensureSelectedTabVisible(jump: true);
    });
  }

  @override
  void didUpdateWidget(covariant HeroUiTabs oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.tabs.length != oldWidget.tabs.length) {
      _tabKeys = _buildTabKeys(widget.tabs.length);
      _selectedIndex = _selectedIndex.clamp(0, widget.tabs.length - 1).toInt();
      _selectedIndex = _resolveEnabledIndex(_selectedIndex);
    } else if (_selectedIndex >= widget.tabs.length) {
      _selectedIndex = widget.tabs.length - 1;
    }

    if (oldWidget.initialIndex != widget.initialIndex) {
      _selectedIndex = _resolveEnabledIndex(
        widget.initialIndex.clamp(0, widget.tabs.length - 1).toInt(),
      );
    }
    _selectedIndex = _resolveEnabledIndex(_selectedIndex);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _syncScrollState();
      _ensureSelectedTabVisible(jump: true);
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_syncScrollState)
      ..dispose();
    super.dispose();
  }

  List<GlobalKey> _buildTabKeys(int count) {
    return List<GlobalKey>.generate(count, (_) => GlobalKey(), growable: false);
  }

  bool _isOptionVisible(int index) {
    final visibility = widget.showOptions;
    if (visibility == null || index >= visibility.length) return true;
    return visibility[index];
  }

  bool _isOptionSelectable(int index) {
    return _isOptionVisible(index) && !widget.tabs[index].isDisabled;
  }

  List<int> _visibleTabIndices() {
    final out = <int>[];
    for (var i = 0; i < widget.tabs.length; i++) {
      if (_isOptionVisible(i)) out.add(i);
    }
    if (out.isEmpty) out.add(0);
    return out;
  }

  int _resolveInitialIndex(int preferred) {
    final clamped = preferred.clamp(0, widget.tabs.length - 1).toInt();
    return _resolveEnabledIndex(clamped);
  }

  int _resolveEnabledIndex(int index) {
    if (_isOptionSelectable(index)) return index;
    for (var i = 0; i < widget.tabs.length; i++) {
      if (_isOptionSelectable(i)) return i;
    }
    for (var i = 0; i < widget.tabs.length; i++) {
      if (_isOptionVisible(i)) return i;
    }
    return 0;
  }

  void _onSelect(int index) {
    if (!_isOptionSelectable(index) || index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
    widget.onChanged?.call(index);
    _ensureSelectedTabVisible();
  }

  void _ensureSelectedTabVisible({bool jump = false}) {
    if (widget.behavior != HeroUiTabsBehavior.hug ||
        !_scrollController.hasClients) {
      return;
    }
    final context = _tabKeys[_selectedIndex].currentContext;
    if (context == null) return;
    Scrollable.ensureVisible(
      context,
      duration: jump ? Duration.zero : _kAnimationDuration,
      curve: Curves.easeOutCubic,
      alignment: 0.5,
    );
  }

  void _syncScrollState() {
    if (widget.behavior != HeroUiTabsBehavior.hug ||
        !_scrollController.hasClients) {
      if (_canScrollBack || _canScrollForward) {
        setState(() {
          _canScrollBack = false;
          _canScrollForward = false;
        });
      }
      return;
    }

    final position = _scrollController.position;
    final canBack = position.pixels > 0.5;
    final canForward = position.maxScrollExtent - position.pixels > 0.5;
    if (canBack == _canScrollBack && canForward == _canScrollForward) return;
    if (!mounted) return;
    setState(() {
      _canScrollBack = canBack;
      _canScrollForward = canForward;
    });
  }

  void _scrollBy(double delta) {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    final target = (_scrollController.offset + delta).clamp(
      0.0,
      position.maxScrollExtent,
    );
    _scrollController.animateTo(
      target.toDouble(),
      duration: _kAnimationDuration,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tokens = _tabsTokens(variant: widget.variant, isDark: isDark);
    final header = _buildHeader(tokens);

    final children = <Widget>[header];
    if (widget.showPanel) {
      Widget panel = Padding(
        padding: widget.panelPadding,
        child: IndexedStack(
          index: _selectedIndex,
          children: [for (final item in widget.tabs) item.child],
        ),
      );
      if (widget.panelHeight != null) {
        panel = SizedBox(
          width: double.infinity,
          height: widget.panelHeight,
          child: panel,
        );
      } else {
        panel = SizedBox(width: double.infinity, child: panel);
      }
      children
        ..add(const SizedBox(height: 12))
        ..add(panel);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  Widget _buildHeader(_HeroUiTabsTokens tokens) {
    Widget tabStrip = _buildTabStrip(tokens);
    final shouldShowOverflowAffordance =
        widget.showScrollButtons ?? widget.showScrollShadow;

    final showScrollAffordance =
        shouldShowOverflowAffordance &&
        widget.behavior == HeroUiTabsBehavior.hug &&
        widget.variant == HeroUiTabsVariant.primary &&
        (_canScrollBack || _canScrollForward);

    if (showScrollAffordance) {
      final transparent = tokens.stripBackground.withValues(alpha: 0);
      tabStrip = Stack(
        children: [
          tabStrip,
          if (_canScrollBack)
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              child: IgnorePointer(
                child: Container(
                  width: 64,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [tokens.stripBackground, transparent],
                    ),
                  ),
                ),
              ),
            ),
          if (_canScrollForward)
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              child: IgnorePointer(
                child: Container(
                  width: 64,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [transparent, tokens.stripBackground],
                    ),
                  ),
                ),
              ),
            ),
          if (_canScrollBack)
            Positioned(
              top: 0,
              bottom: 0,
              left: 4,
              child: Center(
                child: _HeroUiTabsScrollButton(
                  icon: Icons.chevron_left_rounded,
                  color: tokens.scrollIcon,
                  onTap: () => _scrollBy(-120),
                ),
              ),
            ),
          if (_canScrollForward)
            Positioned(
              top: 0,
              bottom: 0,
              right: 4,
              child: Center(
                child: _HeroUiTabsScrollButton(
                  icon: Icons.chevron_right_rounded,
                  color: tokens.scrollIcon,
                  onTap: () => _scrollBy(120),
                ),
              ),
            ),
        ],
      );
    }

    Widget header = switch (widget.variant) {
      HeroUiTabsVariant.primary => ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: tokens.stripBackground,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: tabStrip,
          ),
        ),
      ),
      HeroUiTabsVariant.secondary => DecoratedBox(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: tokens.stripBorder)),
        ),
        child: tabStrip,
      ),
    };

    if (widget.behavior == HeroUiTabsBehavior.fill) {
      header = SizedBox(width: double.infinity, child: header);
    }
    return header;
  }

  Widget _buildTabStrip(_HeroUiTabsTokens tokens) {
    final visibleIndices = _visibleTabIndices();

    if (widget.behavior == HeroUiTabsBehavior.fill) {
      final expandedChildren = <Widget>[];
      for (var i = 0; i < visibleIndices.length; i++) {
        final sourceIndex = visibleIndices[i];
        if (i > 0 && widget.variant == HeroUiTabsVariant.primary) {
          expandedChildren.add(const SizedBox(width: 2));
        }
        expandedChildren.add(
          Expanded(child: _buildTabButton(sourceIndex, tokens)),
        );
      }
      return Row(children: expandedChildren);
    }

    final tabButtons = <Widget>[];
    for (var i = 0; i < visibleIndices.length; i++) {
      final sourceIndex = visibleIndices[i];
      if (i > 0 && widget.variant == HeroUiTabsVariant.primary) {
        tabButtons.add(const SizedBox(width: 2));
      }
      tabButtons.add(_buildTabButton(sourceIndex, tokens));
    }

    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(mainAxisSize: MainAxisSize.min, children: tabButtons),
    );
  }

  Widget _buildTabButton(int index, _HeroUiTabsTokens tokens) {
    final item = widget.tabs[index];
    final selected = _selectedIndex == index;
    final disabled = item.isDisabled;
    final isPrimary = widget.variant == HeroUiTabsVariant.primary;
    final isVertical =
        widget.tabContentOrientation == HeroUiTabContentOrientation.vertical;
    final useFilledPrimary = isPrimary && !isVertical;
    final useUnderlineIndicator = !isPrimary || isVertical;

    final textColor = selected ? tokens.selectedText : tokens.text;
    final borderRadius = isPrimary
        ? BorderRadius.circular(useFilledPrimary && selected ? 24 : 20)
        : BorderRadius.zero;
    final decoration = BoxDecoration(
      color: isPrimary
          ? (useFilledPrimary && selected
                ? tokens.selectedBackground
                : tokens.tabBackground)
          : Colors.transparent,
      borderRadius: borderRadius,
      boxShadow: isPrimary && useFilledPrimary && selected
          ? const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.06),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ]
          : null,
      border: useUnderlineIndicator
          ? Border(
              bottom: BorderSide(
                color: selected ? tokens.indicator : Colors.transparent,
                width: 2,
              ),
            )
          : null,
    );

    final padding = switch ((widget.variant, widget.tabContentOrientation)) {
      (HeroUiTabsVariant.primary, HeroUiTabContentOrientation.horizontal) =>
        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      (HeroUiTabsVariant.primary, HeroUiTabContentOrientation.vertical) =>
        const EdgeInsets.all(12),
      (HeroUiTabsVariant.secondary, HeroUiTabContentOrientation.horizontal) =>
        const EdgeInsets.fromLTRB(12, 4, 12, 6),
      (HeroUiTabsVariant.secondary, HeroUiTabContentOrientation.vertical) =>
        const EdgeInsets.fromLTRB(12, 8, 12, 12),
    };

    Widget button = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: disabled ? null : () => _onSelect(index),
        splashFactory: NoSplash.splashFactory,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        focusColor: Colors.transparent,
        borderRadius: borderRadius,
        child: AnimatedContainer(
          key: _tabKeys[index],
          duration: _kAnimationDuration,
          curve: Curves.easeOutCubic,
          constraints: BoxConstraints(minHeight: isVertical ? 78 : 32),
          padding: padding,
          decoration: decoration,
          child: _buildTabLabel(item, textColor),
        ),
      ),
    );

    if (disabled) button = Opacity(opacity: 0.5, child: button);
    return button;
  }

  Widget _buildTabLabel(HeroUiTabItem item, Color color) {
    final leading =
        item.leading ?? (item.icon == null ? null : Icon(item.icon, size: 16));
    final isVertical =
        widget.tabContentOrientation == HeroUiTabContentOrientation.vertical;
    final textStyle = TextStyle(
      fontFamily: 'Inter',
      fontWeight: FontWeight.w500,
      fontSize: isVertical ? 12 : 14,
      height: isVertical ? 1.34 : 1.43,
      color: color,
    );

    if (isVertical) {
      return IconTheme.merge(
        data: IconThemeData(size: 16, color: color),
        child: DefaultTextStyle(
          style: textStyle,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leading != null) ...[leading, const SizedBox(height: 6)],
              Text(
                item.label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              if (item.trailing != null) ...[
                const SizedBox(height: 6),
                item.trailing!,
              ],
            ],
          ),
        ),
      );
    }

    final text = Text(item.label, maxLines: 1, overflow: TextOverflow.ellipsis);
    final textNode = widget.behavior == HeroUiTabsBehavior.fill
        ? Expanded(child: Center(child: text))
        : text;

    return IconTheme.merge(
      data: IconThemeData(size: 16, color: color),
      child: DefaultTextStyle(
        style: textStyle,
        child: Row(
          mainAxisSize: widget.behavior == HeroUiTabsBehavior.fill
              ? MainAxisSize.max
              : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leading != null) ...[leading, const SizedBox(width: 6)],
            textNode,
            if (item.trailing != null) ...[
              const SizedBox(width: 6),
              item.trailing!,
            ],
          ],
        ),
      ),
    );
  }
}

class _HeroUiTabsTokens {
  const _HeroUiTabsTokens({
    required this.stripBackground,
    required this.tabBackground,
    required this.selectedBackground,
    required this.text,
    required this.selectedText,
    required this.stripBorder,
    required this.indicator,
    required this.scrollIcon,
  });

  final Color stripBackground;
  final Color tabBackground;
  final Color selectedBackground;
  final Color text;
  final Color selectedText;
  final Color stripBorder;
  final Color indicator;
  final Color scrollIcon;
}

_HeroUiTabsTokens _tabsTokens({
  required HeroUiTabsVariant variant,
  required bool isDark,
}) {
  if (!isDark) {
    return switch (variant) {
      HeroUiTabsVariant.primary => const _HeroUiTabsTokens(
        stripBackground: Color(0xFFEBEBEC),
        tabBackground: Color(0xFFEFEFF0),
        selectedBackground: Color(0xFFFFFFFF),
        text: Color(0xFF71717A),
        selectedText: Color(0xFF18181B),
        stripBorder: Color(0xFFDEDEE0),
        indicator: Color(0xFF0485F7),
        scrollIcon: Color(0xFF71717A),
      ),
      HeroUiTabsVariant.secondary => const _HeroUiTabsTokens(
        stripBackground: Colors.transparent,
        tabBackground: Colors.transparent,
        selectedBackground: Colors.transparent,
        text: Color(0xFF71717A),
        selectedText: Color(0xFF18181B),
        stripBorder: Color(0xFFDEDEE0),
        indicator: Color(0xFF0485F7),
        scrollIcon: Color(0xFF71717A),
      ),
    };
  }

  return switch (variant) {
    HeroUiTabsVariant.primary => const _HeroUiTabsTokens(
      stripBackground: Color(0xFF27272A),
      tabBackground: Color(0xFF232325),
      selectedBackground: Color(0xFF46464C),
      text: Color(0xFFA1A1AA),
      selectedText: Color(0xFFFCFCFC),
      stripBorder: Color(0xFF28282C),
      indicator: Color(0xFF0485F7),
      scrollIcon: Color(0xFFA1A1AA),
    ),
    HeroUiTabsVariant.secondary => const _HeroUiTabsTokens(
      stripBackground: Colors.transparent,
      tabBackground: Colors.transparent,
      selectedBackground: Colors.transparent,
      text: Color(0xFFA1A1AA),
      selectedText: Color(0xFFFCFCFC),
      stripBorder: Color(0xFF28282C),
      indicator: Color(0xFF0485F7),
      scrollIcon: Color(0xFFA1A1AA),
    ),
  };
}

class _HeroUiTabsScrollButton extends StatelessWidget {
  const _HeroUiTabsScrollButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        splashFactory: NoSplash.splashFactory,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        focusColor: Colors.transparent,
        child: SizedBox(
          width: 24,
          height: 24,
          child: Icon(icon, size: 16, color: color),
        ),
      ),
    );
  }
}

class HeroUiToolbar extends StatelessWidget {
  const HeroUiToolbar({
    required this.actions,
    super.key,
    this.leading,
    this.title,
  });

  final Widget? leading;
  final Widget? title;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            ...?switch (leading) {
              final Widget leadingWidget => [
                leadingWidget,
                const SizedBox(width: 10),
              ],
              null => null,
            },
            ...switch (title) {
              final Widget titleWidget => [
                Expanded(
                  child: DefaultTextStyle(
                    style:
                        Theme.of(context).textTheme.titleSmall ??
                        const TextStyle(),
                    child: titleWidget,
                  ),
                ),
              ],
              null => [const Spacer()],
            },
            Wrap(spacing: 8, runSpacing: 8, children: actions),
          ],
        ),
      ),
    );
  }
}
