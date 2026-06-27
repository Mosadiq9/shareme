/// ShareMe — Settings Screen.
///
/// App Flow §1, Screen #10: Device name, app version, about.
/// Device name is editable and persisted to local DB.
library;

import 'package:flutter/material.dart';
import 'package:shareme/core/theme/app_colors.dart';
import 'package:shareme/core/theme/app_typography.dart';

/// Settings screen — device name, version info.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: Center(
        child: Text(
          'Settings',
          style: AppTypography.displayMedium,
        ),
      ),
    );
  }
}
