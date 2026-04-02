import 'package:flutter/material.dart';

import '../../../../../design_system/design_system.dart';
import 'shared_demo_widgets.dart';

const String _kInputAffixGlobeIcon = 'heroui-v3-icon__globe__regular';
const String _kInputAffixCopyIcon = 'heroui-v3-icon__copy__regular';
const String _kInputAffixHandsetIcon = 'heroui-v3-icon__handset__regular';
const String _kInputAffixEnvelopeIcon = 'heroui-v3-icon__envelope__regular';
const String _kInputAffixEyeSlashIcon = 'heroui-v3-icon__eye-slash__regular';

// ─── Form ─────────────────────────────────────────────────────────────────────
Widget buildFormDemo(BuildContext context) => const _SimpleFormDemo();

// ─── Fieldset ─────────────────────────────────────────────────────────────────
Widget buildFieldsetDemo(BuildContext context) => SingleChildScrollView(
  padding: const EdgeInsets.all(16),
  child: HeroUiFieldset(
    legend: 'Account settings',
    description: 'Group related fields together and provide context.',
    children: const [
      HeroUiTextField(label: 'Display name', placeholder: 'Jane Doe'),
      HeroUiTextField(label: 'Username', placeholder: '@username'),
    ],
  ),
);

// ─── Label ────────────────────────────────────────────────────────────────────
Widget buildLabelDemo(BuildContext context) => SingleChildScrollView(
  padding: const EdgeInsets.all(16),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const ComponentDemoTitle('Label'),
      const SizedBox(height: 16),
      const ComponentDemoSubtitle('Default'),
      const HeroUiLabel('Email address'),
      const SizedBox(height: 16),
      const ComponentDemoSubtitle('Required'),
      const HeroUiLabel('Password', requiredField: true),
      const SizedBox(height: 16),
      const ComponentDemoSubtitle('Long label'),
      const HeroUiLabel(
        'Your full legal name as it appears on your ID',
        requiredField: true,
      ),
    ],
  ),
);

// ─── Description ─────────────────────────────────────────────────────────────
Widget buildDescriptionDemo(BuildContext context) =>
    const SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ComponentDemoTitle('Description'),
          SizedBox(height: 16),
          HeroUiDescription(
            'Descriptions provide supporting context for a field or section.',
          ),
          SizedBox(height: 8),
          HeroUiDescription('We will never share your email with anyone else.'),
        ],
      ),
    );

// ─── ErrorMessage ─────────────────────────────────────────────────────────────
Widget buildErrorMessageDemo(BuildContext context) =>
    const SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ComponentDemoTitle('ErrorMessage'),
          SizedBox(height: 16),
          HeroUiErrorMessage('Something went wrong. Please try again.'),
          SizedBox(height: 8),
          HeroUiErrorMessage('This field is required.'),
          SizedBox(height: 8),
          HeroUiErrorMessage('Please enter a valid email address.'),
        ],
      ),
    );

// ─── FieldError ───────────────────────────────────────────────────────────────
Widget buildFieldErrorDemo(BuildContext context) => const SingleChildScrollView(
  padding: EdgeInsets.all(16),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ComponentDemoTitle('FieldError'),
      SizedBox(height: 16),
      HeroUiFieldError(
        errorText: 'This field is required.',
        child: HeroUiTextField(placeholder: 'Type something...'),
      ),
    ],
  ),
);

