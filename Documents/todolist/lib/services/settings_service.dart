import 'package:shared_preferences/shared_preferences.dart';

/// Settings service for managing app settings
/// Uses SharedPreferences for local storage
class SettingsService {
  static final SettingsService instance = SettingsService._init();
  SharedPreferences? _prefs;

  SettingsService._init();

  /// Initialize SharedPreferences
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ==================== NOTIFICATION SETTINGS ====================

  /// Get notifications enabled state
  bool getNotificationsEnabled() {
    return _prefs?.getBool('notifications_enabled') ?? true;
  }

  /// Set notifications enabled state
  Future<void> setNotificationsEnabled(bool enabled) async {
    await _prefs?.setBool('notifications_enabled', enabled);
  }

  // ==================== LANGUAGE SETTINGS ====================

  /// Get current language code
  String getLanguage() {
    return _prefs?.getString('language') ?? 'en';
  }

  /// Set language code ('en', 'ar', 'tr')
  Future<void> setLanguage(String languageCode) async {
    await _prefs?.setString('language', languageCode);
  }

  // ==================== NOTIFICATION SOUND ====================

  /// Get notification sound name
  String getNotificationSound() {
    return _prefs?.getString('notification_sound') ?? 'default';
  }

  /// Set notification sound name
  Future<void> setNotificationSound(String sound) async {
    await _prefs?.setString('notification_sound', sound);
  }

  // ==================== VIBRATION SETTINGS ====================

  /// Get vibration enabled state
  bool getVibrationEnabled() {
    return _prefs?.getBool('vibration_enabled') ?? true;
  }

  /// Set vibration enabled state
  Future<void> setVibrationEnabled(bool enabled) async {
    await _prefs?.setBool('vibration_enabled', enabled);
  }

  // ==================== THEME SETTINGS ====================

  /// Get theme mode ('light', 'dark', 'system')
  String getThemeMode() {
    return _prefs?.getString('theme_mode') ?? 'system';
  }

  /// Set theme mode
  Future<void> setThemeMode(String mode) async {
    await _prefs?.setString('theme_mode', mode);
  }

  // ==================== USER NAME ====================

  /// Get user name
  String getUserName() {
    return _prefs?.getString('user_name') ?? '';
  }

  /// Set user name
  Future<void> setUserName(String name) async {
    await _prefs?.setString('user_name', name);
  }
}
