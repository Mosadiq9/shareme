/// ShareMe — Permission Request Screen.
///
/// App Flow §1, Screen #2: Request WiFi/Storage/Local Network access.
/// States: Granted → proceed, Denied → show "Open Settings" CTA.
library;

import 'package:flutter/material.dart';
import 'package:shareme/core/theme/app_colors.dart';
import 'package:shareme/core/theme/app_typography.dart';

/// Permission request screen — blocks app until resolved.
///
/// Phase 1 placeholder — M1 will add real permission request logic.
class PermissionScreen extends StatelessWidget {
  const PermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: Center(
        child: Text(
          'Permission Request',
          style: AppTypography.displayMedium,
        ),
      ),
    );
  }
}
