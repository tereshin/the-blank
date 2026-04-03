part of 'heroui_collections.dart';

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
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: cs.onSurface,
                                ),
                          ),
                          if (item.subtitle != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              item.subtitle!,
                              style: Theme.of(context).textTheme.bodySmall
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
            child: Align(alignment: Alignment.topLeft, child: item.content),
          ),
        ),
        if (widget.showDivider) Divider(height: 1, color: cs.outlineVariant),
      ],
    );
  }
}
