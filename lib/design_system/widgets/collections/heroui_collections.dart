import 'package:flutter/material.dart';

// ─── Accordion ────────────────────────────────────────────────────────────────

enum HeroUiAccordionVariant { defaultVariant, bordered }

class HeroUiAccordionItem {
  const HeroUiAccordionItem({
    required this.title,
    required this.content,
    this.subtitle,
    this.leading,
    this.initiallyExpanded = false,
    this.isDisabled = false,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget content;
  final bool initiallyExpanded;
  final bool isDisabled;
}

class HeroUiAccordion extends StatefulWidget {
  const HeroUiAccordion({
    super.key,
    required this.items,
    this.variant = HeroUiAccordionVariant.defaultVariant,
    this.selectionMode = HeroUiAccordionSelectionMode.single,
  });

  final List<HeroUiAccordionItem> items;
  final HeroUiAccordionVariant variant;
  final HeroUiAccordionSelectionMode selectionMode;

  @override
  State<HeroUiAccordion> createState() => _HeroUiAccordionState();
}

enum HeroUiAccordionSelectionMode { single, multiple }

class _HeroUiAccordionState extends State<HeroUiAccordion> {
  late final Set<int> _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = {
      for (int i = 0; i < widget.items.length; i++)
        if (widget.items[i].initiallyExpanded) i,
    };
  }

  void _toggle(int index) {
    if (widget.items[index].isDisabled) return;
    setState(() {
      if (_expanded.contains(index)) {
        _expanded.remove(index);
      } else {
        if (widget.selectionMode == HeroUiAccordionSelectionMode.single) {
          _expanded.clear();
        }
        _expanded.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isBordered = widget.variant == HeroUiAccordionVariant.bordered;
    final cs = Theme.of(context).colorScheme;

    Widget child = Column(
      children: [
        for (int i = 0; i < widget.items.length; i++) ...[
          _AccordionTile(
            item: widget.items[i],
            isExpanded: _expanded.contains(i),
            onTap: () => _toggle(i),
            showDivider: !isBordered && i < widget.items.length - 1,
          ),
        ],
      ],
    );

    if (isBordered) {
      child = Container(
        decoration: BoxDecoration(
          color: cs.surface,
          border: Border.all(color: cs.outlineVariant),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: child,
      );
    }

    return child;
  }
}

class _AccordionTile extends StatefulWidget {
  const _AccordionTile({
    required this.item,
    required this.isExpanded,
    required this.onTap,
    required this.showDivider,
  });

  final HeroUiAccordionItem item;
  final bool isExpanded;
  final VoidCallback onTap;
  final bool showDivider;

  @override
  State<_AccordionTile> createState() => _AccordionTileState();
}

class _AccordionTileState extends State<_AccordionTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _expand;
  late Animation<double> _rotate;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
      value: widget.isExpanded ? 1.0 : 0.0,
    );
    _expand = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
    _rotate = Tween<double>(begin: 0, end: 0.5).animate(_expand);
  }

  @override
  void didUpdateWidget(_AccordionTile old) {
    super.didUpdateWidget(old);
    if (widget.isExpanded != old.isExpanded) {
      widget.isExpanded ? _ctrl.forward() : _ctrl.reverse();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final item = widget.item;
    final disabled = item.isDisabled;

    return Column(
      children: [
        MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: disabled ? null : widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              color: _isHovered && !disabled
                  ? cs.surfaceContainerHighest.withOpacity(0.5)
                  : Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Opacity(
                opacity: disabled ? 0.5 : 1.0,
                child: Row(
                  children: [
                    if (item.leading != null) ...[
                      item.leading!,
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: cs.onSurface,
                                ),
                          ),
                          if (item.subtitle != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              item.subtitle!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: cs.onSurfaceVariant),
                            ),
                          ],
                        ],
                      ),
                    ),
                    RotationTransition(
                      turns: _rotate,
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 20,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizeTransition(
          sizeFactor: _expand,
          axisAlignment: -1,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: Align(
              alignment: Alignment.topLeft,
              child: item.content,
            ),
          ),
        ),
        if (widget.showDivider)
          Divider(height: 1, color: cs.outlineVariant),
      ],
    );
  }
}

// ─── ListBox ──────────────────────────────────────────────────────────────────

enum HeroUiListBoxSelectionMode { single, multiple }

class HeroUiListBoxItem<T> {
  const HeroUiListBoxItem({
    required this.value,
    required this.label,
    this.description,
    this.leading,
    this.trailing,
    this.isDisabled = false,
    this.isDanger = false,
  });

  final T value;
  final String label;
  final String? description;
  final Widget? leading;
  final Widget? trailing;
  final bool isDisabled;
  final bool isDanger;
}

