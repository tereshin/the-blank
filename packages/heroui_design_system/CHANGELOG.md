# Changelog

All notable changes to this project are documented in this file.

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
