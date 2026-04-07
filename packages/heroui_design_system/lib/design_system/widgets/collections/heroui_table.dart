part of 'heroui_collections.dart';

enum HeroUiTableVariant { primary, secondary }

enum HeroUiTableHeaderVariant { primary, secondary }

enum HeroUiTableHeaderWidth { leading, equal }

enum HeroUiTableHeaderCellVariant {
  defaultVariant,
  sortingHighest,
  sortingLowest,
}

enum HeroUiTableRowState { defaultState, hover, disabled }

enum HeroUiTableRowWidth { leading, equal }

enum HeroUiTableRowCellType {
  value,
  visual,
  visualSupport,
  compare,
  chip,
  actions,
}

enum HeroUiTableRowCellVariant { leading, regular }

enum HeroUiTableFooterType { data, pagination }

class HeroUiTableHeader {
  const HeroUiTableHeader({
    required this.cells,
    this.variant = HeroUiTableHeaderVariant.primary,
    this.width = HeroUiTableHeaderWidth.leading,
    this.showCheck = false,
    this.showDrag = false,
    this.isChecked = false,
    this.onCheckChanged,
  });

  final List<HeroUiTableHeaderCell> cells;
  final HeroUiTableHeaderVariant variant;
  final HeroUiTableHeaderWidth width;
  final bool showCheck;
  final bool showDrag;
  final bool isChecked;
  final ValueChanged<bool>? onCheckChanged;
}

class HeroUiTableHeaderCell {
  const HeroUiTableHeaderCell({
    required this.label,
    this.variant = HeroUiTableHeaderCellVariant.defaultVariant,
    this.showTooltip = false,
    this.tooltipMessage,
    this.alignment = Alignment.centerLeft,
    this.minWidth = 120,
  });

  final String label;
  final HeroUiTableHeaderCellVariant variant;
  final bool showTooltip;
  final String? tooltipMessage;
  final Alignment alignment;
  final double minWidth;
}

class HeroUiTableRow {
  const HeroUiTableRow({
    required this.cells,
    this.state = HeroUiTableRowState.defaultState,
    this.width = HeroUiTableRowWidth.leading,
    this.showCheck,
    this.showDrag,
    this.isChecked = false,
    this.onCheckChanged,
    this.onTap,
  });

  final List<HeroUiTableRowCell> cells;
  final HeroUiTableRowState state;
  final HeroUiTableRowWidth width;
  final bool? showCheck;
  final bool? showDrag;
  final bool isChecked;
  final ValueChanged<bool>? onCheckChanged;
  final VoidCallback? onTap;
}

class HeroUiTableRowCell {
  const HeroUiTableRowCell({
    required this.child,
    this.type = HeroUiTableRowCellType.value,
    this.variant = HeroUiTableRowCellVariant.regular,
    this.prefix,
    this.suffix,
    this.showPrefix,
    this.showSuffix,
    this.alignment = Alignment.centerLeft,
  });

  final Widget child;
  final HeroUiTableRowCellType type;
  final HeroUiTableRowCellVariant variant;
  final Widget? prefix;
  final Widget? suffix;
  final bool? showPrefix;
  final bool? showSuffix;
  final Alignment alignment;

  bool get shouldShowPrefix => showPrefix ?? prefix != null;
  bool get shouldShowSuffix => showSuffix ?? suffix != null;
}

class HeroUiTableFooter {
  const HeroUiTableFooter({
    required this.type,
    this.leading,
    this.trailing,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  });

  final HeroUiTableFooterType type;
  final Widget? leading;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;
}

class HeroUiTable extends StatelessWidget {
  const HeroUiTable({
    super.key,
    required this.header,
    required this.rows,
    this.variant = HeroUiTableVariant.primary,
    this.footer,
    this.emptyWidget,
    this.leadingColumnMinWidth = 240,
    this.regularColumnWidth = 152,
    this.equalColumnMinWidth = 144,
    this.controlColumnWidth = 40,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
  }) : assert(leadingColumnMinWidth > 0),
       assert(regularColumnWidth > 0),
       assert(equalColumnMinWidth > 0),
       assert(controlColumnWidth > 0);

