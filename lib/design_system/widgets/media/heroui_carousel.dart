import 'package:flutter/material.dart';

// ─── Design Tokens ────────────────────────────────────────────────────────────
const Color _kPrimary = Color(0xFF0485F7);
const Color _kSurface = Color(0xFFFFFFFF);
const Color _kMuted = Color(0xFFA1A1AA);

// ─── HeroUiCarousel ───────────────────────────────────────────────────────────
// Figma Carousel: image/content carousel with navigation
//   type: inPlace  — content fills area, dots below, arrows overlaid on sides
//   type: miniatures — thumbnails row + arrows on sides
//   type: modal    — full content + close button + arrows overlaid
//
// Navigation buttons: 40px circular, white/gray fill, backdrop blur
// Dot indicators: 8px circles, primary when active, muted when inactive
// Selected thumbnail: 2px blue border
enum HeroUiCarouselType { inPlace, miniatures, modal }

class HeroUiCarousel extends StatefulWidget {
  const HeroUiCarousel({
    required this.items,
    super.key,
    this.type = HeroUiCarouselType.inPlace,
    this.thumbnails,
    this.onClose,
    this.initialIndex = 0,
    this.onIndexChanged,
    this.width,
    this.height = 360.0,
    this.autoPlay = false,
    this.autoPlayDuration = const Duration(seconds: 3),
  });

  final List<Widget> items;
  final HeroUiCarouselType type;
  final List<Widget>? thumbnails;
  final VoidCallback? onClose;
  final int initialIndex;
  final ValueChanged<int>? onIndexChanged;
  final double? width;
  final double height;
  final bool autoPlay;
  final Duration autoPlayDuration;

  @override
  State<HeroUiCarousel> createState() => _HeroUiCarouselState();
}

class _HeroUiCarouselState extends State<HeroUiCarousel> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goTo(int index) {
    final clamped = index.clamp(0, widget.items.length - 1);
    _pageController.animateToPage(
      clamped,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _prev() => _goTo(_currentIndex - 1);
  void _next() => _goTo(_currentIndex + 1);

  @override
  Widget build(BuildContext context) {
    return switch (widget.type) {
      HeroUiCarouselType.inPlace => _buildInPlace(),
      HeroUiCarouselType.miniatures => _buildMiniatures(),
      HeroUiCarouselType.modal => _buildModal(),
    };
  }

  // ── in-place ──────────────────────────────────────────────────────────────
  Widget _buildInPlace() {
    return SizedBox(
      width: widget.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: widget.height,
              child: Stack(
                children: [
                  _buildPageView(),
                  // Nav arrows
                  Positioned(
                    left: 12,
                    top: 0,
                    bottom: 0,
                    child: Center(child: _NavButton(
                      icon: Icons.chevron_left_rounded,
                      onTap: _currentIndex > 0 ? _prev : null,
                    )),
                  ),
                  Positioned(
                    right: 12,
                    top: 0,
                    bottom: 0,
                    child: Center(child: _NavButton(
                      icon: Icons.chevron_right_rounded,
                      onTap: _currentIndex < widget.items.length - 1 ? _next : null,
                    )),
                  ),
                  // Dot indicators
                  Positioned(
                    bottom: 12,
                    left: 0,
                    right: 0,
                    child: _DotIndicators(
                      count: widget.items.length,
                      current: _currentIndex,
                      onTap: _goTo,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── miniatures ────────────────────────────────────────────────────────────
  Widget _buildMiniatures() {
    final thumbs = widget.thumbnails ?? widget.items;

    return SizedBox(
      width: widget.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: widget.height,
              child: _buildPageView(),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _NavButton(
                icon: Icons.chevron_left_rounded,
                onTap: _currentIndex > 0 ? _prev : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 72,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: thumbs.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, i) {
                      final isSelected = i == _currentIndex;
                      return GestureDetector(
                        onTap: () => _goTo(i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: isSelected
                                ? Border.all(color: _kPrimary, width: 2)
                                : null,
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: thumbs[i],
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              _NavButton(
                icon: Icons.chevron_right_rounded,
                onTap: _currentIndex < widget.items.length - 1 ? _next : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── modal ─────────────────────────────────────────────────────────────────
  Widget _buildModal() {
    return SizedBox(
      width: widget.width,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: SizedBox(
              height: widget.height,
              child: _buildPageView(),
            ),
          ),
          // Close button
          if (widget.onClose != null)
            Positioned(
              top: 12,
              right: 12,
              child: _NavButton(
                icon: Icons.close_rounded,
                onTap: widget.onClose,
              ),
            ),
          // Left nav
          Positioned(
            left: 12,
            bottom: widget.height / 2 - 20,
            child: _NavButton(
              icon: Icons.chevron_left_rounded,
              onTap: _currentIndex > 0 ? _prev : null,
            ),
          ),
          // Right nav
          Positioned(
            right: 12,
            bottom: widget.height / 2 - 20,
            child: _NavButton(
              icon: Icons.chevron_right_rounded,
              onTap: _currentIndex < widget.items.length - 1 ? _next : null,
            ),
          ),
          // Thumbnails bottom row
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: _DotIndicators(
              count: widget.items.length,
              current: _currentIndex,
              onTap: _goTo,
            ),
          ),
        ],
      ),
    );
  }

  // ── shared page view ──────────────────────────────────────────────────────
  Widget _buildPageView() {
    return PageView.builder(
      controller: _pageController,
      itemCount: widget.items.length,
      onPageChanged: (i) {
        setState(() => _currentIndex = i);
        widget.onIndexChanged?.call(i);
      },
      itemBuilder: (context, i) => widget.items[i],
    );
  }
}

// ─── Navigation button ────────────────────────────────────────────────────────
class _NavButton extends StatefulWidget {
  const _NavButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onTap != null;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: enabled
                ? (_hovering
                    ? const Color(0xFFEBEBEC)
                    : _kSurface)
                : _kSurface.withValues(alpha: 0.5),
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            widget.icon,
            size: 20,
            color: enabled ? const Color(0xFF18181B) : _kMuted,
          ),
        ),
      ),
    );
  }
}

// ─── Dot indicators ──────────────────────────────────────────────────────────
class _DotIndicators extends StatelessWidget {
  const _DotIndicators({
    required this.count,
    required this.current,
    this.onTap,
  });

  final int count;
  final int current;
  final ValueChanged<int>? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i == current;
        return GestureDetector(
          onTap: () => onTap?.call(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: isActive ? 20 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: isActive ? _kPrimary : _kSurface.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }),
    );
  }
}
