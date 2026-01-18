import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../providers/settings_provider.dart';
import '../providers/fitness_provider.dart';

/// Settings screen for app configuration
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _userNameController;

  @override
  void initState() {
    super.initState();
    final settingsProvider = context.read<SettingsProvider>();
    _userNameController = TextEditingController(text: settingsProvider.userName);
  }

  @override
  void dispose() {
    _userNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settingsProvider = context.watch<SettingsProvider>();

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.settings),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            // User Name
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.userName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  CupertinoTextField(
                    controller: _userNameController,
                    placeholder: l10n.enterUserName,
                    padding: const EdgeInsets.all(12),
                    onChanged: (value) {
                      settingsProvider.setUserName(value);
                    },
                  ),
                ],
              ),
            ),

            const Divider(),

            // Notifications
            _buildSettingsSection(
              context,
              l10n.notifications,
              [
                _buildSwitchTile(
                  context,
                  l10n.enableNotifications,
                  settingsProvider.notificationsEnabled,
                  (value) {
                    settingsProvider.setNotificationsEnabled(value);
                  },
                ),
              ],
            ),

            const Divider(),

            // Language
            _buildSettingsSection(
              context,
              l10n.language,
              [
                _buildPickerTile(
                  context,
                  l10n.language,
                  _getLanguageName(settingsProvider.language, l10n),
                  () => _showLanguagePicker(context, settingsProvider, l10n),
                ),
              ],
            ),

            const Divider(),

            // Notification Sound
            _buildSettingsSection(
              context,
              l10n.notificationSound,
              [
                _buildPickerTile(
                  context,
                  l10n.notificationSound,
                  settingsProvider.notificationSound,
                  () => _showSoundPicker(context, settingsProvider, l10n),
                ),
              ],
            ),

            const Divider(),

            // Vibration
            _buildSettingsSection(
              context,
              l10n.vibration,
              [
                _buildSwitchTile(
                  context,
                  l10n.enableVibration,
                  settingsProvider.vibrationEnabled,
                  (value) {
                    settingsProvider.setVibrationEnabled(value);
                  },
                ),
              ],
            ),

            const Divider(),

            // Theme Mode
            _buildSettingsSection(
              context,
              l10n.themeMode,
              [
                _buildPickerTile(
                  context,
                  l10n.themeMode,
                  _getThemeModeName(settingsProvider.themeMode, l10n),
                  () => _showThemeModePicker(context, settingsProvider, l10n),
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context, String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
    BuildContext context,
    String title,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return CupertinoListTile(
      title: Text(title),
      trailing: CupertinoSwitch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildPickerTile(
    BuildContext context,
    String title,
    String value,
    VoidCallback onTap,
  ) {
    return CupertinoListTile(
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(color: CupertinoColors.secondaryLabel),
          ),
          const SizedBox(width: 8),
          const Icon(CupertinoIcons.chevron_right, size: 16),
        ],
      ),
      onTap: onTap,
    );
  }

  void _showLanguagePicker(BuildContext context, SettingsProvider provider, AppLocalizations l10n) {
    final languages = [
      {'code': 'en', 'name': 'English'},
      {'code': 'ar', 'name': 'العربية'},
      {'code': 'tr', 'name': 'Türkçe'},
    ];

    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text(l10n.language),
        actions: languages
            .map(
              (lang) => CupertinoActionSheetAction(
                child: Text(lang['name']!),
                onPressed: () {
                  provider.setLanguage(lang['code']!);
                  Navigator.pop(context);
                  // Reload the app to apply language change
                  Navigator.of(context).pushAndRemoveUntil(
                    CupertinoPageRoute(builder: (_) => const SettingsScreen()),
                    (route) => false,
                  );
                },
                isDefaultAction: provider.language == lang['code'],
              ),
            )
            .toList(),
        cancelButton: CupertinoActionSheetAction(
          isDestructiveAction: true,
          child: Text(l10n.cancel),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  void _showSoundPicker(BuildContext context, SettingsProvider provider, AppLocalizations l10n) {
    final sounds = ['default', 'chime', 'bell', 'ding'];

    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text(l10n.notificationSound),
        actions: sounds
            .map(
              (sound) => CupertinoActionSheetAction(
                child: Text(sound),
                onPressed: () {
                  provider.setNotificationSound(sound);
                  Navigator.pop(context);
                },
                isDefaultAction: provider.notificationSound == sound,
              ),
            )
            .toList(),
        cancelButton: CupertinoActionSheetAction(
          isDestructiveAction: true,
          child: Text(l10n.cancel),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  void _showThemeModePicker(BuildContext context, SettingsProvider provider, AppLocalizations l10n) {
    final themes = [
      {'code': 'light', 'name': l10n.light},
      {'code': 'dark', 'name': l10n.dark},
      {'code': 'system', 'name': l10n.system},
    ];

    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text(l10n.themeMode),
        actions: themes
            .map(
              (theme) => CupertinoActionSheetAction(
                child: Text(theme['name']!),
                onPressed: () {
                  provider.setThemeMode(theme['code']!);
                  Navigator.pop(context);
                },
                isDefaultAction: provider.themeMode == theme['code'],
              ),
            )
            .toList(),
        cancelButton: CupertinoActionSheetAction(
          isDestructiveAction: true,
          child: Text(l10n.cancel),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  String _getLanguageName(String code, AppLocalizations l10n) {
    switch (code) {
      case 'ar':
        return 'العربية';
      case 'tr':
        return 'Türkçe';
      default:
        return 'English';
    }
  }

  String _getThemeModeName(String code, AppLocalizations l10n) {
    switch (code) {
      case 'light':
        return l10n.light;
      case 'dark':
        return l10n.dark;
      default:
        return l10n.system;
    }
  }
}
