import 'package:flutter/material.dart';

import 'package:heroui_design_system/design_system.dart';

Widget buildSurfaceDemo(BuildContext context) => _SurfaceDemoPage();

Widget buildDisclosureDemo(BuildContext context) => _DisclosureDemoPage();

Widget buildScrollShadowDemo(BuildContext context) => _ScrollShadowDemoPage();

// ─── Shared helpers ───────────────────────────────────────────────────────────

class _SectionBox extends StatelessWidget {
  const _SectionBox({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return HeroUiDemoSection(children: children);
  }
}

Widget _outlinedDemoCard({required double height, required Widget child}) {
  return SizedBox(
    width: double.infinity,
    height: height,
    child: HeroUiCard(
      padding: EdgeInsets.zero,
      borderRadius: 12,
      showShadow: false,
      borderColor: const Color(0xFFE4E4E7),
      body: child,
    ),
  );
}

// ─── Surface demo ─────────────────────────────────────────────────────────────

class _SurfaceDemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      width: double.infinity,
      height: 80,
      alignment: Alignment.center,
      child: const Text(
        'Content here',
        style: TextStyle(color: Color(0xFF71717A), fontSize: 13),
      ),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ComponentDemoTitle('Surface — transparent'),
          HeroUiSurface(
            variant: HeroUiSurfaceVariant.transparent,
            padding: const EdgeInsets.all(16),
            child: placeholder,
          ),
          const SizedBox(height: 20),

          const ComponentDemoTitle('Surface — default'),
          HeroUiSurface(
            variant: HeroUiSurfaceVariant.defaultVariant,
            padding: const EdgeInsets.all(16),
            child: placeholder,
          ),
          const SizedBox(height: 20),

          const ComponentDemoTitle('Surface — secondary'),
          HeroUiSurface(
            variant: HeroUiSurfaceVariant.secondary,
            padding: const EdgeInsets.all(16),
            child: placeholder,
          ),
          const SizedBox(height: 20),

          const ComponentDemoTitle('Surface — tertiary'),
          HeroUiSurface(
            variant: HeroUiSurfaceVariant.tertiary,
            padding: const EdgeInsets.all(16),
            child: placeholder,
          ),
          const SizedBox(height: 20),

          const ComponentDemoTitle('Surface — all variants'),
          _SectionBox(
            children: [
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  for (final v in HeroUiSurfaceVariant.values)
                    SizedBox(
                      width: 140,
                      height: 80,
                      child: HeroUiSurface(
                        variant: v,
                        child: Center(
                          child: Text(
                            v.name,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF71717A),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          const ComponentDemoTitle('Dark mode preview'),
          HeroUiDemoThemeScope(
            dark: true,
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final v in HeroUiSurfaceVariant.values)
                  SizedBox(
                    width: 140,
                    height: 80,
                    child: HeroUiSurface(
                      variant: v,
                      child: Center(
                        child: Text(
                          v.name,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF71717A),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─── Disclosure demo ──────────────────────────────────────────────────────────

class _DisclosureDemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const bodyText = Text(
      'A disclosure is a collapsible section with a header containing a '
      'heading and a trigger button, and a panel that wraps the content.',
      style: TextStyle(fontSize: 14, color: Color(0xFF71717A), height: 1.5),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ComponentDemoTitle('Disclosure — closed by default'),
          HeroUiDisclosure(title: 'What is HeroUI?', child: bodyText),
          const SizedBox(height: 20),

          const ComponentDemoTitle('Disclosure — open by default'),
          HeroUiDisclosure(
            title: 'Getting started',
            initiallyOpen: true,
            child: bodyText,
          ),
          const SizedBox(height: 20),

          const ComponentDemoTitle('Disclosure — with leading icon'),
          HeroUiDisclosure(
            title: 'Advanced settings',
            leading: const HeroUiIcon(
              HeroUiIconManifest.gear,
              size: 18,
              color: Color(0xFF71717A),
            ),
            child: bodyText,
          ),
          const SizedBox(height: 20),

          const ComponentDemoTitle('DisclosureGroup'),
          HeroUiDisclosureGroup(
            initiallyOpenIndex: 0,
            items: [
              HeroUiDisclosureItem(title: 'What is HeroUI?', child: bodyText),
              HeroUiDisclosureItem(
                title: 'How to install',
                child: const Text(
                  'Run: npm install @heroui/react\nOr: yarn add @heroui/react',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF71717A),
                    height: 1.5,
                  ),
                ),
              ),
              HeroUiDisclosureItem(
                title: 'Configuration',
                leading: const HeroUiIcon(
                  HeroUiIconManifest.gear,
                  size: 18,
                  color: Color(0xFF71717A),
                ),
                child: bodyText,
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
                child: HeroUiDisclosureGroup(
                  initiallyOpenIndex: 0,
                  items: [
                    HeroUiDisclosureItem(
                      title: 'What is HeroUI?',
                      child: bodyText,
                    ),
                    HeroUiDisclosureItem(
                      title: 'Getting started',
                      child: bodyText,
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

// ─── ScrollShadow demo ────────────────────────────────────────────────────────

class _ScrollShadowDemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget scrollContent() => Column(
      children: [
        for (var i = 1; i <= 12; i++)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEFEFF0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Text(
                  'Item $i',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF18181B),
                  ),
                ),
              ],
            ),
          ),
      ],
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ComponentDemoTitle('ScrollShadow — opacity type'),
          _outlinedDemoCard(
            height: 200,
            child: HeroUiScrollShadow(
              type: HeroUiScrollShadowType.opacity,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: scrollContent(),
              ),
            ),
          ),
          const SizedBox(height: 20),

          const ComponentDemoTitle('ScrollShadow — blur type'),
          _outlinedDemoCard(
            height: 200,
            child: HeroUiScrollShadow(
              type: HeroUiScrollShadowType.blur,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: scrollContent(),
              ),
            ),
          ),
          const SizedBox(height: 20),

          const ComponentDemoTitle('ScrollShadow — inSurface: true'),
          Container(
            height: 200,
            color: const Color(0xFFFFFFFF),
            child: HeroUiScrollShadow(
              inSurface: true,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: scrollContent(),
              ),
            ),
          ),
          const SizedBox(height: 20),

          const ComponentDemoTitle('ScrollShadow — horizontal'),
          _outlinedDemoCard(
            height: 80,
            child: HeroUiScrollShadow(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    for (var i = 1; i <= 15; i++)
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFEFF0),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Tag $i',
                          style: const TextStyle(fontSize: 13),
                        ),
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
