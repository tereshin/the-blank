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
    return SvgPicture.asset(
      HeroUiIconManifest.assetPath(name),
      width: size,
      height: size,
      colorFilter: color == null ? null : ColorFilter.mode(color!, BlendMode.srcIn),
      semanticsLabel: semanticLabel,
    );
  }
}

class HeroUiIconManifest {
  const HeroUiIconManifest._();

  static const String _basePath = 'assets/icons/';

  static String assetPath(String name) => '$_basePath$name.svg';

  // Curated aliases for common icons from the exported set.
  static const String magnifierRegular = 'heroui-v3-icon__magnifier__regular';
  static const String bellRegular = 'heroui-v3-icon__bell__regular';
  static const String gearRegular = 'heroui-v3-icon__gear__regular';
  static const String chevronDownRegular = 'heroui-v3-icon__chevron-down__regular';
  static const String globeRegular = 'heroui-v3-icon__globe__regular';
  static const String plusRegular = 'heroui-v3-icon__plus__regular';
  static const String envelopeRegular = 'heroui-v3-icon__envelope__regular';
  static const String personPlusRegular = 'heroui-v3-icon__person-plus__regular';
  static const String arrowLeftRegular = 'heroui-v3-icon__arrow-left__regular';
  static const String trashBinRegular = 'heroui-v3-icon__trash-bin__regular';
  static const String envelopeOpenXmarkRegular =
      'heroui-v3-icon__envelope-open-xmark__regular';
  static const String houseRegular = 'heroui-v3-icon__house__regular';
  static const String personRegular = 'heroui-v3-icon__person__regular';
  static const String xmarkRegular = 'heroui-v3-icon__xmark__regular';
  static const String calendarRegular = 'heroui-v3-icon__calendar__regular';
  static const String chevronLeftRegular = 'heroui-v3-icon__arrow-chevron-left__regular';
  static const String chevronRightRegular = 'heroui-v3-icon__arrow-chevron-right__regular';
}
