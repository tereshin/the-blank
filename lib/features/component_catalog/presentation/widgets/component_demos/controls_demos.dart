import 'package:flutter/material.dart';

import '../../../../../design_system/design_system.dart';
import 'shared_demo_widgets.dart';

Widget buildCheckboxDemo(BuildContext context) => _CheckboxDemoPage();

Widget buildCheckboxGroupDemo(BuildContext context) =>
    _CheckboxGroupDemoPage();

Widget buildRadioDemo(BuildContext context) => _RadioDemoPage();

Widget buildRadioGroupDemo(BuildContext context) => _RadioGroupDemoPage();

Widget buildSwitchDemo(BuildContext context) => _SwitchDemoPage();

Widget buildSliderDemo(BuildContext context) => _SliderDemoPage();

class _CheckboxDemoPage extends StatefulWidget {
  @override
  State<_CheckboxDemoPage> createState() => _CheckboxDemoPageState();
}

class _CheckboxDemoPageState extends State<_CheckboxDemoPage> {
  bool _primaryChecked = false;
  bool? _indeterminate; // null = indeterminate
  bool _secondary = true;
  bool _invalid = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Controls (raw 16×16 indicator) ──────────────────────────────
          const ComponentDemoTitle('CheckboxControl — states (primary)'),
          _ControlsRow(
            children: [
              _LabeledControl(
                label: 'Default',
                child: HeroUiCheckboxControl(
                  value: HeroUiCheckboxValue.unselected,
                ),
              ),
              _LabeledControl(
                label: 'Selected',
                child: HeroUiCheckboxControl(
                  value: HeroUiCheckboxValue.selected,
                ),
              ),
              _LabeledControl(
                label: 'Indeterminate',
                child: HeroUiCheckboxControl(
                  value: HeroUiCheckboxValue.indeterminate,
                ),
              ),
              _LabeledControl(
                label: 'Disabled',
                child: HeroUiCheckboxControl(
                  value: HeroUiCheckboxValue.unselected,
                  isDisabled: true,
                ),
              ),
              _LabeledControl(
                label: 'Disabled+Selected',
                child: HeroUiCheckboxControl(
                  value: HeroUiCheckboxValue.selected,
                  isDisabled: true,
                ),
              ),
              _LabeledControl(
                label: 'Error',
                child: HeroUiCheckboxControl(
                  value: HeroUiCheckboxValue.unselected,
                  isInvalid: true,
                ),
              ),
              _LabeledControl(
                label: 'Error+Selected',
                child: HeroUiCheckboxControl(
                  value: HeroUiCheckboxValue.selected,
                  isInvalid: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const ComponentDemoTitle('CheckboxControl — secondary variant'),
          _ControlsRow(
            children: [
              _LabeledControl(
                label: 'Unselected',
                child: HeroUiCheckboxControl(
                  value: HeroUiCheckboxValue.unselected,
                  variant: HeroUiCheckboxVariant.secondary,
                ),
              ),
              _LabeledControl(
                label: 'Selected',
                child: HeroUiCheckboxControl(
                  value: HeroUiCheckboxValue.selected,
                  variant: HeroUiCheckboxVariant.secondary,
                ),
              ),
              _LabeledControl(
                label: 'Indeterminate',
                child: HeroUiCheckboxControl(
                  value: HeroUiCheckboxValue.indeterminate,
                  variant: HeroUiCheckboxVariant.secondary,
                ),
              ),
              _LabeledControl(
                label: 'Disabled',
                child: HeroUiCheckboxControl(
                  value: HeroUiCheckboxValue.unselected,
                  variant: HeroUiCheckboxVariant.secondary,
                  isDisabled: true,
                ),
              ),
            ],
          ),

          // ── Full Checkbox component ──────────────────────────────────────
          const SizedBox(height: 24),
          const ComponentDemoTitle('Checkbox — interactive'),
          _SectionBox(
            children: [
              HeroUiCheckbox(
                label: 'Accept terms and conditions',
                description: 'You agree to our terms of service.',
                value: _primaryChecked,
                onChanged: (v) => setState(() => _primaryChecked = v),
              ),
              const SizedBox(height: 16),
              HeroUiCheckbox(
                label: 'Indeterminate state',
                description: 'Tap to cycle through states.',
                value: _indeterminate,
                onChanged: (_) => setState(() {
                  if (_indeterminate == null) {
                    _indeterminate = true;
                  } else if (_indeterminate == true) {
                    _indeterminate = false;
                  } else {
                    _indeterminate = null;
                  }
                }),
              ),
              const SizedBox(height: 16),
              HeroUiCheckbox(
                label: 'Secondary variant',
                value: _secondary,
                variant: HeroUiCheckboxVariant.secondary,
                onChanged: (v) => setState(() => _secondary = v),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── States ────────────────────────────────────────────────────────
          const ComponentDemoTitle('Checkbox — state=default'),
          _SectionBox(
            children: [
              const HeroUiCheckbox(
                label: 'Title here',
                description: 'Description here',
                value: false,
              ),
            ],
          ),
          const SizedBox(height: 12),

          const ComponentDemoTitle('Checkbox — state=disabled'),
          _SectionBox(
            children: [
              const HeroUiCheckbox(
                label: 'Title here',
                description: 'Description here',
                value: false,
                isDisabled: true,
              ),
            ],
          ),
          const SizedBox(height: 12),

          const ComponentDemoTitle('Checkbox — state=invalid'),
          _SectionBox(
            children: [
              HeroUiCheckbox(
                label: 'Title here',
                description: 'Description here',
                errorMessage: 'Error message goes here',
                value: _invalid,
                isInvalid: true,
                onChanged: (v) => setState(() => _invalid = v),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ── Dark mode preview ─────────────────────────────────────────────
          const SizedBox(height: 12),
          const ComponentDemoTitle('Dark mode preview'),
          Theme(
            data: ThemeData.dark(),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFF18181B),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeroUiCheckbox(
                      label: 'Dark mode checkbox',
                      description: 'Secondary text color.',
                      value: _primaryChecked,
                      onChanged: (v) => setState(() => _primaryChecked = v),
                    ),
                    const SizedBox(height: 16),
                    const HeroUiCheckbox(
                      label: 'Disabled dark',
                      description: 'Cannot be changed.',
                      value: true,
                      isDisabled: true,
                    ),
                    const SizedBox(height: 16),
                    const HeroUiCheckbox(
                      label: 'Invalid dark',
                      errorMessage: 'Error message goes here',
                      value: false,
                      isInvalid: true,
                    ),
                    const SizedBox(height: 16),
                    _ControlsRow(
                      children: [
                        _LabeledControl(
                          label: 'Unselected',
                          labelColor: const Color(0xFFA1A1AA),
                          child: const HeroUiCheckboxControl(
                            value: HeroUiCheckboxValue.unselected,
                          ),
                        ),
                        _LabeledControl(
                          label: 'Selected',
                          labelColor: const Color(0xFFA1A1AA),
                          child: const HeroUiCheckboxControl(
                            value: HeroUiCheckboxValue.selected,
                          ),
                        ),
                        _LabeledControl(
                          label: 'Indeterminate',
                          labelColor: const Color(0xFFA1A1AA),
                          child: const HeroUiCheckboxControl(
                            value: HeroUiCheckboxValue.indeterminate,
                          ),
                        ),
                        _LabeledControl(
                          label: 'Secondary',
                          labelColor: const Color(0xFFA1A1AA),
                          child: const HeroUiCheckboxControl(
                            value: HeroUiCheckboxValue.unselected,
                            variant: HeroUiCheckboxVariant.secondary,
                          ),
                        ),
                      ],
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

// ─── Helper widgets ──────────────────────────────────────────────────────────

class _ControlsRow extends StatelessWidget {
  const _ControlsRow({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 24,
      runSpacing: 16,
      children: children,
    );
  }
}

class _LabeledControl extends StatelessWidget {
  const _LabeledControl({
    required this.label,
    required this.child,
    this.labelColor,
  });

  final String label;
  final Widget child;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        child,
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: labelColor ?? const Color(0xFF71717A),
          ),
        ),
      ],
    );
  }
}

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

// ─── CheckboxGroup demo ───────────────────────────────────────────────────────

class _CheckboxGroupDemoPage extends StatefulWidget {
  @override
  State<_CheckboxGroupDemoPage> createState() => _CheckboxGroupDemoPageState();
}

class _CheckboxGroupDemoPageState extends State<_CheckboxGroupDemoPage> {
  var _hobbies = <String>{'travel'};
  var _plans = <String>{};
  var _horizontal = <String>{'music'};
  var _invalid = <String>{};

  static const _hobbyItems = [
    HeroUiCheckboxGroupItem(
      value: 'travel',
      label: 'Travel',
      description: 'Enthusiasm for exploring new places, cultures, and experiences',
    ),
    HeroUiCheckboxGroupItem(
      value: 'music',
      label: 'Music',
      description: 'Enthusiasm, curiosity, and passion for music in its various forms',
    ),
    HeroUiCheckboxGroupItem(
      value: 'food',
      label: 'Food',
      description: 'Enthusiasm or curiosity about various aspects of food',
    ),
  ];

  static const _planItems = [
    HeroUiCheckboxGroupItem(value: 'free', label: 'Free'),
    HeroUiCheckboxGroupItem(value: 'pro', label: 'Pro'),
    HeroUiCheckboxGroupItem(value: 'enterprise', label: 'Enterprise'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Default vertical ────────────────────────────────────────────────
          const ComponentDemoTitle('CheckboxGroup — vertical (default)'),
          _SectionBox(
            children: [
              HeroUiCheckboxGroup(
                label: 'Group label',
                description: 'Helper text',
                items: _hobbyItems,
                values: _hobbies,
                onChanged: (v) => setState(() => _hobbies = v),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Horizontal ──────────────────────────────────────────────────────
          const ComponentDemoTitle('CheckboxGroup — horizontal'),
          _SectionBox(
            children: [
              HeroUiCheckboxGroup(
                label: 'Select interests',
                description: 'Choose all that apply',
                orientation: HeroUiCheckboxGroupOrientation.horizontal,
                items: _hobbyItems,
                values: _horizontal,
                onChanged: (v) => setState(() => _horizontal = v),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Invalid / error state ───────────────────────────────────────────
          const ComponentDemoTitle('CheckboxGroup — state=error'),
          _SectionBox(
            children: [
              HeroUiCheckboxGroup(
                label: 'Group label',
                description: 'Helper text',
                errorMessage: 'Error message goes here',
                isInvalid: true,
                items: _hobbyItems,
                values: _invalid,
                onChanged: (v) => setState(() => _invalid = v),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Disabled ────────────────────────────────────────────────────────
          const ComponentDemoTitle('CheckboxGroup — disabled'),
          _SectionBox(
            children: [
              HeroUiCheckboxGroup(
                label: 'Plan',
                description: 'All options are currently disabled',
                isDisabled: true,
                items: _planItems,
                values: const {'pro'},
                onChanged: (_) {},
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Secondary variant ───────────────────────────────────────────────
          const ComponentDemoTitle('CheckboxGroup — secondary variant'),
          _SectionBox(
            children: [
              HeroUiCheckboxGroup(
                label: 'Plan',
                variant: HeroUiCheckboxVariant.secondary,
                items: _planItems,
                values: _plans,
                onChanged: (v) => setState(() => _plans = v),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Dark mode preview ───────────────────────────────────────────────
          const ComponentDemoTitle('Dark mode preview'),
          Theme(
            data: ThemeData.dark(),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFF18181B),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeroUiCheckboxGroup(
                      label: 'Group label',
                      description: 'Helper text',
                      items: _hobbyItems,
                      values: _hobbies,
                      onChanged: (v) => setState(() => _hobbies = v),
                    ),
                    const SizedBox(height: 20),
                    HeroUiCheckboxGroup(
                      label: 'Group label',
                      description: 'Helper text',
                      errorMessage: 'Error message goes here',
                      isInvalid: true,
                      items: _hobbyItems,
                      values: _invalid,
                      onChanged: (v) => setState(() => _invalid = v),
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

// ─── Radio demo ───────────────────────────────────────────────────────────────

class _RadioDemoPage extends StatefulWidget {
  @override
  State<_RadioDemoPage> createState() => _RadioDemoPageState();
}

class _RadioDemoPageState extends State<_RadioDemoPage> {
  bool _selected = false;
  bool _invalid = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ComponentDemoTitle('RadioControl — states'),
          _ControlsRow(
            children: [
              _LabeledControl(
                label: 'Default',
                child: const HeroUiRadioControl(),
              ),
              _LabeledControl(
                label: 'Selected',
                child: const HeroUiRadioControl(isSelected: true),
              ),
              _LabeledControl(
                label: 'Disabled',
                child: const HeroUiRadioControl(isDisabled: true),
              ),
              _LabeledControl(
                label: 'Disabled+Selected',
                child: const HeroUiRadioControl(
                  isSelected: true,
                  isDisabled: true,
                ),
              ),
              _LabeledControl(
                label: 'Invalid',
                child: const HeroUiRadioControl(isInvalid: true),
              ),
              _LabeledControl(
                label: 'Invalid+Selected',
                child: const HeroUiRadioControl(
                  isSelected: true,
                  isInvalid: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const ComponentDemoTitle('Radio — interactive'),
          _SectionBox(
            children: [
              HeroUiRadio(
                label: 'Title here',
                description: 'Description here',
                isSelected: _selected,
                onChanged: () => setState(() => _selected = !_selected),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const ComponentDemoTitle('Radio — state=default'),
          _SectionBox(
            children: const [
              HeroUiRadio(label: 'Title here', description: 'Description here'),
            ],
          ),
          const SizedBox(height: 12),
          const ComponentDemoTitle('Radio — state=disabled'),
          _SectionBox(
            children: const [
              HeroUiRadio(
                label: 'Title here',
                description: 'Description here',
                isDisabled: true,
              ),
            ],
          ),
          const SizedBox(height: 12),
          const ComponentDemoTitle('Radio — state=invalid'),
          _SectionBox(
            children: [
              HeroUiRadio(
                label: 'Title here',
                description: 'Description here',
                errorMessage: 'Error message goes here',
                isSelected: _invalid,
                isInvalid: true,
                onChanged: () => setState(() => _invalid = !_invalid),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const ComponentDemoTitle('Dark mode preview'),
          Theme(
            data: ThemeData.dark(),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFF18181B),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeroUiRadio(
                      label: 'Dark mode radio',
                      description: 'Secondary text color.',
                      isSelected: _selected,
                      onChanged: () => setState(() => _selected = !_selected),
                    ),
                    const SizedBox(height: 16),
                    const HeroUiRadio(label: 'Selected dark', isSelected: true),
                    const SizedBox(height: 16),
                    const HeroUiRadio(label: 'Disabled dark', isDisabled: true),
                    const SizedBox(height: 16),
                    _ControlsRow(
                      children: [
                        _LabeledControl(
                          label: 'Default',
                          labelColor: const Color(0xFFA1A1AA),
                          child: const HeroUiRadioControl(),
                        ),
                        _LabeledControl(
                          label: 'Selected',
                          labelColor: const Color(0xFFA1A1AA),
                          child: const HeroUiRadioControl(isSelected: true),
                        ),
                      ],
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

// ─── RadioGroup demo ──────────────────────────────────────────────────────────

class _RadioGroupDemoPage extends StatefulWidget {
  @override
  State<_RadioGroupDemoPage> createState() => _RadioGroupDemoPageState();
}

class _RadioGroupDemoPageState extends State<_RadioGroupDemoPage> {
  String? _plan;
  String? _horizontal;
  String? _invalid;

  static const _planItems = [
    HeroUiRadioGroupItem(
      value: 'free',
      label: 'Free',
      description: 'Basic features for personal use',
    ),
    HeroUiRadioGroupItem(
      value: 'pro',
      label: 'Pro',
      description: 'Advanced features for professionals',
    ),
    HeroUiRadioGroupItem(
      value: 'enterprise',
      label: 'Enterprise',
      description: 'Full suite for teams',
    ),
  ];

  static const _shortItems = [
    HeroUiRadioGroupItem(value: 'yes', label: 'Yes'),
    HeroUiRadioGroupItem(value: 'no', label: 'No'),
    HeroUiRadioGroupItem(value: 'maybe', label: 'Maybe'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ComponentDemoTitle('RadioGroup — vertical (default)'),
          _SectionBox(
            children: [
              HeroUiRadioGroup(
                label: 'Select a plan',
                description: 'Choose the plan that fits your needs',
                items: _planItems,
                value: _plan,
                onChanged: (v) => setState(() => _plan = v),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const ComponentDemoTitle('RadioGroup — horizontal'),
          _SectionBox(
            children: [
              HeroUiRadioGroup(
                label: 'Do you agree?',
                orientation: HeroUiRadioGroupOrientation.horizontal,
                items: _shortItems,
                value: _horizontal,
                onChanged: (v) => setState(() => _horizontal = v),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const ComponentDemoTitle('RadioGroup — state=error'),
          _SectionBox(
            children: [
              HeroUiRadioGroup(
                label: 'Select a plan',
                description: 'A selection is required',
                errorMessage: 'Error message goes here',
                isInvalid: true,
                items: _shortItems,
                value: _invalid,
                onChanged: (v) => setState(() => _invalid = v),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const ComponentDemoTitle('RadioGroup — disabled'),
          _SectionBox(
            children: [
              HeroUiRadioGroup(
                label: 'Select a plan',
                description: 'All options are currently disabled',
                isDisabled: true,
                items: _planItems,
                value: 'pro',
                onChanged: (_) {},
              ),
            ],
          ),
          const SizedBox(height: 20),
          const ComponentDemoTitle('Dark mode preview'),
          Theme(
            data: ThemeData.dark(),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFF18181B),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeroUiRadioGroup(
                      label: 'Select a plan',
                      description: 'Choose the plan that fits you',
                      items: _planItems,
                      value: _plan,
                      onChanged: (v) => setState(() => _plan = v),
                    ),
                    const SizedBox(height: 20),
                    HeroUiRadioGroup(
                      label: 'Select a plan',
                      errorMessage: 'Error message goes here',
                      isInvalid: true,
                      items: _shortItems,
                      value: _invalid,
                      onChanged: (v) => setState(() => _invalid = v),
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

// ─── Switch demo ──────────────────────────────────────────────────────────────

class _SwitchDemoPage extends StatefulWidget {
  @override
  State<_SwitchDemoPage> createState() => _SwitchDemoPageState();
}

class _SwitchDemoPageState extends State<_SwitchDemoPage> {
  bool _sm = false;
  bool _md = true;
  bool _lg = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ComponentDemoTitle('Switch — sizes (interactive)'),
          _SectionBox(
            children: [
              _ControlsRow(
                children: [
                  _LabeledControl(
                    label: 'sm',
                    child: HeroUiSwitch(
                      size: HeroUiSwitchSize.sm,
                      isSelected: _sm,
                      onChanged: (v) => setState(() => _sm = v),
                    ),
                  ),
                  _LabeledControl(
                    label: 'md',
                    child: HeroUiSwitch(
                      size: HeroUiSwitchSize.md,
                      isSelected: _md,
                      onChanged: (v) => setState(() => _md = v),
                    ),
                  ),
                  _LabeledControl(
                    label: 'lg',
                    child: HeroUiSwitch(
                      size: HeroUiSwitchSize.lg,
                      isSelected: _lg,
                      onChanged: (v) => setState(() => _lg = v),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          const ComponentDemoTitle('Switch — with label'),
          _SectionBox(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeroUiSwitch(
                    size: HeroUiSwitchSize.sm,
                    label: 'Switch label',
                    isSelected: _sm,
                    onChanged: (v) => setState(() => _sm = v),
                  ),
                  const SizedBox(height: 16),
                  HeroUiSwitch(
                    size: HeroUiSwitchSize.md,
                    label: 'Switch label',
                    isSelected: _md,
                    onChanged: (v) => setState(() => _md = v),
                  ),
                  const SizedBox(height: 16),
                  HeroUiSwitch(
                    size: HeroUiSwitchSize.lg,
                    label: 'Switch label',
                    isSelected: _lg,
                    onChanged: (v) => setState(() => _lg = v),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          const ComponentDemoTitle('Switch — state=disabled'),
          _SectionBox(
            children: [
              _ControlsRow(
                children: [
                  _LabeledControl(
                    label: 'Off',
                    child: const HeroUiSwitch(isDisabled: true),
                  ),
                  _LabeledControl(
                    label: 'On',
                    child: const HeroUiSwitch(isSelected: true, isDisabled: true),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          const ComponentDemoTitle('Dark mode preview'),
          Theme(
            data: ThemeData.dark(),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFF18181B),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeroUiSwitch(
                      label: 'Switch label',
                      isSelected: _md,
                      onChanged: (v) => setState(() => _md = v),
                    ),
                    const SizedBox(height: 16),
                    const HeroUiSwitch(label: 'Disabled off', isDisabled: true),
                    const SizedBox(height: 16),
                    const HeroUiSwitch(
                      label: 'Disabled on',
                      isSelected: true,
                      isDisabled: true,
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

// ─── Slider demo ──────────────────────────────────────────────────────────────

class _SliderDemoPage extends StatefulWidget {
  @override
  State<_SliderDemoPage> createState() => _SliderDemoPageState();
}

class _SliderDemoPageState extends State<_SliderDemoPage> {
  double _volume = 40.0;
  double _price = 50000.0;
  double _rating = 3.0;
  double _danger = 70.0;
  double _secondary = 55.0;
  double _sm = 30.0;
  double _lg = 65.0;
  double _tooltip = 35.0;
  double _rangeStart = 20.0;
  double _rangeEnd = 70.0;
  double _rangeTooltipStart = 25.0;
  double _rangeTooltipEnd = 75.0;

  static const _priceMarks = [
    HeroUiSliderMark(value: 0, label: '\$0'),
    HeroUiSliderMark(value: 25000, label: '\$25k'),
    HeroUiSliderMark(value: 50000, label: '\$50k'),
    HeroUiSliderMark(value: 75000, label: '\$75k'),
    HeroUiSliderMark(value: 100000, label: '\$100k'),
  ];

  static const _ratingMarks = [
    HeroUiSliderMark(value: 0, label: '0'),
    HeroUiSliderMark(value: 2, label: '2'),
    HeroUiSliderMark(value: 4, label: '4'),
    HeroUiSliderMark(value: 6, label: '6'),
    HeroUiSliderMark(value: 8, label: '8'),
    HeroUiSliderMark(value: 10, label: '10'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Single – continuous ───────────────────────────────────────────
          const ComponentDemoTitle('Slider — continuous (primary)'),
          _SectionBox(
            children: [
              HeroUiSlider(
                value: _volume,
                min: 0,
                max: 100,
                label: 'Volume',
                formatValue: (v) => '${v.round()}%',
                onChanged: (v) => setState(() => _volume = v),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── With tooltip ──────────────────────────────────────────────────
          const ComponentDemoTitle('Slider — with tooltip (drag to see)'),
          _SectionBox(
            children: [
              HeroUiSlider(
                value: _tooltip,
                min: 0,
                max: 100,
                label: 'Brightness',
                showTooltip: true,
                formatValue: (v) => '${v.round()}%',
                onChanged: (v) => setState(() => _tooltip = v),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Steps + marks ─────────────────────────────────────────────────
          const ComponentDemoTitle('Slider — steps with marks'),
          _SectionBox(
            children: [
              HeroUiSlider(
                value: _rating,
                min: 0,
                max: 10,
                divisions: 10,
                label: 'Rating',
                formatValue: (v) => v.round().toString(),
                marks: _ratingMarks,
                onChanged: (v) => setState(() => _rating = v),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Price range + marks ───────────────────────────────────────────
          const ComponentDemoTitle('Slider — price with marks'),
          _SectionBox(
            children: [
              HeroUiSlider(
                value: _price,
                min: 0,
                max: 100000,
                label: 'Price',
                showTooltip: true,
                formatValue: (v) => '\$${(v / 1000).toStringAsFixed(0)}k',
                marks: _priceMarks,
                onChanged: (v) => setState(() => _price = v),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Range ─────────────────────────────────────────────────────────
          const ComponentDemoTitle('Slider — range'),
          _SectionBox(
            children: [
              HeroUiSlider.range(
                startValue: _rangeStart,
                endValue: _rangeEnd,
                min: 0,
                max: 100,
                label: 'Price range',
                formatValue: (v) => '\$${v.round()}',
                onRangeChanged: (r) => setState(() {
                  _rangeStart = r.start;
                  _rangeEnd = r.end;
                }),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Range + tooltip ───────────────────────────────────────────────
          const ComponentDemoTitle('Slider — range with tooltip'),
          _SectionBox(
            children: [
              HeroUiSlider.range(
                startValue: _rangeTooltipStart,
                endValue: _rangeTooltipEnd,
                min: 0,
                max: 100,
                label: 'Budget',
                showTooltip: true,
                formatValue: (v) => '${v.round()}%',
                onRangeChanged: (r) => setState(() {
                  _rangeTooltipStart = r.start;
                  _rangeTooltipEnd = r.end;
                }),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Colour variants ───────────────────────────────────────────────
          const ComponentDemoTitle('Slider — color=secondary'),
          _SectionBox(
            children: [
              HeroUiSlider(
                value: _secondary,
                min: 0,
                max: 100,
                label: 'Opacity',
                color: HeroUiSliderColor.secondary,
                formatValue: (v) => '${v.round()}%',
                onChanged: (v) => setState(() => _secondary = v),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const ComponentDemoTitle('Slider — color=danger'),
          _SectionBox(
            children: [
              HeroUiSlider(
                value: _danger,
                min: 0,
                max: 100,
                label: 'Heat',
                color: HeroUiSliderColor.danger,
                formatValue: (v) => '${v.round()}°',
                onChanged: (v) => setState(() => _danger = v),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Size variants ─────────────────────────────────────────────────
          const ComponentDemoTitle('Slider — size=sm'),
          _SectionBox(
            children: [
              HeroUiSlider(
                value: _sm,
                min: 0,
                max: 100,
                label: 'Small',
                size: HeroUiSliderSize.sm,
                formatValue: (v) => '${v.round()}%',
                onChanged: (v) => setState(() => _sm = v),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const ComponentDemoTitle('Slider — size=md (default)'),
          _SectionBox(
            children: [
              HeroUiSlider(
                value: _volume,
                min: 0,
                max: 100,
                label: 'Medium',
                size: HeroUiSliderSize.md,
                formatValue: (v) => '${v.round()}%',
                onChanged: (v) => setState(() => _volume = v),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const ComponentDemoTitle('Slider — size=lg'),
          _SectionBox(
            children: [
              HeroUiSlider(
                value: _lg,
                min: 0,
                max: 100,
                label: 'Large',
                size: HeroUiSliderSize.lg,
                formatValue: (v) => '${v.round()}%',
                onChanged: (v) => setState(() => _lg = v),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Disabled ──────────────────────────────────────────────────────
          const ComponentDemoTitle('Slider — state=disabled (single)'),
          _SectionBox(
            children: const [
              HeroUiSlider(
                value: 60,
                min: 0,
                max: 100,
                label: 'Volume',
                isDisabled: true,
              ),
            ],
          ),
          const SizedBox(height: 12),
          const ComponentDemoTitle('Slider — state=disabled (range)'),
          _SectionBox(
            children: const [
              HeroUiSlider.range(
                startValue: 20,
                endValue: 70,
                min: 0,
                max: 100,
                label: 'Price range',
                isDisabled: true,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Dark mode ─────────────────────────────────────────────────────
          const ComponentDemoTitle('Dark mode preview'),
          Theme(
            data: ThemeData.dark(),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFF18181B),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeroUiSlider(
                      value: _volume,
                      min: 0,
                      max: 100,
                      label: 'Volume',
                      showTooltip: true,
                      formatValue: (v) => '${v.round()}%',
                      onChanged: (v) => setState(() => _volume = v),
                    ),
                    const SizedBox(height: 20),
                    HeroUiSlider.range(
                      startValue: _rangeStart,
                      endValue: _rangeEnd,
                      min: 0,
                      max: 100,
                      label: 'Price range',
                      showTooltip: true,
                      formatValue: (v) => '\$${v.round()}',
                      onRangeChanged: (r) => setState(() {
                        _rangeStart = r.start;
                        _rangeEnd = r.end;
                      }),
                    ),
                    const SizedBox(height: 20),
                    HeroUiSlider(
                      value: _danger,
                      min: 0,
                      max: 100,
                      label: 'Heat',
                      color: HeroUiSliderColor.danger,
                      formatValue: (v) => '${v.round()}°',
                      onChanged: (v) => setState(() => _danger = v),
                    ),
                    const SizedBox(height: 20),
                    const HeroUiSlider(
                      value: 60,
                      min: 0,
                      max: 100,
                      label: 'Disabled',
                      isDisabled: true,
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
