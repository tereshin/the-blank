import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

class HeroUiIconManifest {
  const HeroUiIconManifest._();

  static const String packageName = 'heroui_design_system';
  static const String _basePath = 'assets/icons/';

  static String assetPath(String name) => '$_basePath$name.svg';

  // Curated aliases for common icons from the exported set.
  static const String magnifierRegular = 'magnifier';
  static const String bellRegular = 'bell';
  static const String gearRegular = 'gear';
  static const String chevronDownRegular =
      'chevron-down';
  static const String globeRegular = 'globe';
  static const String plusRegular = 'plus';
  static const String envelopeRegular = 'envelope';
  static const String personPlusRegular =
      'person-plus';
  static const String arrowLeftRegular = 'arrow-left';
  static const String trashBinRegular = 'trash-bin';
  static const String envelopeOpenXmarkRegular =
      'envelope-open-xmark';
  static const String houseRegular = 'house';
  static const String personRegular = 'person';
  static const String xmarkRegular = 'xmark';
  static const String calendarRegular = 'calendar';
  static const String chevronLeftRegular =
      'arrow-chevron-left';
  static const String chevronRightRegular =
      'arrow-chevron-right';
  static const String externalRegular = 'external';
  static const String arrowUpRegular = 'arrow-up';
  static const String arrowDownRegular = 'arrow-down';
  static const String circleInfoRegular =
      'circle-info';
  static const String checkRegular = 'check';
  static const String clockRegular = 'clock';
  static const String lockRegular = 'lock';
  static const String barsUnalignedRegular =
      'bars-unaligned';
  static const String eyeRegular = 'eye';
  static const String pencilRegular = 'pencil';
  static const String deleteRegular = 'delete';
  static const String squareListUlRegular =
      'square-list-ul';
}