// ─── Input ────────────────────────────────────────────────────────────────────
Widget buildInputDemo(BuildContext context) => SingleChildScrollView(
  padding: const EdgeInsets.all(16),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const ComponentDemoTitle('Input'),
      const SizedBox(height: 16),
      const ComponentDemoSubtitle('Primary'),
      const HeroUiInput(placeholder: 'Enter text...'),
      const SizedBox(height: 12),
      const ComponentDemoSubtitle('Secondary'),
      const HeroUiInput(
        placeholder: 'Secondary variant',
        variant: HeroUiInputVariant.secondary,
      ),
      const SizedBox(height: 12),
      const ComponentDemoSubtitle('With prefix icon'),
      const HeroUiInput(
        placeholder: 'Search...',
        prefix: Icon(Icons.search_rounded, size: 16),
      ),
      const SizedBox(height: 12),
      const ComponentDemoSubtitle('With suffix icon'),
      const HeroUiInput(
        placeholder: 'Password',
        type: HeroUiInputType.password,
        suffix: Icon(Icons.visibility_off_outlined, size: 16),
      ),
      const SizedBox(height: 12),
      const ComponentDemoSubtitle('With error'),
      const HeroUiInput(
        placeholder: 'Email',
        errorText: 'Please enter a valid email.',
      ),
      const SizedBox(height: 12),
      const ComponentDemoSubtitle('Disabled'),
      const HeroUiInput(placeholder: 'Disabled input', enabled: false),
    ],
  ),
);

