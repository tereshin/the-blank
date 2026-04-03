import 'package:flutter/material.dart';

import '../../../../../core/icons/heroui_icon.dart';
import '../../../../../design_system/design_system.dart';
import 'shared_demo_widgets.dart';

Widget buildTooltipDemo(BuildContext context) => _TooltipDemoPage();

Widget buildPopoverDemo(BuildContext context) => _PopoverDemoPage();

Widget buildModalDemo(BuildContext context) => _ModalDemoPage();

Widget buildAlertDialogDemo(BuildContext context) => _AlertDialogDemoPage();

Widget buildDropdownDemo(BuildContext context) => _DropdownDemoPage();

Widget buildDrawerDemo(BuildContext context) => _DrawerDemoPage();

// ─── Shared buttons ───────────────────────────────────────────────────────────

Widget _demoButton(String label, {VoidCallback? onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF18181B),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFFFFFFFF),
        ),
      ),
    ),
  );
}

Widget _outlineButton(String label, {VoidCallback? onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFDEDEE0)),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF18181B),
        ),
      ),
    ),
  );
}

Widget _dropdownTriggerButton(String label, {VoidCallback? onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFEBEBEC),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          height: 1.43,
          color: Color(0xFF0485F7),
        ),
      ),
    ),
  );
}

Widget _dropdownItemIcon(String name, {Color? color}) {
  return HeroUiIcon(name, size: 16, color: color);
}

Widget _dropdownShortcut(List<String> keys) {
  return HeroUiKbd(keys: keys, variant: HeroUiKbdVariant.light);
}

// ─── Tooltip demo ─────────────────────────────────────────────────────────────

