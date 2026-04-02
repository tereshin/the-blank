import 'package:flutter/material.dart';

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
        label: 'Open docs',
        trailing: const Icon(Icons.open_in_new_rounded),
        onTap: () => showComponentDemoMessage(context, 'Open docs clicked'),
      ),
      const SizedBox(height: 12),
      const HeroUiLink(
        label: 'Disabled link',
        trailing: Icon(Icons.block_rounded),
      ),
    ],
  ),
);

Widget buildPaginationDemo(BuildContext context) => const _PaginationDemo();

Widget buildTabsDemo(BuildContext context) => const _TabsDemo();

Widget buildToolbarDemo(BuildContext context) => SingleChildScrollView(
  padding: const EdgeInsets.all(16),
  child: HeroUiToolbar(
    leading: const Icon(Icons.tune_rounded),
    title: const Text('Component actions'),
    actions: [
      HeroUiButton(
        label: 'Filter',
        onPressed: () => showComponentDemoMessage(context, 'Filter clicked'),
        variant: HeroUiButtonVariant.secondary,
        size: HeroUiButtonSize.sm,
      ),
      HeroUiButton(
        label: 'Create',
        onPressed: () => showComponentDemoMessage(context, 'Create clicked'),
        size: HeroUiButtonSize.sm,
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
      icon: Icons.chat_bubble_outline_rounded,
      child: Text('Chats content'),
    ),
    HeroUiTabItem(
      label: 'Emails',
      icon: Icons.mail_outline_rounded,
      child: Text('Emails content'),
    ),
  ];

  List<HeroUiTabItem> get _verticalTabs => const [
    HeroUiTabItem(
      label: 'Center Stage for photos',
      icon: Icons.crop_free_rounded,
      child: Text('Photo mode'),
    ),
    HeroUiTabItem(
      label: 'Dual Capture Video',
      icon: Icons.groups_2_outlined,
      child: Text('Dual capture'),
    ),
    HeroUiTabItem(
      label: 'Ultra-stabilized video',
      icon: Icons.videocam_outlined,
      child: Text('Stabilized video'),
    ),
    HeroUiTabItem(
      label: 'Center Stage for calls',
      icon: Icons.person_outline_rounded,
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
          SizedBox(
            width: 210,
            child: HeroUiTabs(
              tabs: _durationTabs,
              variant: HeroUiTabsVariant.primary,
              behavior: HeroUiTabsBehavior.hug,
              showPanel: false,
              showScrollShadow: true,
            ),
          ),
          const SizedBox(height: 14),
          const ComponentDemoSubtitle('Primary / Fill'),
          HeroUiTabs(
            tabs: _durationTabs,
            variant: HeroUiTabsVariant.primary,
            behavior: HeroUiTabsBehavior.fill,
            showPanel: false,
          ),
          const SizedBox(height: 14),
          const ComponentDemoSubtitle('Secondary / Hug'),
          SizedBox(
            width: 240,
            child: HeroUiTabs(
              tabs: _durationTabs,
              variant: HeroUiTabsVariant.secondary,
              behavior: HeroUiTabsBehavior.hug,
              showPanel: false,
            ),
          ),
          const SizedBox(height: 14),
          const ComponentDemoSubtitle('Secondary / Fill / With icons'),
          HeroUiTabs(
            tabs: _iconTabs,
            variant: HeroUiTabsVariant.secondary,
            behavior: HeroUiTabsBehavior.fill,
            showPanel: false,
          ),
          const SizedBox(height: 14),
          const ComponentDemoSubtitle('Primary / Fill / Vertical layout'),
          HeroUiTabs(
            tabs: _verticalTabs,
            variant: HeroUiTabsVariant.primary,
            behavior: HeroUiTabsBehavior.fill,
            tabContentOrientation: HeroUiTabContentOrientation.vertical,
            showPanel: false,
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
  int _page = 3;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Current page: $_page'),
          const SizedBox(height: 12),
          HeroUiPagination(
            currentPage: _page,
            totalPages: 12,
            onPageChanged: (page) => setState(() => _page = page),
          ),
        ],
      ),
    );
  }
}
