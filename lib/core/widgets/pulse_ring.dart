/// ShareMe — Pulse Ring widget (signature animation).
///
/// The one motif reused meaningfully across three screens
/// (Frontend Guidelines §5):
///
/// - **Radar screen:** Concentric expanding rings — literal radar sweep.
/// - **Connecting screen:** Two rings animate toward each other, merge on handshake.
/// - **Transfer Progress:** Ring becomes progress indicator, fills as bytes transfer.
///
/// Reduced motion: Must have a static fallback when OS "reduce motion" is on.
/// This is mandatory, not optional polish (Frontend Guidelines §5).
library;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Animated pulse ring used across discovery, connecting, and transfer screens.
///
/// Set [isAnimating] to `false` for the static reduced-motion fallback.
class PulseRing extends StatefulWidget {
  const PulseRing({
    required this.radius,
    super.key,
    this.color = AppColors.accentPulse,
    this.isAnimating = true,
    this.ringCount = 3,
    this.strokeWidth = 2.0,
    this.progress,
  });

  /// Outer radius of the largest ring.
  final double radius;

  /// Ring color — defaults to [AppColors.accentPulse].
  final Color color;

  /// Whether the rings should animate. Set to `false` for reduced-motion.
  final bool isAnimating;

  /// Number of concentric rings to display.
  final int ringCount;

  /// Stroke width of each ring.
  final double strokeWidth;

  /// If provided (0.0–1.0), renders as a progress ring instead of a pulse.
  /// Used on the Transfer Progress screen.
  final double? progress;

  @override
  State<PulseRing> createState() => _PulseRingState();
}

class _PulseRingState extends State<PulseRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    if (widget.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(PulseRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.isAnimating && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.progress != null) {
      return _buildProgressRing();
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size.square(widget.radius * 2),
          painter: _PulseRingPainter(
            progress: widget.isAnimating ? _controller.value : 0.5,
            color: widget.color,
            ringCount: widget.ringCount,
            strokeWidth: widget.strokeWidth,
          ),
        );
      },
    );
  }

  Widget _buildProgressRing() {
    return SizedBox.square(
      dimension: widget.radius * 2,
      child: CircularProgressIndicator(
        value: widget.progress,
        color: widget.color,
        strokeWidth: widget.strokeWidth,
        backgroundColor: widget.color.withValues(alpha: 0.15),
      ),
    );
  }
}

/// Custom painter for the expanding pulse rings.
class _PulseRingPainter extends CustomPainter {
  _PulseRingPainter({
    required this.progress,
    required this.color,
    required this.ringCount,
    required this.strokeWidth,
  });

  final double progress;
  final Color color;
  final int ringCount;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    for (var i = 0; i < ringCount; i++) {
      final ringProgress = (progress + i / ringCount) % 1.0;
      final radius = maxRadius * ringProgress;
      final opacity = (1.0 - ringProgress).clamp(0.0, 1.0);

      final paint = Paint()
        ..color = color.withValues(alpha: opacity * 0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;

      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(_PulseRingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
