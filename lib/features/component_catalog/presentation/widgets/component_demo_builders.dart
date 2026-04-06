import 'package:flutter/material.dart';

import 'component_demos/buttons_demos.dart' as buttons;
import 'component_demos/collections_demos.dart' as collections;
import 'component_demos/controls_demos.dart' as controls;
import 'component_demos/data_display_demos.dart' as data_display;
import 'component_demos/date_time_demos.dart' as date_time;
import 'component_demos/effects_demos.dart' as effects;
import 'component_demos/feedback_demos.dart' as feedback;
import 'component_demos/forms_demos.dart' as forms;
import 'component_demos/layout_demos.dart' as layout;
import 'component_demos/media_demos.dart' as media;
import 'component_demos/navigation_demos.dart' as navigation;
import 'component_demos/overlays_demos.dart' as overlays;
import 'component_demos/pickers_demos.dart' as pickers;

class ComponentDemos {
  static Widget button(BuildContext context) =>
      buttons.buildButtonDemo(context);

  static Widget buttonGroup(BuildContext context) =>
      buttons.buildButtonGroupDemo(context);

  static Widget closeButton(BuildContext context) =>
      buttons.buildCloseButtonDemo(context);

  static Widget toggleButton(BuildContext context) =>
      buttons.buildToggleButtonDemo(context);

  static Widget toggleButtonGroup(BuildContext context) =>
      buttons.buildToggleButtonGroupDemo(context);

  static Widget starReview(BuildContext context) =>
      buttons.buildStarReviewDemo(context);

  static Widget checkbox(BuildContext context) =>
      controls.buildCheckboxDemo(context);

  static Widget checkboxGroup(BuildContext context) =>
      controls.buildCheckboxGroupDemo(context);

  static Widget radio(BuildContext context) => controls.buildRadioDemo(context);

  static Widget radioGroup(BuildContext context) =>
      controls.buildRadioGroupDemo(context);

  static Widget heroSwitch(BuildContext context) =>
      controls.buildSwitchDemo(context);

  static Widget slider(BuildContext context) =>
      controls.buildSliderDemo(context);

  static Widget form(BuildContext context) => forms.buildFormDemo(context);

  static Widget fieldset(BuildContext context) =>
      forms.buildFieldsetDemo(context);

  static Widget label(BuildContext context) => forms.buildLabelDemo(context);

  static Widget description(BuildContext context) =>
      forms.buildDescriptionDemo(context);

  static Widget errorMessage(BuildContext context) =>
      forms.buildErrorMessageDemo(context);

  static Widget fieldError(BuildContext context) =>
      forms.buildFieldErrorDemo(context);

  static Widget input(BuildContext context) => forms.buildInputDemo(context);

  static Widget inputGroup(BuildContext context) =>
      forms.buildInputGroupDemo(context);

  static Widget inputOtp(BuildContext context) =>
      forms.buildInputOtpDemo(context);

  static Widget textField(BuildContext context) =>
      forms.buildTextFieldDemo(context);

  static Widget textArea(BuildContext context) =>
      forms.buildTextAreaDemo(context);

  static Widget numberField(BuildContext context) =>
      forms.buildNumberFieldDemo(context);

  static Widget searchField(BuildContext context) =>
      forms.buildSearchFieldDemo(context);

  static Widget card(BuildContext context) =>
      data_display.buildCardDemo(context);

  static Widget separator(BuildContext context) =>
      data_display.buildSeparatorDemo(context);

  static Widget kbd(BuildContext context) => data_display.buildKbdDemo(context);

  static Widget avatar(BuildContext context) =>
      data_display.buildAvatarDemo(context);

  static Widget badge(BuildContext context) =>
      data_display.buildBadgeDemo(context);

  static Widget chip(BuildContext context) =>
      data_display.buildChipDemo(context);

  static Widget skeleton(BuildContext context) =>
      data_display.buildSkeletonDemo(context);

  static Widget meter(BuildContext context) =>
      data_display.buildMeterDemo(context);

