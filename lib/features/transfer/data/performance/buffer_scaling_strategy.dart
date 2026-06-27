/// ShareMe — Dynamic Buffer Scaling Strategy.
///
/// Optimizes socket buffer chunk sizes based on negotiated wireless frequency band
/// and live throughput feedback (TRD §7.1: Buffer & TCP Window Size Tuning).
library;

import 'package:logger/logger.dart';
import 'package:shareme/core/constants/enums.dart';

class BufferScalingStrategy {
  BufferScalingStrategy({Logger? logger}) : _logger = logger ?? Logger();

  final Logger _logger;

  static const int _chunk64k = 64 * 1024; // 64 KB
  static const int _chunk256k = 256 * 1024; // 256 KB
  static const int _chunk512k = 512 * 1024; // 512 KB

  /// Determine initial socket buffer chunk size based on negotiated [band].
  int getInitialBufferSize(WifiBand band) {
    switch (band) {
      case WifiBand.ghz2_4:
        _logger.i('Buffer strategy: 64 KB allocated for 2.4GHz band');
        return _chunk64k;
      case WifiBand.ghz5:
        _logger.i('Buffer strategy: 256 KB allocated for 5GHz High-Speed band');
        return _chunk256k;
      case WifiBand.ghz6:
        _logger.i('Buffer strategy: 512 KB allocated for 6GHz Ultra-Wideband');
        return _chunk512k;
    }
  }

  /// Dynamically tune buffer chunk size based on live transmission velocity.
  ///
  /// If transmission exceeds 25 MB/s, scales up to 512 KB to saturate channel.
  int getDynamicBufferSize({required WifiBand band, required double speedBytesPerSec}) {
    const threshold25MB = 25.0 * 1024 * 1024;

    if (speedBytesPerSec > threshold25MB && band != WifiBand.ghz2_4) {
      return _chunk512k;
    }

    return getInitialBufferSize(band);
  }
}
