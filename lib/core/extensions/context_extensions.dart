/// ShareMe — BuildContext extension methods.
///
/// Shortcuts for commonly accessed theme properties to reduce boilerplate.
/// Usage: `context.colors` instead of `Theme.of(context).colorScheme`.
library;

import 'package:flutter/material.dart';

/// Convenience extensions on [BuildContext] for theme access.
extension ContextExtensions on BuildContext {
  /// Shortcut to [Theme.of(context)].
  ThemeData get theme => Theme.of(this);

  /// Shortcut to [Theme.of(context).colorScheme].
  ColorScheme get colors => theme.colorScheme;

  /// Shortcut to [Theme.of(context).textTheme].
  TextTheme get textTheme => theme.textTheme;

  /// Shortcut to [MediaQuery.sizeOf(context)].
  Size get screenSize => MediaQuery.sizeOf(this);

  /// Shortcut to [MediaQuery.sizeOf(context).width].
  double get screenWidth => screenSize.width;

  /// Shortcut to [MediaQuery.sizeOf(context).height].
  double get screenHeight => screenSize.height;

  /// Shortcut to [MediaQuery.paddingOf(context)] — safe area insets.
  EdgeInsets get safeArea => MediaQuery.paddingOf(this);

  /// Whether the OS-level "reduce motion" accessibility setting is enabled.
  /// Used to disable Pulse Ring animations (Frontend Guidelines §5).
  bool get reduceMotion => MediaQuery.disableAnimationsOf(this);

  /// Show a snackbar with the app's standard styling.
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
