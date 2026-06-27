/// ShareMe — Transfer Complete Screen.
///
/// App Flow §1, Screen #8: Success confirmation, file location.
/// Shows checkmark, file name, "Open" / "Done" buttons.
library;

import 'package:flutter/material.dart';
import 'package:shareme/core/theme/app_colors.dart';
import 'package:shareme/core/theme/app_typography.dart';

/// Transfer complete screen — success confirmation.
class TransferCompleteScreen extends StatelessWidget {
  const TransferCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: Center(
        child: Text(
          'Transfer Complete',
          style: AppTypography.displayMedium,
        ),
      ),
    );
  }
}
