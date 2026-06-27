/// ShareMe — Splash Screen.
///
/// App Flow §1, Screen #1: App launch, permission check.
/// Auto-advances to Home (if permissions granted) or Permission screen.
library;

import 'package:flutter/material.dart';
import 'package:shareme/core/theme/app_colors.dart';
import 'package:shareme/core/theme/app_typography.dart';

/// Splash screen shown on app launch.
///
/// Phase 1 placeholder — M1 will add permission checking logic
/// and auto-navigation.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'ShareMe',
              style: AppTypography.displayLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Close-Range High-Speed Transfer',
              style: AppTypography.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
