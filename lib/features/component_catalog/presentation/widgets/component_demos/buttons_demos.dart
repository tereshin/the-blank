import 'package:flutter/material.dart';

import 'package:heroui_design_system/design_system.dart';

Widget buildButtonDemo(BuildContext context) => SingleChildScrollView(
  padding: const EdgeInsets.all(16),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const ComponentDemoTitle('Variants (default state)'),
      _HorizontalButtonsRow(
        children: [
          HeroUiButton(
            label: 'Primary',
            onPressed: () {},
            variant: HeroUiButtonVariant.primary,
          ),
          HeroUiButton(
            label: 'Secondary',
            onPressed: () {},
            variant: HeroUiButtonVariant.secondary,
          ),
          HeroUiButton(
            label: 'Danger',
            onPressed: () {},
            variant: HeroUiButtonVariant.danger,
          ),
          HeroUiButton(
            label: 'Tertiary',
            onPressed: () {},
            variant: HeroUiButtonVariant.tertiary,
          ),
          HeroUiButton(
            label: 'Outline',
            onPressed: () {},
            variant: HeroUiButtonVariant.outline,
          ),
          HeroUiButton(
            label: 'Ghost',
            onPressed: () {},
            variant: HeroUiButtonVariant.ghost,
          ),
          HeroUiButton(
            label: 'Danger soft',
            onPressed: () {},
            variant: HeroUiButtonVariant.dangerSoft,
          ),
          const HeroUiButton(
            label: 'Disabled',
            onPressed: null,
            variant: HeroUiButtonVariant.primary,
          ),
        ],
      ),
      const SizedBox(height: 20),
      const ComponentDemoTitle('Variants with icons (light / dark)'),
      _ButtonThemePreviewSurface(
        themeLabel: 'Light',
        dark: false,
        child: _HorizontalButtonsRow(children: _buttonIconVariants()),
      ),
      const SizedBox(height: 12),
      _ButtonThemePreviewSurface(
        themeLabel: 'Dark',
        dark: true,
        child: _HorizontalButtonsRow(children: _buttonIconVariants()),
      ),
      const SizedBox(height: 20),
      const ComponentDemoTitle('Primary states'),
      Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          HeroUiButton(
            label: 'Default',
            onPressed: () {},
            variant: HeroUiButtonVariant.primary,
          ),
          HeroUiButton(
            label: 'Hover',
            onPressed: () {},
            variant: HeroUiButtonVariant.primary,
            state: HeroUiButtonVisualState.hover,
          ),
          HeroUiButton(
            label: 'Pressed',
            onPressed: () {},
            variant: HeroUiButtonVariant.primary,
            state: HeroUiButtonVisualState.pressed,
          ),
          HeroUiButton(
            label: 'Focus',
            onPressed: () {},
            variant: HeroUiButtonVariant.primary,
            state: HeroUiButtonVisualState.focus,
          ),
          const HeroUiButton(
            label: 'Disabled',
            onPressed: null,
            variant: HeroUiButtonVariant.primary,
          ),
        ],
      ),
      const SizedBox(height: 20),
      const ComponentDemoTitle('Sizes'),
      Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          HeroUiButton(
            label: 'Small',
            onPressed: () {},
            size: HeroUiButtonSize.sm,
          ),
          HeroUiButton(
            label: 'Medium',
            onPressed: () {},
            size: HeroUiButtonSize.md,
          ),
          HeroUiButton(
            label: 'Large',
            onPressed: () {},
            size: HeroUiButtonSize.lg,
          ),
        ],
      ),
    ],
  ),
);

List<Widget> _buttonIconVariants() => [
  HeroUiButton(
    label: 'Search',
    onPressed: () {},
    variant: HeroUiButtonVariant.primary,
    leading: const _ButtonGroupIcon(HeroUiIconManifest.globe),
  ),
  HeroUiButton(
    label: 'Add member',
    onPressed: () {},
    variant: HeroUiButtonVariant.secondary,
    leading: const _ButtonGroupIcon(HeroUiIconManifest.plus),
  ),
  HeroUiButton(
    label: 'Delete',
    onPressed: () {},
    variant: HeroUiButtonVariant.danger,
    leading: const _ButtonGroupIcon(HeroUiIconManifest.trashBin),
  ),
  HeroUiButton(
    label: 'Email',
    onPressed: () {},
    variant: HeroUiButtonVariant.tertiary,
    leading: const _ButtonGroupIcon(HeroUiIconManifest.envelope),
  ),
  HeroUiButton(
    label: 'Follow',
    onPressed: () {},
    variant: HeroUiButtonVariant.outline,
    leading: const _ButtonGroupIcon(HeroUiIconManifest.personPlus),
  ),
  HeroUiButton(
    label: 'Go back',
    onPressed: () {},
    variant: HeroUiButtonVariant.ghost,
    leading: const _ButtonGroupIcon(HeroUiIconManifest.arrowLeft),
  ),
  HeroUiButton(
    label: 'Cancel',
    onPressed: () {},
    variant: HeroUiButtonVariant.dangerSoft,
    leading: const _ButtonGroupIcon(HeroUiIconManifest.envelopeOpenXmark),
  ),
  HeroUiButton(
    label: 'Icon only',
    onPressed: () {},
    iconOnly: true,
    variant: HeroUiButtonVariant.primary,
    leading: const _ButtonGroupIcon(HeroUiIconManifest.plus),
  ),
];

