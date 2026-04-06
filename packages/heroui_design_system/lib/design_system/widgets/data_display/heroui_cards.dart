import 'package:flutter/material.dart';

import '../layout/heroui_layout.dart';
import '../../typography/heroui_typography.dart';

class HeroUiCard extends StatelessWidget {
  const HeroUiCard({
    super.key,
    this.header,
    this.body,
    this.footer,
    this.padding = const EdgeInsets.all(16),
    this.sectionGap = 12,
    this.borderRadius = 24,
    this.showShadow = true,
    this.onTap,
    this.backgroundColor,
    this.surfaceVariant = HeroUiSurfaceVariant.defaultVariant,
    this.borderColor,
  });

  final Widget? header;
  final Widget? body;
  final Widget? footer;
  final EdgeInsetsGeometry padding;
  final double sectionGap;
  final double borderRadius;
  final bool showShadow;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final HeroUiSurfaceVariant surfaceVariant;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final tokens = _cardTokens(context);
    final sections = <Widget>[];
    if (header != null) sections.add(header!);
    if (body != null) sections.add(body!);
    if (footer != null) sections.add(footer!);

    final content = Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _withVerticalSpacing(sections, sectionGap),
      ),
    );

    final radius = BorderRadius.circular(borderRadius);
    final resolvedBorderColor = borderColor ?? tokens.border;
    final card = HeroUiSurface(
      variant: surfaceVariant,
      borderRadius: borderRadius,
      showShadow: showShadow,
      backgroundColor: backgroundColor,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: radius,
          border: resolvedBorderColor == null
              ? null
              : Border.all(color: resolvedBorderColor),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: onTap == null
              ? content
              : InkWell(
                  borderRadius: radius,
                  splashFactory: NoSplash.splashFactory,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  onTap: onTap,
                  child: content,
                ),
        ),
      ),
    );

    return card;
  }
}

class HeroUiCardHeader extends StatelessWidget {
  const HeroUiCardHeader({
    super.key,
    this.tagline,
    this.title,
    this.description,
    this.trailing,
  });

  final String? tagline;
  final String? title;
  final String? description;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final tokens = _cardTokens(context);
    final heading = <Widget>[];
    if (tagline != null && tagline!.isNotEmpty) {
      heading.add(
        Text(
          tagline!,
          style: HeroUiTypography.bodyXsMedium.copyWith(
            color: tokens.secondaryText,
          ),
        ),
      );
    }
    if (title != null && title!.isNotEmpty) {
      heading.add(
        Text(
          title!,
          style: HeroUiTypography.bodySmMedium.copyWith(
            color: tokens.primaryText,
          ),
        ),
      );
    }

    final rows = <Widget>[];
    if (heading.isNotEmpty || trailing != null) {
      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _withVerticalSpacing(heading, 2),
              ),
            ),
            if (trailing != null) ...[const SizedBox(width: 8), trailing!],
          ],
        ),
      );
    }
    if (description != null && description!.isNotEmpty) {
      if (rows.isNotEmpty) rows.add(const SizedBox(height: 4));
      rows.add(
        Text(
          description!,
          style: HeroUiTypography.bodyXs.copyWith(color: tokens.secondaryText),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows,
    );
  }
}

class HeroUiCardFooter extends StatelessWidget {
  const HeroUiCardFooter({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}

class HeroUiCardMedia extends StatelessWidget {
  const HeroUiCardMedia({
    required this.child,
    super.key,
    this.width,
    this.height,
    this.borderRadius = 12,
  });

  final Widget child;
  final double? width;
  final double? height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(width: width, height: height, child: child),
    );
  }
}

class _HeroUiCardTokens {
  const _HeroUiCardTokens({
    required this.primaryText,
    required this.secondaryText,
    required this.border,
  });

  final Color primaryText;
  final Color secondaryText;
  final Color? border;
}

_HeroUiCardTokens _cardTokens(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  if (isDark) {
    return const _HeroUiCardTokens(
      primaryText: Color(0xFFFCFCFC),
      secondaryText: Color(0xFFA1A1AA),
      border: null,
    );
  }

  return const _HeroUiCardTokens(
    primaryText: Color(0xFF18181B),
    secondaryText: Color(0xFF71717A),
    border: null,
  );
}

List<Widget> _withVerticalSpacing(List<Widget> children, double spacing) {
  final out = <Widget>[];
  for (var i = 0; i < children.length; i++) {
    if (i > 0) out.add(SizedBox(height: spacing));
    out.add(children[i]);
  }
  return out;
}