  final HeroUiTableHeader header;
  final List<HeroUiTableRow> rows;
  final HeroUiTableVariant variant;
  final HeroUiTableFooter? footer;
  final Widget? emptyWidget;
  final double leadingColumnMinWidth;
  final double regularColumnWidth;
  final double equalColumnMinWidth;
  final double controlColumnWidth;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tokens = _HeroUiTableTokens.resolve(
      isDark: isDark,
      tableVariant: variant,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final viewportWidth =
            constraints.maxWidth.isFinite && constraints.maxWidth > 0
            ? constraints.maxWidth
            : _minimumTableWidth(header.width);

        final headerLayout = _buildLayout(
          viewportWidth: viewportWidth,
          width: header.width,
        );

        return DecoratedBox(
          decoration: BoxDecoration(
            color: tokens.surface,
            borderRadius: borderRadius,
            border: variant == HeroUiTableVariant.primary
                ? Border.all(color: tokens.frameBorder)
                : null,
          ),
          child: ClipRRect(
            borderRadius: borderRadius,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: headerLayout.tableWidth,
                child: _buildContent(
                  context: context,
                  tokens: tokens,
                  headerLayout: headerLayout,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent({
    required BuildContext context,
    required _HeroUiTableTokens tokens,
    required _HeroUiTableLayout headerLayout,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeaderRow(tokens: tokens, layout: headerLayout),
        if (rows.isEmpty)
          _buildEmptyState(
            context: context,
            tokens: tokens,
            showBottomDivider: false,
          ),
        if (rows.isNotEmpty)
          for (int i = 0; i < rows.length; i++)
            _HeroUiTableDataRow(
              row: rows[i],
              header: header,
              columnWidths: _columnWidthsForRow(rows[i], headerLayout),
              tokens: tokens,
              controlColumnWidth: controlColumnWidth,
              showBottomDivider: i < rows.length - 1,
            ),
        if (footer != null) _buildFooter(context: context, tokens: tokens),
      ],
    );
  }

  Widget _buildHeaderRow({
    required _HeroUiTableTokens tokens,
    required _HeroUiTableLayout layout,
  }) {
    final bgColor = header.variant == HeroUiTableHeaderVariant.primary
        ? tokens.headerPrimaryBg
        : tokens.headerSecondaryBg;
    final textColor = header.variant == HeroUiTableHeaderVariant.primary
        ? tokens.headerPrimaryText
        : tokens.headerSecondaryText;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(bottom: BorderSide(color: tokens.divider)),
      ),
      child: Row(
        children: [
          if (header.showDrag)
            _buildControlSlot(
              width: controlColumnWidth,
              dividerColor: tokens.divider,
              child: HeroUiIcon(
                HeroUiIconManifest.barsUnaligned,
                size: 20,
                color: tokens.mutedText,
              ),
            ),
          if (header.showCheck)
            _buildControlSlot(
              width: controlColumnWidth,
              dividerColor: tokens.divider,
              child: _HeroUiTableCheckbox(
                value: header.isChecked,
                onChanged: header.onCheckChanged,
              ),
            ),
          for (int i = 0; i < header.cells.length; i++)
            _buildHeaderCell(
              cell: header.cells[i],
              width: layout.columnWidths[i],
              textColor: textColor,
              iconColor: tokens.mutedText,
            ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell({
    required HeroUiTableHeaderCell cell,
    required double width,
    required Color textColor,
    required Color iconColor,
  }) {
    final sortIcon = switch (cell.variant) {
      HeroUiTableHeaderCellVariant.defaultVariant => null,
      HeroUiTableHeaderCellVariant.sortingHighest =>
        HeroUiIconManifest.arrowDown,
      HeroUiTableHeaderCellVariant.sortingLowest => HeroUiIconManifest.arrowUp,
    };

    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        child: Align(
          alignment: cell.alignment,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                cell.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: HeroUiTypography.bodyXsMedium.copyWith(color: textColor),
              ),
              if (sortIcon != null) ...[
                const SizedBox(width: 6),
                HeroUiIcon(sortIcon, size: 14, color: iconColor),
              ],
              if (cell.showTooltip) ...[
                const SizedBox(width: 4),
                Tooltip(
                  message: cell.tooltipMessage ?? cell.label,
                  child: HeroUiIcon(
                    HeroUiIconManifest.circleInfo,
                    size: 14,
                    color: iconColor,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlSlot({
    required double width,
    required Color dividerColor,
    required Widget child,
  }) {
    return SizedBox(
      width: width,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border(right: BorderSide(color: dividerColor)),
        ),
        child: child,
      ),
    );
  }

  Widget _buildEmptyState({
    required BuildContext context,
    required _HeroUiTableTokens tokens,
    required bool showBottomDivider,
  }) {
    return Container(
      height: 160,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: showBottomDivider
            ? Border(bottom: BorderSide(color: tokens.divider))
            : null,
      ),
      child:
          emptyWidget ??
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              HeroUiIcon(
                HeroUiIconManifest.squareListUl,
                size: 40,
                color: tokens.mutedText,
              ),
              const SizedBox(height: 8),
              Text(
                'No table data.',
                style: HeroUiTypography.bodySm.copyWith(
                  color: tokens.mutedText,
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildFooter({
    required BuildContext context,
    required _HeroUiTableTokens tokens,
  }) {
    final footerValue = footer;
    if (footerValue == null) return const SizedBox.shrink();
    if (footerValue.leading == null && footerValue.trailing == null) {
      return const SizedBox.shrink();
    }

    final bgColor = footerValue.type == HeroUiTableFooterType.data
        ? tokens.footerDataBg
        : tokens.footerPaginationBg;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(top: BorderSide(color: tokens.divider)),
      ),
      padding: footerValue.padding,
      child: DefaultTextStyle(
        style: HeroUiTypography.bodySm.copyWith(color: tokens.mutedText),
        child: Row(
          children: [
            if (footerValue.leading != null)
              Expanded(child: footerValue.leading!),
            if (footerValue.leading == null) const Spacer(),
            if (footerValue.trailing != null) ...[
              if (footerValue.leading != null) const SizedBox(width: 12),
              footerValue.trailing!,
            ],
          ],
        ),
      ),
    );
  }

  List<double> _columnWidthsForRow(
    HeroUiTableRow row,
    _HeroUiTableLayout headerLayout,
  ) {
    if (_isSameWidthMode(row.width, header.width)) {
      return headerLayout.columnWidths;
    }

    return _buildLayout(
      viewportWidth: headerLayout.tableWidth,
      width: _headerWidthFromRow(row.width),
    ).columnWidths;
  }

  bool _isSameWidthMode(
    HeroUiTableRowWidth rowWidth,
    HeroUiTableHeaderWidth headerWidth,
  ) {
    return (rowWidth == HeroUiTableRowWidth.leading &&
            headerWidth == HeroUiTableHeaderWidth.leading) ||
        (rowWidth == HeroUiTableRowWidth.equal &&
            headerWidth == HeroUiTableHeaderWidth.equal);
  }

  HeroUiTableHeaderWidth _headerWidthFromRow(HeroUiTableRowWidth rowWidth) {
    return rowWidth == HeroUiTableRowWidth.leading
        ? HeroUiTableHeaderWidth.leading
        : HeroUiTableHeaderWidth.equal;
  }

  _HeroUiTableLayout _buildLayout({
    required double viewportWidth,
    required HeroUiTableHeaderWidth width,
  }) {
    final minColumnWidths = _minimumColumnWidths(width);
    final minColumnsTotal = _sum(minColumnWidths);
    final minTableWidth = _leadingSlotsWidth + minColumnsTotal;
    final tableWidth = _max(viewportWidth, minTableWidth);

    if (minColumnWidths.isEmpty) {
      return _HeroUiTableLayout(tableWidth: tableWidth, columnWidths: const []);
    }

    if (width == HeroUiTableHeaderWidth.equal) {
      final growBy =
          (tableWidth - _leadingSlotsWidth - minColumnsTotal) /
          minColumnWidths.length;
      return _HeroUiTableLayout(
        tableWidth: tableWidth,
        columnWidths: [for (final value in minColumnWidths) value + growBy],
      );
    }

    if (minColumnWidths.length == 1) {
      return _HeroUiTableLayout(
        tableWidth: tableWidth,
        columnWidths: [tableWidth - _leadingSlotsWidth],
      );
    }

    final trailingTotal = _sum(minColumnWidths.sublist(1));
    final leadingWidth = tableWidth - _leadingSlotsWidth - trailingTotal;

    return _HeroUiTableLayout(
      tableWidth: tableWidth,
      columnWidths: [leadingWidth, ...minColumnWidths.sublist(1)],
    );
  }

  List<double> _minimumColumnWidths(HeroUiTableHeaderWidth width) {
    final result = <double>[];
    for (int i = 0; i < header.cells.length; i++) {
      final cell = header.cells[i];
      if (width == HeroUiTableHeaderWidth.equal) {
        result.add(_max(equalColumnMinWidth, cell.minWidth));
      } else if (i == 0) {
        result.add(_max(leadingColumnMinWidth, cell.minWidth));
      } else {
        result.add(_max(regularColumnWidth, cell.minWidth));
      }
    }
    return result;
  }

  double _minimumTableWidth(HeroUiTableHeaderWidth width) {
    return _leadingSlotsWidth + _sum(_minimumColumnWidths(width));
  }

  double get _leadingSlotsWidth {
    double value = 0;
    if (header.showDrag) value += controlColumnWidth;
    if (header.showCheck) value += controlColumnWidth;
    return value;
  }

  double _sum(List<double> values) {
    double total = 0;
    for (final value in values) {
      total += value;
    }
    return total;
  }

  double _max(double a, double b) => a > b ? a : b;
}

class _HeroUiTableDataRow extends StatefulWidget {
  const _HeroUiTableDataRow({
    required this.row,
    required this.header,
    required this.columnWidths,
    required this.tokens,
    required this.controlColumnWidth,
    required this.showBottomDivider,
  });

  final HeroUiTableRow row;
  final HeroUiTableHeader header;
  final List<double> columnWidths;
  final _HeroUiTableTokens tokens;
  final double controlColumnWidth;
  final bool showBottomDivider;

  @override
  State<_HeroUiTableDataRow> createState() => _HeroUiTableDataRowState();
}

class _HeroUiTableDataRowState extends State<_HeroUiTableDataRow> {
  bool _isHovered = false;

  bool get _isDisabled => widget.row.state == HeroUiTableRowState.disabled;

  bool get _isHoverable => widget.row.state == HeroUiTableRowState.defaultState;

  bool get _showHoverState {
    if (_isDisabled) return false;
    if (widget.row.state == HeroUiTableRowState.hover) return true;
    if (_isHoverable) return _isHovered;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final showDrag = widget.header.showDrag && (widget.row.showDrag ?? true);
    final showCheck = widget.header.showCheck && (widget.row.showCheck ?? true);

    final rowChild = AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: _showHoverState ? widget.tokens.rowHoverBg : Colors.transparent,
        border: widget.showBottomDivider
            ? Border(bottom: BorderSide(color: widget.tokens.divider))
            : null,
      ),
      child: Row(
        children: [
          if (widget.header.showDrag)
            _buildControlSlot(
              width: widget.controlColumnWidth,
              dividerColor: widget.tokens.divider,
              child: showDrag
                  ? HeroUiIcon(
                      HeroUiIconManifest.barsUnaligned,
                      size: 20,
                      color: _isDisabled
                          ? widget.tokens.disabledText
                          : widget.tokens.mutedText,
                    )
                  : const SizedBox.shrink(),
            ),
          if (widget.header.showCheck)
            _buildControlSlot(
              width: widget.controlColumnWidth,
              dividerColor: widget.tokens.divider,
              child: showCheck
                  ? _HeroUiTableCheckbox(
                      value: widget.row.isChecked,
                      onChanged: _isDisabled ? null : widget.row.onCheckChanged,
                    )
                  : const SizedBox.shrink(),
            ),
          for (int i = 0; i < widget.header.cells.length; i++)
            _buildDataCell(
              cell: i < widget.row.cells.length
                  ? widget.row.cells[i]
                  : const HeroUiTableRowCell(child: SizedBox.shrink()),
              width: widget.columnWidths[i],
            ),
        ],
      ),
    );

    return MouseRegion(
      cursor: !_isDisabled && widget.row.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: _isHoverable ? (_) => setState(() => _isHovered = true) : null,
      onExit: _isHoverable ? (_) => setState(() => _isHovered = false) : null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _isDisabled ? null : widget.row.onTap,
        child: Opacity(opacity: _isDisabled ? 0.56 : 1, child: rowChild),
      ),
    );
  }

  Widget _buildControlSlot({
    required double width,
    required Color dividerColor,
    required Widget child,
  }) {
    return SizedBox(
      width: width,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border(right: BorderSide(color: dividerColor)),
        ),
        child: child,
      ),
    );
  }

  Widget _buildDataCell({
    required HeroUiTableRowCell cell,
    required double width,
  }) {
    final textColor = _resolveTextColor(cell);
    final horizontalPadding = cell.variant == HeroUiTableRowCellVariant.leading
        ? 16.0
        : 12.0;
    final verticalPadding = _verticalPadding(cell.type);

    return SizedBox(
      width: width,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: Align(
          alignment: _resolveAlignment(cell),
          child: DefaultTextStyle(
            style: HeroUiTypography.bodySm.copyWith(color: textColor),
            child: IconTheme(
              data: IconThemeData(color: textColor, size: 20),
              child: _buildCellContent(cell, textColor),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCellContent(HeroUiTableRowCell cell, Color fallbackColor) {
    final prefix = cell.shouldShowPrefix && cell.prefix != null
        ? _resolveSlotWidget(cell.prefix!, fallbackColor)
        : null;
    final suffix = cell.shouldShowSuffix && cell.suffix != null
        ? _resolveSlotWidget(cell.suffix!, fallbackColor)
        : null;

    if (prefix == null && suffix == null) {
      return cell.child;
    }

    final shouldExpandChild = switch (cell.type) {
      HeroUiTableRowCellType.value => cell.alignment != Alignment.centerRight,
      HeroUiTableRowCellType.visualSupport => true,
      _ => false,
    };

    return Row(
      mainAxisSize: shouldExpandChild ? MainAxisSize.max : MainAxisSize.min,
      children: [
        if (prefix != null) ...[prefix, const SizedBox(width: 8)],
        if (shouldExpandChild) Expanded(child: cell.child) else cell.child,
        if (suffix != null) ...[const SizedBox(width: 8), suffix],
      ],
    );
  }

  Widget _resolveSlotWidget(Widget child, Color fallbackColor) {
    if (child is HeroUiIcon) {
      return HeroUiIcon(
        child.name,
        key: child.key,
        size: child.size,
        color: child.color ?? fallbackColor,
        semanticLabel: child.semanticLabel,
      );
    }
    return child;
  }

  Alignment _resolveAlignment(HeroUiTableRowCell cell) {
    return switch (cell.type) {
      HeroUiTableRowCellType.actions => Alignment.centerRight,
      HeroUiTableRowCellType.visual => Alignment.center,
      _ => cell.alignment,
    };
  }

  double _verticalPadding(HeroUiTableRowCellType type) {
    return switch (type) {
      HeroUiTableRowCellType.visualSupport => 8,
      HeroUiTableRowCellType.visual => 10,
      HeroUiTableRowCellType.chip => 9,
      HeroUiTableRowCellType.actions => 8,
      _ => 12,
    };
  }

  Color _resolveTextColor(HeroUiTableRowCell cell) {
    if (_isDisabled) return widget.tokens.disabledText;
    if (cell.type != HeroUiTableRowCellType.compare) return widget.tokens.text;

    if (cell.child is Text) {
      final textWidget = cell.child as Text;
      final value =
          (textWidget.data ?? textWidget.textSpan?.toPlainText() ?? '')
              .trimLeft();
      if (value.startsWith('+')) return widget.tokens.positive;
      if (value.startsWith('-')) return widget.tokens.negative;
    }
    return widget.tokens.text;
  }
}

class _HeroUiTableCheckbox extends StatelessWidget {
  const _HeroUiTableCheckbox({required this.value, this.onChanged});

  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return HeroUiCheckboxControl(
      value: value
          ? HeroUiCheckboxValue.selected
          : HeroUiCheckboxValue.unselected,
      variant: HeroUiCheckboxVariant.secondary,
      onToggle: onChanged == null ? null : () => onChanged?.call(!value),
    );
  }
}

class _HeroUiTableLayout {
  const _HeroUiTableLayout({
    required this.tableWidth,
    required this.columnWidths,
  });

  final double tableWidth;
  final List<double> columnWidths;
}

class _HeroUiTableTokens {
  const _HeroUiTableTokens({
    required this.surface,
    required this.frameBorder,
    required this.divider,
    required this.headerPrimaryBg,
    required this.headerSecondaryBg,
    required this.headerPrimaryText,
    required this.headerSecondaryText,
    required this.text,
    required this.mutedText,
    required this.disabledText,
    required this.rowHoverBg,
    required this.footerDataBg,
    required this.footerPaginationBg,
    required this.positive,
    required this.negative,
  });

  final Color surface;
  final Color frameBorder;
  final Color divider;
  final Color headerPrimaryBg;
  final Color headerSecondaryBg;
  final Color headerPrimaryText;
  final Color headerSecondaryText;
  final Color text;
  final Color mutedText;
  final Color disabledText;
  final Color rowHoverBg;
  final Color footerDataBg;
  final Color footerPaginationBg;
  final Color positive;
  final Color negative;

  static _HeroUiTableTokens resolve({
    required bool isDark,
    required HeroUiTableVariant tableVariant,
  }) {
    if (isDark) {
      return _HeroUiTableTokens(
        surface: tableVariant == HeroUiTableVariant.primary
            ? const Color(0xFF18181B)
            : const Color(0xFF111113),
        frameBorder: const Color(0xFF27272A),
        divider: const Color(0xFF27272A),
        headerPrimaryBg: const Color(0xFF27272A),
        headerSecondaryBg: const Color(0xFF18181B),
        headerPrimaryText: const Color(0xFFD4D4D8),
        headerSecondaryText: const Color(0xFFA1A1AA),
        text: const Color(0xFFFCFCFC),
        mutedText: const Color(0xFFA1A1AA),
        disabledText: const Color(0xFF71717A),
        rowHoverBg: const Color(0xFF27272A),
        footerDataBg: const Color(0xFF212126),
        footerPaginationBg: const Color(0xFF18181B),
        positive: const Color(0xFF4ADE80),
        negative: const Color(0xFFDB3B3E),
      );
    }

    return _HeroUiTableTokens(
      surface: tableVariant == HeroUiTableVariant.primary
          ? const Color(0xFFFFFFFF)
          : const Color(0xFFFDFDFD),
      frameBorder: const Color(0xFFE4E4E7),
      divider: const Color(0xFFE4E4E7),
      headerPrimaryBg: const Color(0xFFF4F4F5),
      headerSecondaryBg: const Color(0xFFFAFAFA),
      headerPrimaryText: const Color(0xFF52525B),
      headerSecondaryText: const Color(0xFF71717A),
      text: const Color(0xFF18181B),
      mutedText: const Color(0xFF71717A),
      disabledText: const Color(0xFFA1A1AA),
      rowHoverBg: const Color(0xFFF4F4F5),
      footerDataBg: const Color(0xFFFAFAFA),
      footerPaginationBg: const Color(0xFFFFFFFF),
      positive: const Color(0xFF15803D),
      negative: const Color(0xFFFF383C),
    );
  }
}
