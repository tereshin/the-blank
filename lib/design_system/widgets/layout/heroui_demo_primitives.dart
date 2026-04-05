import 'package:flutter/material.dart';
import 'package:the_blank/design_system/widgets/data_display/heroui_cards.dart';

import '../../../core/icons/heroui_icon.dart';
import '../../typography/heroui_typography.dart';
import '../buttons/heroui_buttons.dart';

const Color _kDemoMuted = Color(0xFF71717A);
const Color _kDemoSectionBorder = Color(0xFFE4E4E7);
const Color _kDemoDarkBackground = Color(0xFF18181B);

class ComponentDemoTitle extends StatelessWidget {
  const ComponentDemoTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(text, style: HeroUiTypography.heading4),
    );
  }
}

class ComponentDemoSubtitle extends StatelessWidget {
  const ComponentDemoSubtitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: HeroUiTypography.bodyXsMedium.copyWith(color: _kDemoMuted),
      ),
    );
  }
}

class ThemePreviewChip extends StatelessWidget {
  const ThemePreviewChip({required this.label, required this.dark, super.key});

  final String label;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final bg = dark ? const Color(0xFF18181B) : const Color(0xFFF4F4F5);
    final fg = dark ? const Color(0xFFD4D4D8) : const Color(0xFF3F3F46);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            HeroUiIcon(HeroUiIconManifest.gearRegular, size: 14, color: fg),
            const SizedBox(width: 6),
            Text(
              label,
              style: HeroUiTypography.bodyXsMedium.copyWith(
                color: fg,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HeroUiDemoSection extends StatelessWidget {
  const HeroUiDemoSection({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}

class HeroUiDemoDarkPreview extends StatelessWidget {
  const HeroUiDemoDarkPreview({
    required this.child,
    this.padding = const EdgeInsets.all(16),
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final darkTheme = Theme.of(context).copyWith(brightness: Brightness.dark);

    return Theme(
      data: darkTheme,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: _kDemoDarkBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

class HeroUiDemoThemeScope extends StatelessWidget {
  const HeroUiDemoThemeScope({
    required this.child,
    this.dark = false,
    super.key,
  });

  final Widget child;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scopedTheme = theme.copyWith(
      brightness: dark ? Brightness.dark : Brightness.light,
    );

    return Theme(data: scopedTheme, child: child);
  }
}

enum HeroUiDemoActionTriggerVariant { primary, outline, secondary }

class HeroUiDemoActionTrigger extends StatelessWidget {
  const HeroUiDemoActionTrigger({
    required this.label,
    this.onPressed,
    this.variant = HeroUiDemoActionTriggerVariant.primary,
    this.size = HeroUiButtonSize.md,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final HeroUiDemoActionTriggerVariant variant;
  final HeroUiButtonSize size;

  @override
  Widget build(BuildContext context) {
    final buttonVariant = switch (variant) {
      HeroUiDemoActionTriggerVariant.primary => HeroUiButtonVariant.primary,
      HeroUiDemoActionTriggerVariant.outline => HeroUiButtonVariant.outline,
      HeroUiDemoActionTriggerVariant.secondary => HeroUiButtonVariant.secondary,
    };

    return HeroUiButton(
      label: label,
      size: size,
      variant: buttonVariant,
      onPressed: onPressed,
    );
  }
}
