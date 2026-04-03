import 'package:flutter/material.dart';

import '../../../../../core/icons/heroui_icon.dart';
import '../../../../../design_system/design_system.dart';
import 'shared_demo_widgets.dart';

Widget buildBreadcrumbsDemo(BuildContext context) => SingleChildScrollView(
  padding: const EdgeInsets.all(16),
  child: HeroUiBreadcrumbs(
    items: [
      HeroUiBreadcrumbItem(
        label: 'Home',
        onTap: () => showComponentDemoMessage(context, 'Home clicked'),
      ),
      HeroUiBreadcrumbItem(
        label: 'Components',
        onTap: () => showComponentDemoMessage(context, 'Components clicked'),
      ),
      const HeroUiBreadcrumbItem(label: 'Breadcrumbs'),
    ],
  ),
);

Widget buildLinkDemo(BuildContext context) => SingleChildScrollView(
  padding: const EdgeInsets.all(16),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      HeroUiLink(
        label: 'Default',
        onTap: () => showComponentDemoMessage(context, 'Default link clicked'),
      ),
      const SizedBox(height: 12),
      HeroUiLink(
        label: 'With external icon',
        showIcon: true,
        onTap: () => showComponentDemoMessage(context, 'External link clicked'),
      ),
      const SizedBox(height: 12),
      const HeroUiLink(
        label: 'Hover state',
        state: HeroUiLinkState.hover,
        showIcon: true,
      ),
      const SizedBox(height: 12),
      const HeroUiLink(
        label: 'Pressed state',
        state: HeroUiLinkState.pressed,
        showIcon: true,
      ),
      const SizedBox(height: 12),
      const HeroUiLink(
        label: 'Focus state',
        state: HeroUiLinkState.focus,
        showIcon: true,
      ),
      const SizedBox(height: 12),
      const HeroUiLink(
        label: 'Disabled link',
        state: HeroUiLinkState.disabled,
        showIcon: true,
      ),
    ],
  ),
);

Widget buildPaginationDemo(BuildContext context) => const _PaginationDemo();

Widget buildTabsDemo(BuildContext context) => const _TabsDemo();