Widget buildButtonGroupDemo(BuildContext context) => SingleChildScrollView(
  padding: const EdgeInsets.all(16),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const ComponentDemoTitle('Figma examples (ButtonGroup)'),
      const _ButtonGroupExamplesSurface(themeLabel: 'Light', dark: false),
      const SizedBox(height: 20),
      const _ButtonGroupExamplesSurface(themeLabel: 'Dark', dark: true),
    ],
  ),
);

Widget buildCloseButtonDemo(BuildContext context) => SingleChildScrollView(
  padding: const EdgeInsets.all(16),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const ComponentDemoTitle('CloseButton states'),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          HeroUiCloseButton(
            state: HeroUiCloseButtonState.defaultState,
            onPressed: () {},
          ),
          const SizedBox(width: 10),
          HeroUiCloseButton(
            state: HeroUiCloseButtonState.hover,
            onPressed: () {},
          ),
          const SizedBox(width: 10),
          HeroUiCloseButton(
            state: HeroUiCloseButtonState.focus,
            onPressed: () {},
          ),
          const SizedBox(width: 10),
          const HeroUiCloseButton(onPressed: null),
        ],
      ),
    ],
  ),
);

Widget buildToggleButtonDemo(BuildContext context) => const _ToggleButtonDemo();

Widget buildToggleButtonGroupDemo(BuildContext context) =>
    const _ToggleButtonGroupDemo();

Widget buildStarReviewDemo(BuildContext context) => const _StarReviewDemo();

class _HorizontalButtonsRow extends StatelessWidget {
  const _HorizontalButtonsRow({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const SizedBox(width: 12),
            children[i],
          ],
        ],
      ),
    );
  }
}

class _ButtonThemePreviewSurface extends StatelessWidget {
  const _ButtonThemePreviewSurface({
    required this.themeLabel,
    required this.dark,
    required this.child,
  });

  final String themeLabel;
  final bool dark;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final surfaceColor = dark
        ? const Color(0xFF060607)
        : const Color(0xFFF5F5F5);
    final borderColor = dark
        ? const Color(0xFF28282C)
        : const Color(0xFFDEDEE0);

