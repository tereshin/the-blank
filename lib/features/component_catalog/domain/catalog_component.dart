import 'package:flutter/widgets.dart';

enum ComponentImplementationStatus { implemented, planned }

extension ComponentImplementationStatusX on ComponentImplementationStatus {
  String get title => switch (this) {
    ComponentImplementationStatus.implemented => 'Implemented',
    ComponentImplementationStatus.planned => 'Planned',
  };
}

typedef ComponentDemoBuilder = Widget Function(BuildContext context);

class CatalogComponent {
  const CatalogComponent({
    required this.name,
    required this.status,
    this.figmaNodeId,
    this.demoBuilder,
    this.notes,
  });

  final String name;
  final ComponentImplementationStatus status;
  final String? figmaNodeId;
  final ComponentDemoBuilder? demoBuilder;
  final String? notes;

  bool get hasDemo => demoBuilder != null;
}
