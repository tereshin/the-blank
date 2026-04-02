import 'package:flutter/material.dart';

import '../../../../../design_system/design_system.dart';
import 'shared_demo_widgets.dart';

Widget buildSelectDemo(BuildContext context) => _SelectDemoPage();

Widget buildComboBoxDemo(BuildContext context) => _ComboBoxDemoPage();

Widget buildAutocompleteDemo(BuildContext context) => _AutocompleteDemoPage();

Widget buildCalendarDemo(BuildContext context) => _CalendarDemoPage();

Widget buildRangeCalendarDemo(BuildContext context) => _RangeCalendarDemoPage();

Widget buildColorSwatchDemo(BuildContext context) => _ColorSwatchDemoPage();

Widget buildColorSwatchPickerDemo(BuildContext context) =>
    _ColorSwatchPickerDemoPage();

Widget buildColorSliderDemo(BuildContext context) => _ColorSliderDemoPage();

Widget buildColorAreaDemo(BuildContext context) => _ColorAreaDemoPage();

Widget buildColorFieldDemo(BuildContext context) => _ColorFieldDemoPage();

Widget buildColorPickerDemo(BuildContext context) => _ColorPickerDemoPage();

// ─── Select demo ──────────────────────────────────────────────────────────────

class _SelectDemoPage extends StatefulWidget {
  @override
  State<_SelectDemoPage> createState() => _SelectDemoPageState();
}

class _SelectDemoPageState extends State<_SelectDemoPage> {
  String? _selected;

