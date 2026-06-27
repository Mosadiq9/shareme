/// ShareMe — Transfer Progress Screen.
///
/// App Flow §1, Screen #7: Live progress, speed, ETA.
/// Uses IBM Plex Mono for numbers to prevent jitter. Auto-redirects on finish.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shareme/core/providers/app_state_providers.dart';
import 'package:shareme/core/theme/app_colors.dart';
import 'package:shareme/core/theme/app_spacing.dart';
import 'package:shareme/core/theme/app_typography.dart';
import 'package:shareme/core/utils/file_utils.dart';
import 'package:shareme/core/widgets/pulse_ring.dart';
import 'package:shareme/features/transfer/domain/transfer_item.dart';
import 'package:shareme/features/transfer/domain/transfer_session.dart';
import 'package:shareme/routing/route_names.dart';

class TransferProgressScreen extends ConsumerWidget {
  const TransferProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(activeTransferSessionProvider);

    // Listen for completion or failure
    ref.listen<TransferSession?>(activeTransferSessionProvider, (previous, next) {
      if (next?.status == TransferSessionStatus.completed) {
        context.pushReplacementNamed(RouteNames.transferComplete);
      } else if (next?.status == TransferSessionStatus.failed) {
        context.pushReplacementNamed(RouteNames.transferFailed);
      }
    });

    if (session == null) {
      return Scaffold(
        backgroundColor: AppColors.bgBase,
        body: Center(
          child: Text('No active transfer session.', style: AppTypography.bodyMedium),
        ),
      );
    }

    final overallProgress = session.totalBytes > 0
        ? (session.transferredBytes / session.totalBytes).clamp(0.0, 1.0)
        : 0.0;
    final percentInt = (overallProgress * 100).toInt();

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Column(
          children: [
            Text('Sending to ${session.peerDevice.name}', style: AppTypography.labelLarge),
            const SizedBox(height: 2),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.bolt_rounded, size: 14, color: AppColors.accentSignal),
                const SizedBox(width: 4),
                Text('Connected via 5GHz Tunnel', style: AppTypography.labelSmall.copyWith(color: AppColors.accentSignal)),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.lg),

            // Speedometer & Progress Ring
            SizedBox.square(
              dimension: 220,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PulseRing(
                    radius: 100,
                    progress: overallProgress,
                    strokeWidth: 8,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$percentInt%',
                        style: GoogleFonts.ibmPlexMono(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formatSpeed(session.speedBytesPerSec / (1024 * 1024)),
                        style: GoogleFonts.ibmPlexMono(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.accentSignal,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        session.etaSeconds > 0
                            ? 'ETA: ${formatEta(Duration(seconds: session.etaSeconds))}'
                            : 'Finishing...',
                        style: AppTypography.labelSmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),

            // File Item List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Files (${session.items.length})', style: AppTypography.labelLarge),
                  Text(
                    '${formatFileSize(session.transferredBytes)} / ${formatFileSize(session.totalBytes)}',
                    style: GoogleFonts.ibmPlexMono(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin),
                itemCount: session.items.length,
                separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final item = session.items[index];
                  return _FileProgressTile(item: item);
                },
              ),
            ),

            // Bottom Actions
            Padding(
              padding: const EdgeInsets.all(AppSpacing.screenMargin),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    ref.read(activeTransferSessionProvider.notifier).cancelTransfer();
                    context.goNamed(RouteNames.home);
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.accentError),
                    foregroundColor: AppColors.accentError,
                  ),
                  child: const Text('Cancel Transfer'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FileProgressTile extends StatelessWidget {
  const _FileProgressTile({required this.item});

  final TransferItem item;

  @override
  Widget build(BuildContext context) {
    final isDone = item.status == TransferItemStatus.completed;
    final isTransferring = item.status == TransferItemStatus.transferring;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(
          color: isTransferring ? AppColors.accentPulse.withValues(alpha: 0.5) : AppColors.borderSubtle,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isDone
                    ? Icons.check_circle_rounded
                    : isTransferring
                        ? Icons.sync_rounded
                        : Icons.pending_outlined,
                color: isDone
                    ? AppColors.accentSignal
                    : isTransferring
                        ? AppColors.accentPulse
                        : AppColors.textMuted,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  item.name,
                  style: AppTypography.labelMedium.copyWith(
                    color: isDone ? AppColors.textPrimary : AppColors.textPrimary.withValues(alpha: 0.8),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                isDone ? 'Done' : '${(item.progress * 100).toInt()}%',
                style: GoogleFonts.ibmPlexMono(
                  fontSize: 12,
                  color: isDone ? AppColors.accentSignal : AppColors.textMuted,
                ),
              ),
            ],
          ),
          if (isTransferring) ...[
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: item.progress,
              backgroundColor: AppColors.surfaceRaised,
              color: AppColors.accentPulse,
              minHeight: 4,
              borderRadius: BorderRadius.circular(2),
            ),
          ],
        ],
      ),
    );
  }
}