Widget buildToolbarDemo(BuildContext context) => SingleChildScrollView(
  padding: const EdgeInsets.all(16),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const ComponentDemoSubtitle('Detached / Horizontal'),
      HeroUiToolbar(
        children: [
          HeroUiButton(
            label: 'Undo',
            variant: HeroUiButtonVariant.tertiary,
            size: HeroUiButtonSize.md,
            leading: const HeroUiIcon(HeroUiIconManifest.arrowLeftRegular),
            onPressed: () => showComponentDemoMessage(context, 'Undo clicked'),
          ),
          const HeroUiToolbarDivider(),
          HeroUiButton(
            label: 'Redo',
            variant: HeroUiButtonVariant.tertiary,
            size: HeroUiButtonSize.md,
            leading: const HeroUiIcon(HeroUiIconManifest.chevronRightRegular),
            onPressed: () => showComponentDemoMessage(context, 'Redo clicked'),
          ),
        ],
      ),
      const SizedBox(height: 16),
      const ComponentDemoSubtitle('Attached / Horizontal'),
      HeroUiToolbar(
        isAttached: true,
        children: [
          HeroUiButton(
            label: 'Copy',
            variant: HeroUiButtonVariant.tertiary,
            size: HeroUiButtonSize.md,
            leading: const HeroUiIcon(HeroUiIconManifest.houseRegular),
            onPressed: () => showComponentDemoMessage(context, 'Copy clicked'),
          ),
          const HeroUiToolbarDivider(),
          HeroUiButton(
            label: 'Paste',
            variant: HeroUiButtonVariant.tertiary,
            size: HeroUiButtonSize.md,
            leading: const HeroUiIcon(HeroUiIconManifest.plusRegular),
            onPressed: () => showComponentDemoMessage(context, 'Paste clicked'),
          ),
        ],
      ),
      const SizedBox(height: 16),
      const ComponentDemoSubtitle('Detached / Vertical'),
      HeroUiToolbar(
        orientation: HeroUiToolbarOrientation.vertical,
        children: [
          HeroUiButton(
            label: 'Save',
            variant: HeroUiButtonVariant.tertiary,
            size: HeroUiButtonSize.md,
            leading: const HeroUiIcon(HeroUiIconManifest.bellRegular),
            onPressed: () => showComponentDemoMessage(context, 'Save clicked'),
          ),
          const HeroUiToolbarDivider(
            toolbarOrientation: HeroUiToolbarOrientation.vertical,
          ),
          HeroUiButton(
            label: 'Delete',
            variant: HeroUiButtonVariant.tertiary,
            size: HeroUiButtonSize.md,
            leading: const HeroUiIcon(HeroUiIconManifest.trashBinRegular),
            onPressed: () =>
                showComponentDemoMessage(context, 'Delete clicked'),
          ),
        ],
      ),
      const SizedBox(height: 16),
      const ComponentDemoSubtitle('Attached / Vertical'),
      HeroUiToolbar(
        isAttached: true,
        orientation: HeroUiToolbarOrientation.vertical,
        children: [
          HeroUiButton(
            label: 'Settings',
            variant: HeroUiButtonVariant.tertiary,
            size: HeroUiButtonSize.md,
            leading: const HeroUiIcon(HeroUiIconManifest.gearRegular),
            onPressed: () =>
                showComponentDemoMessage(context, 'Settings clicked'),
          ),
          const HeroUiToolbarDivider(
            toolbarOrientation: HeroUiToolbarOrientation.vertical,
          ),
          HeroUiButton(
            label: 'Archive',
            variant: HeroUiButtonVariant.tertiary,
            size: HeroUiButtonSize.md,
            leading: const HeroUiIcon(
              HeroUiIconManifest.envelopeOpenXmarkRegular,
            ),
            onPressed: () =>
                showComponentDemoMessage(context, 'Archive clicked'),
          ),
        ],
      ),
    ],
  ),
);

class _TabsDemo extends StatefulWidget {
  const _TabsDemo();

  @override
  State<_TabsDemo> createState() => _TabsDemoState();
}

class _TabsDemoState extends State<_TabsDemo> {
  int _visibleOptions = 4;
  bool _showScrollShadow = true;

  List<HeroUiTabItem> get _durationTabs => const [
    HeroUiTabItem(label: '15m', child: Text('15m content')),
    HeroUiTabItem(label: '30m', child: Text('30m content')),
    HeroUiTabItem(label: '1h', child: Text('1h content')),
    HeroUiTabItem(label: '2h', child: Text('2h content')),
  ];

  List<HeroUiTabItem> get _inboxTabs => const [
    HeroUiTabItem(label: 'All', child: Text('All messages')),
    HeroUiTabItem(label: 'Unread', child: Text('Unread messages')),
  ];

  List<HeroUiTabItem> get _iconTabs => const [
    HeroUiTabItem(
      label: 'Chats',
      leading: HeroUiIcon('heroui-v3-icon__comment__regular', size: 16),
      child: Text('Chats content'),
    ),
    HeroUiTabItem(
      label: 'Emails',
      leading: HeroUiIcon(HeroUiIconManifest.envelopeRegular, size: 16),
      child: Text('Emails content'),
    ),
  ];

  List<HeroUiTabItem> get _verticalTabs => const [
    HeroUiTabItem(
      label: 'Center Stage for photos',
      leading: HeroUiIcon('heroui-v3-icon__square-dashed__regular', size: 16),
      child: Text('Photo mode'),
    ),
    HeroUiTabItem(
      label: 'Dual Capture Video',
      leading: HeroUiIcon('heroui-v3-icon__persons__regular', size: 16),
      child: Text('Dual capture'),
    ),
    HeroUiTabItem(
      label: 'Ultra-stabilized video',
      leading: HeroUiIcon(
        'heroui-v3-icon__square-dashed-circle__regular',
        size: 16,
      ),
      child: Text('Stabilized video'),
    ),
    HeroUiTabItem(
      label: 'Center Stage for video calls',
      leading: HeroUiIcon(HeroUiIconManifest.personRegular, size: 16),
      child: Text('Calls mode'),
    ),
  ];

