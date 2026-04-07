part of 'heroui_buttons.dart';

const String _kStarRegularIcon = 'star';
const String _kStarFillIcon = 'star__fill';
const Color _kStarFillColor = Color(0xFFF5A524);
const Color _kStarMutedLight = Color(0xFF71717A);
const Color _kStarMutedDark = Color(0xFFA1A1AA);

/// A 5-point rating input built with [HeroUiToggleButtonGroup].
class HeroUiStarReview extends StatefulWidget {
  const HeroUiStarReview({
    super.key,
    this.label,
    this.description,
    this.initialValue,
    this.value,
    this.enabled = true,
    this.size = HeroUiButtonSize.md,
    this.onChanged,
  });

  final String? label;
  final String? description;
  final int? initialValue;
  final int? value;
  final bool enabled;
  final HeroUiButtonSize size;
  final ValueChanged<int>? onChanged;

  @override
  State<HeroUiStarReview> createState() => _HeroUiStarReviewState();
}

class _HeroUiStarReviewState extends State<HeroUiStarReview> {
  int? _value;

  @override
  void initState() {
    super.initState();
    _value = _normalizeRating(widget.value ?? widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant HeroUiStarReview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _value = _normalizeRating(widget.value);
    }
  }

  int? _normalizeRating(int? value) {
    if (value == null) return null;
    if (value < 1) return 1;
    if (value > 5) return 5;
    return value;
  }

  void _handleChanged(int next) {
    final normalized = _normalizeRating(next) ?? 1;
    if (widget.value == null) {
      setState(() => _value = normalized);
    }
    widget.onChanged?.call(normalized);
  }

  @override
  Widget build(BuildContext context) {
    final selected = _value ?? 0;
    final muted = Theme.of(context).brightness == Brightness.dark
        ? _kStarMutedDark
        : _kStarMutedLight;

    final options = <HeroUiToggleOption<int>>[
      for (var rating = 1; rating <= 5; rating++)
        HeroUiToggleOption<int>(
          value: rating,
          label: '$rating',
          iconOnly: true,
          icon: HeroUiIcon(
            rating <= selected ? _kStarFillIcon : _kStarRegularIcon,
            size: 21,
            color: rating <= selected ? _kStarFillColor : muted,
          ),
        ),
    ];

    final children = <Widget>[
      if (widget.label?.trim().isNotEmpty == true)
        Text(widget.label!, style: HeroUiTypography.bodySmMedium),
      HeroUiToggleButtonGroup<int>(
        options: options,
        value: _value,
        onChanged: widget.enabled ? _handleChanged : null,
        size: widget.size,
        variant: HeroUiToggleButtonVariant.ghost,
        isAttached: false,
      ),
      if (widget.description?.trim().isNotEmpty == true)
        Text(
          widget.description!,
          style: HeroUiTypography.bodyXs.copyWith(color: muted),
        ),
    ];

    return Opacity(
      opacity: widget.enabled ? 1 : 0.55,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const SizedBox(height: 4),
            children[i],
          ],
        ],
      ),
    );
  }
}
