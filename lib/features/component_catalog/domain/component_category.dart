enum ComponentCategory {
  buttons,
  collections,
  colors,
  controls,
  dataDisplay,
  dateAndTime,
  feedback,
  forms,
  layout,
  media,
  navigation,
  overlays,
  pickers,
  typography,
  utilities,
}

extension ComponentCategoryX on ComponentCategory {
  String get title => switch (this) {
    ComponentCategory.buttons => 'Buttons',
    ComponentCategory.collections => 'Collections',
    ComponentCategory.colors => 'Colors',
    ComponentCategory.controls => 'Controls',
    ComponentCategory.dataDisplay => 'Data Display',
    ComponentCategory.dateAndTime => 'Date and Time',
    ComponentCategory.feedback => 'Feedback',
    ComponentCategory.forms => 'Forms',
    ComponentCategory.layout => 'Layout',
    ComponentCategory.media => 'Media',
    ComponentCategory.navigation => 'Navigation',
    ComponentCategory.overlays => 'Overlays',
    ComponentCategory.pickers => 'Pickers',
    ComponentCategory.typography => 'Typography',
    ComponentCategory.utilities => 'Utilities',
  };
}