  List<HeroUiTabItem> get _tenOptions => List<HeroUiTabItem>.generate(
    10,
    (index) => HeroUiTabItem(
      label: 'Option ${index + 1}',
      child: Text('Option ${index + 1} content'),
    ),
    growable: false,
  );

  List<bool> _optionVisibilityMask(int visibleCount) => [
    for (var i = 0; i < 10; i++) i < visibleCount,
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ComponentDemoTitle('Tabs'),
          const ComponentDemoSubtitle('Primary / Hug / Scroll shadow'),
          Center(
            child: SizedBox(
              width: 211,
              child: HeroUiTabs(
                tabs: _durationTabs,
                variant: HeroUiTabsVariant.primary,
                behavior: HeroUiTabsBehavior.hug,
                initialIndex: 2,
                showPanel: false,
                showScrollShadow: true,
              ),
            ),
          ),
          const SizedBox(height: 14),
          const ComponentDemoSubtitle('Primary / Fill'),
          Center(
            child: SizedBox(
              width: 253,
              child: HeroUiTabs(
                tabs: _durationTabs,
                variant: HeroUiTabsVariant.primary,
                behavior: HeroUiTabsBehavior.fill,
                showPanel: false,
              ),
            ),
          ),
          const SizedBox(height: 14),
          const ComponentDemoSubtitle('Primary / Fill / 2 options'),
          Center(
            child: SizedBox(
              width: 229,
              child: HeroUiTabs(
                tabs: _inboxTabs,
                variant: HeroUiTabsVariant.primary,
                behavior: HeroUiTabsBehavior.fill,
                showPanel: false,
              ),
            ),
          ),
          const SizedBox(height: 14),
          const ComponentDemoSubtitle('Primary / Fill / With icons'),
          Center(
            child: SizedBox(
              width: 229,
              child: HeroUiTabs(
                tabs: _iconTabs,
                variant: HeroUiTabsVariant.primary,
                behavior: HeroUiTabsBehavior.fill,
                showPanel: false,
              ),
            ),
          ),
          const SizedBox(height: 14),
          const ComponentDemoSubtitle('Primary / Fill / Vertical layout'),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 501,
              child: HeroUiTabs(
                tabs: _verticalTabs,
                variant: HeroUiTabsVariant.primary,
                behavior: HeroUiTabsBehavior.fill,
                tabContentOrientation: HeroUiTabContentOrientation.vertical,
                showPanel: false,
              ),
            ),
          ),
          const SizedBox(height: 14),
          const ComponentDemoSubtitle('Secondary / Hug'),
          Center(
            child: SizedBox(
              width: 211,
              child: HeroUiTabs(
                tabs: _durationTabs,
                variant: HeroUiTabsVariant.secondary,
                behavior: HeroUiTabsBehavior.hug,
                showPanel: false,
                showScrollShadow: false,
              ),
            ),
          ),
          const SizedBox(height: 14),
          const ComponentDemoSubtitle('Secondary / Fill / 2 options'),
          Center(
            child: SizedBox(
              width: 229,
              child: HeroUiTabs(
                tabs: _inboxTabs,
                variant: HeroUiTabsVariant.secondary,
                behavior: HeroUiTabsBehavior.fill,
                showPanel: false,
              ),
            ),
          ),
          const SizedBox(height: 14),
          const ComponentDemoSubtitle('Secondary / Fill / With icons'),
          Center(
            child: SizedBox(
              width: 229,
              child: HeroUiTabs(
                tabs: _iconTabs,
                variant: HeroUiTabsVariant.secondary,
                behavior: HeroUiTabsBehavior.fill,
                showPanel: false,
              ),
            ),
          ),
          const SizedBox(height: 14),
          const ComponentDemoSubtitle('Disabled option'),
          HeroUiTabs(
            tabs: const [
              HeroUiTabItem(label: 'Overview', child: Text('Overview')),
              HeroUiTabItem(label: 'Details', child: Text('Details')),
              HeroUiTabItem(
                label: 'Activity',
                child: Text('Activity'),
                isDisabled: true,
              ),
            ],
            variant: HeroUiTabsVariant.secondary,
            behavior: HeroUiTabsBehavior.hug,
            showPanel: false,
          ),
          const SizedBox(height: 16),
          const ComponentDemoSubtitle('Show Option 1-10 + Scroll shadow'),
          Text(
            'Visible options: $_visibleOptions',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          Slider(
            value: _visibleOptions.toDouble(),
            min: 1,
            max: 10,
            divisions: 9,
            label: '$_visibleOptions',
            onChanged: (value) {
              setState(() => _visibleOptions = value.round());
            },
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Switch(
                value: _showScrollShadow,
                onChanged: (value) {
                  setState(() => _showScrollShadow = value);
                },
              ),
              const SizedBox(width: 8),
              const Text('Show Scroll Shadow'),
            ],
          ),
          SizedBox(
            width: 260,
            child: HeroUiTabs(
              tabs: _tenOptions,
              variant: HeroUiTabsVariant.primary,
              behavior: HeroUiTabsBehavior.hug,
              showPanel: false,
              showScrollShadow: _showScrollShadow,
              showOptions: _optionVisibilityMask(_visibleOptions),
            ),
          ),
          const SizedBox(height: 14),
          const ComponentDemoSubtitle('With content panel'),
          HeroUiTabs(
            tabs: _inboxTabs,
            variant: HeroUiTabsVariant.secondary,
            behavior: HeroUiTabsBehavior.fill,
            panelHeight: null,
            panelPadding: const EdgeInsets.fromLTRB(4, 8, 4, 4),
          ),
        ],
      ),
    );
  }
}

