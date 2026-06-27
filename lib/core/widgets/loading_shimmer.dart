/// ShareMe — Skeleton loading shimmer.
///
/// Used for the Radar screen's device card loading state
/// (Frontend Guidelines §6: "3 placeholder cards while scanning").
///
/// Generic enough to be reused for any list loading state.
library;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// A shimmer-effect loading placeholder.
///
/// Usage:
/// ```dart
/// LoadingShimmer(width: 200, height: 60)
/// LoadingShimmer.card()  // Full-width card placeholder
/// ```
class LoadingShimmer extends StatefulWidget {
  const LoadingShimmer({
    super.key,
    this.width = double.infinity,
    this.height = 60,
    this.borderRadius = AppSpacing.radiusCard,
  });

  /// Creates a full-width card-shaped shimmer placeholder.
  const LoadingShimmer.card({super.key})
      : width = double.infinity,
        height = 72,
        borderRadius = AppSpacing.radiusCard;

  /// Creates a small circular shimmer placeholder.
  const LoadingShimmer.circle({
    required double size,
    super.key,
  })  : width = size,
        height = size,
        borderRadius = AppSpacing.radiusCircle;

  /// Width of the shimmer block.
  final double width;

  /// Height of the shimmer block.
  final double height;

  /// Corner radius.
  final double borderRadius;

  @override
  State<LoadingShimmer> createState() => _LoadingShimmerState();
}

class _LoadingShimmerState extends State<LoadingShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              colors: const [
                AppColors.surfaceCard,
                AppColors.surfaceRaised,
                AppColors.surfaceCard,
              ],
              stops: [
                (_animation.value - 0.3).clamp(0.0, 1.0),
                _animation.value.clamp(0.0, 1.0),
                (_animation.value + 0.3).clamp(0.0, 1.0),
              ],
            ),
          ),
        );
      },
    );
  }
}
