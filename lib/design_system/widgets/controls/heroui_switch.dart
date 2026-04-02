import 'package:flutter/material.dart';

// ─── Public enums ─────────────────────────────────────────────────────────────

enum HeroUiSwitchSize { sm, md, lg }

// ─── HeroUiSwitch ─────────────────────────────────────────────────────────────

/// A toggle switch with an optional label.
///
/// Sizes follow the Figma spec:
/// - sm: 32×16 track, 12 px thumb
/// - md: 40×20 track, 16 px thumb  (default)
/// - lg: 48×24 track, 20 px thumb
class HeroUiSwitch extends StatefulWidget {
  const HeroUiSwitch({
    super.key,
    this.isSelected = false,
    this.label,
    this.isDisabled = false,
    this.size = HeroUiSwitchSize.md,
    this.onChanged,
  });

  final bool isSelected;

  /// Optional label rendered to the right of the track.
  final String? label;

  final bool isDisabled;
  final HeroUiSwitchSize size;

  /// Called with the next value when the user taps.
  final ValueChanged<bool>? onChanged;

  @override
  State<HeroUiSwitch> createState() => _HeroUiSwitchState();
}

class _HeroUiSwitchState extends State<HeroUiSwitch>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  bool _focused = false;

  late final AnimationController _slideAnim;

  @override
  void initState() {
    super.initState();
    _slideAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      value: widget.isSelected ? 1.0 : 0.0,
    );
  }

  @override
  void didUpdateWidget(HeroUiSwitch old) {
    super.didUpdateWidget(old);
    if (old.isSelected != widget.isSelected) {
      widget.isSelected ? _slideAnim.forward() : _slideAnim.reverse();
    }
  }

  @override
  void dispose() {
    _slideAnim.dispose();
    super.dispose();
  }

  bool get _interactive => !widget.isDisabled && widget.onChanged != null;

  void _handleTap() {
    if (!_interactive) return;
    widget.onChanged!(!widget.isSelected);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final spec = _sizeSpec(widget.size);

    final labelStyle = switch (widget.size) {
      HeroUiSwitchSize.sm => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.34,
      ),
      HeroUiSwitchSize.md => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.43,
      ),
      HeroUiSwitchSize.lg => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.5,
      ),
    };

    final labelColor = isDark ? const Color(0xFFFCFCFC) : const Color(0xFF18181B);

    return Focus(
      onFocusChange: (v) {
        if (_interactive) setState(() => _focused = v);
      },
      child: MouseRegion(
        cursor: _interactive
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        onEnter: (_) {
          if (_interactive) setState(() => _hovered = true);
        },
        onExit: (_) {
          if (_interactive) setState(() => _hovered = false);
        },
        child: GestureDetector(
          onTap: _handleTap,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 120),
            opacity: widget.isDisabled ? 0.5 : 1.0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _SwitchTrack(
                  slideAnim: _slideAnim,
                  spec: spec,
                  isDark: isDark,
                  isFocused: _focused,
                  isHovered: _hovered,
                ),
                if (widget.label != null) ...[
                  const SizedBox(width: 16),
                  Text(
                    widget.label!,
                    style: labelStyle.copyWith(color: labelColor),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Private: switch track + thumb ───────────────────────────────────────────

class _SizeSpec {
  const _SizeSpec({
    required this.trackWidth,
    required this.trackHeight,
    required this.thumbSize,
    required this.thumbPadding,
  });

  final double trackWidth;
  final double trackHeight;
  final double thumbSize;
  final double thumbPadding;
}

_SizeSpec _sizeSpec(HeroUiSwitchSize size) => switch (size) {
  HeroUiSwitchSize.sm => const _SizeSpec(
    trackWidth: 32,
    trackHeight: 16,
    thumbSize: 12,
    thumbPadding: 2,
  ),
  HeroUiSwitchSize.md => const _SizeSpec(
    trackWidth: 40,
    trackHeight: 20,
    thumbSize: 16,
    thumbPadding: 2,
  ),
  HeroUiSwitchSize.lg => const _SizeSpec(
    trackWidth: 48,
    trackHeight: 24,
    thumbSize: 20,
    thumbPadding: 2,
  ),
};

class _SwitchTrack extends StatelessWidget {
  const _SwitchTrack({
    required this.slideAnim,
    required this.spec,
    required this.isDark,
    required this.isFocused,
    required this.isHovered,
  });

  final AnimationController slideAnim;
  final _SizeSpec spec;
  final bool isDark;
  final bool isFocused;
  final bool isHovered;

  @override
  Widget build(BuildContext context) {
    final activeColor = const Color(0xFF0485F7);
    final inactiveColor = isDark ? const Color(0xFF3F3F46) : const Color(0xFFE4E4E7);

    final maxThumbTravel =
        spec.trackWidth - spec.thumbSize - spec.thumbPadding * 2;

    final focusShadow = isFocused
        ? const <BoxShadow>[
            BoxShadow(
              color: Color(0xFF0485F7),
              blurRadius: 0,
              spreadRadius: 3,
            ),
            BoxShadow(
              color: Color(0xFFF5F5F5),
              blurRadius: 0,
              spreadRadius: 1,
            ),
          ]
        : const <BoxShadow>[];

    return AnimatedBuilder(
      animation: slideAnim,
      builder: (context, _) {
        final t = CurvedAnimation(
          parent: slideAnim,
          curve: Curves.easeInOut,
        ).value;

        final trackColor = Color.lerp(inactiveColor, activeColor, t)!;
        final thumbOffset = spec.thumbPadding + maxThumbTravel * t;

        return Container(
          width: spec.trackWidth,
          height: spec.trackHeight,
          decoration: BoxDecoration(
            color: trackColor,
            borderRadius: BorderRadius.circular(spec.trackHeight / 2),
            boxShadow: focusShadow,
          ),
          child: Stack(
            children: [
              Positioned(
                left: thumbOffset,
                top: spec.thumbPadding,
                child: Container(
                  width: spec.thumbSize,
                  height: spec.thumbSize,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFCFCFC),
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.3),
                        blurRadius: 1,
                        offset: Offset(0, 0),
                      ),
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.06),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.02),
                        blurRadius: 5,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