class _PaginationDemo extends StatefulWidget {
  const _PaginationDemo();

  @override
  State<_PaginationDemo> createState() => _PaginationDemoState();
}

class _PaginationDemoState extends State<_PaginationDemo> {
  static const int _totalItems = 120;
  int _primaryPage = 1;
  int _secondaryPage = 1;
  int _pageSize = 10;

  int get _secondaryTotalPages => (_totalItems / _pageSize).ceil();

  @override
  Widget build(BuildContext context) {
    final clampedSecondaryPage = _secondaryPage
        .clamp(1, _secondaryTotalPages)
        .toInt();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ComponentDemoSubtitle('Primary'),
          HeroUiPagination(
            variant: HeroUiPaginationVariant.primary,
            currentPage: _primaryPage,
            totalPages: 12,
            totalItems: _totalItems,
            pageSize: 10,
            itemLabel: 'invoices',
            onPageChanged: (page) => setState(() => _primaryPage = page),
          ),
          const SizedBox(height: 16),
          const ComponentDemoSubtitle('Secondary'),
          const SizedBox(height: 12),
          HeroUiPagination(
            variant: HeroUiPaginationVariant.secondary,
            currentPage: clampedSecondaryPage,
            totalPages: _secondaryTotalPages,
            totalItems: _totalItems,
            pageSize: _pageSize,
            pageSizeOptions: const [5, 10, 20, 40],
            itemLabel: 'results',
            onPageChanged: (page) => setState(() => _secondaryPage = page),
            onPageSizeChanged: (value) {
              setState(() {
                _pageSize = value;
                final maxPage = _secondaryTotalPages;
                if (_secondaryPage > maxPage) {
                  _secondaryPage = maxPage;
                }
              });
            },
          ),
        ],
      ),
    );
  }
}
