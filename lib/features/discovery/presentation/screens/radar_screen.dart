/// ShareMe — Radar (Discovery) Screen.
///
/// App Flow §1, Screen #5: Show nearby devices in range.
/// Features signature PulseRing sweep and peer cards.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shareme/core/providers/app_state_providers.dart';
import 'package:shareme/core/theme/app_colors.dart';
import 'package:shareme/core/theme/app_spacing.dart';
import 'package:shareme/core/theme/app_typography.dart';
import 'package:shareme/core/widgets/loading_shimmer.dart';
import 'package:shareme/core/widgets/pulse_ring.dart';
import 'package:shareme/features/discovery/domain/peer_device.dart';
import 'package:shareme/routing/route_names.dart';

class RadarScreen extends ConsumerWidget {
  const RadarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final discovery = ref.watch(peerDiscoveryProvider);

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      appBar: AppBar(
        title: const Text('Nearby Devices'),
        actions: [
          IconButton(
            onPressed: () {
              if (discovery.isScanning) {
                ref.read(peerDiscoveryProvider.notifier).stopScanning();
              } else {
                ref.read(peerDiscoveryProvider.notifier).startScanning();
              }
            },
            icon: Icon(
              discovery.isScanning ? Icons.stop_circle_outlined : Icons.refresh_rounded,
              color: AppColors.accentPulse,
            ),
            tooltip: discovery.isScanning ? 'Stop Scanning' : 'Rescan',
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.xl),

            // Signature Radar Sweep Area
            SizedBox(
              height: 220,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PulseRing(
                    radius: 100,
                    isAnimating: discovery.isScanning,
                  ),
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceRaised,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.accentPulse, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accentPulse.withValues(alpha: 0.3),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.radar_rounded, color: AppColors.accentPulse, size: 36),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceCard,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusCircle),
                        border: Border.all(color: AppColors.borderSubtle),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (discovery.isScanning) ...[
                            const SizedBox(
                              width: 10,
                              height: 10,
                              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.accentPulse),
                            ),
                            const SizedBox(width: 8),
                            Text('Scanning nearby devices...', style: AppTypography.labelSmall),
                          ] else ...[
                            const Icon(Icons.check_circle_rounded, size: 14, color: AppColors.accentSignal),
                            const SizedBox(width: 6),
                            Text('Scan finished', style: AppTypography.labelSmall),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),

            // Peer List Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Discovered Peers', style: AppTypography.labelLarge),
                  Text(
                    discovery.isScanning ? 'Searching...' : '${discovery.peers.length} found',
                    style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Peers or Shimmer Placeholder List
            Expanded(
              child: discovery.isScanning && discovery.peers.isEmpty
                  ? ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin),
                      itemCount: 3,
                      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                      itemBuilder: (_, __) => const LoadingShimmer.card(),
                    )
                  : discovery.peers.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.devices_other_rounded, size: 48, color: AppColors.textMuted.withValues(alpha: 0.5)),
                              const SizedBox(height: AppSpacing.md),
                              Text('No devices found.', style: AppTypography.bodyMedium),
                              const SizedBox(height: 4),
                              Text('Make sure ShareMe is open on the other phone.', style: AppTypography.bodySmall),
                              const SizedBox(height: AppSpacing.lg),
                              TextButton.icon(
                                onPressed: () => ref.read(peerDiscoveryProvider.notifier).startScanning(),
                                icon: const Icon(Icons.refresh_rounded, color: AppColors.accentPulse),
                                label: Text('Scan Again', style: AppTypography.labelMedium.copyWith(color: AppColors.accentPulse)),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin),
                          itemCount: discovery.peers.length,
                          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                          itemBuilder: (context, index) {
                            final peer = discovery.peers[index];
                            return _PeerCard(
                              peer: peer,
                              onConnect: () {
                                ref.read(activeTransferSessionProvider.notifier).startPairing(peer);
                                context.pushNamed(RouteNames.connecting);
                              },
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PeerCard extends StatelessWidget {
  const _PeerCard({
    required this.peer,
    required this.onConnect,
  });

  final PeerDevice peer;
  final VoidCallback onConnect;

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
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.surfaceRaised,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              peer.deviceModel.contains('iOS') ? Icons.phone_iphone_rounded : Icons.phone_android_rounded,
              color: AppColors.accentPulse,
              size: 26,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        peer.name,
                        style: AppTypography.labelLarge,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    if (peer.is5GhzSupported)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: AppColors.accentSignal.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '5GHz',
                          style: AppTypography.labelSmall.copyWith(color: AppColors.accentSignal, fontSize: 9, fontWeight: FontWeight.w700),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(peer.deviceModel, style: AppTypography.bodySmall.copyWith(fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          ElevatedButton(
            onPressed: onConnect,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentPulse,
              foregroundColor: AppColors.textPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Connect', style: AppTypography.labelSmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
