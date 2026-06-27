/// ShareMe — Transfer Failed Screen.
///
/// App Flow §1, Screen #9: Error reason + retry.
/// Red accent styling and instant retry without file reselection.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shareme/core/mocks/mock_providers.dart';
import 'package:shareme/core/theme/app_colors.dart';
import 'package:shareme/core/theme/app_spacing.dart';
import 'package:shareme/core/theme/app_typography.dart';
import 'package:shareme/core/widgets/app_button.dart';
import 'package:shareme/routing/route_names.dart';

class TransferFailedScreen extends ConsumerWidget {
  const TransferFailedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(mockTransferProvider);
    final errorMsg = session?.errorMessage ?? 'Connection dropped unexpectedly during high-speed transfer.';

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenMargin),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Error Icon Circle
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: AppColors.accentError.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.accentError, width: 2.5),
                ),
                child: const Icon(Icons.error_outline_rounded, color: AppColors.accentError, size: 56),
              ),
              const SizedBox(height: AppSpacing.xxl),

              Text('Transfer Interrupted', style: AppTypography.displayLarge),
              const SizedBox(height: AppSpacing.md),

              // Error Banner with Red Left Border
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                  border: const Border(
                    left: BorderSide(color: AppColors.accentError, width: 4),
                    top: BorderSide(color: AppColors.borderSubtle),
                    right: BorderSide(color: AppColors.borderSubtle),
                    bottom: BorderSide(color: AppColors.borderSubtle),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Failure Reason:', style: AppTypography.labelSmall.copyWith(color: AppColors.accentError)),
                    const SizedBox(height: 4),
                    Text(errorMsg, style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary)),
                  ],
                ),
              ),
              const Spacer(),

              // Retry & Cancel
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  label: 'Retry Instant Connection',
                  icon: Icons.refresh_rounded,
                  onPressed: () {
                    ref.read(mockTransferProvider.notifier).retryTransfer();
                    context.pushReplacementNamed(RouteNames.connecting);
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    ref.read(mockTransferProvider.notifier).cancelTransfer();
                    context.goNamed(RouteNames.home);
                  },
                  child: const Text('Cancel & Return Home'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
