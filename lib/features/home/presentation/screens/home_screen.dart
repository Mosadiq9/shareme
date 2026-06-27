/// ShareMe — Home Screen.
///
/// App Flow §1, Screen #3: Choose Send or Receive, view recent transfer history.
/// Empty state: "Nothing sent yet. Tap Send to pick your first file."
library;

import 'package:flutter/material.dart';
import 'package:shareme/core/theme/app_colors.dart';
import 'package:shareme/core/theme/app_typography.dart';

/// Home screen — primary entry point after permissions.
///
/// Phase 1 placeholder — M1 will build full layout with Send/Receive buttons
/// and transfer history list.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: Center(
        child: Text(
          'Home',
          style: AppTypography.displayMedium,
        ),
      ),
    );
  }
}
