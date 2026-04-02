import '../domain/catalog_component.dart';
import '../domain/component_category.dart';
import '../presentation/widgets/component_demo_builders.dart';

CatalogComponent _implemented(
  String name, {
  required String figmaNodeId,
  required ComponentDemoBuilder demoBuilder,
  String? notes,
}) {
  return CatalogComponent(
    name: name,
    figmaNodeId: figmaNodeId,
    status: ComponentImplementationStatus.implemented,
    demoBuilder: demoBuilder,
    notes: notes,
  );
}

final Map<ComponentCategory, List<CatalogComponent>> componentRegistry = {
  ComponentCategory.collections: [
    _implemented(
      'Accordion',
      figmaNodeId: '5375:79876',
      demoBuilder: ComponentDemos.accordion,
    ),
    _implemented(
      'ListBox',
      figmaNodeId: '5375:70869',
      demoBuilder: ComponentDemos.listBox,
    ),
    _implemented(
      'TagGroup',
      figmaNodeId: '14288:4550',
      demoBuilder: ComponentDemos.tagGroup,
    ),
    _implemented(
      'Table',
      figmaNodeId: '18729:23034',
      demoBuilder: ComponentDemos.table,
    ),
  ],
  ComponentCategory.buttons: [
    _implemented(
      'Button',
      figmaNodeId: '2218:6175',
      demoBuilder: ComponentDemos.button,
    ),
    _implemented(
      'ButtonGroup',
      figmaNodeId: '14216:12721',
      demoBuilder: ComponentDemos.buttonGroup,
    ),
    _implemented(
      'CloseButton',
      figmaNodeId: '3136:16907',
      demoBuilder: ComponentDemos.closeButton,
    ),
    _implemented(
      'ToggleButton',
      figmaNodeId: '15237:23433',
      demoBuilder: ComponentDemos.toggleButton,
    ),
    _implemented(
      'ToggleButtonGroup',
      figmaNodeId: '15251:25651',
      demoBuilder: ComponentDemos.toggleButtonGroup,
    ),
  ],
  ComponentCategory.colors: [
    _implemented(
      'ColorArea',
      figmaNodeId: '18522:48154',
      demoBuilder: ComponentDemos.colorArea,
    ),
    _implemented(
      'ColorField',
      figmaNodeId: '18530:48242',
      demoBuilder: ComponentDemos.colorField,
    ),
    _implemented(
      'ColorSlider',
      figmaNodeId: '18553:85093',
      demoBuilder: ComponentDemos.colorSlider,
    ),
    _implemented(
      'ColorSwatch',
      figmaNodeId: '18408:5736',
      demoBuilder: ComponentDemos.colorSwatch,
    ),
    _implemented(
      'ColorSwatchPicker',
      figmaNodeId: '18435:3080',
      demoBuilder: ComponentDemos.colorSwatchPicker,
    ),
    _implemented(
      'ColorPicker',
      figmaNodeId: '18581:89574',
      demoBuilder: ComponentDemos.colorPicker,
    ),
  ],
  ComponentCategory.controls: [
    _implemented(
      'Checkbox',
      figmaNodeId: '2487:7402',
      demoBuilder: ComponentDemos.checkbox,
    ),
    _implemented(
      'CheckboxGroup',
      figmaNodeId: '2487:7441',
      demoBuilder: ComponentDemos.checkboxGroup,
    ),
    _implemented(
      'Radio',
      figmaNodeId: '2450:5484',
      demoBuilder: ComponentDemos.radio,
    ),
    _implemented(
      'RadioGroup',
      figmaNodeId: '2450:5614',
      demoBuilder: ComponentDemos.radioGroup,
    ),
    _implemented(
      'Slider',
      figmaNodeId: '2306:2324',
      demoBuilder: ComponentDemos.slider,
    ),
    _implemented(
      'Switch',
      figmaNodeId: '2489:9914',
      demoBuilder: ComponentDemos.heroSwitch,
    ),
  ],
  ComponentCategory.dataDisplay: [
    _implemented(
      'Avatar',
      figmaNodeId: '2595:9483',
      demoBuilder: ComponentDemos.avatar,
    ),
    _implemented(
      'Badge',
      figmaNodeId: '19865:36063',
      demoBuilder: ComponentDemos.badge,
    ),
    _implemented(
      'Card',
      figmaNodeId: '3013:11085',
      demoBuilder: ComponentDemos.card,
    ),
    _implemented(
      'Chip',
      figmaNodeId: '2489:10527',
      demoBuilder: ComponentDemos.chip,
    ),
    _implemented(
      'Kbd',
      figmaNodeId: '2396:4484',
      demoBuilder: ComponentDemos.kbd,
    ),
    _implemented(
      'Meter',
      figmaNodeId: '21302:76781',
      demoBuilder: ComponentDemos.meter,
    ),
    _implemented(
      'Separator',
      figmaNodeId: '2402:4638',
      demoBuilder: ComponentDemos.separator,
    ),
    _implemented(
      'Skeleton',
      figmaNodeId: '6141:14168',
      demoBuilder: ComponentDemos.skeleton,
    ),
  ],
  ComponentCategory.dateAndTime: [
    _implemented(
      'Calendar',
      figmaNodeId: '19806:13944',
      demoBuilder: ComponentDemos.calendar,
    ),
    _implemented(
      'DateField',
      figmaNodeId: '14546:11195',
      demoBuilder: ComponentDemos.dateField,
    ),
    _implemented(
      'DatePicker',
      figmaNodeId: '2740:9201',
      demoBuilder: ComponentDemos.datePicker,
    ),
    _implemented(
      'DateRangePicker',
      figmaNodeId: '14551:12262',
      demoBuilder: ComponentDemos.dateRangePicker,
    ),
    _implemented(
      'RangeCalendar',
      figmaNodeId: '19890:13049',
      demoBuilder: ComponentDemos.rangeCalendar,
    ),
    _implemented(
      'TimeField',
      figmaNodeId: '14551:13694',
      demoBuilder: ComponentDemos.timeField,
    ),
  ],
  ComponentCategory.feedback: [
    _implemented(
      'Alert',
      figmaNodeId: '5375:72355',
      demoBuilder: ComponentDemos.alert,
    ),
    _implemented(
      'ProgressBar',
      figmaNodeId: '21302:78002',
      demoBuilder: ComponentDemos.progressBar,
    ),
    _implemented(
      'ProgressCircle',
      figmaNodeId: '21302:79204',
      demoBuilder: ComponentDemos.progressCircle,
    ),
    _implemented(
      'Spinner',
      figmaNodeId: '5375:71607',
      demoBuilder: ComponentDemos.spinner,
    ),
    _implemented(
      'Toast',
      figmaNodeId: '5375:72573',
      demoBuilder: ComponentDemos.toast,
    ),
  ],
  ComponentCategory.forms: [
    _implemented(
      'Form',
      figmaNodeId: '17290:25455',
      demoBuilder: ComponentDemos.form,
      notes: 'Implemented as compositional wrapper from form primitives.',
    ),
    _implemented(
      'Fieldset',
      figmaNodeId: '17290:25455',
      demoBuilder: ComponentDemos.fieldset,
      notes: 'No dedicated canvas. Implemented as layout wrapper.',
    ),
    _implemented(
      'Label',
      figmaNodeId: '17293:33325',
      demoBuilder: ComponentDemos.label,
    ),
    _implemented(
      'Description',
      figmaNodeId: '17290:25455',
      demoBuilder: ComponentDemos.description,
      notes: 'Mapped from Description & ErrorMessage canvas.',
    ),
    _implemented(
      'ErrorMessage',
      figmaNodeId: '17290:25455',
      demoBuilder: ComponentDemos.errorMessage,
      notes: 'Mapped from Description & ErrorMessage canvas.',
    ),
    _implemented(
      'FieldError',
      figmaNodeId: '17290:25455',
      demoBuilder: ComponentDemos.fieldError,
      notes: 'Mapped from Description & ErrorMessage canvas.',
    ),
    _implemented(
      'Input',
      figmaNodeId: '17293:26222',
      demoBuilder: ComponentDemos.input,
    ),
    _implemented(
      'InputGroup',
      figmaNodeId: '17293:29953',
      demoBuilder: ComponentDemos.inputGroup,
    ),
    _implemented(
      'InputOTP',
      figmaNodeId: '17886:8165',
      demoBuilder: ComponentDemos.inputOtp,
    ),
    _implemented(
      'TextField',
      figmaNodeId: '5375:69732',
      demoBuilder: ComponentDemos.textField,
    ),
    _implemented(
      'TextArea',
      figmaNodeId: '17293:35712',
      demoBuilder: ComponentDemos.textArea,
    ),
    _implemented(
      'NumberField',
      figmaNodeId: '17293:33571',
      demoBuilder: ComponentDemos.numberField,
    ),
    _implemented(
      'SearchField',
      figmaNodeId: '17293:34733',
      demoBuilder: ComponentDemos.searchField,
    ),
  ],
  ComponentCategory.layout: [
    _implemented(
      'Disclosure',
      figmaNodeId: '6160:642',
      demoBuilder: ComponentDemos.disclosure,
    ),
    _implemented(
      'DisclosureGroup',
      figmaNodeId: '17293:43646',
      demoBuilder: ComponentDemos.disclosure,
      notes: 'Demo shared with Disclosure.',
    ),
    _implemented(
      'Surface',
      figmaNodeId: '17294:52295',
      demoBuilder: ComponentDemos.surface,
    ),
    _implemented(
      'ScrollShadow',
      figmaNodeId: '5375:73776',
      demoBuilder: ComponentDemos.scrollShadow,
    ),
  ],
  ComponentCategory.media: [
    _implemented(
      'Carousel',
      figmaNodeId: '3160:21439',
      demoBuilder: ComponentDemos.carousel,
    ),
  ],
  ComponentCategory.utilities: [
    _implemented(
      'ProgressiveBlur',
      figmaNodeId: '3160:31389',
      demoBuilder: ComponentDemos.progressiveBlur,
    ),
    _implemented(
      'Resizable',
      figmaNodeId: '16902:29720',
      demoBuilder: ComponentDemos.resizable,
    ),
  ],
  ComponentCategory.navigation: [
    _implemented(
      'Breadcrumbs',
      figmaNodeId: '14153:3704',
      demoBuilder: ComponentDemos.breadcrumbs,
    ),
    _implemented(
      'Link',
      figmaNodeId: '5375:69635',
      demoBuilder: ComponentDemos.link,
    ),
    _implemented(
      'Pagination',
      figmaNodeId: '19140:12498',
      demoBuilder: ComponentDemos.pagination,
    ),
    _implemented(
      'Tabs',
      figmaNodeId: '5375:79785',
      demoBuilder: ComponentDemos.tabs,
    ),
    _implemented(
      'Toolbar',
      figmaNodeId: '21281:68821',
      demoBuilder: ComponentDemos.toolbar,
    ),
  ],
  ComponentCategory.overlays: [
    _implemented(
      'AlertDialog',
      figmaNodeId: '7814:319',
      demoBuilder: ComponentDemos.alertDialog,
    ),
    _implemented(
      'Drawer',
      figmaNodeId: '21149:43114',
      demoBuilder: ComponentDemos.drawer,
    ),
    _implemented(
      'Dropdown',
      figmaNodeId: '5375:70150',
      demoBuilder: ComponentDemos.dropdown,
    ),
    _implemented(
      'Modal',
      figmaNodeId: '5375:77858',
      demoBuilder: ComponentDemos.modal,
    ),
    _implemented(
      'Popover',
      figmaNodeId: '6192:4931',
      demoBuilder: ComponentDemos.popover,
    ),
    _implemented(
      'Tooltip',
      figmaNodeId: '5375:71565',
      demoBuilder: ComponentDemos.tooltip,
    ),
  ],
  ComponentCategory.pickers: [
    _implemented(
      'Autocomplete',
      figmaNodeId: '14339:37049',
      demoBuilder: ComponentDemos.autocomplete,
    ),
    _implemented(
      'ComboBox',
      figmaNodeId: '17812:4662',
      demoBuilder: ComponentDemos.comboBox,
    ),
    _implemented(
      'Select',
      figmaNodeId: '5375:70822',
      demoBuilder: ComponentDemos.select,
    ),
  ],
  ComponentCategory.typography: [],
};

List<CatalogComponent> componentsFor(ComponentCategory category) =>
    componentRegistry[category] ?? const [];
