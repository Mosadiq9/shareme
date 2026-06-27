/// ShareMe — Splash Screen.
///
/// App Flow §1, Screen #1: App launch and initialization.
/// Auto-advances to Home (if permissions granted) or Permissions screen
/// after a 2-second branded splash animation.
library;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shareme/core/mocks/mock_providers.dart';
import 'package:shareme/core/theme/app_colors.dart';
import 'package:shareme/core/theme/app_spacing.dart';
import 'package:shareme/core/theme/app_typography.dart';
import 'package:shareme/core/widgets/pulse_ring.dart';
import 'package:shareme/routing/route_names.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;
  Timer? _navTimer;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    // Auto-navigate after 2.2 seconds
    _navTimer = Timer(const Duration(milliseconds: 2200), _checkAndNavigate);
  }

  void _checkAndNavigate() {
    if (!mounted) return;
    final hasPermissions = ref.read(mockPermissionsProvider);
    if (hasPermissions) {
      context.goNamed(RouteNames.home);
    } else {
      context.goNamed(RouteNames.permissions);
    }
  }

  @override
  void dispose() {
    _navTimer?.cancel();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Signature Pulse Ring around brand icon
              SizedBox.square(
                dimension: 160,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const PulseRing(
                      radius: 70,
                      strokeWidth: 1.5,
                    ),
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceRaised,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.accentPulse.withValues(alpha: 0.5),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.bolt_rounded,
                        color: AppColors.accentPulse,
                        size: 44,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'ShareMe',
                style: AppTypography.displayLarge.copyWith(
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Close-Range High-Speed Transfer',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