  static const _states = [
    HeroUiPickerItem(value: 'fl', label: 'Florida'),
    HeroUiPickerItem(value: 'de', label: 'Delaware'),
    HeroUiPickerItem(value: 'tx', label: 'Texas'),
    HeroUiPickerItem(value: 'ca', label: 'California'),
    HeroUiPickerItem(value: 'ny', label: 'New York'),
    HeroUiPickerItem(value: 'wy', label: 'Wyoming'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ComponentDemoTitle('Select — default'),
          HeroUiSelect<String>(
            label: 'State',
            requiredField: true,
            placeholder: 'Select one',
            description: 'Choose your state',
            items: _states,
            value: _selected,
            onChanged: (v) => setState(() => _selected = v),
          ),
          const SizedBox(height: 8),
          Text(
            'Selected: ${_selected ?? 'none'}',
            style: const TextStyle(fontSize: 13, color: Color(0xFF71717A)),
          ),
          const SizedBox(height: 20),

          const ComponentDemoTitle('Select — with error'),
          HeroUiSelect<String>(
            label: 'State',
            requiredField: true,
            placeholder: 'Select one',
            items: _states,
            errorText: 'Please select a state',
          ),
          const SizedBox(height: 20),

          const ComponentDemoTitle('Select — disabled'),
          const HeroUiSelect<String>(
            label: 'State',
            placeholder: 'Select one',
            items: [HeroUiPickerItem(value: 'tx', label: 'Texas')],
            enabled: false,
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
                child: HeroUiSelect<String>(
                  label: 'State',
                  placeholder: 'Select one',
                  items: _states,
                  value: _selected,
                  onChanged: (v) => setState(() => _selected = v),
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

// ─── ComboBox demo ────────────────────────────────────────────────────────────

class _ComboBoxDemoPage extends StatefulWidget {
  @override
  State<_ComboBoxDemoPage> createState() => _ComboBoxDemoPageState();
}

class _ComboBoxDemoPageState extends State<_ComboBoxDemoPage> {
  String? _selected;

  static const _states = [
    HeroUiPickerItem(value: 'fl', label: 'Florida'),
    HeroUiPickerItem(value: 'de', label: 'Delaware'),
    HeroUiPickerItem(value: 'tx', label: 'Texas'),
    HeroUiPickerItem(value: 'ca', label: 'California'),
    HeroUiPickerItem(value: 'ny', label: 'New York'),
    HeroUiPickerItem(value: 'wy', label: 'Wyoming'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ComponentDemoTitle('ComboBox — default'),
          HeroUiComboBox<String>(
            label: 'State',
            requiredField: true,
            placeholder: 'Type to search...',
            description: 'Type to filter options',
            items: _states,
            value: _selected,
            onChanged: (v) => setState(() => _selected = v),
          ),
          const SizedBox(height: 8),
          Text(
            'Selected: ${_selected ?? 'none'}',
            style: const TextStyle(fontSize: 13, color: Color(0xFF71717A)),
          ),
          const SizedBox(height: 20),

          const ComponentDemoTitle('ComboBox — with error'),
          HeroUiComboBox<String>(
            label: 'State',
            placeholder: 'Type to search...',
            items: _states,
            errorText: 'Invalid value, please try again',
          ),
          const SizedBox(height: 20),

          const ComponentDemoTitle('ComboBox — disabled'),
          const HeroUiComboBox<String>(
            label: 'State',
            placeholder: 'Type to search...',
            items: [HeroUiPickerItem(value: 'tx', label: 'Texas')],
            enabled: false,
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
                child: HeroUiComboBox<String>(
                  label: 'State',
                  placeholder: 'Type to search...',
                  items: _states,
                  value: _selected,
                  onChanged: (v) => setState(() => _selected = v),
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

// ─── Autocomplete demo ────────────────────────────────────────────────────────

class _AutocompleteDemoPage extends StatefulWidget {
  @override
  State<_AutocompleteDemoPage> createState() => _AutocompleteDemoPageState();
}

class _AutocompleteDemoPageState extends State<_AutocompleteDemoPage> {
  List<String> _selected = [];

  static const _technologies = [
    HeroUiPickerItem(value: 'flutter', label: 'Flutter'),
    HeroUiPickerItem(value: 'react', label: 'React'),
    HeroUiPickerItem(value: 'vue', label: 'Vue'),
    HeroUiPickerItem(value: 'angular', label: 'Angular'),
    HeroUiPickerItem(value: 'svelte', label: 'Svelte'),
    HeroUiPickerItem(value: 'nextjs', label: 'Next.js'),
    HeroUiPickerItem(value: 'nuxt', label: 'Nuxt'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ComponentDemoTitle('Autocomplete — multi-select with tags'),
          HeroUiAutocomplete<String>(
            label: 'Technologies',
            placeholder: 'Search technologies…',
            items: _technologies,
            values: _selected,
            onChanged: (v) => setState(() => _selected = v),
          ),
          const SizedBox(height: 8),
          Text(
            'Selected: ${_selected.isEmpty ? 'none' : _selected.join(', ')}',
            style: const TextStyle(fontSize: 13, color: Color(0xFF71717A)),
          ),
          const SizedBox(height: 20),

          const ComponentDemoTitle('Autocomplete — with error'),
          HeroUiAutocomplete<String>(
            label: 'Skills',
            placeholder: 'Add skills…',
            items: _technologies,
            errorText: 'At least one skill is required',
          ),
          const SizedBox(height: 20),

          const ComponentDemoTitle('Autocomplete — disabled'),
          const HeroUiAutocomplete<String>(
            label: 'Frameworks',
            placeholder: 'Cannot edit',
            items: [HeroUiPickerItem(value: 'flutter', label: 'Flutter')],
            values: ['flutter'],
            enabled: false,
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
                child: HeroUiAutocomplete<String>(
                  label: 'Technologies',
                  placeholder: 'Search technologies…',
                  items: _technologies,
                  values: _selected,
                  onChanged: (v) => setState(() => _selected = v),
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

// ─── Calendar demo ────────────────────────────────────────────────────────────

class _CalendarDemoPage extends StatefulWidget {
  @override
  State<_CalendarDemoPage> createState() => _CalendarDemoPageState();
}

class _CalendarDemoPageState extends State<_CalendarDemoPage> {
  DateTime? _selected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ComponentDemoTitle('Calendar — single selection'),
          HeroUiCalendar(onDateSelected: (d) => setState(() => _selected = d)),
          const SizedBox(height: 8),
          Text(
            'Selected: ${_selected != null ? '${_selected!.year}-${_selected!.month.toString().padLeft(2, '0')}-${_selected!.day.toString().padLeft(2, '0')}' : 'none'}',
            style: const TextStyle(fontSize: 13, color: Color(0xFF71717A)),
          ),
          const SizedBox(height: 24),
          const ComponentDemoTitle('Calendar — with min/max date'),
          HeroUiCalendar(
            minDate: DateTime.now().subtract(const Duration(days: 7)),
            maxDate: DateTime.now().add(const Duration(days: 30)),
            onDateSelected: (_) {},
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─── RangeCalendar demo ───────────────────────────────────────────────────────

class _RangeCalendarDemoPage extends StatefulWidget {
  @override
  State<_RangeCalendarDemoPage> createState() => _RangeCalendarDemoPageState();
}

class _RangeCalendarDemoPageState extends State<_RangeCalendarDemoPage> {
  DateTime? _start;
  DateTime? _end;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ComponentDemoTitle('RangeCalendar — date range selection'),
          HeroUiRangeCalendar(
            onRangeSelected: (start, end) => setState(() {
              _start = start;
              _end = end;
            }),
          ),
          const SizedBox(height: 8),
          Text(
            'Start: ${_start != null ? '${_start!.year}-${_start!.month.toString().padLeft(2, '0')}-${_start!.day.toString().padLeft(2, '0')}' : 'none'}',
            style: const TextStyle(fontSize: 13, color: Color(0xFF71717A)),
          ),
          Text(
            'End: ${_end != null ? '${_end!.year}-${_end!.month.toString().padLeft(2, '0')}-${_end!.day.toString().padLeft(2, '0')}' : 'none'}',
            style: const TextStyle(fontSize: 13, color: Color(0xFF71717A)),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─── ColorSwatch demo ─────────────────────────────────────────────────────────

class _ColorSwatchDemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ComponentDemoTitle('ColorSwatch — circle sizes'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                [
                      HeroUiColorSwatchSize.xs,
                      HeroUiColorSwatchSize.sm,
                      HeroUiColorSwatchSize.md,
                      HeroUiColorSwatchSize.lg,
                      HeroUiColorSwatchSize.xl,
                    ]
                    .map(
                      (s) => HeroUiColorSwatch(
                        color: const Color(0xFF0485F7),
                        size: s,
                      ),
                    )
                    .toList(),
          ),
          const SizedBox(height: 20),
          const ComponentDemoTitle('ColorSwatch — square variant'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                [
                      const Color(0xFFFF383C),
                      const Color(0xFFFF8A00),
                      const Color(0xFF14FF00),
                      const Color(0xFF0485F7),
                      const Color(0xFFAD00FF),
                    ]
                    .map(
                      (c) => HeroUiColorSwatch(
                        color: c,
                        variant: HeroUiColorSwatchVariant.square,
                        size: HeroUiColorSwatchSize.md,
                      ),
                    )
                    .toList(),
          ),
          const SizedBox(height: 20),
          const ComponentDemoTitle('ColorSwatch — selected state'),
          Wrap(
            spacing: 8,
            children: [
              HeroUiColorSwatch(
                color: const Color(0xFFFF383C),
                size: HeroUiColorSwatchSize.md,
                selected: true,
              ),
              HeroUiColorSwatch(
                color: const Color(0xFF0485F7),
                size: HeroUiColorSwatchSize.md,
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─── ColorSwatchPicker demo ───────────────────────────────────────────────────

class _ColorSwatchPickerDemoPage extends StatefulWidget {
  @override
  State<_ColorSwatchPickerDemoPage> createState() =>
      _ColorSwatchPickerDemoPageState();
}

class _ColorSwatchPickerDemoPageState
    extends State<_ColorSwatchPickerDemoPage> {
  Color? _selected;

  static const _palette = [
    Color(0xFFFFFFFF),
    Color(0xFFF4F4F5),
    Color(0xFFE4E4E7),
    Color(0xFFD4D4D8),
    Color(0xFFA1A1AA),
    Color(0xFF71717A),
    Color(0xFF52525B),
    Color(0xFF3F3F46),
    Color(0xFF27272A),
    Color(0xFF18181B),
    Color(0xFFFF383C),
    Color(0xFFFF8A00),
    Color(0xFFFFE600),
    Color(0xFF14FF00),
    Color(0xFF00A3FF),
    Color(0xFF0485F7),
    Color(0xFF0500FF),
    Color(0xFFAD00FF),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ComponentDemoTitle('ColorSwatchPicker — circle palette'),
          HeroUiColorSwatchPicker(
            colors: _palette,
            initialColor: _selected,
            label: 'Select color',
            onColorSelected: (c) => setState(() => _selected = c),
          ),
          const SizedBox(height: 8),
          if (_selected != null)
            Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: _selected,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFE4E4E7)),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '#${_selected!.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF71717A),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 20),
          const ComponentDemoTitle('ColorSwatchPicker — square large'),
          HeroUiColorSwatchPicker(
            colors: _palette.sublist(10),
            swatchVariant: HeroUiColorSwatchVariant.square,
            swatchSize: HeroUiColorSwatchSize.lg,
            columns: 4,
            onColorSelected: (_) {},
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─── ColorSlider demo ─────────────────────────────────────────────────────────

class _ColorSliderDemoPage extends StatefulWidget {
  @override
  State<_ColorSliderDemoPage> createState() => _ColorSliderDemoPageState();
}

class _ColorSliderDemoPageState extends State<_ColorSliderDemoPage> {
  double _hue = 0.5;
  double _alpha = 1.0;

  @override
  Widget build(BuildContext context) {
    final hueColor = HSLColor.fromAHSL(1, _hue * 360, 1, 0.5).toColor();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ComponentDemoTitle('ColorSlider — hue'),
          HeroUiColorSlider(
            label: 'Hue',
            value: _hue,
            type: HeroUiColorSliderType.hue,
            onChanged: (v) => setState(() => _hue = v),
          ),
          const SizedBox(height: 20),
          const ComponentDemoTitle('ColorSlider — alpha'),
          HeroUiColorSlider(
            label: 'Opacity',
            value: _alpha,
            type: HeroUiColorSliderType.alpha,
            baseColor: hueColor,
            onChanged: (v) => setState(() => _alpha = v),
          ),
          const SizedBox(height: 20),
          const ComponentDemoTitle('ColorSlider — disabled'),
          const HeroUiColorSlider(
            label: 'Hue',
            value: 0.3,
            type: HeroUiColorSliderType.hue,
            enabled: false,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─── ColorArea demo ───────────────────────────────────────────────────────────

class _ColorAreaDemoPage extends StatefulWidget {
  @override
  State<_ColorAreaDemoPage> createState() => _ColorAreaDemoPageState();
}

class _ColorAreaDemoPageState extends State<_ColorAreaDemoPage> {
  double _hue = 200;
  double _sat = 0.8;
  double _lig = 0.5;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ComponentDemoTitle('ColorArea — 2D saturation/lightness'),
          HeroUiColorSlider(
            label: 'Hue',
            value: _hue / 360,
            type: HeroUiColorSliderType.hue,
            onChanged: (v) => setState(() => _hue = v * 360),
          ),
          const SizedBox(height: 12),
          HeroUiColorArea(
            hue: _hue,
            saturation: _sat,
            lightness: _lig,
            onChanged: (s, l) => setState(() {
              _sat = s;
              _lig = l;
            }),
          ),
          const SizedBox(height: 8),
          Text(
            'HSL(${_hue.round()}, ${(_sat * 100).round()}%, ${(_lig * 100).round()}%)',
            style: const TextStyle(fontSize: 13, color: Color(0xFF71717A)),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─── ColorField demo ──────────────────────────────────────────────────────────

class _ColorFieldDemoPage extends StatefulWidget {
  @override
  State<_ColorFieldDemoPage> createState() => _ColorFieldDemoPageState();
}

class _ColorFieldDemoPageState extends State<_ColorFieldDemoPage> {
  Color _color = const Color(0xFF0485F7);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ComponentDemoTitle('ColorField — hex input'),
          HeroUiColorField(
            initialColor: _color,
            label: 'Color',
            description: 'Enter a hex color value',
            onColorChanged: (c) => setState(() => _color = c),
          ),
          const SizedBox(height: 8),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: _color,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE4E4E7)),
            ),
          ),
          const SizedBox(height: 20),
          const ComponentDemoTitle('ColorField — with error'),
          const HeroUiColorField(
            label: 'Background',
            errorText: 'Invalid color value',
          ),
          const SizedBox(height: 20),
          const ComponentDemoTitle('ColorField — disabled'),
          HeroUiColorField(
            initialColor: const Color(0xFF71717A),
            label: 'Border',
            enabled: false,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─── ColorPicker demo ─────────────────────────────────────────────────────────

class _ColorPickerDemoPage extends StatefulWidget {
  @override
  State<_ColorPickerDemoPage> createState() => _ColorPickerDemoPageState();
}

class _ColorPickerDemoPageState extends State<_ColorPickerDemoPage> {
  Color _color = const Color(0xFF0485F7);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ComponentDemoTitle('ColorPicker — full picker'),
          HeroUiColorPicker(
            initialColor: _color,
            onColorChanged: (c) => setState(() => _color = c),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _color,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE4E4E7)),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '#${_color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF18181B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const ComponentDemoTitle('ColorPicker — without alpha'),
          HeroUiColorPicker(
            initialColor: const Color(0xFFFF383C),
            showAlpha: false,
            onColorChanged: (_) {},
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
