/// ShareMe — Transfer Progress Screen.
///
/// App Flow §1, Screen #7: Live progress, speed, ETA.
/// Shows real-time progress bar (% complete, speed in MB/s, ETA)
/// on both sender and receiver.
library;

import 'package:flutter/material.dart';
import 'package:shareme/core/theme/app_colors.dart';
import 'package:shareme/core/theme/app_typography.dart';

/// Transfer progress screen — shows live transfer data.
class TransferProgressScreen extends StatelessWidget {
  const TransferProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: Center(
        child: Text(
          'Transfer Progress',
          style: AppTypography.displayMedium,
        ),
      ),
    );
  }
}