// ─── InputGroup ───────────────────────────────────────────────────────────────
Widget buildInputGroupDemo(BuildContext context) => SingleChildScrollView(
  padding: const EdgeInsets.all(16),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const ComponentDemoTitle('InputGroup'),
      const SizedBox(height: 16),
      const ComponentDemoSubtitle('Text / both affixes (active)'),
      const HeroUiInputGroup(
        placeholder: 'heroui.com',
        gapSpace: true,
        prefixAffix: HeroUiInputAffix(
          iconName: _kInputAffixGlobeIcon,
          showContent: false,
          showArrow: true,
          tone: HeroUiInputAffixTone.active,
        ),
        suffixAffix: HeroUiInputAffix(
          iconName: _kInputAffixCopyIcon,
          showContent: false,
          tone: HeroUiInputAffixTone.active,
        ),
      ),
      const SizedBox(height: 12),
      const ComponentDemoSubtitle('Text / both affixes (mute + content)'),
      const HeroUiInputGroup(
        placeholder: 'heroui',
        gapSpace: true,
        prefixAffix: HeroUiInputAffix(
          iconName: _kInputAffixGlobeIcon,
          showContent: false,
          showArrow: true,
          tone: HeroUiInputAffixTone.mute,
        ),
        suffixAffix: HeroUiInputAffix(
          content: '.com',
          showIcon: false,
          tone: HeroUiInputAffixTone.mute,
          showContainerGroup: true,
        ),
      ),
      const SizedBox(height: 12),
      const ComponentDemoSubtitle('Text / prefix only'),
      const HeroUiInputGroup(
        placeholder: 'heroui.com',
        gapSpace: true,
        prefixAffix: HeroUiInputAffix(
          content: 'https://',
          showIcon: false,
          tone: HeroUiInputAffixTone.mute,
          showContainerGroup: true,
        ),
      ),
      const SizedBox(height: 12),
      const ComponentDemoSubtitle('Number / both affixes'),
      const HeroUiInputGroup(
        placeholder: '10',
        type: HeroUiInputType.number,
        gapSpace: true,
        prefixAffix: HeroUiInputAffix(
          content: r'$',
          showIcon: false,
          tone: HeroUiInputAffixTone.mute,
          showContainerGroup: true,
        ),
        suffixAffix: HeroUiInputAffix(
          content: 'USD',
          showIcon: false,
          showArrow: true,
          tone: HeroUiInputAffixTone.mute,
          showContainerGroup: true,
        ),
      ),
      const SizedBox(height: 12),
      const ComponentDemoSubtitle('Number / phone prefix'),
      const HeroUiInputGroup(
        placeholder: '(000) 000 - 0000',
        type: HeroUiInputType.number,
        gapSpace: true,
        prefixAffix: HeroUiInputAffix(
          iconName: _kInputAffixHandsetIcon,
          content: '+1',
          showArrow: true,
          tone: HeroUiInputAffixTone.active,
          showContainerGroup: true,
        ),
      ),
      const SizedBox(height: 12),
      const ComponentDemoSubtitle('Suffix icon / no gap'),
      const HeroUiInputGroup(
        placeholder: 'name@email.com',
        prefixAffix: null,
        gapSpace: false,
        suffixAffix: HeroUiInputAffix(
          iconName: _kInputAffixEnvelopeIcon,
          showContent: false,
          tone: HeroUiInputAffixTone.active,
        ),
      ),
      const SizedBox(height: 12),
      const ComponentDemoSubtitle('Suffix role / gap'),
      const HeroUiInputGroup(
        placeholder: 'name@email.com',
        gapSpace: true,
        suffixAffix: HeroUiInputAffix(
          content: 'Admin',
          showIcon: false,
          showArrow: true,
          tone: HeroUiInputAffixTone.active,
          showContainerGroup: true,
        ),
      ),
      const SizedBox(height: 12),
      const ComponentDemoSubtitle('Password / suffix icon'),
      const HeroUiInputGroup(
        placeholder: '87\$2h.3diua',
        type: HeroUiInputType.password,
        gapSpace: false,
        suffixAffix: HeroUiInputAffix(
          iconName: _kInputAffixEyeSlashIcon,
          showContent: false,
          tone: HeroUiInputAffixTone.mute,
        ),
      ),
      const SizedBox(height: 12),
      const ComponentDemoSubtitle('Suffix Kbd'),
      const HeroUiInputGroup(
        placeholder: 'Command',
        gapSpace: false,
        suffixAffix: HeroUiInputAffix(
          showIcon: false,
          showContent: false,
          tone: HeroUiInputAffixTone.mute,
          child: HeroUiKbd(keys: ['⌘', 'K']),
        ),
      ),
      const SizedBox(height: 12),
      const ComponentDemoSubtitle('Suffix Chip / Spinner'),
      const Row(
        children: [
          Expanded(
            child: HeroUiInputGroup(
              placeholder: 'Email address',
              gapSpace: false,
              suffixAffix: HeroUiInputAffix(
                showIcon: false,
                showContent: false,
                tone: HeroUiInputAffixTone.mute,
                child: HeroUiChip(
                  label: 'Pro',
                  variant: HeroUiChipVariant.soft,
                  type: HeroUiComponentType.accent,
                  size: HeroUiChipSize.sm,
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: HeroUiInputGroup(
              placeholder: 'Sending...',
              gapSpace: false,
              suffixAffix: HeroUiInputAffix(
                showIcon: false,
                showContent: false,
                tone: HeroUiInputAffixTone.mute,
                child: HeroUiSpinner(size: HeroUiSpinnerSize.sm),
              ),
            ),
          ),
        ],
      ),
    ],
  ),
);

// ─── InputOTP ─────────────────────────────────────────────────────────────────
Widget buildInputOtpDemo(BuildContext context) => SingleChildScrollView(
  padding: const EdgeInsets.all(16),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const ComponentDemoTitle('InputOTP'),
      const SizedBox(height: 16),
      const ComponentDemoSubtitle('Default'),
      const HeroUiInputOtp(
        label: 'Verify account',
        helperText: 'Didn’t receive a code?',
        linkText: 'Resend',
      ),
      const SizedBox(height: 16),
      const ComponentDemoSubtitle('With description + separator'),
      const HeroUiInputOtp(
        label: 'Verify account',
        description: 'We’ve sent a code to a****@gmail.com',
        helperText: 'Didn’t receive a code?',
        linkText: 'Resend',
        showSeparator: true,
      ),
      const SizedBox(height: 16),
      const ComponentDemoSubtitle('Error'),
      const HeroUiInputOtp(
        label: 'Verify account',
        description: 'We’ve sent a code to a****@gmail.com',
        showSeparator: true,
        errorText: 'Invalid code, please try again',
      ),
    ],
  ),
);

// ─── TextField ────────────────────────────────────────────────────────────────
Widget buildTextFieldDemo(BuildContext context) => SingleChildScrollView(
  padding: const EdgeInsets.all(16),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const ComponentDemoTitle('TextField'),
      const SizedBox(height: 16),
      const ComponentDemoSubtitle('With label and description'),
      const HeroUiTextField(
        label: 'Email',
        requiredField: true,
        placeholder: 'you@example.com',
        description: 'We will never share your email.',
      ),
      const SizedBox(height: 12),
      const ComponentDemoSubtitle('Error state'),
      const HeroUiTextField(
        label: 'Username',
        placeholder: 'Enter username',
        errorText: 'This username is already taken.',
      ),
      const SizedBox(height: 12),
      const ComponentDemoSubtitle('Secondary variant'),
      const HeroUiTextField(
        label: 'Bio',
        placeholder: 'Tell us about yourself',
        variant: HeroUiInputVariant.secondary,
        description: 'Max 160 characters.',
      ),
    ],
  ),
);

