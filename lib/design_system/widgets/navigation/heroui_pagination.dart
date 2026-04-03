import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/icons/heroui_icon.dart';
import '../../typography/heroui_typography.dart';
import '../buttons/heroui_buttons.dart';
import '../pickers/heroui_pickers.dart';

enum HeroUiPaginationVariant { primary, secondary }

class HeroUiPagination extends StatelessWidget {
  const HeroUiPagination({
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
    super.key,
    this.variant = HeroUiPaginationVariant.primary,
    this.windowSize = 5,
    this.totalItems,
    this.pageSize = 10,
    this.pageSizeOptions = const [5, 10, 20, 50],
    this.onPageSizeChanged,
    this.itemLabel = 'results',
    this.showRangeSummary = true,
    this.showPageNumbers,
    this.showPageSizeSelector,
    this.previousLabel,
    this.nextLabel,
  }) : assert(totalPages > 0, 'totalPages must be greater than zero');

  final int currentPage;
  final int totalPages;
  final ValueChanged<int>? onPageChanged;
  final HeroUiPaginationVariant variant;
  final int windowSize;
  final int? totalItems;
  final int pageSize;
  final List<int> pageSizeOptions;
  final ValueChanged<int>? onPageSizeChanged;
  final String itemLabel;
  final bool showRangeSummary;
  final bool? showPageNumbers;
  final bool? showPageSizeSelector;
  final String? previousLabel;
  final String? nextLabel;

  int get _safePageSize => math.max(1, pageSize);

  int get _clampedCurrentPage => currentPage.clamp(1, totalPages).toInt();

  int get _resolvedTotalItems => totalItems ?? totalPages * _safePageSize;

  int get _rangeStart => _resolvedTotalItems == 0
      ? 0
      : ((_clampedCurrentPage - 1) * _safePageSize) + 1;

  int get _rangeEnd => _resolvedTotalItems == 0
      ? 0
      : math.min(_clampedCurrentPage * _safePageSize, _resolvedTotalItems);

  bool get _showPageNumbersResolved =>
      showPageNumbers ?? variant == HeroUiPaginationVariant.secondary;

  bool get _showPageSizeSelectorResolved =>
      showPageSizeSelector ?? variant == HeroUiPaginationVariant.secondary;

  String _rangeSummaryText() {
    if (totalItems == null) {
      return 'Page $_clampedCurrentPage of $totalPages';
    }
    return '${_rangeStart.toString()} to ${_rangeEnd.toString()} of ${_resolvedTotalItems.toString()} $itemLabel';
  }

  List<int?> _buildVisiblePages() {
    if (totalPages <= 1 || !_showPageNumbersResolved) return const <int?>[];
    if (totalPages <= 7) {
      return [for (var page = 1; page <= totalPages; page++) page];
    }
    final side = math.max(1, windowSize ~/ 2);
    final anchors = <int>{
      1,
      2,
      3,
      totalPages - 2,
      totalPages - 1,
      totalPages,
      for (var delta = -side; delta <= side; delta++)
        _clampedCurrentPage + delta,
    }..removeWhere((value) => value < 1 || value > totalPages);
    final sorted = anchors.toList()..sort();
    final out = <int?>[];
    for (final page in sorted) {
      if (out.isNotEmpty) {
        final previous = out.last;
        if (previous != null && page - previous > 1) {
          out.add(null);
        }
      }
      out.add(page);
    }
    return out;
  }

  Widget _buildArrowButton({
    required bool isPrevious,
    required bool enabled,
    required VoidCallback? onPressed,
  }) {
    final label = isPrevious
        ? (previousLabel ??
              (variant == HeroUiPaginationVariant.primary
                  ? 'Prev'
                  : 'Previous'))
        : (nextLabel ?? 'Next');
    return HeroUiButton(
      label: label,
      variant: HeroUiButtonVariant.ghost,
      size: HeroUiButtonSize.sm,
      leading: isPrevious
          ? const HeroUiIcon(HeroUiIconManifest.chevronLeftRegular, size: 16)
          : null,
      trailing: isPrevious
          ? null
          : const HeroUiIcon(HeroUiIconManifest.chevronRightRegular, size: 16),
      onPressed: enabled ? onPressed : null,
    );
  }

