import 'package:flutter/material.dart';

import '../../../../../design_system/design_system.dart';
import 'shared_demo_widgets.dart';

Widget buildAccordionDemo(BuildContext context) => _AccordionDemoPage();
Widget buildListBoxDemo(BuildContext context) => _ListBoxDemoPage();
Widget buildTagGroupDemo(BuildContext context) => _TagGroupDemoPage();
Widget buildTableDemo(BuildContext context) => _TableDemoPage();

// ─── Shared helpers ───────────────────────────────────────────────────────────

class _SectionBox extends StatelessWidget {
  const _SectionBox({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE4E4E7)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}

// ─── Accordion ────────────────────────────────────────────────────────────────

class _AccordionDemoPage extends StatelessWidget {
  static List<HeroUiAccordionItem> get _items => const [
        HeroUiAccordionItem(
          title: 'Is it accessible?',
          subtitle: 'Keyboard navigation & ARIA',
          content: Text(
            'Yes. It adheres to the WAI-ARIA design pattern and supports '
            'keyboard navigation including Tab and Enter keys.',
          ),
          initiallyExpanded: true,
        ),
        HeroUiAccordionItem(
          title: 'Is it styled?',
          content: Text(
            'Yes. It comes with default styles that match the design system. '
            'You can customize it with your theme.',
          ),
        ),
        HeroUiAccordionItem(
          title: 'Is it animated?',
          content: Text(
            'Yes. Smooth height transitions and icon rotation are included '
            'by default.',
          ),
        ),
        HeroUiAccordionItem(
          title: 'Disabled item (cannot expand)',
          content: Text('This content cannot be shown.'),
          isDisabled: true,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ComponentDemoTitle('Accordion — default (flat)'),
          _SectionBox(
            children: [HeroUiAccordion(items: _items)],
          ),
          const SizedBox(height: 24),
          const ComponentDemoTitle('Accordion — bordered'),
          _SectionBox(
            children: [
              HeroUiAccordion(
                variant: HeroUiAccordionVariant.bordered,
                items: _items,
              ),
            ],
          ),
          const SizedBox(height: 24),
          const ComponentDemoTitle('Accordion — multiple selection'),
          _SectionBox(
            children: [
              HeroUiAccordion(
                selectionMode: HeroUiAccordionSelectionMode.multiple,
                items: const [
                  HeroUiAccordionItem(
                    title: 'Section A',
                    initiallyExpanded: true,
                    content: Text('Content for section A.'),
                  ),
                  HeroUiAccordionItem(
                    title: 'Section B',
                    initiallyExpanded: true,
                    content: Text('Content for section B.'),
                  ),
                  HeroUiAccordionItem(
                    title: 'Section C',
                    content: Text('Content for section C.'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          const ComponentDemoTitle('Dark mode preview'),
          Theme(
            data: ThemeData.dark(),
            child: _SectionBox(
              children: [
                HeroUiAccordion(
                  variant: HeroUiAccordionVariant.bordered,
                  items: _items.take(3).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── ListBox ──────────────────────────────────────────────────────────────────

class _ListBoxDemoPage extends StatelessWidget {
  static const _frameworkItems = [
    HeroUiListBoxItem(value: 'react', label: 'React'),
    HeroUiListBoxItem(
      value: 'vue',
      label: 'Vue',
      description: 'Progressive JavaScript framework',
    ),
    HeroUiListBoxItem(value: 'angular', label: 'Angular'),
    HeroUiListBoxItem(
      value: 'svelte',
      label: 'Svelte',
      isDisabled: true,
    ),
    HeroUiListBoxItem<String>(
      value: 'delete',
      label: 'Delete',
      isDanger: true,
    ),
  ];

  static const _petItems = [
    HeroUiListBoxItem(value: 'cat', label: 'Cat'),
    HeroUiListBoxItem(value: 'dog', label: 'Dog'),
    HeroUiListBoxItem(value: 'rabbit', label: 'Rabbit'),
    HeroUiListBoxItem(value: 'fish', label: 'Fish'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ComponentDemoTitle('ListBox — single selection'),
          _SectionBox(
            children: [
              HeroUiListBox<String>(
                label: 'Choose a framework',
                items: _frameworkItems,
                selectedValues: const {'vue'},
              ),
            ],
          ),
          const SizedBox(height: 24),
          const ComponentDemoTitle('ListBox — multiple selection'),
          _SectionBox(
            children: [
              HeroUiListBox<String>(
                label: 'Choose your pets',
                description: 'You can select multiple options.',
                items: _petItems,
                selectionMode: HeroUiListBoxSelectionMode.multiple,
                selectedValues: const {'cat', 'dog'},
              ),
            ],
          ),
          const SizedBox(height: 24),
          const ComponentDemoTitle('Dark mode preview'),
          Theme(
            data: ThemeData.dark(),
            child: _SectionBox(
              children: [
                HeroUiListBox<String>(
                  label: 'Choose a framework',
                  items: _frameworkItems.take(4).toList(),
                  selectedValues: const {'react'},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── TagGroup ─────────────────────────────────────────────────────────────────

class _TagGroupDemoPage extends StatelessWidget {
  static const _techTags = [
    HeroUiTagItem(value: 'react', label: 'React'),
    HeroUiTagItem(value: 'vue', label: 'Vue'),
    HeroUiTagItem(value: 'angular', label: 'Angular'),
    HeroUiTagItem(value: 'svelte', label: 'Svelte'),
    HeroUiTagItem(value: 'disabled', label: 'Disabled', isDisabled: true),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ComponentDemoTitle('TagGroup — default variant'),
          _SectionBox(
            children: [
              HeroUiTagGroup(
                label: 'Technologies',
                description: 'Select all that apply.',
                items: _techTags,
                selectedValues: const {'react', 'svelte'},
              ),
            ],
          ),
          const SizedBox(height: 24),
          const ComponentDemoTitle('TagGroup — surface variant'),
          _SectionBox(
            children: [
              HeroUiTagGroup(
                variant: HeroUiTagVariant.surface,
                label: 'Technologies',
                items: _techTags,
                selectedValues: const {'vue'},
              ),
            ],
          ),
          const SizedBox(height: 24),
          const ComponentDemoTitle('TagGroup — sizes'),
          _SectionBox(
            children: [
              const Text('Small', style: TextStyle(fontSize: 12, color: Color(0xFF71717A))),
              const SizedBox(height: 8),
              HeroUiTagGroup(
                items: _techTags.take(4).toList(),
                size: HeroUiTagSize.sm,
              ),
              const SizedBox(height: 16),
              const Text('Medium (default)', style: TextStyle(fontSize: 12, color: Color(0xFF71717A))),
              const SizedBox(height: 8),
              HeroUiTagGroup(
                items: _techTags.take(4).toList(),
                size: HeroUiTagSize.md,
              ),
              const SizedBox(height: 16),
              const Text('Large', style: TextStyle(fontSize: 12, color: Color(0xFF71717A))),
              const SizedBox(height: 8),
              HeroUiTagGroup(
                items: _techTags.take(4).toList(),
                size: HeroUiTagSize.lg,
              ),
            ],
          ),
          const SizedBox(height: 24),
          const ComponentDemoTitle('TagGroup — error state'),
          _SectionBox(
            children: [
              HeroUiTagGroup(
                label: 'Choose a framework',
                isRequired: true,
                items: _techTags.take(4).toList(),
                errorMessage: 'Please select at least one option.',
              ),
            ],
          ),
          const SizedBox(height: 24),
          const ComponentDemoTitle('Dark mode preview'),
          Theme(
            data: ThemeData.dark(),
            child: _SectionBox(
              children: [
                HeroUiTagGroup(
                  label: 'Technologies',
                  items: _techTags,
                  selectedValues: const {'angular'},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Table ────────────────────────────────────────────────────────────────────

class _TableDemoPage extends StatelessWidget {
  static const _columns = [
    HeroUiTableColumn(key: 'name', label: 'Name', flex: 2, sortable: true),
    HeroUiTableColumn(key: 'role', label: 'Role', flex: 2),
    HeroUiTableColumn(key: 'status', label: 'Status', flex: 1),
    HeroUiTableColumn(
      key: 'actions',
      label: '',
      flex: 1,
      alignment: Alignment.centerRight,
    ),
  ];

  static List<HeroUiTableRow> _buildRows(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    Widget statusBadge(String status) {
      final isActive = status == 'Active';
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: isActive
              ? Colors.green.withOpacity(0.12)
              : cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          status,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isActive ? const Color(0xFF15803D) : cs.onSurfaceVariant,
          ),
        ),
      );
    }

    Widget actions() => Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _TableIconBtn(icon: Icons.edit_outlined),
            const SizedBox(width: 4),
            _TableIconBtn(
              icon: Icons.delete_outline_rounded,
              isDanger: true,
            ),
          ],
        );

    return [
      HeroUiTableRow(cells: {
        'name': const Text('Kate Moore', style: TextStyle(fontSize: 14)),
        'role': const Text('Designer', style: TextStyle(fontSize: 14)),
        'status': statusBadge('Active'),
        'actions': actions(),
      }),
      HeroUiTableRow(cells: {
        'name': const Text('Alex Taylor', style: TextStyle(fontSize: 14)),
        'role': const Text('Developer', style: TextStyle(fontSize: 14)),
        'status': statusBadge('Inactive'),
        'actions': actions(),
      }),
      HeroUiTableRow(cells: {
        'name': const Text('Sam Rivera', style: TextStyle(fontSize: 14)),
        'role': const Text('Product Manager', style: TextStyle(fontSize: 14)),
        'status': statusBadge('Active'),
        'actions': actions(),
      }),
      HeroUiTableRow(cells: {
        'name': const Text('Jordan Lee', style: TextStyle(fontSize: 14)),
        'role': const Text('Engineer', style: TextStyle(fontSize: 14)),
        'status': statusBadge('Active'),
        'actions': actions(),
      }),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final rows = _buildRows(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ComponentDemoTitle('Table — primary variant'),
          HeroUiTable(
            columns: _columns,
            rows: rows,
          ),
          const SizedBox(height: 24),
          const ComponentDemoTitle('Table — secondary variant'),
          HeroUiTable(
            variant: HeroUiTableVariant.secondary,
            columns: _columns,
            rows: rows,
          ),
          const SizedBox(height: 24),
          const ComponentDemoTitle('Table — empty state'),
          HeroUiTable(
            columns: _columns,
            rows: const [],
            emptyWidget: Column(
              children: const [
                Icon(Icons.inbox_outlined, size: 48, color: Color(0xFFD4D4D8)),
                SizedBox(height: 8),
                Text(
                  'No results found.',
                  style: TextStyle(color: Color(0xFF71717A)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const ComponentDemoTitle('Dark mode preview'),
          Theme(
            data: ThemeData.dark(),
            child: HeroUiTable(
              columns: _columns,
              rows: _buildRows(context).take(3).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _TableIconBtn extends StatefulWidget {
  const _TableIconBtn({required this.icon, this.isDanger = false});
  final IconData icon;
  final bool isDanger;

  @override
  State<_TableIconBtn> createState() => _TableIconBtnState();
}

class _TableIconBtnState extends State<_TableIconBtn> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final bg = widget.isDanger
        ? (_isHovered
            ? const Color(0xFFFF383C).withOpacity(0.15)
            : const Color(0xFFFF383C).withOpacity(0.08))
        : (_isHovered ? cs.surfaceContainerHighest : const Color(0xFFEBEBEC));

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          widget.icon,
          size: 16,
          color: widget.isDanger ? const Color(0xFFFF383C) : cs.onSurface,
        ),
      ),
    );
  }
}
