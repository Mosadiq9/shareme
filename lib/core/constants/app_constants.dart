/// ShareMe — App-wide constants.
///
/// Every magic number in the app lives here, not inline.
/// Grouped by domain for easy discovery.
library;

/// Transfer engine constants — mirrors TRD §6.
abstract final class TransferConstants {
  /// Default chunk size in bytes (4MB).
  /// Tuned during M7 device testing — smaller = finer resume granularity,
  /// larger = less overhead.
  static const int defaultChunkSizeBytes = 4 * 1024 * 1024;

  /// Minimum parallel TCP streams for budget devices.
  static const int minParallelStreams = 4;

  /// Maximum parallel TCP streams for flagship devices.
  static const int maxParallelStreams = 8;

  /// Seconds to wait for reconnection before marking transfer as failed.
  static const int reconnectTimeoutSeconds = 30;

  /// Interval in seconds between discovery re-scans while radar is open.
  static const int discoveryRefreshIntervalSeconds = 2;

  /// Timeout in seconds for WiFi Direct discovery before falling back to mDNS.
  static const int wifiDirectDiscoveryTimeoutSeconds = 3;
}

/// mDNS service type used for cross-platform discovery — TRD §3.2.
abstract final class DiscoveryConstants {
  /// Service type registered on both Android (NsdManager) and iOS (NWBrowser).
  static const String mdnsServiceType = '_shareme._tcp.local.';

  /// Service name prefix for mDNS advertisement.
  static const String mdnsServiceName = 'ShareMe';
}

/// App metadata constants.
abstract final class AppMetadata {
  /// Application display name.
  static const String appName = 'ShareMe';

  /// Current app version string.
  static const String appVersion = '1.0.0';

  /// Phase identifier for this build.
  static const String phase = 'Phase 1 — Close-Range Transfer';
}
