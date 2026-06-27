/// ShareMe — Permission Request Screen.
///
/// App Flow §1, Screen #2: Request WiFi/Storage/Local Network access.
/// Interactive cards allow simulated toggling of OS permissions.
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

class PermissionScreen extends ConsumerWidget {
  const PermissionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isGranted = ref.watch(mockPermissionsProvider);

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Setup Permissions',
                style: AppTypography.displayMedium,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'To transfer files at 40+ MB/s without cellular data, ShareMe requires direct hardware access.',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Permission Cards
              Expanded(
                child: ListView(
                  children: [
                    _PermissionCard(
                      icon: Icons.wifi_tethering_rounded,
                      title: 'Wi-Fi Direct & Local Network',
                      description: 'Required to create high-speed offline peer-to-peer tunnels.',
                      isGranted: isGranted,
                      onToggle: () => ref.read(mockPermissionsProvider.notifier).grantAll(),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _PermissionCard(
                      icon: Icons.folder_shared_rounded,
                      title: 'Storage Access',
                      description: 'Required to read files you select and save received files.',
                      isGranted: isGranted,
                      onToggle: () => ref.read(mockPermissionsProvider.notifier).grantAll(),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _PermissionCard(
                      icon: Icons.location_on_rounded,
                      title: 'Nearby Devices (Location)',
                      description: 'Required by system OS to scan for Wi-Fi Direct hardware frequencies.',
                      isGranted: isGranted,
                      onToggle: () => ref.read(mockPermissionsProvider.notifier).grantAll(),
                    ),
                  ],
                ),
              ),

              // Bottom CTA
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  label: isGranted ? 'Enter ShareMe' : 'Grant Permissions & Continue',
                  icon: isGranted ? Icons.check_circle_rounded : Icons.security_rounded,
                  onPressed: () {
                    ref.read(mockPermissionsProvider.notifier).grantAll();
                    context.goNamed(RouteNames.home);
                  },
                ),
              ),
              if (isGranted) ...[
                const SizedBox(height: AppSpacing.sm),
                Center(
                  child: TextButton(
                    onPressed: () => ref.read(mockPermissionsProvider.notifier).revokeAll(),
                    child: Text(
                      'Simulate Revoke (Test Lockout)',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.accentError,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _PermissionCard extends StatelessWidget {
  const _PermissionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.isGranted,
    required this.onToggle,
  });

  final IconData icon;
  final String title;
  final String description;
  final bool isGranted;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(
          color: isGranted ? AppColors.accentSignal.withValues(alpha: 0.4) : AppColors.borderSubtle,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: isGranted
                  ? AppColors.accentSignal.withValues(alpha: 0.15)
                  : AppColors.surfaceRaised,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isGranted ? AppColors.accentSignal : AppColors.accentPulse,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.labelLarge),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTypography.bodySmall.copyWith(fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          IconButton(
            onPressed: onToggle,
            icon: Icon(
              isGranted ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
              color: isGranted ? AppColors.accentSignal : AppColors.textMuted,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}
