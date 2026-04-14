# Changelog

All notable changes to this project are documented in this file.

## 0.1.8

- `HeroUiSelect`, `HeroUiComboBox`, and `HeroUiAutocomplete`: added closing animation parity with opening by reversing the same dropdown overlay animation before removing the overlay.
- `HeroUiComboBox` and `HeroUiAutocomplete`: hardened overlay lifecycle handling (including `dispose`) to avoid teardown assertions and focus-related race conditions when opening/closing rapidly.
- `HeroUiAutocomplete`: dropdown now closes on outside tap and on item selection; filtering state is kept in sync when external `items`/`values` props change.
- `HeroUiAutocomplete`: on mobile layouts, the field now expands to full available width.
- `HeroUiInputOtp`: reworked cell row sizing to adapt to available width (with a narrow-width horizontal scroll fallback), preventing right-side `RenderFlex` overflows for compact screens.

## 0.1.7

- `HeroUiButtonGroup` (attached, horizontal, `width: hug`): when the parent supplies a finite max width, segments now share the row with `Expanded` and `HeroUiButton.expand` so the group no longer overflows narrow layouts (e.g. catalog cards).
- `HeroUiSelect`: closing the dropdown from `dispose()` removes the overlay only and skips `setState`, avoiding lifecycle assertions and follow-on errors during widget teardown.
- Tuned layout metrics on core controls (buttons, button groups, checkbox, radio, slider, switch, star review, close button, and key data-display surfaces) so padding, min sizes, radii, and icon sizes stay consistent with the updated visual scale.

## 0.1.6

- `HeroUiTabs`: validate the tab strip indicator `Rect` from layout (`localToGlobal` / `RenderBox.size`) so only finite `left`, `top`, `width`, and `height` are passed into `AnimatedPositioned`. This prevents `Stack` layout assertions (`height.isNaN`) when transient or invalid geometry would otherwise reach the positioned child.

## 0.1.5

- Added `HeroUiShell`: shell similar to `Scaffold` where the app bar and bottom navigation sit in a `Stack` above the body with margins and rounded `Material` surfaces (floating / iOS-style chrome). Body is full-bleed; optional `resizeToAvoidBottomInset` shifts content when the keyboard opens.
- `HeroUiDrawer`: added optional `maxHeight` (0–1, fraction of logical window height) to cap panel height; when there are no `footerActions`, removed the extra bottom spacer and applied bottom `viewPadding` as `SingleChildScrollView` padding so content scrolls clear of the home indicator on bottom sheets.
- `HeroUiDrawer` (bottom/top handle): header no longer shows the close icon when the drag handle is present; tapping the handle dismisses the drawer; swipe-to-close by dragging the handle is unchanged.
- Added `HeroUiMenuCard` and `HeroUiMenuItem` (collections): grouped rows inside `HeroUiCard` with iOS Settings–style inset separators (`HeroUiSeparator`), optional leading, subtitle, trailing, and optional `onTap`. Interactive rows use hover (`HeroUiSurfaceVariant.secondary`) and pressed (`HeroUiSurfaceVariant.tertiary`) fills via `HeroUiSurface` (no extra shadow); non-tappable rows stay visual-only.
- Added `HeroUiSurface.fillColor` to resolve the same default fill colors as `HeroUiSurface` for a given `HeroUiSurfaceVariant` and theme brightness (single source of truth with the widget’s `build` method).
- Expanded `HeroUiIconManifest` with a constant for every icon under `assets/icons` (camelCase names map to SVG stems). Removed the `Regular` suffix from manifest entries; update call sites accordingly. Chevron navigation icons that map to `arrow-chevron-left` / `arrow-chevron-right` assets are now `arrowChevronLeft` and `arrowChevronRight`.
- Added `HeroUiTypography.textOTPFieldBase` (16px, weight 600) and wired `HeroUiInputOtp` value text to use it instead of `bodySmMedium`.
- Improved `HeroUiInputOtp` layout: wider cells, symmetric padding, full-width `TextField` so digits stay centered and are not clipped.
- Added dark-theme styling for `HeroUiCloseButton` (surface, icon, and focus inner ring colors).
- Applied a light press feedback (`AnimatedScale` to 0.97) to the whole control for `HeroUiButton` and `HeroUiCloseButton`, including background and borders, not only the label or icon.

## 0.1.4

- Updated `HeroUiCard` to use `HeroUiSurface` backgrounds with configurable surface variants.
- Extended `HeroUiSurface` with `showShadow` and `backgroundColor` options for reusable surface styling.
- Improved `HeroUiDrawer` with configurable `surfaceVariant`, full-width swipe handle area, and release-based swipe-to-close behavior.
- Reworked `HeroUiDrawer` layout paddings so header/footer keep insets while content body remains edge-to-edge.
- Removed unwanted text underlines in drawer content and standardized overlay close actions to use `HeroUiCloseButton`.
- Added new typography tokens: `HeroUiTypography.bodyXxs` and `HeroUiTypography.bodyXxsMedium` (10px).
- Renamed packaged icon assets by removing `heroui-v3-icon__` prefix and `__regular` suffix, and updated manifest/icon references to the new names.
- Fixed inherited text decoration in `HeroUiToast` so `HeroUiToastService` notifications no longer render with yellow double underlines.

## 0.1.3
– Updated `HeroUiSpinner`

## 0.1.2

- Updated `HeroUiTimeField` to use a bottom sheet modal picker.
- Reworked time inputs to `HeroUiInput` (secondary) with digits-only validation.
- Added `HeroUiStarReview`, a 5-point star rating component built with `HeroUiToggleButtonGroup`.
- Updated component catalog demos to cover the new time picker flow and star review component.

## 0.1.0

- Initial release of the HeroUI Flutter design system package.
- Includes core UI components, typography, and icon assets.
