/// ShareMe — Transfer Complete Screen.
///
/// App Flow §1, Screen #8: Success confirmation, metrics summary.
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
import 'package:shareme/core/widgets/app_button.dart';
import 'package:shareme/routing/route_names.dart';

class TransferCompleteScreen extends ConsumerWidget {
  const TransferCompleteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(activeTransferSessionProvider);
    final peerName = session?.peerDevice.name ?? 'Peer Device';
    final totalBytes = session?.totalBytes ?? 0;
    final fileCount = session?.items.length ?? 0;
    final elapsed = session?.elapsedSeconds ?? 1;
    final isSent = session?.isSent ?? true;
    final speedBytesPerSec = elapsed > 0 ? totalBytes / elapsed : (session?.speedBytesPerSec ?? 0.0);
    final speedMBs = (speedBytesPerSec / (1024 * 1024)).toStringAsFixed(1);

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenMargin),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Success Illustration Circle
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.accentSignal.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.accentSignal, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accentSignal.withValues(alpha: 0.3),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(Icons.check_rounded, color: AppColors.accentSignal, size: 64),
              ),
              const SizedBox(height: AppSpacing.xxl),

              Text('Transfer Complete!', style: AppTypography.displayLarge),
              const SizedBox(height: AppSpacing.xs),
              Text(
                isSent ? 'Successfully sent to $peerName' : 'Successfully received from $peerName',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Metrics Summary Card
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Column(
                  children: [
                    _MetricRow(label: 'Total Files', value: '$fileCount files'),
                    const Divider(height: 24),
                    _MetricRow(label: 'Total Data', value: formatFileSize(totalBytes)),
                    const Divider(height: 24),
                    _MetricRow(
                      label: 'Average Speed',
                      value: '$speedMBs MB/s',
                      isMono: true,
                      valueColor: AppColors.accentSignal,
                    ),
                    const Divider(height: 24),
                    _MetricRow(label: 'Duration', value: '${elapsed}s'),
                  ],
                ),
              ),
              const Spacer(),

              // Action CTAs
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  label: 'Open Received Folder',
                  icon: Icons.folder_open_rounded,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: AppColors.surfaceRaised,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        title: const Row(
                          children: [
                            Icon(Icons.folder_shared_rounded, color: AppColors.accentSignal),
                            SizedBox(width: 12),
                            Text('Received Files Location', style: TextStyle(color: Colors.white, fontSize: 18)),
                          ],
                        ),
                        content: const Text(
                          'Your shared files are permanently saved to your phone\'s internal storage at:\n\n📁 Internal Storage / Download / ShareMe\n\nYou can open your My Files app or Samsung Gallery to view them anytime!',
                          style: TextStyle(color: AppColors.textMuted, height: 1.5, fontSize: 14),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: const Text('GOT IT', style: TextStyle(color: AppColors.accentSignal, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    ref.read(activeTransferSessionProvider.notifier).cancelTransfer();
                    context.goNamed(RouteNames.home);
                  },
                  child: const Text('Back to Home'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({
    required this.label,
    required this.value,
    this.isMono = false,
    this.valueColor = AppColors.textPrimary,
  });

  final String label;
  final String value;
  final bool isMono;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.bodySmall),
        Text(
          value,
          style: isMono
              ? GoogleFonts.ibmPlexMono(fontSize: 15, fontWeight: FontWeight.w600, color: valueColor)
              : AppTypography.labelLarge.copyWith(color: valueColor),
        ),
      ],
    );
  }
}
