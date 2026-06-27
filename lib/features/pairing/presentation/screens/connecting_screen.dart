/// ShareMe — Connecting (Pairing) Screen.
///
/// App Flow §1, Screen #6: Band negotiation + handshake in progress.
/// Loading state: "Connecting…"
/// Success: Auto-advance to Transfer Progress.
library;

import 'package:flutter/material.dart';
import 'package:shareme/core/theme/app_colors.dart';
import 'package:shareme/core/theme/app_typography.dart';

/// Connecting screen — shown during band negotiation and handshake.
class ConnectingScreen extends StatelessWidget {
  const ConnectingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: Center(
        child: Text(
          'Connecting',
          style: AppTypography.displayMedium,
        ),
      ),
    );
  }
}
