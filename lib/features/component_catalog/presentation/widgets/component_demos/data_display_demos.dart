import 'package:flutter/material.dart';

import 'package:heroui_design_system/design_system.dart';

Widget buildCardDemo(BuildContext context) => _CardDemoPage();

Widget buildSeparatorDemo(BuildContext context) => _SeparatorDemoPage();

Widget buildKbdDemo(BuildContext context) => _KbdDemoPage();

Widget buildAvatarDemo(BuildContext context) => _AvatarDemoPage();

Widget buildBadgeDemo(BuildContext context) => _BadgeDemoPage();

Widget buildChipDemo(BuildContext context) => _ChipDemoPage();

Widget buildSkeletonDemo(BuildContext context) => _SkeletonDemoPage();

Widget buildMeterDemo(BuildContext context) => _MeterDemoPage();

// ─── Helper widgets ───────────────────────────────────────────────────────────

class _SectionBox extends StatelessWidget {
  const _SectionBox({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return HeroUiDemoSection(children: children);
  }
}

class _Wrap extends StatelessWidget {
  const _Wrap({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Wrap(spacing: 8, runSpacing: 8, children: children);
  }
}

// ─── Card demo (previously in data_display_demos.dart) ────────────────────────

class _CardDemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ComponentDemoTitle('Card — default'),
          const HeroUiCard(
            body: Text('Basic card with content'),
          ),
          const SizedBox(height: 20),
          const ComponentDemoTitle('Card — with header and footer'),
          const HeroUiCard(
            header: HeroUiCardHeader(
              title: 'Card Title',
              description: 'Card subtitle text',
            ),
            body: Text('Card body content goes here.'),
            footer: HeroUiCardFooter(
              child: Text('Footer content'),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─── Separator demo ───────────────────────────────────────────────────────────

class _SeparatorDemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ComponentDemoTitle('Separator — horizontal (primary)'),
          _SectionBox(
            children: [
              const Text('Above'),
              const SizedBox(height: 12),
              const HeroUiSeparator(),
              const SizedBox(height: 12),
              const Text('Below'),
            ],
          ),
          const SizedBox(height: 20),

          const ComponentDemoTitle('Separator — with label'),
          _SectionBox(
            children: [
              const Text('Above'),
              const SizedBox(height: 12),
              const HeroUiSeparator(label: 'OR'),
              const SizedBox(height: 12),
              const Text('Below'),
            ],
          ),
          const SizedBox(height: 20),

          const ComponentDemoTitle('Separator — variants'),
          _SectionBox(
            children: [
              const HeroUiSeparator(label: 'Primary', variant: HeroUiSeparatorVariant.primary),
              const SizedBox(height: 12),
              const HeroUiSeparator(label: 'Secondary', variant: HeroUiSeparatorVariant.secondary),
              const SizedBox(height: 12),
              const HeroUiSeparator(label: 'Tertiary', variant: HeroUiSeparatorVariant.tertiary),
            ],
          ),
          const SizedBox(height: 20),

          const ComponentDemoTitle('Separator — vertical'),
          _SectionBox(
            children: [
              SizedBox(
                height: 60,
                child: Row(
                  children: const [
                    Text('Left'),
                    SizedBox(width: 16),
                    HeroUiSeparator(orientation: HeroUiSeparatorOrientation.vertical),
                    SizedBox(width: 16),
                    Text('Right'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          const ComponentDemoTitle('Dark mode preview'),
          HeroUiDemoThemeScope(
            dark: true,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFF18181B),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    HeroUiSeparator(label: 'OR'),
                    SizedBox(height: 12),
                    HeroUiSeparator(variant: HeroUiSeparatorVariant.secondary),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─── Kbd demo ─────────────────────────────────────────────────────────────────

class _KbdDemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ComponentDemoTitle('Kbd — shortcuts'),
          _SectionBox(
            children: [
              _Wrap(
                children: const [
                  HeroUiKbd(keys: ['⌘', 'K']),
                  HeroUiKbd(keys: ['⌃', 'Shift', 'P']),
                  HeroUiKbd(keys: ['⌥', 'Tab']),
                  HeroUiKbd(keys: ['⇧', 'Enter']),
                  HeroUiKbd(keys: ['Esc']),
                  HeroUiKbd(keys: ['Win', '+', 'K']),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          const ComponentDemoTitle('Kbd — light variant'),
          _SectionBox(
            children: [
              _Wrap(
                children: const [
                  HeroUiKbd(keys: ['⌘', 'K'], variant: HeroUiKbdVariant.light),
                  HeroUiKbd(keys: ['⌃', 'P'], variant: HeroUiKbdVariant.light),
                  HeroUiKbd(keys: ['F5'], variant: HeroUiKbdVariant.light),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          const ComponentDemoTitle('Dark mode preview'),
          HeroUiDemoThemeScope(
            dark: true,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFF18181B),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _Wrap(
                  children: const [
                    HeroUiKbd(keys: ['⌘', 'K']),
                    HeroUiKbd(keys: ['⌃', 'Shift', 'P']),
                    HeroUiKbd(keys: ['⌘', 'Z'], variant: HeroUiKbdVariant.light),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─── Avatar demo ──────────────────────────────────────────────────────────────

class _AvatarDemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ComponentDemoTitle('Avatar — letter variant (types)'),
          _SectionBox(
            children: [
              _Wrap(
                children: const [
                  HeroUiAvatar(initials: 'JD', type: HeroUiComponentType.defaultType),
                  HeroUiAvatar(initials: 'AB', type: HeroUiComponentType.accent),
                  HeroUiAvatar(initials: 'MK', type: HeroUiComponentType.success),
                  HeroUiAvatar(initials: 'PQ', type: HeroUiComponentType.warning),
                  HeroUiAvatar(initials: 'XZ', type: HeroUiComponentType.danger),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          const ComponentDemoTitle('Avatar — soft variant'),
          _SectionBox(
            children: [
              _Wrap(
                children: const [
                  HeroUiAvatar(
                    initials: 'JD',
                    variant: HeroUiAvatarVariant.letterSoft,
                    type: HeroUiComponentType.accent,
                  ),
                  HeroUiAvatar(
                    initials: 'MK',
                    variant: HeroUiAvatarVariant.letterSoft,
                    type: HeroUiComponentType.success,
                  ),
                  HeroUiAvatar(
                    initials: 'PQ',
                    variant: HeroUiAvatarVariant.letterSoft,
                    type: HeroUiComponentType.warning,
                  ),
                  HeroUiAvatar(
                    initials: 'XZ',
                    variant: HeroUiAvatarVariant.letterSoft,
                    type: HeroUiComponentType.danger,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          const ComponentDemoTitle('Avatar — icon variant'),
          _SectionBox(
            children: [
              _Wrap(
                children: const [
                  HeroUiAvatar(
                    variant: HeroUiAvatarVariant.icon,
                    type: HeroUiComponentType.defaultType,
                  ),
                  HeroUiAvatar(
                    variant: HeroUiAvatarVariant.icon,
                    type: HeroUiComponentType.accent,
                  ),
                  HeroUiAvatar(
                    variant: HeroUiAvatarVariant.iconSoft,
                    type: HeroUiComponentType.success,
                  ),
                  HeroUiAvatar(
                    variant: HeroUiAvatarVariant.iconSoft,
                    type: HeroUiComponentType.danger,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          const ComponentDemoTitle('Avatar — sizes'),
          _SectionBox(
            children: [
              _Wrap(
                children: const [
                  HeroUiAvatar(initials: 'SM', size: 24, type: HeroUiComponentType.accent),
                  HeroUiAvatar(initials: 'MD', size: 36, type: HeroUiComponentType.accent),
                  HeroUiAvatar(initials: 'LG', size: 48, type: HeroUiComponentType.accent),
                  HeroUiAvatar(initials: 'XL', size: 60, type: HeroUiComponentType.accent),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─── Badge demo ───────────────────────────────────────────────────────────────

class _BadgeDemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ComponentDemoTitle('Badge — primary variant (types)'),
          _SectionBox(
            children: [
              _Wrap(
                children: const [
                  HeroUiBadge(label: 'Default', type: HeroUiComponentType.defaultType),
                  HeroUiBadge(label: 'Accent', type: HeroUiComponentType.accent),
                  HeroUiBadge(label: 'Success', type: HeroUiComponentType.success),
                  HeroUiBadge(label: 'Warning', type: HeroUiComponentType.warning),
                  HeroUiBadge(label: 'Danger', type: HeroUiComponentType.danger),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          const ComponentDemoTitle('Badge — secondary variant'),
          _SectionBox(
            children: [
              _Wrap(
                children: const [
                  HeroUiBadge(label: 'Default', variant: HeroUiBadgeVariant.secondary, type: HeroUiComponentType.defaultType),
                  HeroUiBadge(label: 'Accent', variant: HeroUiBadgeVariant.secondary, type: HeroUiComponentType.accent),
                  HeroUiBadge(label: 'Success', variant: HeroUiBadgeVariant.secondary, type: HeroUiComponentType.success),
                  HeroUiBadge(label: 'Warning', variant: HeroUiBadgeVariant.secondary, type: HeroUiComponentType.warning),
                  HeroUiBadge(label: 'Danger', variant: HeroUiBadgeVariant.secondary, type: HeroUiComponentType.danger),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          const ComponentDemoTitle('Badge — soft variant'),
          _SectionBox(
            children: [
              _Wrap(
                children: const [
                  HeroUiBadge(label: 'Default', variant: HeroUiBadgeVariant.soft, type: HeroUiComponentType.defaultType),
                  HeroUiBadge(label: 'Accent', variant: HeroUiBadgeVariant.soft, type: HeroUiComponentType.accent),
                  HeroUiBadge(label: 'Success', variant: HeroUiBadgeVariant.soft, type: HeroUiComponentType.success),
                  HeroUiBadge(label: 'Warning', variant: HeroUiBadgeVariant.soft, type: HeroUiComponentType.warning),
                  HeroUiBadge(label: 'Danger', variant: HeroUiBadgeVariant.soft, type: HeroUiComponentType.danger),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          const ComponentDemoTitle('Badge — sizes'),
          _SectionBox(
            children: [
              _Wrap(
                children: const [
                  HeroUiBadge(label: 'Small', size: HeroUiBadgeSize.sm, type: HeroUiComponentType.accent),
                  HeroUiBadge(label: 'Medium', size: HeroUiBadgeSize.md, type: HeroUiComponentType.accent),
                  HeroUiBadge(label: 'Large', size: HeroUiBadgeSize.lg, type: HeroUiComponentType.accent),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          const ComponentDemoTitle('Badge — with icons'),
          _SectionBox(
            children: [
              _Wrap(
                children: const [
                  HeroUiBadge(
                    label: 'New',
                    type: HeroUiComponentType.success,
                    startIcon: HeroUiIcon(HeroUiIconManifest.plusRegular),
                  ),
                  HeroUiBadge(
                    label: 'Alert',
                    type: HeroUiComponentType.danger,
                    startIcon: HeroUiIcon(HeroUiIconManifest.circleInfoRegular),
                  ),
                  HeroUiBadge(
                    label: 'Beta',
                    type: HeroUiComponentType.warning,
                    variant: HeroUiBadgeVariant.soft,
                    startIcon: HeroUiIcon(HeroUiIconManifest.globeRegular),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          const ComponentDemoTitle('Dark mode preview'),
          HeroUiDemoThemeScope(
            dark: true,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFF18181B),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _Wrap(
                  children: const [
                    HeroUiBadge(label: 'Default', type: HeroUiComponentType.defaultType),
                    HeroUiBadge(label: 'Accent', type: HeroUiComponentType.accent),
                    HeroUiBadge(label: 'Success', variant: HeroUiBadgeVariant.soft, type: HeroUiComponentType.success),
                    HeroUiBadge(label: 'Warning', variant: HeroUiBadgeVariant.secondary, type: HeroUiComponentType.warning),
                    HeroUiBadge(label: 'Danger', variant: HeroUiBadgeVariant.soft, type: HeroUiComponentType.danger),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─── Chip demo ────────────────────────────────────────────────────────────────

class _ChipDemoPage extends StatefulWidget {
  @override
  State<_ChipDemoPage> createState() => _ChipDemoPageState();
}

class _ChipDemoPageState extends State<_ChipDemoPage> {
  bool _selected = false;
  final Set<String> _selectedTags = {'flutter', 'dart'};

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ComponentDemoTitle('Chip — primary variant'),
          _SectionBox(
            children: [
              _Wrap(
                children: const [
                  HeroUiChip(label: 'Default'),
                  HeroUiChip(label: 'Accent', type: HeroUiComponentType.accent),
                  HeroUiChip(label: 'Success', type: HeroUiComponentType.success),
                  HeroUiChip(label: 'Warning', type: HeroUiComponentType.warning),
                  HeroUiChip(label: 'Danger', type: HeroUiComponentType.danger),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          const ComponentDemoTitle('Chip — variants'),
          _SectionBox(
            children: [
              _Wrap(
                children: const [
                  HeroUiChip(label: 'Primary', variant: HeroUiChipVariant.primary, type: HeroUiComponentType.accent),
                  HeroUiChip(label: 'Secondary', variant: HeroUiChipVariant.secondary, type: HeroUiComponentType.accent),
                  HeroUiChip(label: 'Soft', variant: HeroUiChipVariant.soft, type: HeroUiComponentType.accent),
                  HeroUiChip(label: 'Tertiary', variant: HeroUiChipVariant.tertiary, type: HeroUiComponentType.accent),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          const ComponentDemoTitle('Chip — selectable (interactive)'),
          _SectionBox(
            children: [
              HeroUiChip(
                label: 'Selectable',
                type: HeroUiComponentType.accent,
                isSelected: _selected,
                onTap: () => setState(() => _selected = !_selected),
              ),
            ],
          ),
          const SizedBox(height: 20),

          const ComponentDemoTitle('Chip — multi-select tags'),
          _SectionBox(
            children: [
              _Wrap(
                children: [
                  for (final tag in ['flutter', 'dart', 'mobile', 'web', 'desktop'])
                    HeroUiChip(
                      label: tag,
                      type: HeroUiComponentType.accent,
                      isSelected: _selectedTags.contains(tag),
                      onTap: () => setState(() {
                        if (_selectedTags.contains(tag)) {
                          _selectedTags.remove(tag);
                        } else {
                          _selectedTags.add(tag);
                        }
                      }),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          const ComponentDemoTitle('Chip — closeable'),
          _SectionBox(
            children: [
              _Wrap(
                children: const [
                  HeroUiChip(
                    label: 'Flutter',
                    type: HeroUiComponentType.accent,
                    isCloseable: true,
                  ),
                  HeroUiChip(
                    label: 'React',
                    type: HeroUiComponentType.success,
                    variant: HeroUiChipVariant.soft,
                    isCloseable: true,
                  ),
                  HeroUiChip(
                    label: 'TypeScript',
                    type: HeroUiComponentType.warning,
                    variant: HeroUiChipVariant.secondary,
                    isCloseable: true,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          const ComponentDemoTitle('Chip — sizes'),
          _SectionBox(
            children: [
              _Wrap(
                children: const [
                  HeroUiChip(label: 'Small', size: HeroUiChipSize.sm, type: HeroUiComponentType.accent),
                  HeroUiChip(label: 'Medium', size: HeroUiChipSize.md, type: HeroUiComponentType.accent),
                  HeroUiChip(label: 'Large', size: HeroUiChipSize.lg, type: HeroUiComponentType.accent),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          const ComponentDemoTitle('Chip — disabled'),
          _SectionBox(
            children: [
              _Wrap(
                children: const [
                  HeroUiChip(label: 'Disabled', isDisabled: true, type: HeroUiComponentType.accent),
                  HeroUiChip(label: 'Disabled+selected', isDisabled: true, isSelected: true, type: HeroUiComponentType.accent),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─── Skeleton demo ────────────────────────────────────────────────────────────

class _SkeletonDemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ComponentDemoTitle('Skeleton — text lines'),
          _SectionBox(
            children: [
              const HeroUiSkeleton(width: 200, height: 20),
              const SizedBox(height: 8),
              const HeroUiSkeleton(width: 160, height: 16),
              const SizedBox(height: 8),
              const HeroUiSkeleton(width: 240, height: 16),
            ],
          ),
          const SizedBox(height: 20),

          const ComponentDemoTitle('Skeleton — card layout'),
          _SectionBox(
            children: [
              Row(
                children: const [
                  HeroUiSkeleton.circle(width: 48, height: 48),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HeroUiSkeleton(height: 16),
                        SizedBox(height: 8),
                        HeroUiSkeleton(width: 120, height: 12),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const HeroUiSkeleton(height: 80, borderRadius: 8),
            ],
          ),
          const SizedBox(height: 20),

          const ComponentDemoTitle('Skeleton — shapes'),
          _SectionBox(
            children: [
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: const [
                  HeroUiSkeleton(width: 80, height: 80, borderRadius: 12),
                  HeroUiSkeleton.circle(width: 60, height: 60),
                  HeroUiSkeleton(width: 120, height: 40, borderRadius: 24),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          const ComponentDemoTitle('Dark mode preview'),
          HeroUiDemoThemeScope(
            dark: true,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFF18181B),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: const [
                    HeroUiSkeleton(height: 20),
                    SizedBox(height: 8),
                    HeroUiSkeleton(width: 160, height: 16),
                    SizedBox(height: 8),
                    HeroUiSkeleton(height: 60, borderRadius: 8),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─── Meter demo ───────────────────────────────────────────────────────────────

class _MeterDemoPage extends StatefulWidget {
  @override
  State<_MeterDemoPage> createState() => _MeterDemoPageState();
}

class _MeterDemoPageState extends State<_MeterDemoPage> {
  double _storage = 0.65;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ComponentDemoTitle('Meter — types'),
          _SectionBox(
            children: [
              const HeroUiMeter(
                value: 0.3,
                label: 'Accent',
                valueLabel: '30%',
                type: HeroUiComponentType.accent,
              ),
              const SizedBox(height: 16),
              const HeroUiMeter(
                value: 0.7,
                label: 'Success',
                valueLabel: '70%',
                type: HeroUiComponentType.success,
              ),
              const SizedBox(height: 16),
              const HeroUiMeter(
                value: 0.85,
                label: 'Warning',
                valueLabel: '85%',
                type: HeroUiComponentType.warning,
              ),
              const SizedBox(height: 16),
              const HeroUiMeter(
                value: 0.95,
                label: 'Danger',
                valueLabel: '95%',
                type: HeroUiComponentType.danger,
              ),
            ],
          ),
          const SizedBox(height: 20),

          const ComponentDemoTitle('Meter — interactive'),
          _SectionBox(
            children: [
              HeroUiMeter(
                value: _storage,
                label: 'Storage used',
                valueLabel: '${(_storage * 100).round()}%',
                type: _storage > 0.8
                    ? HeroUiComponentType.danger
                    : _storage > 0.6
                        ? HeroUiComponentType.warning
                        : HeroUiComponentType.success,
              ),
              const SizedBox(height: 12),
              HeroUiSlider(
                value: _storage,
                min: 0,
                max: 1,
                label: 'Usage',
                formatValue: (v) => '${(v * 100).round()}%',
                onChanged: (v) => setState(() => _storage = v),
              ),
            ],
          ),
          const SizedBox(height: 20),

          const ComponentDemoTitle('Dark mode preview'),
          HeroUiDemoThemeScope(
            dark: true,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFF18181B),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    HeroUiMeter(
                      value: 0.6,
                      label: 'CPU Usage',
                      valueLabel: '60%',
                      type: HeroUiComponentType.accent,
                    ),
                    SizedBox(height: 16),
                    HeroUiMeter(
                      value: 0.9,
                      label: 'Memory',
                      valueLabel: '90%',
                      type: HeroUiComponentType.danger,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
