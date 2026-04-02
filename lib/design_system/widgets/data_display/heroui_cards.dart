import 'package:flutter/material.dart';

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
    final card = DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor ?? tokens.surface,
        borderRadius: radius,
        border: (borderColor ?? tokens.border) == null
            ? null
            : Border.all(color: borderColor ?? tokens.border!),
        boxShadow: showShadow ? tokens.shadows : null,
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
          style: TextStyle(
            color: tokens.secondaryText,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            height: 1.34,
          ),
        ),
      );
    }
    if (title != null && title!.isNotEmpty) {
      heading.add(
        Text(
          title!,
          style: TextStyle(
            color: tokens.primaryText,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.43,
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
          style: TextStyle(
            color: tokens.secondaryText,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            height: 1.34,
          ),
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
    required this.surface,
    required this.primaryText,
    required this.secondaryText,
    required this.border,
    required this.shadows,
  });

  final Color surface;
  final Color primaryText;
  final Color secondaryText;
  final Color? border;
  final List<BoxShadow>? shadows;
}

_HeroUiCardTokens _cardTokens(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  if (isDark) {
    return const _HeroUiCardTokens(
      surface: Color(0xFF18181B),
      primaryText: Color(0xFFFCFCFC),
      secondaryText: Color(0xFFA1A1AA),
      border: Color(0xFF27272A),
      shadows: null,
    );
  }

  return const _HeroUiCardTokens(
    surface: Color(0xFFFFFFFF),
    primaryText: Color(0xFF18181B),
    secondaryText: Color(0xFF71717A),
    border: null,
    shadows: [
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.02),
        offset: Offset(0, 2),
        blurRadius: 2,
      ),
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.04),
        offset: Offset(0, 1),
        blurRadius: 2,
      ),
    ],
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