class _TooltipDemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ComponentDemoTitle('Tooltip — positions'),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE4E4E7)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Wrap(
              spacing: 16,
              runSpacing: 24,
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                for (final pos in HeroUiTooltipPosition.values)
                  HeroUiTooltip(
                    message: '${pos.name} tooltip',
                    position: pos,
                    child: _outlineButton(pos.name),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const ComponentDemoTitle('Tooltip — inverse (dark)'),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE4E4E7)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Wrap(
              spacing: 16,
              runSpacing: 24,
              alignment: WrapAlignment.center,
              children: [
                for (final pos in HeroUiTooltipPosition.values)
                  HeroUiTooltip(
                    message: '${pos.name} tooltip',
                    position: pos,
                    inverse: true,
                    child: _outlineButton('${pos.name} inverse'),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─── Popover demo ─────────────────────────────────────────────────────────────

class _PopoverDemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ComponentDemoTitle('Popover — basic'),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE4E4E7)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HeroUiPopover(
                  trigger: _demoButton('Click me'),
                  content: Text(
                    'This is the popover content. You can put any content here.',
                    style: TextStyle(fontSize: 12, height: 1.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const ComponentDemoTitle('Popover — above trigger'),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE4E4E7)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HeroUiPopover(
                  trigger: _demoButton('Open above'),
                  preferBelow: false,
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Popover title',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'This popover appears above the trigger button.',
                        style: TextStyle(fontSize: 13, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─── Modal demo ───────────────────────────────────────────────────────────────

class _ModalDemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bodyText = const Text(
      'This is the modal body. You can put any content here, '
      'including forms, images, or other components.',
      style: TextStyle(fontSize: 14, color: Color(0xFF71717A), height: 1.5),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ComponentDemoTitle('Modal — sizes'),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE4E4E7)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final size in HeroUiModalSize.values)
                  _demoButton(
                    'Open ${size.name}',
                    onTap: () => HeroUiModal.show(
                      context: context,
                      title: '${size.name.toUpperCase()} Modal',
                      body: bodyText,
                      actions: [
                        _outlineButton(
                          'Cancel',
                          onTap: () => Navigator.of(context).pop(),
                        ),
                        _demoButton(
                          'Confirm',
                          onTap: () => Navigator.of(context).pop(),
                        ),
                      ],
                      size: size,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const ComponentDemoTitle('Modal — with form body'),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE4E4E7)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: _demoButton(
              'Open with form',
              onTap: () => HeroUiModal.show(
                context: context,
                title: 'Edit Profile',
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        isDense: true,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        isDense: true,
                      ),
                    ),
                  ],
                ),
                actions: [
                  _outlineButton(
                    'Cancel',
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  _demoButton('Save', onTap: () => Navigator.of(context).pop()),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─── AlertDialog demo ─────────────────────────────────────────────────────────

class _AlertDialogDemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ComponentDemoTitle('AlertDialog — confirmation'),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE4E4E7)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: _demoButton(
              'Open confirmation',
              onTap: () => HeroUiAlertDialog.show(
                context: context,
                title: 'Confirm action',
                description:
                    'Are you sure you want to proceed? This action cannot be undone.',
                confirmLabel: 'Confirm',
                cancelLabel: 'Cancel',
              ),
            ),
          ),
          const SizedBox(height: 20),

          const ComponentDemoTitle('AlertDialog — danger'),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE4E4E7)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: _demoButton(
              'Delete account',
              onTap: () => HeroUiAlertDialog.show(
                context: context,
                title: 'Delete Account',
                description:
                    'This will permanently delete your account and all associated data. This action cannot be undone.',
                confirmLabel: 'Delete',
                cancelLabel: 'Cancel',
                isDanger: true,
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─── Dropdown demo ────────────────────────────────────────────────────────────

class _DropdownDemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ComponentDemoTitle('Dropdown — grouped actions'),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE4E4E7)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: HeroUiDropdown(
              trigger: _dropdownTriggerButton('Actions'),
              sections: [
                HeroUiDropdownSection(
                  title: 'Actions',
                  items: [
                    HeroUiDropdownItem(
                      label: 'New file',
                      description: 'Create a new file',
                      leading: _dropdownItemIcon(
                        HeroUiIconManifest.plusRegular,
                      ),
                      trailing: _dropdownShortcut(const ['⌘', 'N']),
                    ),
                    HeroUiDropdownItem(
                      label: 'Copy link',
                      description: 'Copy the file link',
                      leading: _dropdownItemIcon(
                        'heroui-v3-icon__link__regular',
                      ),
                      trailing: _dropdownShortcut(const ['⌘', 'L']),
                    ),
                    HeroUiDropdownItem(
                      label: 'Edit file',
                      description: 'Make changes',
                      leading: _dropdownItemIcon(
                        'heroui-v3-icon__pencil__regular',
                      ),
                      trailing: _dropdownShortcut(const ['⌘', 'E']),
                    ),
                  ],
                ),
                HeroUiDropdownSection(
                  title: 'Danger zone',
                  items: [
                    HeroUiDropdownItem(
                      label: 'Delete file',
                      description: 'Move to trash',
                      leading: _dropdownItemIcon(
                        HeroUiIconManifest.trashBinRegular,
                        color: const Color(0xFFFF383C),
                      ),
                      trailing: _dropdownShortcut(const ['⌘⇧', 'K']),
                      isDanger: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const ComponentDemoTitle('Dropdown — states'),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE4E4E7)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: HeroUiDropdown(
              trigger: _dropdownTriggerButton('Styles'),
              sections: [
                HeroUiDropdownSection(
                  title: 'Initial',
                  items: [
                    HeroUiDropdownItem(
                      label: 'Default',
                      description: 'state=default',
                      leading: _dropdownItemIcon(
                        'heroui-v3-icon__circle-dashed__regular',
                      ),
                      trailing: _dropdownShortcut(const ['⌘', 'D']),
                      state: HeroUiDropdownItemState.defaultState,
                    ),
                    HeroUiDropdownItem(
                      label: 'Hover',
                      description: 'state=hover',
                      leading: _dropdownItemIcon(
                        'heroui-v3-icon__circle-dashed__regular',
                      ),
                      trailing: _dropdownShortcut(const ['⌘', 'H']),
                      state: HeroUiDropdownItemState.hover,
                    ),
                    HeroUiDropdownItem(
                      label: 'Focus',
                      description: 'state=focus',
                      leading: _dropdownItemIcon(
                        'heroui-v3-icon__circle-dashed__regular',
                      ),
                      trailing: _dropdownShortcut(const ['⌘', 'F']),
                      state: HeroUiDropdownItemState.focus,
                    ),
                    HeroUiDropdownItem(
                      label: 'Pressed',
                      description: 'state=pressed',
                      leading: _dropdownItemIcon(
                        'heroui-v3-icon__circle-dashed__regular',
                      ),
                      trailing: _dropdownShortcut(const ['⌘', 'P']),
                      state: HeroUiDropdownItemState.pressed,
                    ),
                    HeroUiDropdownItem(
                      label: 'Selected',
                      description: 'state=selected',
                      trailing: _dropdownShortcut(const ['⌘', 'S']),
                      state: HeroUiDropdownItemState.selected,
                    ),
                    HeroUiDropdownItem(
                      label: 'Disabled',
                      description: 'state=disabled',
                      leading: _dropdownItemIcon(
                        'heroui-v3-icon__square-exclamation__regular',
                      ),
                      trailing: _dropdownShortcut(const ['⌘', 'X']),
                      state: HeroUiDropdownItemState.disabled,
                    ),
                  ],
                ),
                HeroUiDropdownSection(
                  title: 'Danger',
                  items: [
                    HeroUiDropdownItem(
                      label: 'Delete file',
                      description: 'type=danger',
                      leading: _dropdownItemIcon(
                        HeroUiIconManifest.trashBinRegular,
                      ),
                      trailing: _dropdownShortcut(const ['⌘⇧', 'K']),
                      isDanger: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const ComponentDemoTitle('Dropdown — no groups / no divider'),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE4E4E7)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: HeroUiDropdown(
              trigger: _dropdownTriggerButton('Share'),
              showGroups: false,
              showDividers: false,
              sections: [
                HeroUiDropdownSection(
                  showDivider: false,
                  items: [
                    HeroUiDropdownItem(
                      label: 'WhatsApp',
                      trailing: _dropdownItemIcon(
                        HeroUiIconManifest.chevronRightRegular,
                      ),
                    ),
                    HeroUiDropdownItem(
                      label: 'Slack',
                      trailing: _dropdownItemIcon(
                        HeroUiIconManifest.chevronRightRegular,
                      ),
                    ),
                    HeroUiDropdownItem(
                      label: 'Discord',
                      trailing: _dropdownItemIcon(
                        HeroUiIconManifest.chevronRightRegular,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─── Drawer demo ──────────────────────────────────────────────────────────────

class _DrawerDemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bodyContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: const [
        Text(
          'Drawer body content goes here. You can add forms, lists, or any other widgets.',
          style: TextStyle(fontSize: 14, color: Color(0xFF71717A), height: 1.5),
        ),
        SizedBox(height: 12),
        Text(
          'Item 1',
          style: TextStyle(fontSize: 14, color: Color(0xFF18181B)),
        ),
        SizedBox(height: 8),
        Text(
          'Item 2',
          style: TextStyle(fontSize: 14, color: Color(0xFF18181B)),
        ),
        SizedBox(height: 8),
        Text(
          'Item 3',
          style: TextStyle(fontSize: 14, color: Color(0xFF18181B)),
        ),
      ],
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ComponentDemoTitle('Drawer — positions'),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE4E4E7)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final pos in HeroUiDrawerPosition.values)
                  _demoButton(
                    pos.name,
                    onTap: () => HeroUiDrawer.show(
                      context: context,
                      position: pos,
                      title: '${pos.name.toUpperCase()} Drawer',
                      subtitle: 'Drawer content example',
                      body: bodyContent,
                      footerActions: [
                        _outlineButton(
                          'Cancel',
                          onTap: () => Navigator.of(context).pop(),
                        ),
                        _demoButton(
                          'Save',
                          onTap: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const ComponentDemoTitle('Drawer — no title'),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE4E4E7)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: _demoButton(
              'Open minimal',
              onTap: () =>
                  HeroUiDrawer.show(context: context, body: bodyContent),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
