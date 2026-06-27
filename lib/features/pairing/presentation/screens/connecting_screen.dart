/// ShareMe — Connecting (Pairing) Screen.
///
/// App Flow §1, Screen #6: Band negotiation + handshake in progress.
/// Auto-redirects to Transfer Progress when session begins transferring.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shareme/core/mocks/mock_providers.dart';
import 'package:shareme/core/theme/app_colors.dart';
import 'package:shareme/core/theme/app_spacing.dart';
import 'package:shareme/core/theme/app_typography.dart';
import 'package:shareme/core/widgets/pulse_ring.dart';
import 'package:shareme/features/transfer/domain/transfer_session.dart';
import 'package:shareme/routing/route_names.dart';

class ConnectingScreen extends ConsumerWidget {
  const ConnectingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(mockTransferProvider);

    // Listen to session state transitions
    ref.listen<TransferSession?>(mockTransferProvider, (previous, next) {
      if (next?.status == TransferSessionStatus.transferring) {
        context.pushReplacementNamed(RouteNames.transferProgress);
      } else if (next?.status == TransferSessionStatus.failed) {
        context.pushReplacementNamed(RouteNames.transferFailed);
      }
    });

    final peerName = session?.peerDevice.name ?? 'Target Peer';

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Merging rings illustration
              SizedBox(
                height: 200,
                width: 280,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Positioned(
                      left: 20,
                      child: PulseRing(radius: 70),
                    ),
                    const Positioned(
                      right: 20,
                      child: PulseRing(radius: 70, color: AppColors.accentSignal),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceRaised,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.borderSubtle),
                      ),
                      child: const Icon(Icons.handshake_rounded, color: AppColors.textPrimary, size: 32),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              Text('Connecting to $peerName', style: AppTypography.displayMedium),
              const SizedBox(height: AppSpacing.sm),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusCircle),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.accentSignal),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Negotiating 5GHz High-Speed Band...',
                      style: AppTypography.labelSmall.copyWith(color: AppColors.accentSignal),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),

              TextButton(
                onPressed: () {
                  ref.read(mockTransferProvider.notifier).cancelTransfer();
                  context.pop();
                },
                child: Text('Cancel Handshake', style: AppTypography.labelMedium.copyWith(color: AppColors.textMuted)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
