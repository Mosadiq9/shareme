/// ShareMe — Sliding Window Speed Moving Average.
///
/// Computes exponential moving average (EMA) transmission velocity to eliminate
/// UI speed fluctuation and ETA flickering (TRD §7.2: Speed Benchmarking & Live Graphing).
library;

import 'dart:math' as math;

class SpeedMovingAverage {
  SpeedMovingAverage({this.alpha = 0.3});

  /// Smoothing factor for exponential moving average (0.0 < alpha <= 1.0).
  /// Lower values smooth more heavily; higher values react faster.
  final double alpha;

  double _smoothedSpeed = 0;
  int _lastBytes = 0;
  DateTime? _lastTimestamp;

  /// Current smoothed transmission speed in Bytes/second.
  double get currentSpeedBytesPerSec => _smoothedSpeed;

  /// Current smoothed speed formatted in MB/s.
  double get currentSpeedMBPerSec => _smoothedSpeed / (1024 * 1024);

  /// Record a progress sample and update the smoothed speed.
  void addSample({required int bytesTransferred, required DateTime timestamp}) {
    if (_lastTimestamp == null || bytesTransferred < _lastBytes) {
      _lastBytes = bytesTransferred;
      _lastTimestamp = timestamp;
      return;
    }

    final durationMs = timestamp.difference(_lastTimestamp!).inMilliseconds;
    if (durationMs < 50) {
      // Ignore sample intervals too short to provide meaningful velocity calculation
      return;
    }

    final deltaBytes = bytesTransferred - _lastBytes;
    final instantSpeed = deltaBytes / (durationMs / 1000.0);

    if (_smoothedSpeed == 0) {
      _smoothedSpeed = instantSpeed;
    } else {
      // EMA formula: S_t = alpha * Y_t + (1 - alpha) * S_{t-1}
      _smoothedSpeed = (alpha * instantSpeed) + ((1.0 - alpha) * _smoothedSpeed);
    }

    _lastBytes = bytesTransferred;
    _lastTimestamp = timestamp;
  }

  /// Calculate jitter-free estimated time of arrival (ETA) in seconds.
  int calculateEtaSeconds(int remainingBytes) {
    if (remainingBytes <= 0) return 0;
    if (_smoothedSpeed <= 0.1) return 999; // Fallback placeholder when stalled

    final seconds = remainingBytes / _smoothedSpeed;
    return math.max(1, seconds.ceil());
  }

  /// Reset calculation state for a new transfer session.
  void reset() {
    _smoothedSpeed = 0;
    _lastBytes = 0;
    _lastTimestamp = null;
  }
}
