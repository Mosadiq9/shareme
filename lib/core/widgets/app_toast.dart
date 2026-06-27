/// ShareMe — Toast/Snackbar component.
///
/// Bottom-anchored toast with [surfaceRaised] background.
/// Error variant has [accentError] left-border accent strip
/// (Frontend Guidelines §6).
library;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Shows a styled toast message at the bottom of the screen.
///
/// Usage:
/// ```dart
/// AppToast.show(context, message: 'File sent successfully');
/// AppToast.showError(context, message: 'Connection lost. Retry to resume.');
/// ```
abstract final class AppToast {
  /// Show a standard informational toast.
  static void show(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showSnackBar(context, message: message, duration: duration);
  }

  /// Show an error toast with red left-border accent strip.
  static void showError(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 4),
  }) {
    _showSnackBar(
      context,
      message: message,
      duration: duration,
      isError: true,
    );
  }

  /// Show a success toast with teal accent.
  static void showSuccess(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showSnackBar(
      context,
      message: message,
      duration: duration,
      isSuccess: true,
    );
  }

  static void _showSnackBar(
    BuildContext context, {
    required String message,
    required Duration duration,
    bool isError = false,
    bool isSuccess = false,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: isError
                    ? AppColors.accentError
                    : isSuccess
                        ? AppColors.accentSignal
                        : Colors.transparent,
                width: isError || isSuccess ? 3 : 0,
              ),
            ),
          ),
          padding: const EdgeInsets.only(left: AppSpacing.xs),
          child: Text(message, style: AppTypography.bodySmall),
        ),
        backgroundColor: AppColors.surfaceRaised,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        ),
        duration: duration,
        margin: const EdgeInsets.all(AppSpacing.md),
      ),
    );
  }
}