class HeroUiListBox<T> extends StatefulWidget {
  const HeroUiListBox({
    super.key,
    required this.items,
    this.selectionMode = HeroUiListBoxSelectionMode.single,
    this.selectedValues = const {},
    this.onSelectionChanged,
    this.label,
    this.description,
  });

  final List<HeroUiListBoxItem<T>> items;
  final HeroUiListBoxSelectionMode selectionMode;
  final Set<T> selectedValues;
  final ValueChanged<Set<T>>? onSelectionChanged;
  final String? label;
  final String? description;

  @override
  State<HeroUiListBox<T>> createState() => _HeroUiListBoxState<T>();
}

class _HeroUiListBoxState<T> extends State<HeroUiListBox<T>> {
  late Set<T> _selected;

  @override
  void initState() {
    super.initState();
    _selected = Set<T>.from(widget.selectedValues);
  }

  @override
  void didUpdateWidget(HeroUiListBox<T> old) {
    super.didUpdateWidget(old);
    if (widget.selectedValues != old.selectedValues) {
      _selected = Set<T>.from(widget.selectedValues);
    }
  }

  void _toggleItem(HeroUiListBoxItem<T> item) {
    if (item.isDisabled) return;
    setState(() {
      if (_selected.contains(item.value)) {
        _selected.remove(item.value);
      } else {
        if (widget.selectionMode == HeroUiListBoxSelectionMode.single) {
          _selected = {item.value};
        } else {
          _selected.add(item.value);
        }
      }
    });
    widget.onSelectionChanged?.call(Set<T>.from(_selected));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(fontWeight: FontWeight.w500, color: cs.onSurface),
          ),
          const SizedBox(height: 6),
        ],
        Container(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: cs.outlineVariant),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              for (int i = 0; i < widget.items.length; i++) ...[
                _ListBoxItemTile<T>(
                  item: widget.items[i],
                  isSelected: _selected.contains(widget.items[i].value),
                  onTap: () => _toggleItem(widget.items[i]),
                ),
                if (i < widget.items.length - 1)
                  Divider(
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                    color: cs.outlineVariant.withOpacity(0.5),
                  ),
              ],
            ],
          ),
        ),
        if (widget.description != null) ...[
          const SizedBox(height: 6),
          Text(
            widget.description!,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: cs.onSurfaceVariant),
          ),
        ],
      ],
    );
  }
}

class _ListBoxItemTile<T> extends StatefulWidget {
  const _ListBoxItemTile({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final HeroUiListBoxItem<T> item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_ListBoxItemTile<T>> createState() => _ListBoxItemTileState<T>();
}

class _ListBoxItemTileState<T> extends State<_ListBoxItemTile<T>> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final item = widget.item;
    final disabled = item.isDisabled;
    final selected = widget.isSelected;
    final danger = item.isDanger;

    Color textColor = cs.onSurface;
    if (danger) textColor = const Color(0xFFFF383C);
    if (disabled) textColor = cs.onSurface.withOpacity(0.4);

    Color bgColor = Colors.transparent;
    if (selected) bgColor = cs.primary.withOpacity(0.08);
    if (_isHovered && !disabled && !selected) {
      bgColor = cs.surfaceContainerHighest.withOpacity(0.6);
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: disabled ? null : widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          color: bgColor,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Opacity(
            opacity: disabled ? 0.5 : 1.0,
            child: Row(
              children: [
                if (item.leading != null) ...[
                  item.leading!,
                  const SizedBox(width: 10),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.label,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: textColor),
                      ),
                      if (item.description != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          item.description!,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: cs.onSurfaceVariant),
                        ),
                      ],
                    ],
                  ),
                ),
                if (item.trailing != null) ...[
                  const SizedBox(width: 8),
                  item.trailing!,
                ] else if (selected) ...[
                  const SizedBox(width: 8),
                  Icon(Icons.check_rounded, size: 18, color: cs.primary),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── TagGroup ─────────────────────────────────────────────────────────────────

enum HeroUiTagVariant { defaultVariant, surface }

enum HeroUiTagSize { sm, md, lg }

class HeroUiTagItem {
  const HeroUiTagItem({
    required this.value,
    required this.label,
    this.leading,
    this.trailing,
    this.isDisabled = false,
  });

  final String value;
  final String label;
  final Widget? leading;
  final Widget? trailing;
  final bool isDisabled;
}

class HeroUiTagGroup extends StatefulWidget {
  const HeroUiTagGroup({
    super.key,
    required this.items,
    this.variant = HeroUiTagVariant.defaultVariant,
    this.size = HeroUiTagSize.md,
    this.selectedValues = const {},
    this.selectionMode = HeroUiTagGroupSelectionMode.multiple,
    this.onSelectionChanged,
    this.label,
    this.description,
    this.errorMessage,
    this.isRequired = false,
  });

  final List<HeroUiTagItem> items;
  final HeroUiTagVariant variant;
  final HeroUiTagSize size;
  final Set<String> selectedValues;
  final HeroUiTagGroupSelectionMode selectionMode;
  final ValueChanged<Set<String>>? onSelectionChanged;
  final String? label;
  final String? description;
  final String? errorMessage;
  final bool isRequired;

  @override
  State<HeroUiTagGroup> createState() => _HeroUiTagGroupState();
}

enum HeroUiTagGroupSelectionMode { single, multiple }

class _HeroUiTagGroupState extends State<HeroUiTagGroup> {
  late Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = Set<String>.from(widget.selectedValues);
  }

  @override
  void didUpdateWidget(HeroUiTagGroup old) {
    super.didUpdateWidget(old);
    if (widget.selectedValues != old.selectedValues) {
      _selected = Set<String>.from(widget.selectedValues);
    }
  }

  void _toggleTag(HeroUiTagItem item) {
    if (item.isDisabled) return;
    setState(() {
      if (_selected.contains(item.value)) {
        _selected.remove(item.value);
      } else {
        if (widget.selectionMode == HeroUiTagGroupSelectionMode.single) {
          _selected = {item.value};
        } else {
          _selected.add(item.value);
        }
      }
    });
    widget.onSelectionChanged?.call(Set<String>.from(_selected));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final hasError = widget.errorMessage != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Row(
            children: [
              Text(
                widget.label!,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(fontWeight: FontWeight.w500, color: cs.onSurface),
              ),
              if (widget.isRequired)
                Text(
                  ' *',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: cs.error),
                ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final item in widget.items)
              _TagChip(
                item: item,
                isSelected: _selected.contains(item.value),
                variant: widget.variant,
                size: widget.size,
                onTap: () => _toggleTag(item),
              ),
          ],
        ),
        if (widget.description != null && !hasError) ...[
          const SizedBox(height: 6),
          Text(
            widget.description!,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: cs.onSurfaceVariant),
          ),
        ],
        if (hasError) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.error_outline_rounded, size: 14, color: cs.error),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  widget.errorMessage!,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: cs.error),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _TagChip extends StatefulWidget {
  const _TagChip({
    required this.item,
    required this.isSelected,
    required this.variant,
    required this.size,
    required this.onTap,
  });

  final HeroUiTagItem item;
  final bool isSelected;
  final HeroUiTagVariant variant;
  final HeroUiTagSize size;
  final VoidCallback onTap;

  @override
  State<_TagChip> createState() => _TagChipState();
}

