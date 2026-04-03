part of 'heroui_collections.dart';

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
          _buildHeader(context, cs, isPrimary),
          _buildBody(context, cs, isPrimary),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ColorScheme cs, bool isPrimary) {
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

  Widget _buildBody(BuildContext context, ColorScheme cs, bool isPrimary) {
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
        child:
            widget.emptyWidget ??
            Text(
              'No items found.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
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
                        child:
                            widget.row.cells[col.key] ??
                            const SizedBox.shrink(),
                      ),
                    ),
                  ),
              ],
            ),
            if (!widget.isLast)
              Divider(height: 1, color: cs.outlineVariant.withOpacity(0.5)),
          ],
        ),
      ),
    );
  }
}
