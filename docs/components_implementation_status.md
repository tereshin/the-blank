# HeroUI Components Implementation Status

This file tracks the implementation status of components in this project.

## Implemented

| Component | Category | Status | Figma Node | Flutter API |
| --- | --- | --- | --- | --- |
| Button | Buttons | Implemented | `2218:6175` | `HeroUiButton` |
| ButtonGroup | Buttons | Implemented | `14216:12721` | `HeroUiButtonGroup` |
| CloseButton | Buttons | Implemented | `3136:16907` | `HeroUiCloseButton` |
| ToggleButton | Buttons | Implemented | `15237:23433` | `HeroUiToggleButton` |
| ToggleButtonGroup | Buttons | Implemented | `15251:25651` | `HeroUiToggleButtonGroup` |
| Card | Data Display | Implemented | `3013:11085` | `HeroUiCard` |
| Form | Forms | Implemented | `17290:25455` | `HeroUiForm` |
| Fieldset | Forms | Implemented | `17290:25455` | `HeroUiFieldset` |
| Label | Forms | Implemented | `17293:33325` | `HeroUiLabel` |
| Description | Forms | Implemented | `17290:25455` | `HeroUiDescription` |
| ErrorMessage | Forms | Implemented | `17290:25455` | `HeroUiErrorMessage` |
| FieldError | Forms | Implemented | `17290:25455` | `HeroUiFieldError` |
| Input | Forms | Implemented | `17293:26222` | `HeroUiInput` |
| InputGroup | Forms | Implemented | `17293:29953` | `HeroUiInputGroup` |
| InputOTP | Forms | Implemented | `5375:69951` | `HeroUiInputOtp` |
| TextField | Forms | Implemented | `5375:69732` | `HeroUiTextField` |
| TextArea | Forms | Implemented | `17293:35712` | `HeroUiTextArea` |
| NumberField | Forms | Implemented | `17293:33571` | `HeroUiNumberField` |
| SearchField | Forms | Implemented | `17293:34733` | `HeroUiSearchField` |
| Breadcrumbs | Navigation | Implemented | `14153:3704` | `HeroUiBreadcrumbs` |
| Link | Navigation | Implemented | `5375:69635` | `HeroUiLink` |
| Pagination | Navigation | Implemented | `19140:12498` | `HeroUiPagination` |
| Tabs | Navigation | Implemented | `5375:79785` | `HeroUiTabs` |
| Toolbar | Navigation | Implemented | `21281:68821` | `HeroUiToolbar` |

## Notes

- `Form`, `Fieldset`, and `FieldError` do not have dedicated standalone canvas pages in the source Figma kit and are implemented as compositional primitives.
- `Description` and `ErrorMessage` are mapped from the combined Figma page `Description & ErrorMessage` (`17290:25455`).
- Full icon export from `Icons` page is stored under `assets/icons/` with names in format `heroui-v3-icon__{setSlug}__{variant}.svg`.
- Icon export completeness: `705` SVG files and `705` entries in `assets/icons/manifest.json`.
