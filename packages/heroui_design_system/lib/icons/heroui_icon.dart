import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

part 'heroui_icon_manifest.dart';

class HeroUiIcon extends StatelessWidget {
  const HeroUiIcon(
    this.name, {
    super.key,
    this.size = 20,
    this.color,
    this.semanticLabel,
  });

  final String name;
  final double size;
  final Color? color;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? IconTheme.of(context).color;
    return SvgPicture.asset(
      HeroUiIconManifest.assetPath(name),
      package: HeroUiIconManifest.packageName,
      width: size,
      height: size,
      colorFilter: effectiveColor == null
          ? null
          : ColorFilter.mode(effectiveColor, BlendMode.srcIn),
      semanticsLabel: semanticLabel,
    );
  }
}