    return HeroUiDemoThemeScope(
      dark: dark,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: borderColor),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ThemePreviewChip(label: themeLabel, dark: dark),
              const SizedBox(height: 12),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _ButtonGroupExamplesSurface extends StatelessWidget {
  const _ButtonGroupExamplesSurface({
    required this.themeLabel,
    required this.dark,
  });

  final String themeLabel;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final surfaceColor = dark
        ? const Color(0xFF09090B)
        : const Color(0xFFFFFFFF);
    final borderColor = dark
        ? const Color(0xFF27272A)
        : const Color(0xFFE4E4E7);
    final exampleGroups = _examples();

    return HeroUiDemoThemeScope(
      dark: dark,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: borderColor),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ThemePreviewChip(label: themeLabel, dark: dark),
              const SizedBox(height: 12),
              for (var i = 0; i < exampleGroups.length; i++) ...[
                if (i > 0) const SizedBox(height: 8),
                exampleGroups[i],
              ],
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _examples() => [
    _group(
      variant: HeroUiButtonVariant.primary,
      items: [
        HeroUiButtonGroupItem(label: 'Merge pull request', onPressed: () {}),
        HeroUiButtonGroupItem(
          label: 'Menu',
          onPressed: () {},
          iconOnly: true,
          leading: const _ButtonGroupIcon(HeroUiIconManifest.chevronDown),
        ),
      ],
    ),
    _group(
      variant: HeroUiButtonVariant.tertiary,
      items: [
        HeroUiButtonGroupItem(
          label: 'Fork',
          onPressed: () {},
          leading: const _ButtonGroupIcon(HeroUiIconManifest.gitBranchLine),
          trailing: const _ButtonGroupCounterBadge('4'),
        ),
        HeroUiButtonGroupItem(
          label: 'Menu',
          onPressed: () {},
          iconOnly: true,
          leading: const _ButtonGroupIcon(HeroUiIconManifest.chevronDown),
        ),
      ],
    ),
    _group(
      variant: HeroUiButtonVariant.tertiary,
      items: [
        HeroUiButtonGroupItem(
          label: 'Scan',
          onPressed: () {},
          iconOnly: true,
          leading: const _ButtonGroupIcon(HeroUiIconManifest.qrcodeLine),
        ),
        HeroUiButtonGroupItem(label: 'Scan to pay', onPressed: () {}),
      ],
    ),
    _group(
      variant: HeroUiButtonVariant.secondary,
      items: [
        HeroUiButtonGroupItem(
          label: 'Like',
          onPressed: () {},
          leading: const _ButtonGroupIcon(HeroUiIconManifest.thumbUpLine),
        ),
        HeroUiButtonGroupItem(label: '43', onPressed: () {}),
      ],
    ),
    _group(
      variant: HeroUiButtonVariant.tertiary,
      items: [
        HeroUiButtonGroupItem(
          label: 'Star',
          onPressed: () {},
          leading: const _ButtonGroupIcon(HeroUiIconManifest.starLine),
        ),
        HeroUiButtonGroupItem(label: '104', onPressed: () {}),
      ],
    ),
    _group(
      variant: HeroUiButtonVariant.tertiary,
      items: [
        HeroUiButtonGroupItem(
          label: 'Pinned',
          onPressed: () {},
          leading: const _ButtonGroupIcon(HeroUiIconManifest.pinLine),
        ),
        HeroUiButtonGroupItem(
          label: 'Menu',
          onPressed: () {},
          iconOnly: true,
          leading: const _ButtonGroupIcon(HeroUiIconManifest.chevronDown),
        ),
      ],
    ),
    _group(
      variant: HeroUiButtonVariant.tertiary,
      items: [
        HeroUiButtonGroupItem(
          label: 'Previous',
          onPressed: () {},
          iconOnly: true,
          leading: const _ButtonGroupIcon(HeroUiIconManifest.chevronLeft),
        ),
        HeroUiButtonGroupItem(label: 'Previous', onPressed: () {}),
      ],
    ),
    _group(
      variant: HeroUiButtonVariant.tertiary,
      items: [
        HeroUiButtonGroupItem(label: 'Next', onPressed: () {}),
        HeroUiButtonGroupItem(
          label: 'Next',
          onPressed: () {},
          iconOnly: true,
          leading: const _ButtonGroupIcon(HeroUiIconManifest.chevronRight),
        ),
      ],
    ),
    _group(
      variant: HeroUiButtonVariant.tertiary,
      items: [
        HeroUiButtonGroupItem(
          label: 'Photos',
          onPressed: () {},
          leading: const _ButtonGroupIcon(HeroUiIconManifest.photoAlbumLine),
        ),
        HeroUiButtonGroupItem(
          label: 'Videos',
          onPressed: () {},
          leading: const _ButtonGroupIcon(HeroUiIconManifest.videoLine),
        ),
        HeroUiButtonGroupItem(
          label: 'More',
          onPressed: () {},
          iconOnly: true,
          leading: const _ButtonGroupIcon(HeroUiIconManifest.more2Line),
        ),
      ],
    ),
    _group(
      variant: HeroUiButtonVariant.tertiary,
      width: HeroUiButtonGroupWidth.fill,
      items: [
        HeroUiButtonGroupItem(label: 'Left', onPressed: () {}),
        HeroUiButtonGroupItem(label: 'Center', onPressed: () {}),
        HeroUiButtonGroupItem(label: 'Right', onPressed: () {}),
      ],
    ),
    _group(
      variant: HeroUiButtonVariant.tertiary,
      items: [
        HeroUiButtonGroupItem(
          label: 'Align left',
          onPressed: () {},
          iconOnly: true,
          leading: const _ButtonGroupIcon(HeroUiIconManifest.alignLeftLine),
        ),
        HeroUiButtonGroupItem(
          label: 'Align center',
          onPressed: () {},
          iconOnly: true,
          leading: const _ButtonGroupIcon(HeroUiIconManifest.alignCenterLine),
        ),
        HeroUiButtonGroupItem(
          label: 'Align right',
          onPressed: () {},
          iconOnly: true,
          leading: const _ButtonGroupIcon(HeroUiIconManifest.alignRightLine),
        ),
        HeroUiButtonGroupItem(
          label: 'Align justify',
          onPressed: () {},
          iconOnly: true,
          leading: const _ButtonGroupIcon(HeroUiIconManifest.alignJustifyLine),
        ),
      ],
    ),
  ];

  Widget _group({
    required HeroUiButtonVariant variant,
    required List<HeroUiButtonGroupItem> items,
    HeroUiButtonGroupWidth width = HeroUiButtonGroupWidth.hug,
  }) {
    return HeroUiButtonGroup(
      size: HeroUiButtonSize.md,
      variant: variant,
      width: width,
      items: items,
    );
  }
}

class _ButtonGroupIcon extends StatelessWidget {
  const _ButtonGroupIcon(this.name);

