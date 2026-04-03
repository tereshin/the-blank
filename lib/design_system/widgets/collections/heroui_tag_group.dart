part of 'heroui_collections.dart';

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
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: cs.onSurface,
                ),
              ),
              if (widget.isRequired)
                Text(
                  ' *',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: cs.error),
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
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
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
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: cs.error),
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
    HeroUiTagSize.sm => const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    HeroUiTagSize.md => const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    HeroUiTagSize.lg => const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
      bgColor = isSurface ? const Color(0xFFF5F5F5) : const Color(0xFFE1E1E2);
      textColor = cs.onSurface;
    } else {
      bgColor = isSurface ? cs.surface : const Color(0xFFEBEBEC);
      textColor = cs.onSurface;
    }

    if (isSurface && !selected) {
      border = Border.all(color: _isHovered ? cs.outline : cs.outlineVariant);
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