class _TagChipState extends State<_TagChip> {
  bool _isHovered = false;

  EdgeInsets get _padding => switch (widget.size) {
        HeroUiTagSize.sm => const EdgeInsets.symmetric(
            horizontal: 6, vertical: 2),
        HeroUiTagSize.md => const EdgeInsets.symmetric(
            horizontal: 8, vertical: 4),
        HeroUiTagSize.lg => const EdgeInsets.symmetric(
            horizontal: 10, vertical: 6),
      };

  double get _fontSize => switch (widget.size) {
        HeroUiTagSize.sm => 11,
        HeroUiTagSize.md => 12,
        HeroUiTagSize.lg => 14,
      };

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final selected = widget.isSelected;
    final disabled = widget.item.isDisabled;
    final isSurface = widget.variant == HeroUiTagVariant.surface;

    Color bgColor;
    Color textColor;
    Border? border;

    if (selected) {
      bgColor = const Color(0xFF0485F7).withOpacity(0.15);
      textColor = const Color(0xFF0485F7);
    } else if (_isHovered && !disabled) {
      bgColor = isSurface
          ? const Color(0xFFF5F5F5)
          : const Color(0xFFE1E1E2);
      textColor = cs.onSurface;
    } else {
      bgColor = isSurface ? cs.surface : const Color(0xFFEBEBEC);
      textColor = cs.onSurface;
    }

