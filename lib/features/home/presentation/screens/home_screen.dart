/// ShareMe — Home Screen.
///
/// App Flow §1, Screen #3: Choose Send or Receive, view recent transfer history.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shareme/core/mocks/mock_providers.dart';
import 'package:shareme/core/theme/app_colors.dart';
import 'package:shareme/core/theme/app_spacing.dart';
import 'package:shareme/core/theme/app_typography.dart';
import 'package:shareme/core/utils/date_utils.dart';
import 'package:shareme/core/utils/file_utils.dart';
import 'package:shareme/features/home/domain/history_item.dart';
import 'package:shareme/routing/route_names.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(mockHistoryProvider);
    final deviceName = ref.watch(mockDeviceNameProvider);

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.bolt_rounded, color: AppColors.accentPulse, size: 22),
            const SizedBox(width: 6),
            Text('ShareMe', style: AppTypography.displayMedium.copyWith(fontSize: 20)),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => context.pushNamed(RouteNames.settings),
            icon: const Icon(Icons.settings_outlined, color: AppColors.textPrimary),
            tooltip: 'Settings',
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Device Name Badge
              Container(
                margin: const EdgeInsets.only(top: AppSpacing.xs, bottom: AppSpacing.lg),
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusCircle),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.smartphone_rounded, size: 16, color: AppColors.accentSignal),
                    const SizedBox(width: 6),
                    Text(
                      'Visible as: $deviceName',
                      style: AppTypography.labelSmall.copyWith(color: AppColors.textPrimary),
                    ),
                  ],
                ),
              ),

              // Hero Send / Receive Buttons
              Row(
                children: [
                  Expanded(
                    child: _HeroActionButton(
                      label: 'SEND',
                      sublabel: 'Share files',
                      icon: Icons.arrow_upward_rounded,
                      color: AppColors.accentPulse,
                      onTap: () => context.pushNamed(RouteNames.filePicker),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _HeroActionButton(
                      label: 'RECEIVE',
                      sublabel: 'Wait for sender',
                      icon: Icons.arrow_downward_rounded,
                      color: AppColors.accentSignal,
                      onTap: () {
                        // Receiver enters radar waiting mode
                        ref.read(mockDiscoveryProvider.notifier).startScanning();
                        context.pushNamed(RouteNames.radar);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Recent Transfer History Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Recent Transfers', style: AppTypography.labelLarge),
                  if (history.isNotEmpty)
                    Text(
                      '${history.length} items',
                      style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // History List or Empty State
              Expanded(
                child: history.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.history_rounded, size: 48, color: AppColors.textMuted.withValues(alpha: 0.5)),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              'Nothing sent yet.',
                              style: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Tap Send to pick your first file.',
                              style: AppTypography.bodySmall,
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        itemCount: history.length,
                        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                        itemBuilder: (context, index) {
                          final item = history[index];
                          return _HistoryCard(item: item);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroActionButton extends StatelessWidget {
  const _HeroActionButton({
    required this.label,
    required this.sublabel,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final String sublabel;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        splashColor: color.withValues(alpha: 0.3),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
            border: Border.all(color: color.withValues(alpha: 0.5), width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.textPrimary, size: 28),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                label,
                style: AppTypography.displayMedium.copyWith(fontSize: 22, color: color),
              ),
              const SizedBox(height: 2),
              Text(
                sublabel,
                style: AppTypography.bodySmall.copyWith(fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.item});

  final HistoryItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: item.isSent
                  ? AppColors.accentPulse.withValues(alpha: 0.15)
                  : AppColors.accentSignal.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              item.isSent ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
              color: item.isSent ? AppColors.accentPulse : AppColors.accentSignal,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item.peerName, style: AppTypography.labelLarge),
                    Text(
                      formatRelativeTime(item.timestampEpochMs),
                      style: AppTypography.labelSmall,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '${item.fileCount} ${item.fileCount == 1 ? 'file' : 'files'} • ${formatFileSize(item.totalSizeBytes)}',
                      style: AppTypography.bodySmall,
                    ),
                    const Spacer(),
                    if (!item.isSuccess)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.accentError.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Failed',
                          style: AppTypography.labelSmall.copyWith(color: AppColors.accentError, fontSize: 10),
                        ),
                      )
                    else
                      Icon(Icons.check_circle_rounded, size: 14, color: AppColors.accentSignal.withValues(alpha: 0.8)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
