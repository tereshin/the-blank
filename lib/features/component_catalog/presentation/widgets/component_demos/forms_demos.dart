import 'package:flutter/material.dart';

import 'package:heroui_design_system/design_system.dart';
import 'shared_demo_widgets.dart';

const String _kInputAffixGlobeIcon = 'globe';
const String _kInputAffixCopyIcon = 'copy';
const String _kInputAffixHandsetIcon = 'handset';
const String _kInputAffixEnvelopeIcon = 'envelope';
const String _kInputAffixEyeSlashIcon = 'eye-slash';
const String _kIconLock = 'lock';
const String _kIconKey = 'key';
const Color _kDemoIconColor = Color(0xFF71717A);
const Color _kDemoOutlineBorder = Color(0xFFDEDEE0);
const Color _kDemoOnPrimaryColor = Color(0xFFFFFFFF);

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
        prefix: HeroUiIcon(HeroUiIconManifest.magnifier, size: 16),
      ),
      const SizedBox(height: 12),
      const ComponentDemoSubtitle('With suffix icon'),
      const HeroUiInput(
        placeholder: 'Password',
        type: HeroUiInputType.password,
        suffix: HeroUiIcon(_kInputAffixEyeSlashIcon, size: 16),
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
  final _authEmail = TextEditingController();
  final _authPassword = TextEditingController();
  final _regName = TextEditingController();
  final _regEmail = TextEditingController();
  final _regPassword = TextEditingController();
  final _newsletterEmail = TextEditingController();
  final _bookingNotes = TextEditingController();

  bool _rememberMe = false;
  bool _termsAccepted = false;
  bool _newsletterWeekly = true;
  bool _newsletterProduct = false;
  String? _partySize;

  Color _iconColor() => _kDemoIconColor;

  @override
  void dispose() {
    _authEmail.dispose();
    _authPassword.dispose();
    _regName.dispose();
    _regEmail.dispose();
    _regPassword.dispose();
    _newsletterEmail.dispose();
    _bookingNotes.dispose();
    super.dispose();
  }

  Widget _passwordBlock(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    String placeholder = '••••••••',
    HeroUiInputVariant variant = HeroUiInputVariant.primary,
  }) {
    final c = _iconColor();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeroUiLabel(label, requiredField: true),
        const SizedBox(height: 4),
        HeroUiInput(
          controller: controller,
          type: HeroUiInputType.password,
          variant: variant,
          placeholder: placeholder,
          prefix: HeroUiIcon(_kIconLock, size: 16, color: c),
          suffix: HeroUiIcon(_kInputAffixEyeSlashIcon, size: 16, color: c),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final icon = _iconColor();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ComponentDemoTitle('Form compositions'),
          const SizedBox(height: 8),
          HeroUiDescription(
            'Примеры экранов из компонентов дизайн-системы и HeroUiIcon.',
          ),
          const SizedBox(height: 24),

          // ── Авторизация ─────────────────────────────────────────────
          const ComponentDemoSubtitle('Авторизация'),
          HeroUiCard(
            borderRadius: 20,

            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                HeroUiTextField(
                  label: 'Email',
                  requiredField: true,
                  controller: _authEmail,
                  placeholder: 'you@example.com',
                  variant: HeroUiInputVariant.secondary,
                  prefix: HeroUiIcon(
                    _kInputAffixEnvelopeIcon,
                    size: 16,
                    color: icon,
                  ),
                ),
                const SizedBox(height: 12),
                _passwordBlock(
                  context,
                  controller: _authPassword,
                  label: 'Пароль',
                  variant: HeroUiInputVariant.secondary,
                ),
                const SizedBox(height: 12),
                HeroUiCheckbox(
                  label: 'Запомнить меня на этом устройстве',
                  value: _rememberMe,
                  onChanged: (v) => setState(() => _rememberMe = v),
                  variant: HeroUiCheckboxVariant.secondary,
                ),
                const SizedBox(height: 16),
                HeroUiButton(
                  label: 'Войти',
                  size: HeroUiButtonSize.lg,
                  expand: true,

                  onPressed: () => showComponentDemoMessage(
                    context,
                    'Вход: ${_authEmail.text.isEmpty ? '…' : _authEmail.text}',
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: HeroUiLink(
                    label: 'Забыли пароль?',
                    leading: HeroUiIcon(_kIconKey, size: 16),
                    onTap: () => showComponentDemoMessage(
                      context,
                      'Восстановление пароля (демо)',
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: HeroUiLink(
                    label: 'Создать аккаунт',
                    leading: HeroUiIcon(HeroUiIconManifest.plus, size: 16),
                    onTap: () =>
                        showComponentDemoMessage(context, 'Регистрация'),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // ── Регистрация ────────────────────────────────────────────
          const ComponentDemoSubtitle('Регистрация'),
          HeroUiSurface(
            variant: HeroUiSurfaceVariant.secondary,
            borderRadius: 16,
            showShadow: false,
            child: HeroUiFieldset(
              legend: 'Новый аккаунт',
              description:
                  'Мы отправим письмо с подтверждением на указанный адрес.',
              children: [
                HeroUiTextField(
                  label: 'Имя и фамилия',
                  requiredField: true,
                  controller: _regName,
                  placeholder: 'Алексей Иванов',
                  prefix: HeroUiIcon(
                    HeroUiIconManifest.person,
                    size: 16,
                    color: icon,
                  ),
                ),
                HeroUiTextField(
                  label: 'Email',
                  requiredField: true,
                  controller: _regEmail,
                  placeholder: 'name@company.com',
                  description: 'Рабочая почта предпочтительнее.',
                  prefix: HeroUiIcon(
                    _kInputAffixEnvelopeIcon,
                    size: 16,
                    color: icon,
                  ),
                ),
                _passwordBlock(
                  context,
                  controller: _regPassword,
                  label: 'Пароль',
                  placeholder: 'Не менее 8 символов',
                ),
                HeroUiCheckbox(
                  label:
                      'Я принимаю условия использования и политику конфиденциальности',
                  value: _termsAccepted,
                  onChanged: (v) => setState(() => _termsAccepted = v),
                ),
                Row(
                  children: [
                    Expanded(
                      child: HeroUiButton(
                        label: 'Зарегистрироваться',
                        variant: HeroUiButtonVariant.primary,
                        expand: true,
                        onPressed: _termsAccepted
                            ? () => showComponentDemoMessage(
                                context,
                                'Регистрация отправлена',
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    HeroUiButton(
                      label: 'Отмена',
                      variant: HeroUiButtonVariant.ghost,
                      onPressed: () =>
                          showComponentDemoMessage(context, 'Отмена'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // ── Рассылка ───────────────────────────────────────────────
          const ComponentDemoSubtitle('Подписаться на рассылку'),
          HeroUiCard(
            borderRadius: 16,
            showShadow: false,
            borderColor: _kDemoOutlineBorder,
            header: HeroUiCardHeader(
              tagline: 'Рассылка',
              title: 'Будьте в курсе',
              description: 'Советы, релизы и подборки — без спама.',
              trailing: HeroUiIcon(
                HeroUiIconManifest.bell,
                size: 26,
                color: icon,
              ),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                HeroUiTextField(
                  label: 'Email для подписки',
                  controller: _newsletterEmail,
                  placeholder: 'hello@example.com',
                  variant: HeroUiInputVariant.secondary,
                  prefix: HeroUiIcon(
                    HeroUiIconManifest.envelopeOpenXmark,
                    size: 16,
                    color: icon,
                  ),
                ),
                const SizedBox(height: 12),
                HeroUiCheckbox(
                  label: 'Еженедельный дайджест',
                  description: 'Лучшие материалы за неделю одним письмом.',
                  value: _newsletterWeekly,
                  onChanged: (v) => setState(() => _newsletterWeekly = v),
                ),
                HeroUiCheckbox(
                  variant: HeroUiCheckboxVariant.secondary,
                  label: 'Продуктовые обновления',
                  description: 'Новые функции и изменения в сервисе.',
                  value: _newsletterProduct,
                  onChanged: (v) => setState(() => _newsletterProduct = v),
                ),
                const SizedBox(height: 8),
                HeroUiButton(
                  label: 'Подписаться',
                  variant: HeroUiButtonVariant.secondary,
                  expand: true,
                  leading: HeroUiIcon(_kInputAffixEnvelopeIcon, size: 16),
                  onPressed: () => showComponentDemoMessage(
                    context,
                    'Подписка: дайджест ${_newsletterWeekly ? "да" : "нет"}, продукт ${_newsletterProduct ? "да" : "нет"}',
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // ── Бронирование ───────────────────────────────────────────
          const ComponentDemoSubtitle('Бронирование'),
          HeroUiCard(
            borderRadius: 24,
            header: HeroUiCardHeader(
              title: 'Забронировать визит',
              trailing: HeroUiIcon(
                HeroUiIconManifest.calendar,
                size: 26,
                color: icon,
              ),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: HeroUiDateField(
                        label: 'Дата',
                        description: 'Ближайшие 30 дней',
                        placeholder: 'Выберите день',
                        variant: HeroUiInputVariant.secondary,
                        minDate: DateTime.now(),
                        maxDate: DateTime.now().add(const Duration(days: 30)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: HeroUiTimeField(
                        label: 'Время',
                        description: 'Bottom sheet, интервал 30 мин',
                        placeholder: 'ЧЧ:ММ',
                        variant: HeroUiInputVariant.secondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                HeroUiSelect<String>(
                  label: 'Гостей',
                  requiredField: true,
                  placeholder: 'Сколько человек',
                  value: _partySize,
                  variant: HeroUiInputVariant.secondary,
                  onChanged: (v) => setState(() => _partySize = v),
                  items: const [
                    HeroUiPickerItem(value: '1', label: '1 гость'),
                    HeroUiPickerItem(value: '2', label: '2 гостя'),
                    HeroUiPickerItem(value: '3', label: '3 гостя'),
                    HeroUiPickerItem(value: '4', label: '4 гостя'),
                    HeroUiPickerItem(value: '5', label: '5+ гостей'),
                  ],
                ),
                const SizedBox(height: 12),
                HeroUiTextArea(
                  label: 'Пожелания',
                  controller: _bookingNotes,
                  placeholder: 'Детское кресло, аллергии, повод…',
                  description: 'Необязательно, до 200 символов.',
                  minLines: 3,
                  maxLines: 5,
                  variant: HeroUiInputVariant.secondary,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: HeroUiButton(
                        label: 'Отправить заявку',
                        expand: true,
                        leading: HeroUiIcon(
                          HeroUiIconManifest.calendar,
                          size: 16,
                          color: _kDemoOnPrimaryColor,
                        ),
                        onPressed: _partySize == null
                            ? null
                            : () => showComponentDemoMessage(
                                context,
                                'Бронирование: $_partySize гостей',
                              ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    HeroUiButton(
                      label: '',
                      iconOnly: true,
                      variant: HeroUiButtonVariant.outline,
                      leading: HeroUiIcon(HeroUiIconManifest.gear, size: 18),
                      onPressed: () => showComponentDemoMessage(
                        context,
                        'Настройки бронирования',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
