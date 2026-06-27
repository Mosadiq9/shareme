/// ShareMe — Primary button component.
///
/// Implements all 4 states from Frontend Guidelines §6:
/// - Default: [accentPulse] fill, white text
/// - Pressed: 90% opacity
/// - Disabled: [surfaceCard] fill, [textMuted] text
/// - Loading: Spinner replaces label, button stays same size (no layout shift)
///
/// Hard rule: button NEVER changes size when entering loading state.
library;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Primary CTA button with all required states.
class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.width,
  });

  /// Button label text.
  final String label;

  /// Callback when tapped. Ignored when [isLoading] or [isDisabled].
  final VoidCallback onPressed;

  /// When true, shows spinner instead of label. Button size stays constant.
  final bool isLoading;

  /// When true, button is visually disabled and non-interactive.
  final bool isDisabled;

  /// Optional leading icon.
  final IconData? icon;

  /// Optional fixed width. If null, button sizes to content.
  final double? width;

  @override
  Widget build(BuildContext context) {
    final isActive = !isLoading && !isDisabled;

    return SizedBox(
      width: width,
      height: 52,
      child: ElevatedButton(
        onPressed: isActive ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isDisabled ? AppColors.surfaceCard : AppColors.accentPulse,
          foregroundColor:
              isDisabled ? AppColors.textMuted : AppColors.textPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          ),
        ),
        child: _buildChild(),
      ),
    );
  }

  Widget _buildChild() {
    if (isLoading) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: AppColors.textPrimary,
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppSpacing.iconButton),
          const SizedBox(width: AppSpacing.xs),
          Text(label, style: AppTypography.buttonLarge),
        ],
      );
    }

    return Text(label, style: AppTypography.buttonLarge);
  }
}