  static Widget spinner(BuildContext context) =>
      feedback.buildSpinnerDemo(context);

  static Widget progressBar(BuildContext context) =>
      feedback.buildProgressBarDemo(context);

  static Widget progressCircle(BuildContext context) =>
      feedback.buildProgressCircleDemo(context);

  static Widget alert(BuildContext context) => feedback.buildAlertDemo(context);

  static Widget toast(BuildContext context) => feedback.buildToastDemo(context);

  static Widget surface(BuildContext context) =>
      layout.buildSurfaceDemo(context);

  static Widget disclosure(BuildContext context) =>
      layout.buildDisclosureDemo(context);

  static Widget scrollShadow(BuildContext context) =>
      layout.buildScrollShadowDemo(context);

  static Widget shell(BuildContext context) => layout.buildShellDemo(context);

  static Widget select(BuildContext context) =>
      pickers.buildSelectDemo(context);

  static Widget comboBox(BuildContext context) =>
      pickers.buildComboBoxDemo(context);

  static Widget autocomplete(BuildContext context) =>
      pickers.buildAutocompleteDemo(context);

  static Widget calendar(BuildContext context) =>
      pickers.buildCalendarDemo(context);

  static Widget rangeCalendar(BuildContext context) =>
      pickers.buildRangeCalendarDemo(context);

  static Widget colorSwatch(BuildContext context) =>
      pickers.buildColorSwatchDemo(context);

  static Widget colorSwatchPicker(BuildContext context) =>
      pickers.buildColorSwatchPickerDemo(context);

  static Widget colorSlider(BuildContext context) =>
      pickers.buildColorSliderDemo(context);

  static Widget colorArea(BuildContext context) =>
      pickers.buildColorAreaDemo(context);

  static Widget colorField(BuildContext context) =>
      pickers.buildColorFieldDemo(context);

  static Widget colorPicker(BuildContext context) =>
      pickers.buildColorPickerDemo(context);

  static Widget dateField(BuildContext context) =>
      date_time.buildDateFieldDemo(context);

  static Widget timeField(BuildContext context) =>
      date_time.buildTimeFieldDemo(context);

  static Widget datePicker(BuildContext context) =>
      date_time.buildDatePickerDemo(context);

  static Widget dateRangePicker(BuildContext context) =>
      date_time.buildDateRangePickerDemo(context);

  static Widget carousel(BuildContext context) =>
      media.buildCarouselDemo(context);

  static Widget progressiveBlur(BuildContext context) =>
      effects.buildProgressiveBlurDemo(context);

  static Widget resizable(BuildContext context) =>
      effects.buildResizableDemo(context);

  static Widget tooltip(BuildContext context) =>
      overlays.buildTooltipDemo(context);

  static Widget popover(BuildContext context) =>
      overlays.buildPopoverDemo(context);

  static Widget modal(BuildContext context) => overlays.buildModalDemo(context);

  static Widget alertDialog(BuildContext context) =>
      overlays.buildAlertDialogDemo(context);

  static Widget dropdown(BuildContext context) =>
      overlays.buildDropdownDemo(context);

  static Widget drawer(BuildContext context) =>
      overlays.buildDrawerDemo(context);

  static Widget accordion(BuildContext context) =>
      collections.buildAccordionDemo(context);

  static Widget listBox(BuildContext context) =>
      collections.buildListBoxDemo(context);

  static Widget tagGroup(BuildContext context) =>
      collections.buildTagGroupDemo(context);

  static Widget table(BuildContext context) =>
      collections.buildTableDemo(context);

  static Widget breadcrumbs(BuildContext context) =>
      navigation.buildBreadcrumbsDemo(context);

  static Widget link(BuildContext context) => navigation.buildLinkDemo(context);

  static Widget pagination(BuildContext context) =>
      navigation.buildPaginationDemo(context);

  static Widget tabs(BuildContext context) => navigation.buildTabsDemo(context);

  static Widget toolbar(BuildContext context) =>
      navigation.buildToolbarDemo(context);
}
