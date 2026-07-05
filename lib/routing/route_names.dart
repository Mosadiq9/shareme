/// ShareMe — Route names and path constants.
///
/// Every route in the app is defined here — no magic strings in navigation calls.
library;

/// Named route constants for GoRouter navigation.
abstract final class RouteNames {
  static const String splash = 'splash';
  static const String permissions = 'permissions';
  static const String home = 'home';
  static const String filePicker = 'filePicker';
  static const String radar = 'radar';
  static const String connecting = 'connecting';
  static const String transferProgress = 'transferProgress';
  static const String transferComplete = 'transferComplete';
  static const String transferFailed = 'transferFailed';
  static const String settings = 'settings';
  static const String debugLogs = 'debugLogs';
}

/// Route path constants.
abstract final class RoutePaths {
  static const String splash = '/';
  static const String permissions = '/permissions';
  static const String home = '/home';
  static const String filePicker = '/file-picker';
  static const String radar = '/radar';
  static const String connecting = '/connecting';
  static const String transferProgress = '/transfer-progress';
  static const String transferComplete = '/transfer-complete';
  static const String transferFailed = '/transfer-failed';
  static const String settings = '/settings';
  static const String debugLogs = '/debug-logs';
}
