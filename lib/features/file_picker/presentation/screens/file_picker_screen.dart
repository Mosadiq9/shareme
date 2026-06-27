/// ShareMe — File Picker Screen.
///
/// App Flow §1, Screen #4: Select file(s)/folder to send.
/// Empty state: No files selected yet.
/// Loading state: Scanning device storage.
library;

import 'package:flutter/material.dart';
import 'package:shareme/core/theme/app_colors.dart';
import 'package:shareme/core/theme/app_typography.dart';

/// File picker screen — select files/folders to transfer.
class FilePickerScreen extends StatelessWidget {
  const FilePickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: Center(
        child: Text(
          'File Picker',
          style: AppTypography.displayMedium,
        ),
      ),
    );
  }
}
