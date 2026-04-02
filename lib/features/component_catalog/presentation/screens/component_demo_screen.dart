import 'package:flutter/material.dart';

import '../../domain/catalog_component.dart';

class ComponentDemoScreen extends StatelessWidget {
  const ComponentDemoScreen({
    required this.component,
    super.key,
  });

  final CatalogComponent component;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(component.name),
      ),
      body: component.demoBuilder?.call(context) ??
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                '${component.name} is planned but does not have a demo widget yet.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
    );
  }
}