  final String name;

  @override
  Widget build(BuildContext context) {
    return HeroUiIcon(name, size: 22);
  }
}

class _ButtonGroupCounterBadge extends StatelessWidget {
  const _ButtonGroupCounterBadge(this.value);

  final String value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF006FEE),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            height: 1.1,
          ),
        ),
      ),
    );
  }
}

class _ToggleButtonDemo extends StatefulWidget {
  const _ToggleButtonDemo();

  @override
  State<_ToggleButtonDemo> createState() => _ToggleButtonDemoState();
}

class _ToggleButtonDemoState extends State<_ToggleButtonDemo> {
  bool _selected = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ComponentDemoTitle('ToggleButton'),
          HeroUiToggleButton(
            label: _selected ? 'Selected' : 'Not selected',
            selected: _selected,
            onChanged: (next) => setState(() => _selected = next),
            leading: const HeroUiIcon(HeroUiIconManifest.check),
          ),
        ],
      ),
    );
  }
}

class _ToggleButtonGroupDemo extends StatefulWidget {
  const _ToggleButtonGroupDemo();

  @override
  State<_ToggleButtonGroupDemo> createState() => _ToggleButtonGroupDemoState();
}

class _ToggleButtonGroupDemoState extends State<_ToggleButtonGroupDemo> {
  String _value = 'week';
  int _rating = 4;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ComponentDemoTitle('ToggleButtonGroup'),
          HeroUiToggleButtonGroup<String>(
            value: _value,
            options: const [
              HeroUiToggleOption(value: 'day', label: 'Day'),
              HeroUiToggleOption(value: 'week', label: 'Week'),
              HeroUiToggleOption(value: 'month', label: 'Month'),
            ],
            onChanged: (next) => setState(() => _value = next),
          ),
          const SizedBox(height: 20),
          const ComponentDemoTitle('StarReview — built with ToggleButtonGroup'),
          HeroUiStarReview(
            value: _rating,
            description: 'Current rating: $_rating / 5',
            onChanged: (next) => setState(() => _rating = next),
          ),
        ],
      ),
    );
  }
}

class _StarReviewDemo extends StatefulWidget {
  const _StarReviewDemo();

  @override
  State<_StarReviewDemo> createState() => _StarReviewDemoState();
}

class _StarReviewDemoState extends State<_StarReviewDemo> {
  int _rating = 5;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ComponentDemoTitle('StarReview — default'),
          HeroUiStarReview(
            value: _rating,
            description: 'Tap to rate from 1 to 5',
            onChanged: (next) => setState(() => _rating = next),
          ),
          const SizedBox(height: 8),
          Text(
            'Selected: $_rating / 5',
            style: const TextStyle(fontSize: 13, color: Color(0xFF71717A)),
          ),
          const SizedBox(height: 20),
          const ComponentDemoTitle('StarReview — with label'),
          HeroUiStarReview(
            label: 'Rate your experience',
            description:
                'This input uses HeroUiToggleButtonGroup under the hood',
            initialValue: 3,
            onChanged: (_) {},
          ),
          const SizedBox(height: 20),
          const ComponentDemoTitle('StarReview — disabled'),
          const HeroUiStarReview(
            value: 2,
            label: 'Readonly rating',
            description: 'Disabled state',
            enabled: false,
          ),
          const SizedBox(height: 20),
          const ComponentDemoTitle('StarReview — compact'),
          HeroUiStarReview(
            size: HeroUiButtonSize.sm,
            value: 4,
            onChanged: (_) {},
          ),
        ],
      ),
    );
  }
}
