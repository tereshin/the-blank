import 'package:flutter/material.dart';

import '../../../../../design_system/design_system.dart';

Widget buildSpinnerDemo(BuildContext context) => _SpinnerDemoPage();

Widget buildProgressBarDemo(BuildContext context) => _ProgressBarDemoPage();

Widget buildProgressCircleDemo(BuildContext context) =>
    _ProgressCircleDemoPage();

Widget buildAlertDemo(BuildContext context) => _AlertDemoPage();

Widget buildToastDemo(BuildContext context) => _ToastDemoPage();

// ─── Shared helpers ───────────────────────────────────────────────────────────

class _SectionBox extends StatelessWidget {
  const _SectionBox({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return HeroUiDemoSection(children: children);
  }
}

// ─── Spinner demo ─────────────────────────────────────────────────────────────

class _SpinnerDemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ComponentDemoTitle('Spinner — sizes'),
          _SectionBox(
            children: [
              Wrap(
                spacing: 24,
                runSpacing: 16,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: const [
                  HeroUiSpinner(size: HeroUiSpinnerSize.sm),
                  HeroUiSpinner(size: HeroUiSpinnerSize.md),
                  HeroUiSpinner(size: HeroUiSpinnerSize.lg),
                  HeroUiSpinner(size: HeroUiSpinnerSize.xl),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          const ComponentDemoTitle('Spinner — types'),
          _SectionBox(
            children: [
              Wrap(
                spacing: 24,
                runSpacing: 16,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: const [
                  HeroUiSpinner(type: HeroUiComponentType.defaultType),
                  HeroUiSpinner(type: HeroUiComponentType.accent),
                  HeroUiSpinner(type: HeroUiComponentType.success),
                  HeroUiSpinner(type: HeroUiComponentType.warning),
                  HeroUiSpinner(type: HeroUiComponentType.danger),
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
                child: Wrap(
                  spacing: 24,
                  runSpacing: 16,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: const [
                    HeroUiSpinner(size: HeroUiSpinnerSize.sm, type: HeroUiComponentType.accent),
                    HeroUiSpinner(size: HeroUiSpinnerSize.md, type: HeroUiComponentType.success),
                    HeroUiSpinner(size: HeroUiSpinnerSize.lg, type: HeroUiComponentType.warning),
                    HeroUiSpinner(size: HeroUiSpinnerSize.xl, type: HeroUiComponentType.danger),
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

// ─── ProgressBar demo ─────────────────────────────────────────────────────────

class _ProgressBarDemoPage extends StatefulWidget {
  @override
  State<_ProgressBarDemoPage> createState() => _ProgressBarDemoPageState();
}

class _ProgressBarDemoPageState extends State<_ProgressBarDemoPage> {
  double _progress = 0.6;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ComponentDemoTitle('ProgressBar — interactive'),
          _SectionBox(
            children: [
              HeroUiProgressBar(
                value: _progress,
                label: 'Storage',
                valueLabel: '${(_progress * 100).round()}%',
                type: _progress > 0.8
                    ? HeroUiComponentType.danger
                    : _progress > 0.6
                        ? HeroUiComponentType.warning
                        : HeroUiComponentType.accent,
              ),
              HeroUiSlider(
                value: _progress,
                min: 0,
                max: 1,
                label: 'Progress',
                formatValue: (v) => '${(v * 100).round()}%',
                onChanged: (v) => setState(() => _progress = v),
              ),
            ],
          ),
          const SizedBox(height: 20),

          const ComponentDemoTitle('ProgressBar — sizes'),
          _SectionBox(
            children: [
              const HeroUiProgressBar(
                value: 0.6,
                label: 'Small',
                valueLabel: '60%',
                size: HeroUiProgressBarSize.sm,
              ),
              const SizedBox(height: 16),
              const HeroUiProgressBar(
                value: 0.6,
                label: 'Medium',
                valueLabel: '60%',
                size: HeroUiProgressBarSize.md,
              ),
              const SizedBox(height: 16),
              const HeroUiProgressBar(
                value: 0.6,
                label: 'Large',
                valueLabel: '60%',
                size: HeroUiProgressBarSize.lg,
              ),
            ],
          ),
          const SizedBox(height: 20),

          const ComponentDemoTitle('ProgressBar — types'),
          _SectionBox(
            children: [
              const HeroUiProgressBar(value: 0.4, label: 'Accent', valueLabel: '40%', type: HeroUiComponentType.accent),
              const SizedBox(height: 12),
              const HeroUiProgressBar(value: 0.7, label: 'Success', valueLabel: '70%', type: HeroUiComponentType.success),
              const SizedBox(height: 12),
              const HeroUiProgressBar(value: 0.85, label: 'Warning', valueLabel: '85%', type: HeroUiComponentType.warning),
              const SizedBox(height: 12),
              const HeroUiProgressBar(value: 0.95, label: 'Danger', valueLabel: '95%', type: HeroUiComponentType.danger),
            ],
          ),
          const SizedBox(height: 20),

          const ComponentDemoTitle('ProgressBar — indeterminate'),
          _SectionBox(
            children: const [
              HeroUiProgressBar(
                value: 0,
                label: 'Loading...',
                isIndeterminate: true,
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
                  children: [
                    HeroUiProgressBar(
                      value: _progress,
                      label: 'Storage',
                      valueLabel: '${(_progress * 100).round()}%',
                      type: HeroUiComponentType.accent,
                    ),
                    const SizedBox(height: 16),
                    const HeroUiProgressBar(
                      value: 0,
                      label: 'Loading...',
                      isIndeterminate: true,
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

// ─── ProgressCircle demo ──────────────────────────────────────────────────────

class _ProgressCircleDemoPage extends StatefulWidget {
  @override
  State<_ProgressCircleDemoPage> createState() =>
      _ProgressCircleDemoPageState();
}

class _ProgressCircleDemoPageState extends State<_ProgressCircleDemoPage> {
  double _value = 0.25;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ComponentDemoTitle('ProgressCircle — sizes'),
          _SectionBox(
            children: [
              Wrap(
                spacing: 24,
                runSpacing: 16,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  HeroUiProgressCircle(value: _value, size: HeroUiProgressCircleSize.sm),
                  HeroUiProgressCircle(value: _value, size: HeroUiProgressCircleSize.md),
                  HeroUiProgressCircle(value: _value, size: HeroUiProgressCircleSize.lg),
                ],
              ),
              HeroUiSlider(
                value: _value,
                min: 0,
                max: 1,
                label: 'Progress',
                formatValue: (v) => '${(v * 100).round()}%',
                onChanged: (v) => setState(() => _value = v),
              ),
            ],
          ),
          const SizedBox(height: 20),

          const ComponentDemoTitle('ProgressCircle — with label'),
          _SectionBox(
            children: [
              HeroUiProgressCircle(
                value: _value,
                label: '${(_value * 100).round()}% Complete',
                size: HeroUiProgressCircleSize.md,
              ),
              const SizedBox(height: 12),
              HeroUiProgressCircle(
                value: _value,
                label: '${(_value * 100).round()}% Complete',
                size: HeroUiProgressCircleSize.lg,
              ),
            ],
          ),
          const SizedBox(height: 20),

          const ComponentDemoTitle('ProgressCircle — types'),
          _SectionBox(
            children: [
              Wrap(
                spacing: 20,
                runSpacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: const [
                  HeroUiProgressCircle(value: 0.4, type: HeroUiComponentType.accent),
                  HeroUiProgressCircle(value: 0.7, type: HeroUiComponentType.success),
                  HeroUiProgressCircle(value: 0.85, type: HeroUiComponentType.warning),
                  HeroUiProgressCircle(value: 0.95, type: HeroUiComponentType.danger),
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

// ─── Alert demo ───────────────────────────────────────────────────────────────

class _AlertDemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ComponentDemoTitle('Alert — variants'),
          Column(
            children: const [
              HeroUiAlert(
                title: 'This is an alert',
                description: 'Add description in this place',
              ),
              SizedBox(height: 12),
              HeroUiAlert(
                title: 'This is an alert',
                description: 'Add description in this place',
                type: HeroUiComponentType.accent,
              ),
              SizedBox(height: 12),
              HeroUiAlert(
                title: 'Operation successful',
                description: 'Your changes have been saved.',
                type: HeroUiComponentType.success,
              ),
              SizedBox(height: 12),
              HeroUiAlert(
                title: 'Warning',
                description: 'This action may affect other users.',
                type: HeroUiComponentType.warning,
              ),
              SizedBox(height: 12),
              HeroUiAlert(
                title: 'Error occurred',
                description: 'Please try again or contact support.',
                type: HeroUiComponentType.danger,
              ),
            ],
          ),
          const SizedBox(height: 20),

          const ComponentDemoTitle('Alert — with action button'),
          const HeroUiAlert(
            title: 'New update available',
            description: 'A new version of the app is ready to install.',
            type: HeroUiComponentType.accent,
            actionLabel: 'Update',
          ),
          const SizedBox(height: 12),
          const HeroUiAlert(
            title: 'This is an alert',
            description: 'Add description in this place',
            actionLabel: 'Label',
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
                    HeroUiAlert(
                      title: 'This is an alert',
                      description: 'Add description in this place',
                    ),
                    SizedBox(height: 12),
                    HeroUiAlert(
                      title: 'Operation successful',
                      description: 'Your changes have been saved.',
                      type: HeroUiComponentType.success,
                    ),
                    SizedBox(height: 12),
                    HeroUiAlert(
                      title: 'Error occurred',
                      description: 'Please try again.',
                      type: HeroUiComponentType.danger,
                      actionLabel: 'Retry',
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

// ─── Toast demo ───────────────────────────────────────────────────────────────

class _ToastDemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ComponentDemoTitle('Toast — variants (inline preview)'),
          Column(
            children: const [
              HeroUiToast(message: 'This is a notification'),
              SizedBox(height: 12),
              HeroUiToast(
                message: 'Operation successful',
                description: 'Your changes have been saved.',
                type: HeroUiComponentType.success,
              ),
              SizedBox(height: 12),
              HeroUiToast(
                message: 'Warning',
                description: 'This action may affect other users.',
                type: HeroUiComponentType.warning,
              ),
              SizedBox(height: 12),
              HeroUiToast(
                message: 'Error occurred',
                description: 'Please try again.',
                type: HeroUiComponentType.danger,
              ),
            ],
          ),
          const SizedBox(height: 20),

          const ComponentDemoTitle('Toast — with action'),
          const HeroUiToast(
            message: 'File deleted',
            description: 'document.pdf has been removed.',
            actionLabel: 'Undo',
          ),
          const SizedBox(height: 20),

          const ComponentDemoTitle('Toast — live (bottom overlay)'),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE4E4E7)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final entry in [
                      ('Show default', HeroUiComponentType.defaultType),
                      ('Show accent', HeroUiComponentType.accent),
                      ('Show success', HeroUiComponentType.success),
                      ('Show warning', HeroUiComponentType.warning),
                      ('Show danger', HeroUiComponentType.danger),
                    ])
                      HeroUiButton(
                        label: entry.$1,
                        variant: HeroUiButtonVariant.secondary,
                        size: HeroUiButtonSize.sm,
                        onPressed: () => HeroUiToastService.show(
                          context,
                          message: 'Toast notification',
                          description: '${entry.$1} toast.',
                          type: entry.$2,
                        ),
                      ),
                  ],
                ),
              ],
            ),
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
                    HeroUiToast(
                      message: 'This is a notification',
                      description: 'Dark mode toast.',
                    ),
                    SizedBox(height: 12),
                    HeroUiToast(
                      message: 'Success',
                      description: 'Operation completed.',
                      type: HeroUiComponentType.success,
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
