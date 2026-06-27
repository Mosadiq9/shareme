/// ShareMe — Radar (Discovery) Screen.
///
/// App Flow §1, Screen #5: Show nearby devices in range.
/// Empty state: "No devices found yet. Open ShareMe on the other phone."
/// Loading state: Scanning (spinner + "Searching…")
library;

import 'package:flutter/material.dart';
import 'package:shareme/core/theme/app_colors.dart';
import 'package:shareme/core/theme/app_typography.dart';

/// Radar screen — shows nearby devices during discovery.
class RadarScreen extends StatelessWidget {
  const RadarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: Center(
        child: Text(
          'Radar',
          style: AppTypography.displayMedium,
        ),
      ),
    );
  }
}
