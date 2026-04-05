import 'package:flutter/material.dart';

import 'package:heroui_design_system/design_system.dart';

Widget buildProgressiveBlurDemo(BuildContext context) =>
    _ProgressiveBlurDemoPage();

Widget buildResizableDemo(BuildContext context) => _ResizableDemoPage();

// ─── ProgressiveBlur demo ─────────────────────────────────────────────────────

class _ProgressiveBlurDemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ComponentDemoTitle('ProgressiveBlur — light (bottom-to-top)'),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 160,
              child: Stack(
                children: [
                  // Background content
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF0485F7), Color(0xFF8B5CF6)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Content behind blur',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  // Progressive blur at bottom
                  const Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: HeroUiProgressiveBlur(
                      color: HeroUiProgressiveBlurColor.light,
                      direction: HeroUiProgressiveBlurDirection.bottomToTop,
                      height: 80,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const ComponentDemoTitle('ProgressiveBlur — dark (top-to-bottom)'),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 160,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF10B981), Color(0xFFF59E0B)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Content behind blur',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  const Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: HeroUiProgressiveBlur(
                      color: HeroUiProgressiveBlurColor.dark,
                      direction: HeroUiProgressiveBlurDirection.topToBottom,
                      height: 80,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─── Resizable demo ───────────────────────────────────────────────────────────

class _ResizableDemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ComponentDemoTitle('Resizable — handle types'),
          const ComponentDemoSubtitle('Line'),
          Row(
            children: const [
              HeroUiResizable(
                type: HeroUiResizableType.line,
                length: 60,
              ),
              SizedBox(width: 32),
              HeroUiResizable(
                type: HeroUiResizableType.line,
                variant: HeroUiResizableVariant.secondary,
                length: 60,
              ),
              SizedBox(width: 32),
              HeroUiResizable(
                type: HeroUiResizableType.line,
                variant: HeroUiResizableVariant.tertiary,
                length: 60,
              ),
            ],
          ),
          const SizedBox(height: 20),
          const ComponentDemoSubtitle('Pill'),
          Row(
            children: const [
              HeroUiResizable(
                type: HeroUiResizableType.pill,
                length: 60,
              ),
              SizedBox(width: 32),
              HeroUiResizable(
                type: HeroUiResizableType.pill,
                variant: HeroUiResizableVariant.secondary,
                length: 60,
              ),
              SizedBox(width: 32),
              HeroUiResizable(
                type: HeroUiResizableType.pill,
                variant: HeroUiResizableVariant.tertiary,
                length: 60,
              ),
            ],
          ),
          const SizedBox(height: 20),
          const ComponentDemoSubtitle('Drag'),
          Row(
            children: const [
              HeroUiResizable(
                type: HeroUiResizableType.drag,
                length: 60,
              ),
              SizedBox(width: 32),
              HeroUiResizable(
                type: HeroUiResizableType.drag,
                variant: HeroUiResizableVariant.secondary,
                length: 60,
              ),
              SizedBox(width: 32),
              HeroUiResizable(
                type: HeroUiResizableType.drag,
                variant: HeroUiResizableVariant.tertiary,
                length: 60,
              ),
            ],
          ),
          const SizedBox(height: 20),
          const ComponentDemoTitle('ResizablePanel — drag to resize'),
          SizedBox(
            height: 200,
            child: HeroUiResizablePanel(
              initialSize: 200,
              minSize: 80,
              maxSize: double.infinity,
              child: Container(
                color: const Color(0xFFF4F4F5),
                child: const Center(
                  child: Text(
                    'Drag handle →\nto resize',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF71717A),
                      fontSize: 13,
                    ),
                  ),
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
