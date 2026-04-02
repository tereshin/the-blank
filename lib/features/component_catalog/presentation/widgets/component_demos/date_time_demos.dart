import 'package:flutter/material.dart';

import '../../../../../design_system/design_system.dart';
import 'shared_demo_widgets.dart';

Widget buildDateFieldDemo(BuildContext context) => _DateFieldDemoPage();

Widget buildTimeFieldDemo(BuildContext context) => _TimeFieldDemoPage();

Widget buildDatePickerDemo(BuildContext context) => _DatePickerDemoPage();

Widget buildDateRangePickerDemo(BuildContext context) =>
    _DateRangePickerDemoPage();

// ─── DateField demo ───────────────────────────────────────────────────────────

class _DateFieldDemoPage extends StatefulWidget {
  @override
  State<_DateFieldDemoPage> createState() => _DateFieldDemoPageState();
}

class _DateFieldDemoPageState extends State<_DateFieldDemoPage> {
  DateTime? _date;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ComponentDemoTitle('DateField — default'),
          HeroUiDateField(
            label: 'Date',
            description: 'MM/DD/YYYY format',
            onChanged: (d) => setState(() => _date = d),
          ),
          const SizedBox(height: 8),
          if (_date != null)
            Text(
              'Selected: ${_date!.year}-${_date!.month.toString().padLeft(2, '0')}-${_date!.day.toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 13, color: Color(0xFF71717A)),
            ),
          const SizedBox(height: 20),
          const ComponentDemoTitle('DateField — with time'),
          HeroUiDateField(
            label: 'Date & Time',
            showTime: true,
            onChanged: (_) {},
          ),
          const SizedBox(height: 20),
          const ComponentDemoTitle('DateField — error state'),
          const HeroUiDateField(
            label: 'Date',
            errorText: 'Invalid date',
          ),
          const SizedBox(height: 20),
          const ComponentDemoTitle('DateField — disabled'),
          HeroUiDateField(
            label: 'Date',
            initialValue: DateTime(2024, 6, 15),
            enabled: false,
            onChanged: (_) {},
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─── TimeField demo ───────────────────────────────────────────────────────────

class _TimeFieldDemoPage extends StatefulWidget {
  @override
  State<_TimeFieldDemoPage> createState() => _TimeFieldDemoPageState();
}

class _TimeFieldDemoPageState extends State<_TimeFieldDemoPage> {
  TimeOfDay? _time;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ComponentDemoTitle('TimeField — 12hr format'),
          HeroUiTimeField(
            label: 'Time',
            description: 'Select a time',
            onChanged: (t) => setState(() => _time = t),
          ),
          const SizedBox(height: 8),
          if (_time != null)
            Text(
              'Selected: ${_time!.format(context)}',
              style: const TextStyle(fontSize: 13, color: Color(0xFF71717A)),
            ),
          const SizedBox(height: 20),
          const ComponentDemoTitle('TimeField — 24hr format'),
          const HeroUiTimeField(
            label: 'Time',
            show12hr: false,
          ),
          const SizedBox(height: 20),
          const ComponentDemoTitle('TimeField — with seconds'),
          const HeroUiTimeField(
            label: 'Duration',
            showSeconds: true,
          ),
          const SizedBox(height: 20),
          const ComponentDemoTitle('TimeField — error'),
          const HeroUiTimeField(
            label: 'Time',
            errorText: 'Time is required',
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─── DatePicker demo ──────────────────────────────────────────────────────────

class _DatePickerDemoPage extends StatefulWidget {
  @override
  State<_DatePickerDemoPage> createState() => _DatePickerDemoPageState();
}

class _DatePickerDemoPageState extends State<_DatePickerDemoPage> {
  DateTime? _date;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ComponentDemoTitle('DatePicker — tap to open calendar'),
          HeroUiDatePicker(
            label: 'Date',
            description: 'Tap the field to open calendar',
            onChanged: (d) => setState(() => _date = d),
          ),
          const SizedBox(height: 8),
          if (_date != null)
            Text(
              'Selected: ${_date!.year}-${_date!.month.toString().padLeft(2, '0')}-${_date!.day.toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 13, color: Color(0xFF71717A)),
            ),
          const SizedBox(height: 20),
          const ComponentDemoTitle('DatePicker — with min/max'),
          HeroUiDatePicker(
            label: 'Date',
            minDate: DateTime.now().subtract(const Duration(days: 7)),
            maxDate: DateTime.now().add(const Duration(days: 30)),
            onChanged: (_) {},
          ),
          const SizedBox(height: 20),
          const ComponentDemoTitle('DatePicker — error state'),
          const HeroUiDatePicker(
            label: 'Date',
            errorText: 'Please select a date',
          ),
          const SizedBox(height: 20),
          const ComponentDemoTitle('DatePicker — disabled'),
          HeroUiDatePicker(
            label: 'Date',
            initialValue: DateTime(2024, 6, 15),
            enabled: false,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─── DateRangePicker demo ─────────────────────────────────────────────────────

class _DateRangePickerDemoPage extends StatefulWidget {
  @override
  State<_DateRangePickerDemoPage> createState() =>
      _DateRangePickerDemoPageState();
}

class _DateRangePickerDemoPageState extends State<_DateRangePickerDemoPage> {
  DateTime? _start;
  DateTime? _end;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ComponentDemoTitle('DateRangePicker — tap to open'),
          HeroUiDateRangePicker(
            label: 'Date Range',
            description: 'Tap to select a date range',
            onChanged: (s, e) => setState(() {
              _start = s;
              _end = e;
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
          const SizedBox(height: 20),
          const ComponentDemoTitle('DateRangePicker — error state'),
          const HeroUiDateRangePicker(
            label: 'Date Range',
            errorText: 'Please select a date range',
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
