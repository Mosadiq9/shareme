/// ShareMe — Transfer Failed Screen.
///
/// App Flow §1, Screen #9: Error reason + retry.
/// Shows reason + "Retry" + "Cancel".
/// Retry re-enters Radar (not File Picker — user shouldn't reselect files).
library;

import 'package:flutter/material.dart';
import 'package:shareme/core/theme/app_colors.dart';
import 'package:shareme/core/theme/app_typography.dart';

/// Transfer failed screen — error details with retry option.
class TransferFailedScreen extends StatelessWidget {
  const TransferFailedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: Center(
        child: Text(
          'Transfer Failed',
          style: AppTypography.displayMedium,
        ),
      ),
    );
  }
}
