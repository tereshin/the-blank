part of 'heroui_forms.dart';

class HeroUiSearchField extends StatefulWidget {
  const HeroUiSearchField({
    super.key,
    this.placeholder = 'Search...',
    this.label,
    this.description,
    this.variant = HeroUiInputVariant.primary,
    this.enabled = true,
    this.onChanged,
  });

  final String placeholder;
  final String? label;
  final String? description;
  final HeroUiInputVariant variant;
  final bool enabled;
  final ValueChanged<String>? onChanged;

  @override
  State<HeroUiSearchField> createState() => _HeroUiSearchFieldState();
}

class _HeroUiSearchFieldState extends State<HeroUiSearchField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChange);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChange);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onTextChange() =>
      setState(() => _hasText = _controller.text.isNotEmpty);

  void _clear() {
    _controller.clear();
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    final clearBtn = _hasText
        ? GestureDetector(
            onTap: _clear,
            child: const SizedBox(
              width: 20,
              height: 20,
              child: Icon(Icons.close_rounded, size: 14, color: _kMuted),
            ),
          )
        : null;

    final inputWidget = HeroUiInput(
      controller: _controller,
      focusNode: _focusNode,
      placeholder: widget.placeholder,
      variant: widget.variant,
      enabled: widget.enabled,
      description: widget.description,
      prefix: const Icon(Icons.search_rounded, size: 16, color: _kMuted),
      suffix: clearBtn,
      onChanged: (v) {
        widget.onChanged?.call(v);
      },
    );

    final items = <Widget>[
      if (widget.label != null) HeroUiLabel(widget.label!),
      inputWidget,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: _withVerticalSpacing(items, 4),
    );
  }
}
