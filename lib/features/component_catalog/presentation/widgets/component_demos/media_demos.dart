import 'package:flutter/material.dart';

import 'package:heroui_design_system/design_system.dart';

Widget buildCarouselDemo(BuildContext context) => _CarouselDemoPage();

// ─── Carousel demo ────────────────────────────────────────────────────────────

class _CarouselDemoPage extends StatefulWidget {
  @override
  State<_CarouselDemoPage> createState() => _CarouselDemoPageState();
}

class _CarouselDemoPageState extends State<_CarouselDemoPage> {
  static final _slides = [
    _colorSlide(const Color(0xFF0485F7), 'Slide 1'),
    _colorSlide(const Color(0xFF8B5CF6), 'Slide 2'),
    _colorSlide(const Color(0xFF10B981), 'Slide 3'),
    _colorSlide(const Color(0xFFF59E0B), 'Slide 4'),
    _colorSlide(const Color(0xFFEF4444), 'Slide 5'),
  ];

  static Widget _colorSlide(Color color, String label) {
    return Container(
      color: color,
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ComponentDemoTitle('Carousel — in-place with dots'),
          HeroUiCarousel(
            items: _slides,
            height: 240,
            onIndexChanged: (_) {},
          ),
          const SizedBox(height: 24),
          const ComponentDemoTitle('Carousel — miniatures'),
          HeroUiCarousel(
            items: _slides,
            thumbnails: _slides,
            type: HeroUiCarouselType.miniatures,
            height: 200,
            onIndexChanged: (_) {},
          ),
          const SizedBox(height: 24),
          const ComponentDemoTitle('Carousel — modal type'),
          HeroUiCarousel(
            items: _slides,
            type: HeroUiCarouselType.modal,
            height: 300,
            onClose: () {},
            onIndexChanged: (_) {},
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
