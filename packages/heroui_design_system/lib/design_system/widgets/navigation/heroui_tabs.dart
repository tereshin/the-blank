import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../icons/heroui_icon.dart';
import '../../typography/heroui_typography.dart';

/// Single tab in the list ([HeroUiTabs]), matching Figma **TabsElement**: label,
/// interactive state, optional prefix ([leading]) / suffix ([trailing]) icons.
class HeroUiTabItem {
  const HeroUiTabItem({
    required this.label,
    required this.child,
    this.leading,
    this.trailing,
    this.isDisabled = false,
  });

  final String label;
  final Widget child;
  final Widget? leading;
  final Widget? trailing;
  final bool isDisabled;
}

enum HeroUiTabsVariant { primary, secondary }

enum HeroUiTabsBehavior { hug, fill }

enum HeroUiTabContentOrientation { horizontal, vertical }

/// Tabs bar + optional panel, aligned with HeroUI v3 / Figma **Tabs**:
/// [variant] primary (filled selected state) vs secondary (underline selected state);
/// [behavior] hug vs fill; optional horizontal
/// [showScrollShadow] when the list overflows; [showOptions] toggles tab 1…N visibility.
class HeroUiTabs extends StatefulWidget {
  const HeroUiTabs({
    required this.tabs,
    super.key,
    this.initialIndex = 0,
    this.variant = HeroUiTabsVariant.primary,
    this.behavior = HeroUiTabsBehavior.hug,
    this.tabContentOrientation = HeroUiTabContentOrientation.horizontal,
    this.showScrollShadow = true,
    this.showScrollButtons = false,
    this.showOptions,
    this.showPanel = true,
    this.panelHeight = 200,
    this.panelPadding = const EdgeInsets.all(12),
    this.enableSwipeSelection = true,
    this.onChanged,
  }) : assert(tabs.length > 0, 'tabs cannot be empty');

  final List<HeroUiTabItem> tabs;
  final int initialIndex;
  final HeroUiTabsVariant variant;
  final HeroUiTabsBehavior behavior;
  final HeroUiTabContentOrientation tabContentOrientation;
  final bool showScrollShadow;

  /// Optional explicit override for chevrons when overflowing in hug mode.
  /// When [showScrollShadow] is true, chevrons are also shown for primary tabs
  /// to match the HeroUI Figma examples.
  final bool showScrollButtons;
  final List<bool>? showOptions;
  final bool showPanel;
  final double? panelHeight;
  final EdgeInsetsGeometry panelPadding;

  /// Enables long-press drag selection (press, hold, move, release).
  /// Disable when this gesture conflicts with horizontal scrolling.
  final bool enableSwipeSelection;

  final ValueChanged<int>? onChanged;

  @override
  State<HeroUiTabs> createState() => _HeroUiTabsState();
}

class _HeroUiTabsState extends State<HeroUiTabs> {
  static const Duration _kAnimationDuration = Duration(milliseconds: 180);
  static const double _kIndicatorHeight = 2;
  static const double _kRectEpsilon = 0.5;
  static const double _kSwipeTouchSlop = 18;

