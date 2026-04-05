import 'package:flutter/material.dart';

import 'package:heroui_design_system/design_system.dart';

void showComponentDemoMessage(BuildContext context, String message) {
  HeroUiToastService.show(context, message: message);
}