  Widget _buildPrimaryNavigation() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _buildArrowButton(
          isPrevious: true,
          enabled: onPageChanged != null && _clampedCurrentPage > 1,
          onPressed: () => onPageChanged?.call(_clampedCurrentPage - 1),
        ),
        _buildArrowButton(
          isPrevious: false,
          enabled: onPageChanged != null && _clampedCurrentPage < totalPages,
          onPressed: () => onPageChanged?.call(_clampedCurrentPage + 1),
        ),
      ],
    );
  }

  Widget _buildSecondaryPageButtons(BuildContext context) {
    final muted = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFFA1A1AA)
        : const Color(0xFF71717A);
    final pages = _buildVisiblePages();
    return Wrap(
      spacing: 2,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (final page in pages)
          if (page == null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                '...',
                style: HeroUiTypography.bodySmMedium.copyWith(color: muted),
              ),
            )
          else
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              child: HeroUiButton(
                label: '$page',
                variant: page == _clampedCurrentPage
                    ? HeroUiButtonVariant.tertiary
                    : HeroUiButtonVariant.ghost,
                size: HeroUiButtonSize.sm,
                onPressed: onPageChanged == null
                    ? null
                    : () => onPageChanged!(page),
              ),
            ),
      ],
    );
  }

  Widget _buildPageSizeSelector(BuildContext context) {
    final options = pageSizeOptions.where((value) => value > 0).toSet().toList()
      ..sort();
    if (options.isEmpty) {
      options.add(_safePageSize);
    }
    final selectorValue = options.contains(pageSize) ? pageSize : options.first;
    final items = [
      for (final option in options)
        HeroUiPickerItem<int>(
          value: option,
          label: () {
            if (_resolvedTotalItems == 0) return '0-0';
            final maxPageForOption = (_resolvedTotalItems / option).ceil();
            final pageForOption = _clampedCurrentPage
                .clamp(1, maxPageForOption)
                .toInt();
            final start = ((pageForOption - 1) * option) + 1;
            final end = math.min(pageForOption * option, _resolvedTotalItems);
            return '${start.toString()}-${end.toString()}';
          }(),
        ),
    ];
    final longestLabel = items.fold<String>(
      '',
      (current, item) =>
          item.label.length > current.length ? item.label : current,
    );
    final textPainter = TextPainter(
      text: TextSpan(text: longestLabel, style: HeroUiTypography.textFieldSm),
      maxLines: 1,
      textDirection: Directionality.of(context),
    )..layout();
    final selectorWidth = (textPainter.width + 64)
        .clamp(96.0, 132.0)
        .toDouble();

    return SizedBox(
      width: selectorWidth,
      child: HeroUiSelect<int>(
        items: items,
        value: selectorValue,
        placeholder: '${_rangeStart.toString()}-${_rangeEnd.toString()}',
        onChanged: onPageSizeChanged,
        enabled: onPageSizeChanged != null,
        maxListHeight: 220,
      ),
    );
  }

  Widget _buildSecondaryNavigation(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _buildArrowButton(
          isPrevious: true,
          enabled: onPageChanged != null && _clampedCurrentPage > 1,
          onPressed: () => onPageChanged?.call(_clampedCurrentPage - 1),
        ),
        _buildSecondaryPageButtons(context),
        _buildArrowButton(
          isPrevious: false,
          enabled: onPageChanged != null && _clampedCurrentPage < totalPages,
          onPressed: () => onPageChanged?.call(_clampedCurrentPage + 1),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFFA1A1AA)
        : const Color(0xFF71717A);
    final left = switch (variant) {
      HeroUiPaginationVariant.primary =>
        showRangeSummary
            ? Text(
                _rangeSummaryText(),
                style: HeroUiTypography.bodySm.copyWith(color: muted),
              )
            : const SizedBox.shrink(),
      HeroUiPaginationVariant.secondary => Wrap(
        spacing: 12,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          if (_showPageSizeSelectorResolved) ...[
            Text(
              'Showing',
              style: HeroUiTypography.bodySm.copyWith(color: muted),
            ),
            _buildPageSizeSelector(context),
            Text(
              'of ${_resolvedTotalItems.toString()} $itemLabel',
              style: HeroUiTypography.bodySm.copyWith(color: muted),
            ),
          ] else if (showRangeSummary)
            Text(
              _rangeSummaryText(),
              style: HeroUiTypography.bodySm.copyWith(color: muted),
            ),
        ],
      ),
    };
    final right = switch (variant) {
      HeroUiPaginationVariant.primary => _buildPrimaryNavigation(),
      HeroUiPaginationVariant.secondary => _buildSecondaryNavigation(context),
    };

    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      runAlignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 16,
      runSpacing: 16,
      children: [left, right],
    );
  }
}