    if (isSurface && !selected) {
      border = Border.all(
        color: _isHovered ? cs.outline : cs.outlineVariant,
      );
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: disabled ? null : widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: _padding,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            border: border,
          ),
          child: Opacity(
            opacity: disabled ? 0.5 : 1.0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.item.leading != null) ...[
                  widget.item.leading!,
                  const SizedBox(width: 4),
                ],
                Text(
                  widget.item.label,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: _fontSize,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
                if (widget.item.trailing != null) ...[
                  const SizedBox(width: 4),
                  widget.item.trailing!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Table ────────────────────────────────────────────────────────────────────

enum HeroUiTableVariant { primary, secondary }

enum HeroUiSortDirection { none, ascending, descending }

class HeroUiTableColumn {
  const HeroUiTableColumn({
    required this.key,
    required this.label,
    this.flex = 1,
    this.sortable = false,
    this.alignment = Alignment.centerLeft,
  });

  final String key;
  final String label;
  final int flex;
  final bool sortable;
  final AlignmentGeometry alignment;
}

class HeroUiTableRow {
  const HeroUiTableRow({required this.cells});

  final Map<String, Widget> cells;
}

class HeroUiTable extends StatefulWidget {
  const HeroUiTable({
    super.key,
    required this.columns,
    required this.rows,
    this.variant = HeroUiTableVariant.primary,
    this.onSortChanged,
    this.emptyWidget,
  });

  final List<HeroUiTableColumn> columns;
  final List<HeroUiTableRow> rows;
  final HeroUiTableVariant variant;
  final void Function(String columnKey, HeroUiSortDirection direction)?
      onSortChanged;
  final Widget? emptyWidget;

  @override
  State<HeroUiTable> createState() => _HeroUiTableState();
}

class _HeroUiTableState extends State<HeroUiTable> {
  String? _sortKey;
  HeroUiSortDirection _sortDir = HeroUiSortDirection.none;

  void _onHeaderTap(HeroUiTableColumn col) {
    if (!col.sortable) return;
    setState(() {
      if (_sortKey == col.key) {
        _sortDir = _sortDir == HeroUiSortDirection.ascending
            ? HeroUiSortDirection.descending
            : HeroUiSortDirection.ascending;
      } else {
        _sortKey = col.key;
        _sortDir = HeroUiSortDirection.ascending;
      }
    });
    widget.onSortChanged?.call(col.key, _sortDir);
  }

  Widget _sortIcon(HeroUiTableColumn col) {
    final isActive = _sortKey == col.key;
    if (!col.sortable) return const SizedBox.shrink();
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 160),
      child: Icon(
        isActive && _sortDir == HeroUiSortDirection.descending
            ? Icons.arrow_downward_rounded
            : Icons.arrow_upward_rounded,
        key: ValueKey('$isActive$_sortDir'),
        size: 14,
        color: isActive
            ? const Color(0xFF0485F7)
            : Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isPrimary = widget.variant == HeroUiTableVariant.primary;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEFEFF0),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          _buildHeader(context, cs, isPrimary),
          // Body
          _buildBody(context, cs, isPrimary),
        ],
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context, ColorScheme cs, bool isPrimary) {
    return Container(
      decoration: BoxDecoration(
        color: isPrimary ? null : Colors.transparent,
        borderRadius: isPrimary ? BorderRadius.circular(12) : null,
      ),
      child: Row(
        children: [
          for (final col in widget.columns)
            Expanded(
              flex: col.flex,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: col.sortable ? () => _onHeaderTap(col) : null,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: col.alignment == Alignment.centerRight
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      Text(
                        col.label,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: cs.onSurfaceVariant,
                            ),
                      ),
                      if (col.sortable) ...[
                        const SizedBox(width: 4),
                        _sortIcon(col),
                      ],
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBody(
      BuildContext context, ColorScheme cs, bool isPrimary) {
    if (widget.rows.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: isPrimary ? cs.surface : Colors.transparent,
          borderRadius: isPrimary ? BorderRadius.circular(12) : null,
          border: !isPrimary
              ? Border(top: BorderSide(color: cs.outlineVariant))
              : null,
        ),
        padding: const EdgeInsets.all(32),
        alignment: Alignment.center,
        child: widget.emptyWidget ??
            Text(
              'No items found.',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: cs.onSurfaceVariant),
            ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: isPrimary ? cs.surface : Colors.transparent,
        borderRadius: isPrimary ? BorderRadius.circular(12) : null,
        border: !isPrimary
            ? Border(top: BorderSide(color: cs.outlineVariant))
            : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (int i = 0; i < widget.rows.length; i++) ...[
            _TableDataRow(
              row: widget.rows[i],
              columns: widget.columns,
              isLast: i == widget.rows.length - 1,
            ),
          ],
        ],
      ),
    );
  }
}

class _TableDataRow extends StatefulWidget {
  const _TableDataRow({
    required this.row,
    required this.columns,
    required this.isLast,
  });

  final HeroUiTableRow row;
  final List<HeroUiTableColumn> columns;
  final bool isLast;

  @override
  State<_TableDataRow> createState() => _TableDataRowState();
}

class _TableDataRowState extends State<_TableDataRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        color: _isHovered
            ? cs.surfaceContainerHighest.withOpacity(0.5)
            : Colors.transparent,
        child: Column(
          children: [
            Row(
              children: [
                for (final col in widget.columns)
                  Expanded(
                    flex: col.flex,
                    child: Align(
                      alignment: col.alignment,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        child: widget.row.cells[col.key] ??
                            const SizedBox.shrink(),
                      ),
                    ),
                  ),
              ],
            ),
            if (!widget.isLast)
              Divider(
                height: 1,
                color: cs.outlineVariant.withOpacity(0.5),
              ),
          ],
        ),
      ),
    );
  }
}
