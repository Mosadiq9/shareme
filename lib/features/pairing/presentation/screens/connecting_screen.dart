/// ShareMe — Connecting (Pairing) Screen.
///
/// App Flow §1, Screen #6: Band negotiation + handshake in progress.
/// Auto-redirects to Transfer Progress when session begins transferring.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shareme/core/providers/app_state_providers.dart';
import 'package:shareme/core/theme/app_colors.dart';
import 'package:shareme/core/theme/app_typography.dart';
import 'package:shareme/core/widgets/pulse_ring.dart';
import 'package:shareme/features/transfer/domain/transfer_session.dart';
import 'package:shareme/routing/route_names.dart';

class ConnectingScreen extends ConsumerWidget {
  const ConnectingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(activeTransferSessionProvider);

    // Listen to session state transitions
    ref.listen<TransferSession?>(activeTransferSessionProvider, (previous, next) {
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
                        color: AppColors.surfaceCard,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.accentPulse, width: 2),
                      ),
                      child: const Icon(Icons.handshake_rounded, color: AppColors.accentPulse, size: 36),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              Text('Connecting to $peerName...', style: AppTypography.displayMedium.copyWith(fontSize: 22)),
              const SizedBox(height: 8),
              Text('Securing socket & establishing handshake', style: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted)),
              const SizedBox(height: 24),

              // Band status indicator
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.accentSignal.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.speed_rounded, color: AppColors.accentSignal, size: 18),
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
                  ref.read(activeTransferSessionProvider.notifier).cancelTransfer();
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
