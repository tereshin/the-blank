import 'package:flutter/material.dart';

import '../../../../../design_system/design_system.dart';

void showComponentDemoMessage(BuildContext context, String message) {
  HeroUiToastService.show(context, message: message);
}
