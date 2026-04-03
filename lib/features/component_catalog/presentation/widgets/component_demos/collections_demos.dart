import 'package:flutter/material.dart';

import '../../../../../core/icons/heroui_icon.dart';
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
          _SectionBox(children: [HeroUiAccordion(items: _items)]),
          const SizedBox(height: 24),
          const ComponentDemoTitle('Accordion — secondary'),
          _SectionBox(
            children: [
              HeroUiAccordion(
                variant: HeroUiAccordionVariant.secondary,
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
                  variant: HeroUiAccordionVariant.secondary,
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
    HeroUiListBoxItem(value: 'svelte', label: 'Svelte', isDisabled: true),
    HeroUiListBoxItem<String>(value: 'delete', label: 'Delete', isDanger: true),
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
              const Text(
                'Small',
                style: TextStyle(fontSize: 12, color: Color(0xFF71717A)),
              ),
              const SizedBox(height: 8),
              HeroUiTagGroup(
                items: _techTags.take(4).toList(),
                size: HeroUiTagSize.sm,
              ),
              const SizedBox(height: 16),
              const Text(
                'Medium (default)',
                style: TextStyle(fontSize: 12, color: Color(0xFF71717A)),
              ),
              const SizedBox(height: 8),
              HeroUiTagGroup(
                items: _techTags.take(4).toList(),
                size: HeroUiTagSize.md,
              ),
              const SizedBox(height: 16),
              const Text(
                'Large',
                style: TextStyle(fontSize: 12, color: Color(0xFF71717A)),
              ),
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
  static const HeroUiTableHeader _leadingHeader = HeroUiTableHeader(
    variant: HeroUiTableHeaderVariant.primary,
    width: HeroUiTableHeaderWidth.leading,
    showCheck: true,
    showDrag: true,
    cells: [
      HeroUiTableHeaderCell(
        label: 'Employee',
        variant: HeroUiTableHeaderCellVariant.sortingHighest,
        showTooltip: true,
        tooltipMessage: 'Sort by employee name',
        minWidth: 260,
      ),
      HeroUiTableHeaderCell(label: 'Revenue', minWidth: 140),
      HeroUiTableHeaderCell(
        label: 'Growth',
        variant: HeroUiTableHeaderCellVariant.sortingLowest,
        minWidth: 120,
      ),
      HeroUiTableHeaderCell(label: 'Status', minWidth: 130),
      HeroUiTableHeaderCell(
        label: 'Actions',
        alignment: Alignment.centerRight,
        minWidth: 140,
      ),
    ],
  );

  static const HeroUiTableHeader _equalHeader = HeroUiTableHeader(
    variant: HeroUiTableHeaderVariant.secondary,
    width: HeroUiTableHeaderWidth.equal,
    cells: [
      HeroUiTableHeaderCell(label: 'Avatar', alignment: Alignment.center),
      HeroUiTableHeaderCell(label: 'Name', minWidth: 160),
      HeroUiTableHeaderCell(
        label: 'Team',
        showTooltip: true,
        tooltipMessage: 'Current team assignment',
      ),
      HeroUiTableHeaderCell(
        label: 'Utilization',
        variant: HeroUiTableHeaderCellVariant.sortingHighest,
        alignment: Alignment.centerRight,
      ),
    ],
  );

  static List<HeroUiTableRow> _buildLeadingRows() {
    return [
      HeroUiTableRow(
        isChecked: true,
        cells: [
          _employeeCell(
            initials: 'KM',
            name: 'Kate Moore',
            email: 'kate.moore@heroui.com',
            type: HeroUiComponentType.accent,
          ),
          const HeroUiTableRowCell(child: Text('\$18,430')),
          _compareCell('+18.3%'),
          _statusCell('Active', HeroUiComponentType.success),
          _actionsCell(),
        ],
      ),
      HeroUiTableRow(
        state: HeroUiTableRowState.hover,
        cells: [
          _employeeCell(
            initials: 'AT',
            name: 'Alex Taylor',
            email: 'alex.taylor@heroui.com',
            type: HeroUiComponentType.defaultType,
          ),
          const HeroUiTableRowCell(child: Text('\$14,820')),
          _compareCell('-4.2%'),
          _statusCell('On hold', HeroUiComponentType.warning),
          _actionsCell(),
        ],
      ),
      HeroUiTableRow(
        cells: [
          _employeeCell(
            initials: 'SR',
            name: 'Sam Rivera',
            email: 'sam.rivera@heroui.com',
            type: HeroUiComponentType.success,
          ),
          const HeroUiTableRowCell(child: Text('\$22,110')),
          _compareCell('+26.7%'),
          _statusCell('Active', HeroUiComponentType.success),
          _actionsCell(),
        ],
      ),
      HeroUiTableRow(
        state: HeroUiTableRowState.disabled,
        showCheck: false,
        showDrag: false,
        cells: [
          _employeeCell(
            initials: 'JL',
            name: 'Jordan Lee',
            email: 'jordan.lee@heroui.com',
            type: HeroUiComponentType.defaultType,
          ),
          const HeroUiTableRowCell(child: Text('\$11,390')),
          _compareCell('-2.1%'),
          _statusCell('Archived', HeroUiComponentType.defaultType),
          _actionsCell(),
        ],
      ),
    ];
  }

  static List<HeroUiTableRow> _buildEqualRows() {
    return [
      HeroUiTableRow(
        width: HeroUiTableRowWidth.equal,
        cells: [
          HeroUiTableRowCell(
            type: HeroUiTableRowCellType.visual,
            alignment: Alignment.center,
            child: const HeroUiAvatar(
              initials: 'KM',
              size: 28,
              variant: HeroUiAvatarVariant.letterSoft,
              type: HeroUiComponentType.accent,
            ),
          ),
          const HeroUiTableRowCell(child: Text('Kate Moore')),
          const HeroUiTableRowCell(child: Text('Design')),
          _compareCell('+84%'),
        ],
      ),
      HeroUiTableRow(
        width: HeroUiTableRowWidth.equal,
        cells: [
          HeroUiTableRowCell(
            type: HeroUiTableRowCellType.visual,
            alignment: Alignment.center,
            child: const HeroUiAvatar(
              initials: 'AT',
              size: 28,
              variant: HeroUiAvatarVariant.letter,
              type: HeroUiComponentType.defaultType,
            ),
          ),
          const HeroUiTableRowCell(child: Text('Alex Taylor')),
          const HeroUiTableRowCell(child: Text('Engineering')),
          _compareCell('+67%'),
        ],
      ),
      HeroUiTableRow(
        width: HeroUiTableRowWidth.equal,
        cells: [
          HeroUiTableRowCell(
            type: HeroUiTableRowCellType.visual,
            alignment: Alignment.center,
            child: const HeroUiAvatar(
              initials: 'SR',
              size: 28,
              variant: HeroUiAvatarVariant.letterSoft,
              type: HeroUiComponentType.success,
            ),
          ),
          const HeroUiTableRowCell(child: Text('Sam Rivera')),
          const HeroUiTableRowCell(child: Text('Product')),
          _compareCell('-12%'),
        ],
      ),
    ];
  }

  static HeroUiTableRowCell _employeeCell({
    required String initials,
    required String name,
    required String email,
    required HeroUiComponentType type,
  }) {
    return HeroUiTableRowCell(
      type: HeroUiTableRowCellType.visualSupport,
      variant: HeroUiTableRowCellVariant.leading,
      prefix: HeroUiAvatar(
        initials: initials,
        size: 32,
        variant: HeroUiAvatarVariant.letterSoft,
        type: type,
      ),
      child: _TableEmployeeInfo(name: name, email: email),
    );
  }

  static HeroUiTableRowCell _compareCell(String value) {
    final isPositive = value.trimLeft().startsWith('+');
    return HeroUiTableRowCell(
      type: HeroUiTableRowCellType.compare,
      alignment: Alignment.centerRight,
      prefix: HeroUiIcon(
        isPositive
            ? HeroUiIconManifest.arrowUpRegular
            : HeroUiIconManifest.arrowDownRegular,
        size: 14,
      ),
      child: Text(value),
    );
  }

  static HeroUiTableRowCell _statusCell(
    String value,
    HeroUiComponentType type,
  ) {
    return HeroUiTableRowCell(
      type: HeroUiTableRowCellType.chip,
      child: HeroUiBadge(
        label: value,
        type: type,
        variant: HeroUiBadgeVariant.soft,
        size: HeroUiBadgeSize.sm,
      ),
    );
  }

  static HeroUiTableRowCell _actionsCell() {
    return const HeroUiTableRowCell(
      type: HeroUiTableRowCellType.actions,
      alignment: Alignment.centerRight,
      child: _TableRowActions(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final leadingRows = _buildLeadingRows();
    final equalRows = _buildEqualRows();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ComponentDemoTitle(
            'Table — primary (leading width, data footer)',
          ),
          HeroUiTable(
            variant: HeroUiTableVariant.primary,
            header: _leadingHeader,
            rows: leadingRows,
            footer: const HeroUiTableFooter(
              type: HeroUiTableFooterType.data,
              leading: Text('Total quarterly revenue'),
              trailing: Text(
                '\$66,750',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const ComponentDemoTitle('Table — secondary (equal width)'),
          HeroUiTable(
            variant: HeroUiTableVariant.secondary,
            header: _equalHeader,
            rows: equalRows,
          ),
          const SizedBox(height: 24),
          const ComponentDemoTitle('Table — pagination footer'),
          HeroUiTable(
            variant: HeroUiTableVariant.primary,
            header: _leadingHeader,
            rows: leadingRows.take(3).toList(),
            footer: HeroUiTableFooter(
              type: HeroUiTableFooterType.pagination,
              leading: const Text('Showing 1-3 of 12 employees'),
              trailing: HeroUiPagination(
                currentPage: 1,
                totalPages: 4,
                onPageChanged: (_) {},
                showRangeSummary: false,
                showPageNumbers: false,
                showPageSizeSelector: false,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const ComponentDemoTitle('Table — empty state'),
          HeroUiTable(
            header: _leadingHeader,
            rows: const [],
            emptyWidget: Column(
              children: const [
                HeroUiIcon(
                  HeroUiIconManifest.squareListUlRegular,
                  size: 48,
                  color: Color(0xFFD4D4D8),
                ),
                SizedBox(height: 8),
                Text(
                  'No employee records found.',
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
              header: _leadingHeader,
              rows: leadingRows.take(2).toList(),
              footer: const HeroUiTableFooter(
                type: HeroUiTableFooterType.data,
                leading: Text('Total quarterly revenue'),
                trailing: Text(
                  '\$33,250',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TableEmployeeInfo extends StatelessWidget {
  const _TableEmployeeInfo({required this.name, required this.email});

  final String name;
  final String email;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final supportColor = isDark
        ? const Color(0xFFA1A1AA)
        : const Color(0xFF71717A);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name, style: HeroUiTypography.bodySmMedium),
        const SizedBox(height: 2),
        Text(
          email,
          style: HeroUiTypography.bodyXs.copyWith(color: supportColor),
        ),
      ],
    );
  }
}

class _TableRowActions extends StatelessWidget {
  const _TableRowActions();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _TableActionIconButton(
          iconName: HeroUiIconManifest.eyeRegular,
          label: 'View',
        ),
        SizedBox(width: 4),
        _TableActionIconButton(
          iconName: HeroUiIconManifest.pencilRegular,
          label: 'Edit',
        ),
        SizedBox(width: 4),
        _TableActionIconButton(
          iconName: HeroUiIconManifest.deleteRegular,
          label: 'Delete',
          isDanger: true,
        ),
      ],
    );
  }
}

class _TableActionIconButton extends StatelessWidget {
  const _TableActionIconButton({
    required this.iconName,
    required this.label,
    this.isDanger = false,
  });

  final String iconName;
  final String label;
  final bool isDanger;

  @override
  Widget build(BuildContext context) {
    return HeroUiButton(
      label: label,
      iconOnly: true,
      size: HeroUiButtonSize.sm,
      variant: isDanger
          ? HeroUiButtonVariant.dangerSoft
          : HeroUiButtonVariant.ghost,
      leading: HeroUiIcon(iconName, size: 16),
      onPressed: () {},
    );
  }
}
