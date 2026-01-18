# Mariam

A lightweight, offline-first iOS mobile application built with Flutter. The app contains two modules: **Task Reminder** and **Personal Fitness Coach**.

## Features

### Module 1: Task Reminder (To-Do App)
- ✅ Create, edit, and delete tasks
- ✅ Mark tasks as completed
- ✅ Schedule local notifications based on task date & time
- ✅ Priority levels (Low, Medium, High) with color coding
- ✅ Separate views for pending and completed tasks
- ✅ All data stored locally with SQLite

### Module 2: Personal Fitness Coach
- 🏃 Running reminders every 16 hours
- 💧 Water drinking reminders every 16 hours
- 💪 Predefined home workout routines
- 📊 Three difficulty levels: Beginner, Intermediate, Advanced
- 🎯 Offline-only functionality

### Settings
- 🔔 Enable/Disable notifications
- 🌍 Multi-language support (English, Arabic, Turkish)
- 🔊 Notification sound selection
- 📳 Vibration on/off
- 🌓 Theme mode (Light, Dark, System)
- 👤 User name configuration

## Requirements

- Flutter SDK 3.0.0 or higher
- Xcode 14.0 or higher
- iOS 12.0 or higher
- macOS (for building iOS apps)

## Installation

### 1. Clone or download the project

```bash
cd /path/to/todolist
```

### 2. Initialize Flutter project (if iOS folder doesn't exist)

If the `ios` folder doesn't exist, you need to initialize the Flutter project:

```bash
flutter create .
```

This will generate the iOS (and Android) platform folders needed to build the app.

### 3. Install Flutter dependencies

```bash
flutter pub get
```

### 4. Generate localization files

```bash
flutter gen-l10n
```

This generates the localization code from the ARB files in `lib/l10n/`.

## Running on iPhone using Xcode

### Option 1: Using Xcode (Recommended for iOS development)

1. **Open the project in Xcode:**
   ```bash
   open ios/Runner.xcworkspace
   ```
   
   Or navigate to the `ios` folder in Xcode and open `Runner.xcworkspace`

2. **Select your iPhone:**
   - Connect your iPhone to your Mac via USB
   - Make sure your iPhone is unlocked and you've trusted the computer
   - In Xcode, select your iPhone from the device dropdown at the top

3. **Configure signing:**
   - Select the `Runner` target in the project navigator
   - Go to "Signing & Capabilities" tab
   - Select your Apple Developer Team (or use Personal Team for development)
   - Xcode will automatically manage provisioning profiles

4. **Update Bundle Identifier (if needed):**
   - In "Signing & Capabilities", change the Bundle Identifier to something unique (e.g., `com.yourname.wellnessapp`)
   - This ensures it doesn't conflict with other apps

5. **Build and Run:**
   - Click the "Play" button (▶️) in Xcode, or press `Cmd + R`
   - The app will build and install on your iPhone

### Option 2: Using Flutter CLI

1. **List available devices:**
   ```bash
   flutter devices
   ```
   Make sure your iPhone appears in the list.

2. **Run the app:**
   ```bash
   flutter run
   ```
   Flutter will automatically build and install the app on your connected iPhone.

## Project Structure

```
lib/
├── l10n/                    # Localization files (ARB)
├── models/                  # Data models
│   ├── task.dart
│   └── workout_routine.dart
├── providers/               # State management (Provider)
│   ├── task_provider.dart
│   ├── fitness_provider.dart
│   └── settings_provider.dart
├── screens/                 # UI screens
│   ├── home_screen.dart
│   ├── task_list_screen.dart
│   ├── task_edit_screen.dart
│   ├── fitness_coach_screen.dart
│   └── settings_screen.dart
├── services/                # Business logic services
│   ├── database_helper.dart
│   ├── notification_service.dart
│   └── settings_service.dart
└── main.dart               # App entry point
```

## Database Schema

### Tables

- **tasks**: Stores pending tasks
  - id, title, description, date, time, priority, status

- **completed_tasks**: Stores completed tasks separately
  - id, title, description, date, time, priority, completed_at

- **fitness_reminders**: Tracks fitness reminder state
  - id, reminder_type, last_reminder_time, enabled

## Dependencies

- `provider`: State management
- `sqflite`: SQLite database
- `shared_preferences`: Settings storage
- `flutter_local_notifications`: Local notifications
- `timezone`: Timezone support for notifications
- `flutter_localizations`: Multi-language support
- `intl`: Internationalization utilities

## Important Notes

⚠️ **This app is iOS-only and completely offline.**

- ❌ No backend or cloud services
- ❌ No external APIs
- ❌ No authentication
- ❌ No cloud sync
- ✅ All data stored locally on device
- ✅ Works without internet connection

## Permissions

The app requires the following permissions:

- **Notifications**: To send local reminders for tasks and fitness activities

These permissions are requested automatically when the app first runs.

## Troubleshooting

### Issue: "No device found"
- Make sure your iPhone is connected via USB
- Unlock your iPhone and trust the computer if prompted
- Check that Developer Mode is enabled on iOS 16+ (Settings > Privacy & Security > Developer Mode)

### Issue: "Signing certificate errors"
- In Xcode, go to Signing & Capabilities
- Select your Apple Developer account
- Or create a free Personal Team for development

### Issue: "App won't build"
- Make sure you've run `flutter pub get`
- Try `flutter clean` then `flutter pub get`
- Make sure Xcode is up to date

### Issue: "Notifications not working"
- Check that notifications are enabled in iPhone Settings > [App Name] > Notifications
- Make sure the app has notification permissions

## License

This project is provided as-is for educational and personal use.

## Support

For issues or questions, please check the Flutter documentation:
- [Flutter iOS Setup](https://docs.flutter.dev/get-started/install/macos#ios-setup)
- [Xcode Setup](https://docs.flutter.dev/get-started/install/macos#install-xcode)