// ─── TextArea ─────────────────────────────────────────────────────────────────
Widget buildTextAreaDemo(BuildContext context) => SingleChildScrollView(
  padding: const EdgeInsets.all(16),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const ComponentDemoTitle('TextArea'),
      const SizedBox(height: 16),
      const ComponentDemoSubtitle('Default'),
      const HeroUiTextArea(
        label: 'Description',
        placeholder: 'Write here...',
        description: 'Characters: 0/80',
      ),
      const SizedBox(height: 12),
      const ComponentDemoSubtitle('Error state'),
      const HeroUiTextArea(
        label: 'Notes',
        placeholder: 'Enter your notes',
        errorText: 'Characters: 82/80',
      ),
      const SizedBox(height: 12),
      const ComponentDemoSubtitle('Secondary variant'),
      const HeroUiTextArea(
        placeholder: 'Tell us about your project',
        variant: HeroUiInputVariant.secondary,
        description: 'Minimum 40 characters.',
      ),
    ],
  ),
);

// ─── NumberField ──────────────────────────────────────────────────────────────
Widget buildNumberFieldDemo(BuildContext context) => SingleChildScrollView(
  padding: const EdgeInsets.all(16),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const ComponentDemoTitle('NumberField'),
      const SizedBox(height: 16),
      const ComponentDemoSubtitle('With label'),
      const HeroUiNumberField(
        label: 'Quantity',
        initialValue: 3,
        min: 0,
        max: 10,
        description: 'Min: 0  Max: 10',
      ),
      const SizedBox(height: 12),
      const ComponentDemoSubtitle('Secondary variant'),
      const HeroUiNumberField(
        initialValue: 5,
        min: 1,
        variant: HeroUiInputVariant.secondary,
      ),
    ],
  ),
);

// ─── SearchField ──────────────────────────────────────────────────────────────
Widget buildSearchFieldDemo(BuildContext context) => SingleChildScrollView(
  padding: const EdgeInsets.all(16),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const ComponentDemoTitle('SearchField'),
      const SizedBox(height: 16),
      const ComponentDemoSubtitle('With label and description'),
      const HeroUiSearchField(
        label: 'Vehicle',
        placeholder: 'Search...',
        description: 'More than 20 brands',
      ),
      const SizedBox(height: 12),
      const ComponentDemoSubtitle('Secondary variant'),
      const HeroUiSearchField(
        placeholder: 'Search anything...',
        variant: HeroUiInputVariant.secondary,
      ),
    ],
  ),
);

// ─── Simple Form Demo ─────────────────────────────────────────────────────────
class _SimpleFormDemo extends StatefulWidget {
  const _SimpleFormDemo();

  @override
  State<_SimpleFormDemo> createState() => _SimpleFormDemoState();
}

class _SimpleFormDemoState extends State<_SimpleFormDemo> {
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  String? _emailError;

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() {
      _emailError = _emailController.text.contains('@')
          ? null
          : 'Please enter a valid email';
    });
    if (_emailError == null) {
      showComponentDemoMessage(context, 'Form submitted successfully');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: HeroUiForm(
        child: HeroUiFieldset(
          legend: 'Profile',
          description: 'Basic form composition using HeroUI primitives.',
          children: [
            HeroUiTextField(
              label: 'Full name',
              requiredField: true,
              controller: _nameController,
              placeholder: 'Jane Doe',
            ),
            HeroUiTextField(
              label: 'Email',
              requiredField: true,
              controller: _emailController,
              placeholder: 'you@example.com',
              errorText: _emailError,
            ),
            HeroUiButton(label: 'Submit', onPressed: _submit),
          ],
        ),
      ),
    );
  }
}