  late int _selectedIndex;
  late final ScrollController _scrollController;
  late List<GlobalKey> _tabKeys;
  final GlobalKey _stripKey = GlobalKey();
  Rect? _selectedIndicatorRect;
  bool _isIndicatorSyncScheduled = false;
  Timer? _swipeHoldTimer;
  int? _activeSwipePointer;
  Offset? _swipePointerDownPosition;
  bool _isSwipeSelectionActive = false;
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
      _scheduleIndicatorSync();
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
      _scheduleIndicatorSync();
    });
  }

  @override
  void dispose() {
    _cancelSwipeSelection();
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

  void _onSelect(int index, {bool emitHaptic = true}) {
    if (!_isOptionSelectable(index) || index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
    if (emitHaptic) {
      HapticFeedback.selectionClick();
    }
    widget.onChanged?.call(index);
    _ensureSelectedTabVisible();
    _scheduleIndicatorSync();
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

  void _scheduleIndicatorSync() {
    if (_isIndicatorSyncScheduled) return;
    _isIndicatorSyncScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isIndicatorSyncScheduled = false;
      if (!mounted) return;
      final nextRect = _measureSelectedTabRect();
      if (_sameRect(_selectedIndicatorRect, nextRect)) return;
      setState(() => _selectedIndicatorRect = nextRect);
    });
  }

  Rect? _measureSelectedTabRect() {
    final stripContext = _stripKey.currentContext;
    final tabContext = _tabKeys[_selectedIndex].currentContext;
    if (stripContext == null || tabContext == null) return null;

    final stripRenderObject = stripContext.findRenderObject();
    final tabRenderObject = tabContext.findRenderObject();
    if (stripRenderObject is! RenderBox || tabRenderObject is! RenderBox) {
      return null;
    }
    if (!stripRenderObject.hasSize || !tabRenderObject.hasSize) return null;

    final stripOffset = stripRenderObject.localToGlobal(Offset.zero);
    final tabOffset = tabRenderObject.localToGlobal(Offset.zero);
    final localOffset = tabOffset - stripOffset;
    return localOffset & tabRenderObject.size;
  }

  bool _sameRect(Rect? lhs, Rect? rhs) {
    if (identical(lhs, rhs)) return true;
    if (lhs == null || rhs == null) return false;
    return (lhs.left - rhs.left).abs() <= _kRectEpsilon &&
        (lhs.top - rhs.top).abs() <= _kRectEpsilon &&
        (lhs.width - rhs.width).abs() <= _kRectEpsilon &&
        (lhs.height - rhs.height).abs() <= _kRectEpsilon;
  }

  int? _tabIndexAtGlobalPosition(Offset globalPosition) {
    for (final index in _visibleTabIndices()) {
      final context = _tabKeys[index].currentContext;
      if (context == null) continue;

      final renderObject = context.findRenderObject();
      if (renderObject is! RenderBox || !renderObject.hasSize) continue;

      final offset = renderObject.localToGlobal(Offset.zero);
      final rect = offset & renderObject.size;
      if (rect.contains(globalPosition)) return index;
    }
    return null;
  }

  void _selectByGlobalPosition(Offset globalPosition) {
    final targetIndex = _tabIndexAtGlobalPosition(globalPosition);
    if (targetIndex == null) return;
    _onSelect(targetIndex);
  }

  void _cancelSwipeSelection() {
    _swipeHoldTimer?.cancel();
    _swipeHoldTimer = null;
    _activeSwipePointer = null;
    _swipePointerDownPosition = null;
    _isSwipeSelectionActive = false;
  }

  void _handleSwipePointerDown(PointerDownEvent event) {
    if (!widget.enableSwipeSelection) return;
    _cancelSwipeSelection();
    _activeSwipePointer = event.pointer;
    _swipePointerDownPosition = event.position;
    _swipeHoldTimer = Timer(kLongPressTimeout, () {
      if (!mounted || _activeSwipePointer != event.pointer) return;
      _isSwipeSelectionActive = true;
      _selectByGlobalPosition(event.position);
    });
  }

  void _handleSwipePointerMove(PointerMoveEvent event) {
    if (_activeSwipePointer != event.pointer) return;

    if (!_isSwipeSelectionActive) {
      final downPosition = _swipePointerDownPosition;
      if (downPosition == null) return;
      final distance = (event.position - downPosition).distance;
      if (distance > _kSwipeTouchSlop) {
        _cancelSwipeSelection();
      }
      return;
    }

    _selectByGlobalPosition(event.position);
  }

  void _handleSwipePointerUp(PointerEvent event) {
    if (_activeSwipePointer != event.pointer) return;
    _cancelSwipeSelection();
  }

  Widget _buildActiveIndicator(_HeroUiTabsTokens tokens) {
    final rect = _selectedIndicatorRect;
    if (rect == null) return const SizedBox.shrink();

    if (widget.variant == HeroUiTabsVariant.primary) {
      final radius =
          widget.tabContentOrientation == HeroUiTabContentOrientation.vertical
          ? 20.0
          : 24.0;
      return AnimatedPositioned(
        duration: _kAnimationDuration,
        curve: Curves.easeOutCubic,
        left: rect.left,
        top: rect.top,
        width: rect.width,
        height: rect.height,
        child: IgnorePointer(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: tokens.selectedBackground,
              borderRadius: BorderRadius.circular(radius),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.06),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return AnimatedPositioned(
      duration: _kAnimationDuration,
      curve: Curves.easeOutCubic,
      left: rect.left,
      top: rect.bottom - _kIndicatorHeight,
      width: rect.width,
      height: _kIndicatorHeight,
      child: IgnorePointer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: tokens.indicator,
            borderRadius: BorderRadius.circular(_kIndicatorHeight),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tokens = _tabsTokens(variant: widget.variant, isDark: isDark);
    _scheduleIndicatorSync();
    final header = _buildHeader(context, tokens);

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

  Widget _buildHeader(BuildContext context, _HeroUiTabsTokens tokens) {
    Widget tabStrip = _buildTabStrip(tokens);

    if (widget.enableSwipeSelection) {
      tabStrip = Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: _handleSwipePointerDown,
        onPointerMove: _handleSwipePointerMove,
        onPointerUp: _handleSwipePointerUp,
        onPointerCancel: _handleSwipePointerUp,
        child: tabStrip,
      );
    }

    final hugOverflow =
        widget.behavior == HeroUiTabsBehavior.hug &&
        (_canScrollBack || _canScrollForward);

    final showButtons =
        (widget.showScrollButtons || widget.showScrollShadow) &&
        widget.variant == HeroUiTabsVariant.primary;

    if (hugOverflow && (widget.showScrollShadow || showButtons)) {
      final opaque = widget.variant == HeroUiTabsVariant.primary
          ? tokens.stripBackground
          : Theme.of(context).colorScheme.surface;
      final transparent = opaque.withValues(alpha: 0);
      tabStrip = Stack(
        clipBehavior: Clip.none,
        children: [
          tabStrip,
          if (widget.showScrollShadow && _canScrollBack)
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
                      colors: [opaque, transparent],
                    ),
                  ),
                ),
              ),
            ),
          if (widget.showScrollShadow && _canScrollForward)
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
                      colors: [transparent, opaque],
                    ),
                  ),
                ),
              ),
            ),
          if (showButtons && _canScrollBack)
            Positioned(
              top: 0,
              bottom: 0,
              left: 4,
              child: Center(
                child: _HeroUiTabsScrollButton(
                  iconName: HeroUiIconManifest.chevronLeftRegular,
                  color: tokens.scrollIcon,
                  onTap: () => _scrollBy(-120),
                ),
              ),
            ),
          if (showButtons && _canScrollForward)
            Positioned(
              top: 0,
              bottom: 0,
              right: 4,
              child: Center(
                child: _HeroUiTabsScrollButton(
                  iconName: HeroUiIconManifest.chevronRightRegular,
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
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
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
    final tabButtons = <Widget>[];

    for (var i = 0; i < visibleIndices.length; i++) {
      final sourceIndex = visibleIndices[i];
      if (i > 0 && widget.variant == HeroUiTabsVariant.primary) {
        tabButtons.add(const SizedBox(width: 2));
      }
      tabButtons.add(_buildTabButton(sourceIndex, tokens));
    }

    final tabRow = widget.behavior == HeroUiTabsBehavior.fill
        ? Row(
            children: [
              for (final tabButton in tabButtons)
                switch (tabButton) {
                  final SizedBox spacer => spacer,
                  _ => Expanded(child: tabButton),
                },
            ],
          )
        : Row(mainAxisSize: MainAxisSize.min, children: tabButtons);

    final stripContent = Stack(
      key: _stripKey,
      fit: StackFit.passthrough,
      clipBehavior: Clip.none,
      children: [_buildActiveIndicator(tokens), tabRow],
    );

    if (widget.behavior == HeroUiTabsBehavior.fill) {
      return stripContent;
    }

    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: stripContent,
    );
  }

  Widget _buildTabButton(int index, _HeroUiTabsTokens tokens) {
    final item = widget.tabs[index];
    final selected = _selectedIndex == index;
    final disabled = item.isDisabled;
    final isPrimary = widget.variant == HeroUiTabsVariant.primary;
    final isVertical =
        widget.tabContentOrientation == HeroUiTabContentOrientation.vertical;

    final textColor = selected ? tokens.selectedText : tokens.text;
    final borderRadius = isPrimary
        ? BorderRadius.circular(20)
        : BorderRadius.zero;
    final decoration = BoxDecoration(
      color: Colors.transparent,
      borderRadius: borderRadius,
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
          alignment: Alignment.center,
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
    final leading = item.leading;
    final isVertical =
        widget.tabContentOrientation == HeroUiTabContentOrientation.vertical;
    final textStyle =
        (isVertical
                ? HeroUiTypography.bodyXsMedium
                : HeroUiTypography.bodySmMedium)
            .copyWith(color: color);

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

    return IconTheme.merge(
      data: IconThemeData(size: 16, color: color),
      child: DefaultTextStyle(
        style: textStyle,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leading != null) ...[leading, const SizedBox(width: 6)],
            text,
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
        tabBackground: Color(0xFFEBEBEC),
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
      tabBackground: Color(0xFF27272A),
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
    required this.iconName,
    required this.color,
    required this.onTap,
  });

  final String iconName;
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
          child: Center(child: HeroUiIcon(iconName, size: 16, color: color)),
        ),
      ),
    );
  }
}
