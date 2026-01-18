import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../services/settings_service.dart';

/// Provider for managing app settings state
class SettingsProvider with ChangeNotifier {
  final SettingsService _settings = SettingsService.instance;

  bool _notificationsEnabled = true;
  String _language = 'en';
  String _notificationSound = 'default';
  bool _vibrationEnabled = true;
  String _themeMode = 'system';
  String _userName = '';

  bool get notificationsEnabled => _notificationsEnabled;
  String get language => _language;
  String get notificationSound => _notificationSound;
  bool get vibrationEnabled => _vibrationEnabled;
  String get themeMode => _themeMode;
  String get userName => _userName;

  /// Load settings from storage
  Future<void> loadSettings() async {
    _notificationsEnabled = _settings.getNotificationsEnabled();
    _language = _settings.getLanguage();
    _notificationSound = _settings.getNotificationSound();
    _vibrationEnabled = _settings.getVibrationEnabled();
    _themeMode = _settings.getThemeMode();
    _userName = _settings.getUserName();
    notifyListeners();
  }

  /// Set notifications enabled
  Future<void> setNotificationsEnabled(bool enabled) async {
    _notificationsEnabled = enabled;
    await _settings.setNotificationsEnabled(enabled);
    notifyListeners();
  }

  /// Set language
  Future<void> setLanguage(String languageCode) async {
    _language = languageCode;
    await _settings.setLanguage(languageCode);
    notifyListeners();
  }

  /// Set notification sound
  Future<void> setNotificationSound(String sound) async {
    _notificationSound = sound;
    await _settings.setNotificationSound(sound);
    notifyListeners();
  }

  /// Set vibration enabled
  Future<void> setVibrationEnabled(bool enabled) async {
    _vibrationEnabled = enabled;
    await _settings.setVibrationEnabled(enabled);
    notifyListeners();
  }

  /// Set theme mode
  Future<void> setThemeMode(String mode) async {
    _themeMode = mode;
    await _settings.setThemeMode(mode);
    notifyListeners();
  }

  /// Set user name
  Future<void> setUserName(String name) async {
    _userName = name;
    await _settings.setUserName(name);
    notifyListeners();
  }

  /// Get theme mode as Brightness
  ThemeMode getThemeModeEnum() {
    switch (_themeMode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  /// Get Locale from language code
  Locale getLocale() {
    switch (_language) {
      case 'ar':
        return const Locale('ar');
      case 'tr':
        return const Locale('tr');
      default:
        return const Locale('en');
    }
  }
}
