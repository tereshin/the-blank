part of 'heroui_forms.dart';

class HeroUiForm extends StatelessWidget {
  const HeroUiForm({
    required this.child,
    super.key,
    this.formKey,
    this.autovalidateMode = AutovalidateMode.disabled,
  });

  final Widget child;
  final GlobalKey<FormState>? formKey;
  final AutovalidateMode autovalidateMode;

  @override
  Widget build(BuildContext context) {
    return Form(key: formKey, autovalidateMode: autovalidateMode, child: child);
  }
}

class HeroUiFieldset extends StatelessWidget {
  const HeroUiFieldset({
    required this.children,
    super.key,
    this.legend,
    this.description,
    this.padding = const EdgeInsets.all(16),
  });

  final String? legend;
  final String? description;
  final List<Widget> children;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return HeroUiSurface(
      variant: HeroUiSurfaceVariant.secondary,
      borderRadius: 16,
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (legend != null) HeroUiLabel(legend!),
          if (description != null) ...[
            const SizedBox(height: 4),
            HeroUiDescription(description!),
          ],
          if (children.isNotEmpty) ...[
            if (legend != null || description != null)
              const SizedBox(height: 12),
            ..._withVerticalSpacing(children, 12),
          ],
        ],
      ),
    );
  }
}

class HeroUiLabel extends StatelessWidget {
  const HeroUiLabel(this.text, {super.key, this.requiredField = false});

  final String text;
  final bool requiredField;

  @override
  Widget build(BuildContext context) {
    final textColor = _textColor(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          text,
          style: _kLabelStyle.copyWith(
            color: textColor,
            fontWeight: FontWeight.w400,
          ),
        ),
        if (requiredField) ...[
          const SizedBox(width: 4),
          Text('*', style: _kLabelStyle.copyWith(color: _kDanger)),
        ],
      ],
    );
  }
}

class HeroUiDescription extends StatelessWidget {
  const HeroUiDescription(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: _kBodyXsStyle.copyWith(color: _kMuted));
  }
}

class HeroUiErrorMessage extends StatelessWidget {
  const HeroUiErrorMessage(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: _kBodyXsStyle.copyWith(color: _kDanger));
  }
}

class HeroUiFieldError extends StatelessWidget {
  const HeroUiFieldError({required this.child, super.key, this.errorText});

  final Widget child;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        child,
        if (errorText != null && errorText!.trim().isNotEmpty) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: HeroUiErrorMessage(errorText!),
          ),
        ],
      ],
    );
  }
}
