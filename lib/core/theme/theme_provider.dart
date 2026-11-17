import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notifier that manages the active [ThemeMode] (system, light, dark).
class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    return ThemeMode.system;
  }

  /// Sets the application theme mode.
  void setThemeMode(ThemeMode mode) {
    state = mode;
  }

  /// Toggles between light and dark mode.
  void toggleTheme() {
    state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  }
}

/// Riverpod provider exposing the [ThemeMode] and its notifier.
final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);
